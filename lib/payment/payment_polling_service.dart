import 'dart:async';

class PaymentPollingService<T> {
  Timer? _timer;
  bool _disposed = false;
  int _attempt = 0;

  void start({
    required Future<T> Function() fetch,
    required bool Function(T value) isTerminal,
    required void Function(T value) onValue,
    void Function(Object error)? onError,
    Duration initialDelay = const Duration(seconds: 2),
    Duration maxDelay = const Duration(seconds: 20),
    Duration maxDuration = const Duration(minutes: 3),
  }) {
    stop();
    final startedAt = DateTime.now();

    Future<void> tick() async {
      if (_disposed) return;
      try {
        final value = await fetch();
        onValue(value);
        if (isTerminal(value)) return;
      } catch (error) {
        onError?.call(error);
      }
      if (_disposed || DateTime.now().difference(startedAt) >= maxDuration) {
        return;
      }
      _attempt += 1;
      final seconds =
          initialDelay.inSeconds * (1 << (_attempt > 4 ? 4 : _attempt));
      final delay = Duration(
        seconds: seconds > maxDelay.inSeconds ? maxDelay.inSeconds : seconds,
      );
      _timer = Timer(delay, tick);
    }

    _timer = Timer(initialDelay, tick);
  }

  void refreshNow({
    required Future<T> Function() fetch,
    required void Function(T value) onValue,
    void Function(Object error)? onError,
  }) {
    fetch().then(onValue).catchError((error) {
      onError?.call(error);
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _attempt = 0;
  }

  void dispose() {
    _disposed = true;
    stop();
  }
}
