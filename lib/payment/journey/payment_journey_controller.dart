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
    if (current == null || !journeyStageNeedsPolling(current.journeyStage)) {
      _poller.stop();
      return;
    }
    _poller.start(
      fetch: () => repository.getPaymentJourney(eventId),
      isTerminal: (value) => !journeyStageNeedsPolling(value.journeyStage),
      onValue: (value) {
        journey = value;
        state = PaymentWorkflowState.ready;
        update();
      },
      maxDuration: const Duration(minutes: 4),
    );
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
        case PaymentNextActionCode.resumeFinalPayment:
          await _resumePayment(current.nextAction.paymentId ??
              current.finalPayment.paymentId ??
              current.downPayment.paymentId);
          break;
        case PaymentNextActionCode.retryFinalPayment:
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
      BotToast.showText(text: _messageForError(error));
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
      BotToast.showText(text: _messageForError(error));
    } finally {
      actionInFlight = false;
      update();
    }
  }

  Future<void> createCounter({
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
      await refreshJourney();
    } on PaymentApiException catch (error) {
      BotToast.showText(text: _messageForError(error));
    } finally {
      actionInFlight = false;
      update();
    }
  }

  Future<void> reviseCounter({
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
      await refreshJourney();
    } on PaymentApiException catch (error) {
      BotToast.showText(text: _messageForError(error));
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
      await refreshJourney();
    } on PaymentApiException catch (error) {
      BotToast.showText(text: _messageForError(error));
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
      BotToast.showText(text: _messageForError(error));
    } finally {
      actionInFlight = false;
      update();
    }
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
      case 'counter_active':
        return 'A counter is already open for this event.';
      case 'counter_expired':
        return 'This counter has expired.';
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
