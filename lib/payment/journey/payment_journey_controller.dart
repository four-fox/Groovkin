import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Routes/app_pages.dart';
import '../event_acceptance_coordinator.dart';
import '../payment_controller.dart';
import '../payment_models.dart';
import '../payment_polling_service.dart';
import '../payment_repository.dart';
import '../stripe_config_service.dart';
import '../wallet/wallet_controller.dart';
import 'payment_journey_mapper.dart';
import 'payment_journey_models.dart';

class PaymentJourneyController extends GetxController
    with WidgetsBindingObserver {
  PaymentJourneyController({
    required this.eventId,
    PaymentRepository? repository,
    StripeConfigService? stripeConfigService,
  })  : repository = repository ?? PaymentRepository(),
        stripeConfigService = stripeConfigService ?? StripeConfigService();

  final int eventId;
  final PaymentRepository repository;
  final StripeConfigService stripeConfigService;
  final PaymentPollingService<PaymentJourney> _poller =
      PaymentPollingService<PaymentJourney>();

  PaymentJourney? journey;
  PaymentWorkflowState state = PaymentWorkflowState.initial;
  String? errorMessage;
  String? errorCode;
  bool actionInFlight = false;
  bool _pollingActive = false;
  bool _walletRefreshedForSettlement = false;

  JourneyUiState get ui => journey == null
      ? const JourneyUiState(
          title: 'Payment status',
          explanation: 'Loading payment journey...',
          icon: Icons.hourglass_empty,
          badge: 'Loading',
        )
      : PaymentJourneyMapper.uiFor(journey!);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    refreshJourney();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _poller.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.resumed) {
      refreshJourney(silent: true);
    }
  }

  Future<void> refreshJourney({bool silent = false}) async {
    try {
      if (!silent) {
        state = PaymentWorkflowState.loading;
        errorMessage = null;
        errorCode = null;
        update();
      }
      journey = await repository.getPaymentJourney(eventId);
      state = PaymentWorkflowState.ready;
      errorMessage = null;
      errorCode = null;
      _maybeStartPolling();
      await _maybeRefreshWalletAfterSettlement();
    } on PaymentApiException catch (error) {
      errorCode = error.code;
      errorMessage = _messageForError(error);
      state = error.httpStatus == 403
          ? PaymentWorkflowState.authorizationError
          : PaymentWorkflowState.retryableFailure;
      if (!silent) BotToast.showText(text: errorMessage!);
    } catch (_) {
      errorMessage = 'Unable to connect. Check your internet and try again.';
      state = PaymentWorkflowState.networkError;
      if (!silent) BotToast.showText(text: errorMessage!);
    }
    update();
  }

  void _maybeStartPolling() {
    final current = journey;
    if (current == null ||
        journeyStageStopsPolling(current.journeyStage) ||
        !journeyStageNeedsPolling(current.journeyStage)) {
      _pollingActive = false;
      _poller.stop();
      return;
    }
    // Prevent duplicate polling loops for the same processing stage.
    if (_pollingActive) return;
    _pollingActive = true;
    _poller.start(
      fetch: () => repository.getPaymentJourney(eventId),
      isTerminal: (value) =>
          journeyStageStopsPolling(value.journeyStage) ||
          !journeyStageNeedsPolling(value.journeyStage),
      onValue: (value) async {
        journey = value;
        state = PaymentWorkflowState.ready;
        update();
        await _maybeRefreshWalletAfterSettlement();
      },
      onComplete: () {
        _pollingActive = false;
        _poller.stop();
      },
      // Backend transfer reconciliation typically completes within ~10
      // minutes; bound polling generously beyond that so the UI can observe
      // the automatic transition to financially_settled without user action.
      maxDuration: const Duration(minutes: 15),
      maxDelay: const Duration(seconds: 45),
    );
  }

  Future<void> _maybeRefreshWalletAfterSettlement() async {
    final current = journey;
    if (current == null || !isFinanciallySettled(current.settlementStatus)) {
      if (current != null && !isFinanciallySettled(current.settlementStatus)) {
        _walletRefreshedForSettlement = false;
      }
      return;
    }
    if (_walletRefreshedForSettlement) return;
    _walletRefreshedForSettlement = true;
    try {
      if (Get.isRegistered<WalletController>()) {
        await Get.find<WalletController>().refreshAll(silent: true);
      } else {
        // Warm wallet data so EO/VM see final earnings/payment after settlement.
        final wallet = Get.put(WalletController());
        await wallet.refreshAll(silent: true);
      }
    } catch (_) {
      // Wallet refresh is best-effort after settlement.
    }
  }

  Future<void> runPrimaryAction() async {
    final current = journey;
    if (current == null || actionInFlight) return;
    actionInFlight = true;
    update();
    try {
      switch (current.nextAction.code) {
        case PaymentNextActionCode.completeConnectOnboarding:
          await Get.toNamed(Routes.connectOnboardingScreen);
          break;
        case PaymentNextActionCode.addPaymentMethod:
          await Get.toNamed(
            Routes.securePaymentMethodsScreen,
            arguments: {
              'contextMessage':
                  'Add a secure card before accepting or completing payment.',
              'returnAfterAdd': true,
            },
          );
          break;
        case PaymentNextActionCode.reviewAndAccept:
          await EventAcceptanceCoordinator.startVmAcceptance(eventId);
          break;
        case PaymentNextActionCode.completeDownPayment:
          await _resumePayment(current.nextAction.paymentId ??
              current.downPayment.paymentId ??
              current.finalPayment.paymentId);
          break;
        case PaymentNextActionCode.resumeFinalPayment:
          if (_mustNotChargeFinalPaymentAgain(current)) {
            BotToast.showText(
              text:
                  'Final payment already succeeded. Organizer transfer recovery is handled by Groovkin support.',
            );
            break;
          }
          await _resumePayment(current.nextAction.paymentId ??
              current.finalPayment.paymentId ??
              current.downPayment.paymentId);
          break;
        case PaymentNextActionCode.retryFinalPayment:
          if (_mustNotChargeFinalPaymentAgain(current)) {
            BotToast.showText(
              text:
                  'Final payment already succeeded. Organizer transfer recovery is handled by Groovkin support.',
            );
            break;
          }
          await _retryPayment(
              current.nextAction.paymentId ?? current.finalPayment.paymentId);
          break;
        case PaymentNextActionCode.submitCompletion:
          await _submitCompletion();
          break;
        case PaymentNextActionCode.reviewCompletion:
          await Get.toNamed(
            Routes.completionWorkflowScreen,
            arguments: {'eventId': eventId},
          );
          break;
        case PaymentNextActionCode.reviewCounter:
          await Get.toNamed(
            Routes.completionWorkflowScreen,
            arguments: {'eventId': eventId, 'focusCounter': true},
          );
          break;
        case PaymentNextActionCode.viewCancellation:
          await Get.toNamed(
            Routes.cancellationWorkflowScreen,
            arguments: {
              'eventId': eventId,
              'cancellationId':
                  current.nextAction.cancellationId ?? current.cancellation.id,
            },
          );
          break;
        case PaymentNextActionCode.viewSettlement:
        case PaymentNextActionCode.viewSupportReview:
          await Get.toNamed(Routes.walletHomeScreen);
          break;
        case PaymentNextActionCode.waitForEvent:
        case PaymentNextActionCode.none:
        case PaymentNextActionCode.unknown:
          break;
      }
    } finally {
      actionInFlight = false;
      await refreshJourney();
    }
  }

  Future<void> submitCompletion() => _submitCompletion();

  Future<void> _submitCompletion() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Mark Event Complete?'),
        content: const Text(
          'This notifies the Venue Manager. They have 48 hours to approve or submit a counter.',
        ),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Confirm')),
        ],
      ),
    );
    if (confirmed != true) return;
    actionInFlight = true;
    update();
    try {
      await repository.submitCompletion(eventId);
      BotToast.showText(text: 'Completion requested.');
      await refreshJourney();
    } on PaymentApiException catch (error) {
      await _handleActionError(error);
    } finally {
      actionInFlight = false;
      update();
    }
  }

  Future<void> approveCompletion() async {
    actionInFlight = true;
    update();
    try {
      await repository.approveCompletion(eventId);
      BotToast.showText(text: 'Final payment processing.');
      await refreshJourney();
    } on PaymentApiException catch (error) {
      await _handleActionError(error);
    } finally {
      actionInFlight = false;
      update();
    }
  }

  /// Returns true when the counter was created (caller can close its sheet).
  Future<bool> createCounter({
    required int proposedPrincipalMinor,
    required String message,
  }) async {
    actionInFlight = true;
    update();
    try {
      await repository.createCounter(
        eventId,
        proposedPrincipalMinor: proposedPrincipalMinor,
        message: message,
      );
      BotToast.showText(text: 'Counter submitted.');
      await refreshJourney();
      return true;
    } on PaymentApiException catch (error) {
      await _handleActionError(error);
      return false;
    } finally {
      actionInFlight = false;
      update();
    }
  }

  /// Returns true when the counter revision was accepted by the backend.
  Future<bool> reviseCounter({
    required int counterId,
    required int proposedPrincipalMinor,
    required String message,
  }) async {
    actionInFlight = true;
    update();
    try {
      await repository.reviseCounter(
        counterId,
        proposedPrincipalMinor: proposedPrincipalMinor,
        message: message,
      );
      BotToast.showText(text: 'Counter revised.');
      await refreshJourney();
      return true;
    } on PaymentApiException catch (error) {
      await _handleActionError(error);
      return false;
    } finally {
      actionInFlight = false;
      update();
    }
  }

  Future<void> acceptCounter(int counterId) async {
    actionInFlight = true;
    update();
    try {
      await repository.acceptCounter(counterId);
      BotToast.showText(text: 'Counter accepted. Final payment processing.');
      await refreshJourney();
    } on PaymentApiException catch (error) {
      await _handleActionError(error);
    } finally {
      actionInFlight = false;
      update();
    }
  }

  Future<void> rejectCounter(int counterId) async {
    actionInFlight = true;
    update();
    try {
      await repository.rejectCounter(counterId);
      await refreshJourney();
    } on PaymentApiException catch (error) {
      await _handleActionError(error);
    } finally {
      actionInFlight = false;
      update();
    }
  }

  /// Shows friendly copy; when the backend says the action already happened
  /// (idempotent replay / parameter conflict), re-sync from the journey.
  Future<void> _handleActionError(PaymentApiException error) async {
    BotToast.showText(text: _messageForError(error));
    if (const {
      'payment_already_processing',
      'payment_already_succeeded',
      'payment_attempt_parameter_conflict',
    }.contains(error.code)) {
      await refreshJourney(silent: true);
    }
  }

  /// Once the final PaymentIntent succeeded, never initiate another VM charge.
  /// EO Connect transfer recovery is backend/support-driven only.
  bool _mustNotChargeFinalPaymentAgain(PaymentJourney current) {
    return current.finalPayment.isSucceeded;
  }

  /// Stripe authentication for a final payment in `requires_action`.
  Future<void> resumeFinalPaymentAction() async {
    final current = journey;
    if (current == null || actionInFlight) return;
    if (_mustNotChargeFinalPaymentAgain(current)) {
      await refreshJourney(silent: true);
      return;
    }
    actionInFlight = true;
    update();
    try {
      await _resumePayment(
        current.finalPayment.paymentId ?? current.nextAction.paymentId,
      );
    } finally {
      actionInFlight = false;
      update();
    }
  }

  /// Retry a failed final payment charge.
  Future<void> retryFinalPaymentAction() async {
    final current = journey;
    if (current == null || actionInFlight) return;
    actionInFlight = true;
    update();
    try {
      await _retryPayment(
        current.finalPayment.paymentId ?? current.nextAction.paymentId,
      );
    } finally {
      actionInFlight = false;
      update();
    }
  }

  Future<void> updatePaymentMethod() async {
    await Get.toNamed(
      Routes.securePaymentMethodsScreen,
      arguments: {
        'contextMessage':
            'Update your payment method, then retry the payment if needed.',
        'returnAfterAdd': true,
      },
    );
    await refreshJourney();
  }

  Future<void> _resumePayment(int? paymentId) async {
    if (paymentId == null) {
      BotToast.showText(text: 'Payment reference is missing.');
      return;
    }
    final payment = _paymentController();
    await payment.resumeAuthentication(paymentId);
    await refreshJourney();
  }

  Future<void> _retryPayment(int? paymentId) async {
    if (paymentId == null) {
      BotToast.showText(text: 'Payment reference is missing.');
      return;
    }
    if (journey != null && _mustNotChargeFinalPaymentAgain(journey!)) {
      BotToast.showText(
        text:
            'Final payment already succeeded. Organizer transfer recovery is handled by Groovkin support.',
      );
      return;
    }
    final payment = _paymentController();
    await payment.retryPayment(paymentId);
    await refreshJourney();
  }

  PaymentController _paymentController() {
    if (Get.isRegistered<PaymentController>()) {
      return Get.find<PaymentController>();
    }
    return Get.put(PaymentController());
  }

  String _messageForError(PaymentApiException error) {
    switch (error.code) {
      case 'unauthorized_event_payment_access':
        return 'You are not authorized to view payment information for this event.';
      case 'payment_journey_not_found':
        return 'Payment journey is not available for this event yet.';
      case 'payment_method_required':
        return 'Add a secure card before accepting or completing payment.';
      case 'vm_connect_onboarding_incomplete':
      case 'connect_onboarding_incomplete':
        return 'Complete your Stripe account setup before continuing.';
      case 'eo_connect_onboarding_incomplete':
        return 'The Event Organizer must complete their Stripe payout setup first.';
      case 'payment_requires_action':
        return 'Payment authentication is required to continue.';
      case 'payment_failed':
        return 'Payment failed. Update your payment method or try again.';
      case 'invalid_payment_state':
        return 'This payment step is not available right now.';
      case 'completion_not_available':
        return 'Completion is not available for this event yet.';
      case 'completion_amount_prohibited':
        return 'Completion cannot include an amount. Approve or counter instead.';
      case 'counter_active':
        return 'A counter is already open for this event.';
      case 'counter_expired':
        return 'This counter has expired.';
      case 'counter_amount_exceeds_event_principal':
        return 'Counter amount cannot exceed the agreed event total.';
      case 'payment_already_processing':
      case 'payment_already_succeeded':
        return 'This payment is already being handled. Refreshing status...';
      case 'payment_attempt_parameter_conflict':
        return 'Something changed on this payment. Refresh and try again.';
      case 'manual_review_required':
        return 'This event needs manual review before it can continue.';
      default:
        if (error.httpStatus == 401) return 'Please log in again.';
        if (error.httpStatus == 0) {
          return 'Unable to connect. Check your internet and try again.';
        }
        return error.message;
    }
  }
}

PaymentJourneyController paymentJourneyController(int eventId) {
  final tag = 'payment_journey_$eventId';
  if (Get.isRegistered<PaymentJourneyController>(tag: tag)) {
    return Get.find<PaymentJourneyController>(tag: tag);
  }
  return Get.put(PaymentJourneyController(eventId: eventId), tag: tag);
}
