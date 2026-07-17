import 'package:get/get.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'payment_controller.dart';
import 'payment_models.dart';
import 'stripe_connect_controller.dart';
import 'stripe_connect_models.dart';

class EventAcceptanceCoordinator {
  static Future<bool> startVmAcceptance(int eventId) async {
    final connect = stripeConnectController();
    final payment = _paymentController();

    await connect.refreshConnectStatus();
    if (!connect.isOnboardingComplete) {
      await Get.toNamed(Routes.connectOnboardingScreen);
      await connect.refreshConnectStatus(silent: true);
      if (!connect.isOnboardingComplete) return false;
    }

    await payment.refreshPaymentMethods();
    if (!_hasReusablePaymentMethod(payment.paymentMethods)) {
      await Get.toNamed(
        Routes.securePaymentMethodsScreen,
        arguments: {
          'contextMessage':
              'Add a secure card to continue accepting this event.',
          'returnAfterAdd': true,
        },
      );
      await payment.refreshPaymentMethods();
      if (!_hasReusablePaymentMethod(payment.paymentMethods)) return false;
    }

    final result = await Get.toNamed(
      Routes.eventAcceptPaymentScreen,
      arguments: {'eventId': eventId},
    );
    return result == true;
  }

  static Future<EventAcceptanceBlocker> evaluateVmReadiness({
    required StripeConnectStatus? vmStatus,
    required List<PaymentMethodCard> paymentMethods,
  }) async {
    if (!connectStatusIsReady(vmStatus)) {
      return EventAcceptanceBlocker.vmConnectIncomplete;
    }
    if (!_hasReusablePaymentMethod(paymentMethods)) {
      return EventAcceptanceBlocker.paymentMethodRequired;
    }
    return EventAcceptanceBlocker.none;
  }

  static Future<EventAcceptanceBlocker> acceptEventWithGuard(
    PaymentController payment,
    StripeConnectController connect,
    int eventId,
  ) async {
    await connect.refreshConnectStatus(silent: true);
    await payment.refreshPaymentMethods();

    final readiness = await evaluateVmReadiness(
      vmStatus: connect.status,
      paymentMethods: payment.paymentMethods,
    );
    if (readiness != EventAcceptanceBlocker.none) {
      return readiness;
    }

    try {
      payment.errorCode = null;
      payment.errorMessage = null;
      await payment.acceptEvent(
        eventId,
        paymentMethodId: _defaultPaymentMethodId(payment.paymentMethods),
      );
      const connectErrorCodes = {
        'connect_onboarding_incomplete',
        'vm_connect_onboarding_incomplete',
        'eo_connect_onboarding_incomplete',
        'payment_method_required',
        'stripe_configuration_missing',
      };
      if (connectErrorCodes.contains(payment.errorCode)) {
        return resolveAcceptanceBlocker(
          vmOnboardingComplete: connect.isOnboardingComplete,
          errorCode: payment.errorCode,
          httpStatus: null,
        );
      }
      if (payment.state == PaymentWorkflowState.authorizationError) {
        return EventAcceptanceBlocker.unauthorized;
      }
      if (payment.state == PaymentWorkflowState.networkError) {
        return EventAcceptanceBlocker.networkError;
      }
      if (payment.state == PaymentWorkflowState.validationError) {
        return EventAcceptanceBlocker.validationError;
      }
      if (payment.state == PaymentWorkflowState.retryableFailure ||
          payment.state == PaymentWorkflowState.nonRetryableFailure) {
        return EventAcceptanceBlocker.retryableFailure;
      }
      return EventAcceptanceBlocker.none;
    } on PaymentApiException catch (error) {
      return resolveAcceptanceBlocker(
        vmOnboardingComplete: connect.isOnboardingComplete,
        errorCode: error.code,
        httpStatus: error.httpStatus,
      );
    }
  }

  static bool _hasReusablePaymentMethod(List<PaymentMethodCard> cards) {
    return cards.any((card) => card.isDefault && !card.isExpired);
  }

  static String? _defaultPaymentMethodId(List<PaymentMethodCard> cards) {
    for (final card in cards) {
      if (card.isDefault && !card.isExpired) {
        return card.paymentMethodId;
      }
    }
    return null;
  }

  static PaymentController _paymentController() {
    if (Get.isRegistered<PaymentController>()) {
      return Get.find<PaymentController>();
    }
    return Get.put(PaymentController());
  }
}
