import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment_models.dart';
import 'payment_repository.dart';
import 'stripe_connect_models.dart';

class StripeConnectController extends GetxController
    with WidgetsBindingObserver {
  StripeConnectController({PaymentRepository? repository})
      : repository = repository ?? PaymentRepository();

  final PaymentRepository repository;

  StripeConnectStatus? status;
  PaymentWorkflowState state = PaymentWorkflowState.initial;
  String? errorMessage;
  String? errorCode;
  bool checkingVerificationAfterReturn = false;
  bool awaitingBrowserReturn = false;

  /// True when the user came back through the
  /// `groovkin://stripe-connect/refresh?status=expired` deep link and needs
  /// a fresh onboarding link.
  bool onboardingLinkExpired = false;
  bool _refreshInFlight = false;
  bool _launchInFlight = false;

  StripeConnectRole get role =>
      StripeConnectCopy.roleFromStorage(API().sp.read('role')?.toString());

  bool get isOnboardingComplete => status?.onboardingComplete == true;

  bool get hasRequirementsDue => (status?.requirementsDue ?? []).isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.resumed && awaitingBrowserReturn) {
      handleBrowserReturn();
    }
  }

  Future<void> refreshConnectStatus({
    bool silent = false,
    bool afterReturn = false,
  }) async {
    if (_refreshInFlight) return;
    _refreshInFlight = true;
    try {
      if (afterReturn) {
        checkingVerificationAfterReturn = true;
        update();
      } else if (!silent) {
        state = PaymentWorkflowState.loading;
        errorMessage = null;
        errorCode = null;
        update();
      }

      status = await repository.getConnectStatus();
      state = _stateForStatus(status);
      errorMessage = null;
      errorCode = null;
      if (isOnboardingComplete) {
        onboardingLinkExpired = false;
      }
    } on PaymentApiException catch (error) {
      errorCode = error.code;
      errorMessage = _messageForError(error);
      state = _stateForError(error);
      if (!silent) {
        BotToast.showText(text: errorMessage!);
      }
    } catch (_) {
      errorMessage = 'Unable to connect. Check your internet and try again.';
      state = PaymentWorkflowState.networkError;
      if (!silent) {
        BotToast.showText(text: errorMessage!);
      }
    } finally {
      _refreshInFlight = false;
      checkingVerificationAfterReturn = false;
      update();
    }
  }

  Future<bool> launchConnectOnboarding() async {
    if (_launchInFlight) return false;
    _launchInFlight = true;
    try {
      state = PaymentWorkflowState.submitting;
      errorMessage = null;
      errorCode = null;
      update();

      final link = await repository.createConnectOnboardingLink();
      if (!isValidStripeOnboardingUrl(link.url)) {
        throw PaymentApiException(
          message: 'Stripe onboarding link was invalid. Please try again.',
          retryable: true,
        );
      }

      final launched = await launchUrl(
        Uri.parse(link.url),
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        state = PaymentWorkflowState.retryableFailure;
        errorMessage =
            'Unable to open Stripe onboarding. Check your browser and try again.';
        BotToast.showText(text: errorMessage!);
        update();
        return false;
      }

      onboardingLinkExpired = false;
      awaitingBrowserReturn = true;
      state = PaymentWorkflowState.processing;
      update();
      return true;
    } on PaymentApiException catch (error) {
      errorCode = error.code;
      errorMessage = _messageForError(error);
      state = _stateForError(error);
      BotToast.showText(text: errorMessage!);
      update();
      return false;
    } catch (_) {
      errorMessage = 'Unable to connect. Check your internet and try again.';
      state = PaymentWorkflowState.networkError;
      BotToast.showText(text: errorMessage!);
      update();
      return false;
    } finally {
      _launchInFlight = false;
    }
  }

  Future<void> handleBrowserReturn() async {
    await refreshConnectStatus(afterReturn: true);
    awaitingBrowserReturn = false;
  }

  /// Handles `groovkin://stripe-connect/return` and
  /// `groovkin://stripe-connect/refresh` deep links. The deep link never
  /// marks onboarding complete by itself; the backend status endpoint is
  /// always re-queried.
  Future<void> handleDeepLinkReturn({bool linkExpired = false}) async {
    onboardingLinkExpired = linkExpired;
    awaitingBrowserReturn = true;
    await handleBrowserReturn();
  }

  // Both complete and incomplete statuses render the status card UI, so
  // they map to states that PaymentStateView passes through to the child.
  PaymentWorkflowState _stateForStatus(StripeConnectStatus? value) {
    if (value == null) return PaymentWorkflowState.ready;
    return value.onboardingComplete
        ? PaymentWorkflowState.success
        : PaymentWorkflowState.ready;
  }

  PaymentWorkflowState _stateForError(PaymentApiException error) {
    if (error.httpStatus == 401 ||
        error.code == 'unauthorized_payment_access') {
      return PaymentWorkflowState.authorizationError;
    }
    if (error.httpStatus == 422) {
      return PaymentWorkflowState.validationError;
    }
    return error.retryable
        ? PaymentWorkflowState.retryableFailure
        : PaymentWorkflowState.nonRetryableFailure;
  }

  String _messageForError(PaymentApiException error) {
    switch (error.code) {
      case 'connect_onboarding_incomplete':
      case 'vm_connect_onboarding_incomplete':
        return 'Stripe setup must be completed before this payment can continue.';
      case 'eo_connect_onboarding_incomplete':
        return 'The Event Organizer must complete their Stripe payout setup first.';
      case 'stripe_configuration_missing':
        return 'Payment setup is temporarily unavailable.';
      default:
        if (error.httpStatus == 401) {
          return 'Your session expired. Please sign in again.';
        }
        if (error.httpStatus == 0) {
          return 'Unable to connect. Check your internet and try again.';
        }
        return error.message;
    }
  }
}

StripeConnectController stripeConnectController() {
  if (Get.isRegistered<StripeConnectController>()) {
    return Get.find<StripeConnectController>();
  }
  return Get.put(StripeConnectController(), permanent: true);
}
