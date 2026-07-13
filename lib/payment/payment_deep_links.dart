import 'package:get/get.dart';
import 'package:groovkin/Routes/app_pages.dart';

class PaymentDeepLink {
  PaymentDeepLink({
    required this.workflow,
    this.paymentId,
    this.eventId,
    this.cancellationId,
  });

  final String workflow;
  final int? paymentId;
  final int? eventId;
  final int? cancellationId;

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
    if (uri.host == 'stripe-connect' &&
        segments.isNotEmpty &&
        segments.first == 'status') {
      return PaymentDeepLink(workflow: 'stripe_connect');
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
      case 'stripe_redirect':
        Get.toNamed(Routes.connectOnboardingScreen);
        break;
    }
  }
}
