import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../Components/Network/Url.dart';
import 'socket_session.dart';

typedef ListenFunction = void Function(dynamic onData);
typedef NotificationCountHandler = void Function(int count);

/// Single authenticated Socket.IO connection for the signed-in Sanctum session.
class SocketIoClass {
  io.Socket? socket;
  SocketIoClass._();

  static SocketIoClass? singleton;

  factory SocketIoClass() {
    return singleton ??= SocketIoClass._();
  }

  final Map<String, ListenFunction> _handlers = <String, ListenFunction>{};
  final List<void Function()> _sessionBinders = <void Function()>[];

  NotificationCountHandler? _onNotificationCount;
  int? _latestNotificationCount;
  String? _notificationEvent;
  String? _boundToken;
  String? _boundUserId;
  bool _authRejected = false;
  bool _started = false;
  bool _syncScheduled = false;
  int _generation = 0;
  int _serverDisconnects = 0;
  Timer? _reconnectTimer;
  VoidCallback? _stopTokenListen;
  VoidCallback? _stopUserListen;

  bool get isConnected => socket?.connected ?? false;

  String? get boundUserId => _boundUserId;

  set onNotificationCount(NotificationCountHandler? handler) {
    _onNotificationCount = handler;
    final latest = _latestNotificationCount;
    if (handler != null && latest != null) handler(latest);
  }

  /// Listen for later token and profile changes, then connect a stored session.
  void start() {
    if (!_started) {
      _started = true;
      final box = GetStorage();
      _stopTokenListen = box.listenKey('token', (_) => syncSession());
      _stopUserListen = box.listenKey('userId', (_) => syncSession());
    }
    syncSession();
  }

  /// Re-read storage after login, OTP, registration, Google sign-in, or profile switch.
  void syncSession() {
    if (_syncScheduled) return;
    _syncScheduled = true;
    scheduleMicrotask(() {
      _syncScheduled = false;
      _syncNow();
    });
  }

  void addSessionBinder(void Function() binder) {
    if (!_sessionBinders.contains(binder)) {
      _sessionBinders.add(binder);
    }
    if (socket != null) binder();
  }

  void removeSessionBinder(void Function() binder) {
    _sessionBinders.remove(binder);
  }

  void on(String event, ListenFunction handler) {
    _handlers[event] = handler;
    final active = socket;
    if (active == null) return;
    active.off(event);
    active.on(event, handler);
  }

  void off(String event) {
    _handlers.remove(event);
    socket?.off(event);
  }

  void emit(String event, dynamic data) {
    final active = socket;
    if (active == null || active.connected != true) return;
    active.emit(event, data);
  }

  /// Drop the socket on logout, account deletion, or a revoked HTTP session.
  void disconnect() {
    _generation++;
    _authRejected = false;
    _boundToken = null;
    _boundUserId = null;
    _serverDisconnects = 0;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    final active = socket;
    socket = null;
    _destroy(active);
    _dropCachedManager(Url().socketUrl);
  }

  void _syncNow() {
    final box = GetStorage();
    final token = sanctumSocketToken(box.read('token'));
    final userId = normalizeUserId(box.read('userId'));
    if (shouldCloseSocket(token)) {
      if (socket != null || _boundToken != null) disconnect();
      return;
    }
    final open = shouldOpenSocket(
      hasLiveSocket: socket != null,
      authRejected: _authRejected,
      boundToken: _boundToken,
      boundUserId: _boundUserId,
      nextToken: token,
      nextUserId: userId,
    );
    if (!open) return;
    _open(token!, userId);
  }

  void _open(String token, String? userId) {
    _generation++;
    final generation = _generation;
    _authRejected = false;
    _boundToken = token;
    _boundUserId = userId;
    _serverDisconnects = 0;
    _reconnectTimer?.cancel();
    final previous = socket;
    socket = null;
    _destroy(previous);
    _dropCachedManager(Url().socketUrl);

    final active = io.io(Url().socketUrl, buildSocketOptions(token));
    socket = active;
    _attachLifecycle(active, generation);
    active.connect();
  }

  void _attachLifecycle(io.Socket active, int generation) {
    active.onConnect((_) {
      if (!_isCurrent(active, generation)) return;
      _serverDisconnects = 0;
      if (kDebugMode) {
        debugPrint('socket connected');
      }
      _bindBuiltIn(active);
      _restoreHandlers(active);
      for (final binder in List<void Function()>.of(_sessionBinders)) {
        binder();
      }
    });

    active.onReconnect((_) {
      if (!_isCurrent(active, generation)) return;
      _serverDisconnects = 0;
      if (kDebugMode) {
        debugPrint('socket reconnected');
      }
      _bindBuiltIn(active);
      _restoreHandlers(active);
    });

    active.onDisconnect((reason) {
      if (!_isCurrent(active, generation)) return;
      if (kDebugMode) {
        debugPrint('socket disconnected');
      }
      final reasonText = socketErrorText(reason).toLowerCase();
      if (reasonText.contains('client') || _authRejected) return;
      if (!reasonText.contains('server')) return;
      _scheduleServerReconnect(active, generation);
    });

    active.onConnectError((error) {
      if (!_isCurrent(active, generation)) return;
      if (isSocketAuthFailure(error)) {
        _authRejected = true;
        if (kDebugMode) {
          debugPrint('socket connect_error: authentication rejected');
        }
        _reject(active, generation);
        return;
      }
      if (kDebugMode) {
        debugPrint('socket connect_error: transport');
      }
    });
  }

  bool _isCurrent(io.Socket active, int generation) =>
      generation == _generation && identical(socket, active);

  void _scheduleServerReconnect(io.Socket active, int generation) {
    _serverDisconnects += 1;
    if (_serverDisconnects > 8) return;
    _reconnectTimer?.cancel();
    final seconds = _serverDisconnects.clamp(1, 30);
    _reconnectTimer = Timer(Duration(seconds: seconds), () {
      if (!_isCurrent(active, generation) || _authRejected) return;
      if (active.connected) return;
      active.connect();
    });
  }

  void _reject(io.Socket active, int generation) {
    if (generation != _generation) return;
    if (identical(socket, active)) socket = null;
    _reconnectTimer?.cancel();
    try {
      active.io.skipReconnect = true;
      active.io.reconnection = false;
    } catch (_) {}
    _destroy(active);
  }

  void _bindBuiltIn(io.Socket active) {
    if (_notificationEvent != null) {
      active.off(_notificationEvent!);
    }
    final userId = _boundUserId;
    if (userId == null) return;
    _notificationEvent = 'notification-count-$userId';
    active.off(_notificationEvent!);
    active.on(_notificationEvent!, _handleNotification);
  }

  void _handleNotification(dynamic raw) {
    final event = parseNotificationCount(raw);
    if (event == null) return;
    if (!notificationCountForUser(event, _boundUserId)) return;
    _latestNotificationCount = event.count;
    _onNotificationCount?.call(event.count);
  }

  void _restoreHandlers(io.Socket active) {
    for (final entry in _handlers.entries) {
      active.off(entry.key);
      active.on(entry.key, entry.value);
    }
  }

  void _destroy(io.Socket? active) {
    if (active == null) return;
    try {
      active.io.skipReconnect = true;
      active.dispose();
    } catch (_) {}
  }

  void _dropCachedManager(String url) {
    final cached = io.cache.remove(socketCacheId(url));
    if (cached == null) return;
    try {
      cached.disconnect();
    } catch (_) {}
  }

  @visibleForTesting
  static void resetForTest() {
    final current = singleton;
    if (current != null) {
      current._stopTokenListen?.call();
      current._stopUserListen?.call();
      current.disconnect();
    }
    singleton = null;
  }
}
