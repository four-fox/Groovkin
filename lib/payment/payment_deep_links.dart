import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'stripe_connect_controller.dart';

class PaymentDeepLink {
  PaymentDeepLink({
    required this.workflow,
    this.paymentId,
    this.eventId,
    this.cancellationId,
    this.status,
  });

  final String workflow;
  final int? paymentId;
  final int? eventId;
  final int? cancellationId;

  /// Query value from Stripe Connect return/refresh links, e.g.
  /// `success` or `expired`. Informational only; backend status is
  /// always re-fetched before rendering.
  final String? status;

  bool get isConnectReturn =>
      workflow == 'stripe_connect_return' ||
      workflow == 'stripe_connect_refresh' ||
      workflow == 'stripe_connect' ||
      workflow == 'stripe_redirect';

  static PaymentDeepLink? parse(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null || uri.scheme != 'groovkin') return null;
    final segments = uri.pathSegments;
    if (uri.host == 'stripe-redirect') {
      return PaymentDeepLink(workflow: 'stripe_redirect');
    }
    if (uri.host == 'payments' && segments.isNotEmpty) {
      return PaymentDeepLink(
        workflow: 'payment',
        paymentId: int.tryParse(segments.first),
      );
    }
    if (uri.host == 'events' && segments.length >= 2) {
      final eventId = int.tryParse(segments.first);
      if (segments[1] == 'completion') {
        return PaymentDeepLink(workflow: 'completion', eventId: eventId);
      }
      if (segments[1] == 'counter') {
        return PaymentDeepLink(workflow: 'counter', eventId: eventId);
      }
    }
    if (uri.host == 'cancellations' && segments.isNotEmpty) {
      return PaymentDeepLink(
        workflow: 'cancellation',
        cancellationId: int.tryParse(segments.first),
      );
    }
    if (uri.host == 'stripe-connect') {
      final action = segments.isNotEmpty ? segments.first : 'status';
      switch (action) {
        case 'return':
          return PaymentDeepLink(
            workflow: 'stripe_connect_return',
            status: uri.queryParameters['status'],
          );
        case 'refresh':
          return PaymentDeepLink(
            workflow: 'stripe_connect_refresh',
            status: uri.queryParameters['status'],
          );
        case 'status':
          return PaymentDeepLink(workflow: 'stripe_connect');
      }
    }
    return null;
  }

  void navigate() {
    switch (workflow) {
      case 'payment':
        if (paymentId != null) {
          Get.toNamed(Routes.paymentStatusScreen,
              arguments: {'paymentId': paymentId});
        }
        break;
      case 'completion':
      case 'counter':
        if (eventId != null) {
          Get.toNamed(Routes.completionWorkflowScreen,
              arguments: {'eventId': eventId});
        }
        break;
      case 'cancellation':
        if (cancellationId != null) {
          Get.toNamed(Routes.cancellationWorkflowScreen, arguments: {
            'cancellationId': cancellationId,
          });
        }
        break;
      case 'stripe_connect':
      case 'stripe_connect_return':
      case 'stripe_connect_refresh':
      case 'stripe_redirect':
        _openConnectStatus();
        break;
    }
  }

  void _openConnectStatus() {
    final expired = workflow == 'stripe_connect_refresh';
    if (Get.currentRoute != Routes.connectOnboardingScreen) {
      Get.toNamed(
        Routes.connectOnboardingScreen,
        arguments: {
          'refreshAfterReturn': true,
          'linkExpired': expired,
        },
      );
    }
    stripeConnectController().handleDeepLinkReturn(linkExpired: expired);
  }
}

/// Listens for OS-level `groovkin://` deep links (cold start and while
/// running) and routes payment/Stripe Connect links to the right screen.
class PaymentDeepLinkService {
  PaymentDeepLinkService._();

  static final PaymentDeepLinkService instance = PaymentDeepLinkService._();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;
  Uri? _pendingInitialLink;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      _pendingInitialLink = await _appLinks.getInitialLink();
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[DeepLink] Failed to read initial link: $error');
      }
    }

    _subscription = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (Object error) {
        if (kDebugMode) {
          debugPrint('[DeepLink] Link stream error: $error');
        }
      },
    );
  }

  /// Called once navigation is ready; replays a cold-start link if any.
  void flushInitialLink() {
    final link = _pendingInitialLink;
    _pendingInitialLink = null;
    if (link != null) {
      _handleUri(link);
    }
  }

  void _handleUri(Uri uri) {
    if (kDebugMode) {
      debugPrint('[DeepLink] Received: ${uri.scheme}://${uri.host}${uri.path}');
    }
    final parsed = PaymentDeepLink.parse(uri.toString());
    parsed?.navigate();
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }
}
