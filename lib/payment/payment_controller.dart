import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment_models.dart';
import 'payment_polling_service.dart';
import 'payment_repository.dart';
import 'stripe_config_service.dart';

class PaymentController extends GetxController {
  PaymentController({
    PaymentRepository? repository,
    StripeConfigService? stripeConfigService,
  })  : repository = repository ?? PaymentRepository(),
        stripeConfigService = stripeConfigService ?? StripeConfigService();

  final PaymentRepository repository;
  final StripeConfigService stripeConfigService;
  final PaymentPollingService<PaymentRecord> _paymentPoller =
      PaymentPollingService<PaymentRecord>();
  final PaymentPollingService<CancellationDetail> _cancellationPoller =
      PaymentPollingService<CancellationDetail>();

  PaymentWorkflowState state = PaymentWorkflowState.initial;
  String? errorMessage;
  String? errorCode;
  StripeConnectStatus? connectStatus;
  List<PaymentMethodCard> paymentMethods = [];
  PaymentSummary? paymentSummary;
  PaymentRecord? currentPayment;
  CompletionStatusResponse? completionStatus;
  CancellationPolicy? cancellationPolicy;
  CancellationQuote? cancellationQuote;
  CancellationDetail? cancellationDetail;
  List<dynamic> completionHistory = [];
  List<dynamic> cancellationHistory = [];

  @override
  void onClose() {
    _paymentPoller.dispose();
    _cancellationPoller.dispose();
    super.onClose();
  }

  Future<void> refreshConnectStatus() async {
    await _guard(() async {
      state = PaymentWorkflowState.loading;
      update();
      connectStatus = await repository.getConnectStatus();
      state = PaymentWorkflowState.ready;
    });
  }

  Future<void> launchConnectOnboarding() async {
    await _guard(() async {
      state = PaymentWorkflowState.submitting;
      update();
      final link = await repository.createConnectOnboardingLink();
      final launched = await launchUrl(
        Uri.parse(link.url),
        mode: LaunchMode.externalApplication,
      );
      state = launched
          ? PaymentWorkflowState.processing
          : PaymentWorkflowState.retryableFailure;
    });
  }

  Future<void> refreshPaymentMethods() async {
    await _guard(() async {
      state = PaymentWorkflowState.loading;
      update();
      paymentMethods = await repository.getPaymentMethods();
      state = paymentMethods.isEmpty
          ? PaymentWorkflowState.empty
          : PaymentWorkflowState.ready;
    });
  }

  Future<void> addPaymentMethod({bool setFirstCardDefault = true}) async {
    await _guard(() async {
      state = PaymentWorkflowState.submitting;
      update();
      final setupIntent = await repository.createSetupIntent();
      await stripeConfigService.configureStripe(
        publishableKey: setupIntent.publishableKey,
      );
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Groovkin',
          setupIntentClientSecret: setupIntent.clientSecret,
          returnURL: StripeConfigService.returnUrl,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      state = PaymentWorkflowState.processing;
      update();
      await refreshPaymentMethods();
      if (setFirstCardDefault &&
          paymentMethods.length == 1 &&
          !paymentMethods.first.isDefault) {
        await repository.setDefaultPaymentMethod(
          paymentMethods.first.paymentMethodId,
        );
        await refreshPaymentMethods();
      }
    });
  }

  Future<void> setDefaultPaymentMethod(PaymentMethodCard card) async {
    await _guard(() async {
      state = PaymentWorkflowState.submitting;
      update();
      await repository.setDefaultPaymentMethod(card.paymentMethodId);
      await refreshPaymentMethods();
    });
  }

  Future<void> deletePaymentMethod(PaymentMethodCard card) async {
    await _guard(() async {
      state = PaymentWorkflowState.submitting;
      update();
      await repository.deletePaymentMethod(card.id);
      await refreshPaymentMethods();
    });
  }

  Future<void> loadPaymentSummary(int eventId) async {
    await _guard(() async {
      state = PaymentWorkflowState.loading;
      update();
      paymentSummary = await repository.getPaymentSummary(eventId);
      state = PaymentWorkflowState.ready;
    });
  }

  Future<void> acceptEvent(int eventId, {String? paymentMethodId}) async {
    await _guard(() async {
      state = PaymentWorkflowState.submitting;
      update();
      final result = await repository.acceptEvent(
        eventId,
        paymentMethodId: paymentMethodId,
        idempotencyKey: repository.idempotencyKey('accept_event', eventId),
      );
      paymentSummary = result.summary ?? paymentSummary;
      if (!result.paymentRequired) {
        currentPayment = result.payment;
        state = PaymentWorkflowState.success;
        repository.clearIdempotencyKey('accept_event', eventId);
        return;
      }
      final clientSecret = result.clientSecret;
      final publishableKey = result.publishableKey;
      final paymentId = result.payment?.id;
      if (clientSecret == null || publishableKey == null || paymentId == null) {
        throw PaymentApiException(
          message: 'Payment response was incomplete.',
          retryable: true,
        );
      }
      await stripeConfigService.configureStripe(publishableKey: publishableKey);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Groovkin',
          paymentIntentClientSecret: clientSecret,
          returnURL: StripeConfigService.returnUrl,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      state = PaymentWorkflowState.processing;
      update();
      _pollPayment(paymentId);
    });
  }

  Future<void> loadPayment(int paymentId) async {
    await _guard(() async {
      state = PaymentWorkflowState.refreshing;
      update();
      currentPayment = await repository.getPayment(paymentId);
      state = _stateForPayment(currentPayment!.status);
    });
  }

  Future<void> resumeAuthentication(int paymentId) async {
    await _guard(() async {
      state = PaymentWorkflowState.submitting;
      update();
      final resume = await repository.resumeAuthentication(paymentId);
      if (resume.publishableKey != null) {
        await stripeConfigService.configureStripe(
          publishableKey: resume.publishableKey!,
        );
      }
      await Stripe.instance.handleNextAction(
        resume.clientSecret,
        returnURL: StripeConfigService.returnUrl,
      );
      state = PaymentWorkflowState.processing;
      update();
      _pollPayment(resume.paymentId);
    });
  }

  Future<void> retryPayment(int paymentId) async {
    await _guard(() async {
      state = PaymentWorkflowState.submitting;
      update();
      currentPayment = await repository.retryPayment(
        paymentId,
        repository.idempotencyKey('retry_payment', paymentId),
      );
      _pollPayment(paymentId);
    });
  }

  Future<void> submitCompletion(int eventId) async {
    await _guard(() async {
      state = PaymentWorkflowState.submitting;
      update();
      await repository.submitCompletion(eventId);
      await loadCompletionStatus(eventId);
    });
  }

  Future<void> approveCompletion(int eventId) async {
    await _guard(() async {
      state = PaymentWorkflowState.submitting;
      update();
      await repository.approveCompletion(eventId);
      await loadCompletionStatus(eventId);
    });
  }

  Future<void> loadCompletionStatus(int eventId) async {
    await _guard(() async {
      state = PaymentWorkflowState.loading;
      update();
      completionStatus = await repository.getCompletionStatus(eventId);
      state = _stateForCompletion(completionStatus!.status);
    });
  }

  Future<void> loadCompletionHistory(int eventId) async {
    await _guard(() async {
      completionHistory = await repository.getCompletionHistory(eventId);
      update();
    });
  }

  Future<void> escalateCompletion(int eventId) async {
    await _guard(() async {
      await repository.escalateCompletion(eventId);
      await loadCompletionStatus(eventId);
    });
  }

  Future<void> createCounter(
    int eventId, {
    required int proposedPrincipalMinor,
    required String message,
  }) async {
    await _guard(() async {
      state = PaymentWorkflowState.submitting;
      update();
      await repository.createCounter(
        eventId,
        proposedPrincipalMinor: proposedPrincipalMinor,
        message: message,
      );
      await loadCompletionStatus(eventId);
    });
  }

  Future<void> acceptCounter(int eventId, int counterId) async {
    await _guard(() async {
      await repository.acceptCounter(counterId);
      await loadCompletionStatus(eventId);
    });
  }

  Future<void> rejectCounter(int eventId, int counterId) async {
    await _guard(() async {
      await repository.rejectCounter(counterId);
      await loadCompletionStatus(eventId);
    });
  }

  Future<void> loadCancellationPolicy(int eventId) async {
    await _guard(() async {
      state = PaymentWorkflowState.loading;
      update();
      cancellationPolicy = await repository.getCancellationPolicy(eventId);
      state = PaymentWorkflowState.ready;
    });
  }

  Future<void> createCancellationQuote(
    int eventId, {
    required String reasonType,
    required String reasonMessage,
    required bool forceMajeure,
  }) async {
    await _guard(() async {
      state = PaymentWorkflowState.submitting;
      update();
      cancellationQuote = await repository.createCancellationQuote(
        eventId,
        reasonType: reasonType,
        reasonMessage: reasonMessage,
        forceMajeure: forceMajeure,
      );
      state = PaymentWorkflowState.ready;
    });
  }

  Future<void> confirmCancellation() async {
    final quoteId = cancellationQuote?.id;
    if (quoteId == null) {
      BotToast.showText(text: 'Cancellation quote is missing.');
      return;
    }
    await _guard(() async {
      state = PaymentWorkflowState.submitting;
      update();
      cancellationDetail = await repository.confirmCancellation(
        quoteId,
        repository.idempotencyKey('confirm_cancellation', quoteId),
      );
      state = _stateForCancellation(cancellationDetail!.status);
      final paymentId = cancellationDetail?.payment?.id;
      if (paymentId != null &&
          cancellationDetail!.status == CancellationStatus.paymentProcessing) {
        _pollCancellation(quoteId);
      }
    });
  }

  Future<void> loadCancellation(int cancellationId) async {
    await _guard(() async {
      state = PaymentWorkflowState.loading;
      update();
      cancellationDetail = await repository.getCancellation(cancellationId);
      state = _stateForCancellation(cancellationDetail!.status);
    });
  }

  Future<void> loadCancellationHistory(int cancellationId) async {
    await _guard(() async {
      cancellationHistory =
          await repository.getCancellationHistory(cancellationId);
      update();
    });
  }

  Future<void> resumeCancellationPayment(int cancellationId) async {
    await _guard(() async {
      state = PaymentWorkflowState.submitting;
      update();
      final resume = await repository.resumeCancellationPayment(cancellationId);
      if (resume.publishableKey != null) {
        await stripeConfigService.configureStripe(
          publishableKey: resume.publishableKey!,
        );
      }
      await Stripe.instance.handleNextAction(
        resume.clientSecret,
        returnURL: StripeConfigService.returnUrl,
      );
      state = PaymentWorkflowState.processing;
      update();
      _pollCancellation(cancellationId);
    });
  }

  Future<void> retryCancellationPayment(int cancellationId) async {
    await _guard(() async {
      cancellationDetail = await repository.retryCancellationPayment(
        cancellationId,
        repository.idempotencyKey('retry_cancellation', cancellationId),
      );
      _pollCancellation(cancellationId);
    });
  }

  Future<void> respondForceMajeure(
    int cancellationId, {
    required String responseValue,
    required String message,
  }) async {
    await _guard(() async {
      cancellationDetail = await repository.respondForceMajeure(
        cancellationId,
        responseValue: responseValue,
        message: message,
      );
      state = _stateForCancellation(cancellationDetail!.status);
    });
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      errorCode = null;
      errorMessage = null;
      await action();
    } on PaymentApiException catch (e) {
      errorCode = e.code;
      errorMessage = _messageForError(e);
      state = _stateForError(e);
      BotToast.showText(text: errorMessage!);
    } catch (e) {
      errorMessage = 'Please check your connection and try again.';
      state = PaymentWorkflowState.networkError;
      BotToast.showText(text: errorMessage!);
    }
    update();
  }

  void _pollPayment(int paymentId) {
    _paymentPoller.start(
      fetch: () => repository.getPayment(paymentId),
      isTerminal: (payment) => _isTerminalPayment(payment.status),
      onValue: (payment) {
        currentPayment = payment;
        state = _stateForPayment(payment.status);
        if (_isTerminalPayment(payment.status)) {
          repository.clearIdempotencyKey('retry_payment', paymentId);
        }
        update();
      },
      onError: (error) {
        errorMessage = error.toString();
        state = PaymentWorkflowState.retryableFailure;
        update();
      },
    );
  }

  void _pollCancellation(int cancellationId) {
    _cancellationPoller.start(
      fetch: () => repository.getCancellation(cancellationId),
      isTerminal: (value) => _isTerminalCancellation(value.status),
      onValue: (value) {
        cancellationDetail = value;
        state = _stateForCancellation(value.status);
        update();
      },
    );
  }

  PaymentWorkflowState _stateForPayment(GroovkinPaymentStatus status) {
    switch (status) {
      case GroovkinPaymentStatus.succeeded:
        return PaymentWorkflowState.success;
      case GroovkinPaymentStatus.processing:
      case GroovkinPaymentStatus.created:
        return PaymentWorkflowState.processing;
      case GroovkinPaymentStatus.requiresAction:
        return PaymentWorkflowState.requiresAction;
      case GroovkinPaymentStatus.failed:
      case GroovkinPaymentStatus.cancelled:
        return PaymentWorkflowState.retryableFailure;
      case GroovkinPaymentStatus.manualReview:
        return PaymentWorkflowState.manualReview;
      case GroovkinPaymentStatus.partiallyRefunded:
        return PaymentWorkflowState.partiallyRefunded;
      case GroovkinPaymentStatus.refunded:
        return PaymentWorkflowState.refunded;
      case GroovkinPaymentStatus.disputed:
        return PaymentWorkflowState.disputed;
      case GroovkinPaymentStatus.unknown:
        return PaymentWorkflowState.ready;
    }
  }

  PaymentWorkflowState _stateForCompletion(CompletionStatus status) {
    switch (status) {
      case CompletionStatus.paymentProcessing:
        return PaymentWorkflowState.processing;
      case CompletionStatus.paymentRequiresAction:
        return PaymentWorkflowState.requiresAction;
      case CompletionStatus.paymentFailed:
        return PaymentWorkflowState.retryableFailure;
      case CompletionStatus.supportReview:
        return PaymentWorkflowState.supportReview;
      case CompletionStatus.manualReview:
        return PaymentWorkflowState.manualReview;
      case CompletionStatus.financiallySettled:
      case CompletionStatus.approved:
      case CompletionStatus.autoApproved:
        return PaymentWorkflowState.success;
      default:
        return PaymentWorkflowState.ready;
    }
  }

  PaymentWorkflowState _stateForCancellation(CancellationStatus status) {
    switch (status) {
      case CancellationStatus.paymentProcessing:
      case CancellationStatus.refundPending:
      case CancellationStatus.refundProcessing:
      case CancellationStatus.transferReversalPending:
        return PaymentWorkflowState.processing;
      case CancellationStatus.paymentRequiresAction:
        return PaymentWorkflowState.requiresAction;
      case CancellationStatus.paymentFailed:
        return PaymentWorkflowState.retryableFailure;
      case CancellationStatus.supportReview:
        return PaymentWorkflowState.supportReview;
      case CancellationStatus.manualReview:
        return PaymentWorkflowState.manualReview;
      case CancellationStatus.financiallySettled:
      case CancellationStatus.cancelled:
        return PaymentWorkflowState.success;
      default:
        return PaymentWorkflowState.ready;
    }
  }

  PaymentWorkflowState _stateForError(PaymentApiException e) {
    if (e.httpStatus == 401 || e.code == 'unauthorized_payment_access') {
      return PaymentWorkflowState.authorizationError;
    }
    if (e.httpStatus == 422) return PaymentWorkflowState.validationError;
    return e.retryable
        ? PaymentWorkflowState.retryableFailure
        : PaymentWorkflowState.nonRetryableFailure;
  }

  String _messageForError(PaymentApiException e) {
    switch (e.code) {
      case 'connect_onboarding_incomplete':
        return 'Stripe Connect onboarding must be completed before this payment can continue.';
      case 'payment_method_required':
        return 'A reusable payment method is required.';
      case 'payment_requires_action':
        return 'This payment needs authentication before it can finish.';
      case 'deprecated_raw_card_api':
        return 'This card flow is no longer supported. Please add your card securely with Stripe.';
      case 'legacy_cancellation_flow_disabled':
      case 'cancellation_quote_confirmation_required':
        return 'Please review a cancellation quote before confirming cancellation.';
      case 'counter_amount_exceeds_event_principal':
        return 'The proposed counter amount is above the allowed backend limit.';
      case 'completion_amount_prohibited':
        return 'Completion amount cannot be changed in this step.';
      default:
        return e.message;
    }
  }

  bool _isTerminalPayment(GroovkinPaymentStatus status) {
    return {
      GroovkinPaymentStatus.succeeded,
      GroovkinPaymentStatus.failed,
      GroovkinPaymentStatus.cancelled,
      GroovkinPaymentStatus.manualReview,
      GroovkinPaymentStatus.partiallyRefunded,
      GroovkinPaymentStatus.refunded,
      GroovkinPaymentStatus.disputed,
    }.contains(status);
  }

  bool _isTerminalCancellation(CancellationStatus status) {
    return {
      CancellationStatus.supportReview,
      CancellationStatus.manualReview,
      CancellationStatus.financiallySettled,
      CancellationStatus.cancelled,
      CancellationStatus.paymentFailed,
    }.contains(status);
  }
}
