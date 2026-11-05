import 'package:socket_io_client/socket_io_client.dart';

/// Engine.IO path required by the production Socket.IO server.
const String kSocketPath = '/socket.io/';

/// Client emit. The server rebroadcasts `typing-{conversationId}`.
const String kTypingEmitEvent = 'typing';

/// Raw Sanctum token for the Socket.IO handshake.
///
/// HTTP calls add `Bearer`. The socket auth map must not.
String? sanctumSocketToken(dynamic raw) {
  if (raw == null) return null;
  var token = raw.toString().trim();
  if (token.isEmpty || token.toLowerCase() == 'null') return null;
  if (token.toLowerCase().startsWith('bearer ')) {
    token = token.substring(7).trim();
  }
  if (token.isEmpty) return null;
  return token;
}

String? normalizeUserId(dynamic raw) {
  if (raw == null) return null;
  final text = raw.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return null;
  return text;
}

/// Same cache key `socket_io_client` uses for Manager reuse.
String socketCacheId(String url) {
  final parsed = Uri.parse(url);
  return '${parsed.scheme}://${parsed.host}:${parsed.port}';
}

/// Options for one authenticated Socket.IO v4 connection.
///
/// `autoConnect` is false so the caller can invoke `connect()` a single time.
/// `forceNew` avoids the client cache after a token or profile change.
Map<String, dynamic> buildSocketOptions(String token) {
  return OptionBuilder()
      .setPath(kSocketPath)
      .setTransports(const ['websocket'])
      .disableAutoConnect()
      .enableForceNew()
      .enableForceNewConnection()
      .setAuth(<String, dynamic>{'token': token})
      .build();
}

/// Open a new socket only when the stored session is usable and not already live.
bool shouldOpenSocket({
  required bool hasLiveSocket,
  required bool authRejected,
  required String? boundToken,
  required String? boundUserId,
  required String? nextToken,
  required String? nextUserId,
}) {
  if (nextToken == null || nextToken.isEmpty) return false;
  final sameSession = boundToken == nextToken && boundUserId == nextUserId;
  if (authRejected && sameSession) return false;
  if (hasLiveSocket && sameSession) return false;
  return true;
}

bool shouldCloseSocket(String? nextToken) =>
    nextToken == null || nextToken.isEmpty;

String socketErrorText(dynamic error) {
  if (error is Map) {
    final message = error['message'] ?? error['data'] ?? error['reason'];
    if (message != null && message is! Map) return message.toString();
    if (message is Map) return socketErrorText(message);
  }
  return error?.toString() ?? '';
}

/// Auth failures must stop reconnect loops. Transport failures must not.
bool isSocketAuthFailure(dynamic error) {
  final text = socketErrorText(error).toLowerCase();
  const hints = <String>[
    'unauthenticated',
    'unauthorized',
    'authentication error',
    'authentication failed',
    'invalid token',
    'token expired',
    'expired token',
    'revoked',
    'auth error',
  ];
  return hints.any(text.contains);
}

Map<String, dynamic>? asStringKeyedMap(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) {
    return raw.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}

int? asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

bool? asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final text = value.trim().toLowerCase();
    if (text == 'true' || text == '1') return true;
    if (text == 'false' || text == '0') return false;
  }
  return null;
}

class NotificationCountEvent {
  const NotificationCountEvent({required this.receiverId, required this.count});

  final String? receiverId;
  final int count;
}

/// `notification-count-{userId}` payload: `receiverId` and `count`.
NotificationCountEvent? parseNotificationCount(dynamic raw) {
  final map = asStringKeyedMap(raw);
  if (map == null) return null;
  final count = asInt(map['count']);
  if (count == null) return null;
  final receiver = map['receiverId'] ?? map['receiver_id'];
  return NotificationCountEvent(
    receiverId: normalizeUserId(receiver),
    count: count,
  );
}

bool notificationCountForUser(NotificationCountEvent event, String? userId) {
  final receiverId = event.receiverId;
  if (receiverId == null || receiverId.isEmpty) return true;
  if (userId == null || userId.isEmpty) return false;
  return receiverId == userId;
}

/// `receiver-message-{userId}` payload contains `message`.
Map<String, dynamic>? parseIncomingMessage(dynamic raw) {
  final map = asStringKeyedMap(raw);
  final message = map?['message'];
  return asStringKeyedMap(message);
}

/// Message ids inside `seen-message-{conversationId}` `data`.
///
/// An empty set means the event named the conversation but not individual rows.
Set<int> parseSeenMessageIds(dynamic raw) {
  final map = asStringKeyedMap(raw);
  if (map == null) return <int>{};
  final payload = map.containsKey('data') ? map['data'] : null;
  final ids = <int>{};
  void take(dynamic node) {
    if (node is Map) {
      final id = asInt(node['id'] ?? node['message_id']);
      if (id != null) ids.add(id);
    } else if (node is List) {
      for (final item in node) {
        take(item);
      }
    } else {
      final id = asInt(node);
      if (id != null) ids.add(id);
    }
  }

  take(payload);
  return ids;
}

/// `message-delete-everyone-{conversationId}` payload contains `data`.
Map<String, dynamic>? parseDeleteEveryoneData(dynamic raw) {
  final map = asStringKeyedMap(raw);
  return asStringKeyedMap(map?['data']);
}

class TypingEvent {
  const TypingEvent({
    required this.conversationId,
    required this.userId,
    required this.isTyping,
  });

  final String? conversationId;
  final String? userId;
  final bool isTyping;
}

/// `typing-{conversationId}` payload: `conversation_id`, `user_id`, `is_typing`.
TypingEvent? parseTypingEvent(dynamic raw) {
  final map = asStringKeyedMap(raw);
  if (map == null || !map.containsKey('is_typing')) return null;
  final isTyping = asBool(map['is_typing']);
  if (isTyping == null) return null;
  return TypingEvent(
    conversationId: normalizeUserId(map['conversation_id']),
    userId: normalizeUserId(map['user_id']),
    isTyping: isTyping,
  );
}

/// Emit body aligned with the broadcast payload. The old `typing` boolean is not sent.
Map<String, dynamic> typingEmitPayload({
  required String conversationId,
  required dynamic userId,
  required bool isTyping,
}) {
  return <String, dynamic>{
    'conversation_id': conversationId,
    'user_id': userId,
    'is_typing': isTyping,
  };
}
