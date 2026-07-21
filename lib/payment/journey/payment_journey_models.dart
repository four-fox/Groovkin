import '../payment_models.dart';

/// Central journey stages from `PaymentJourneyStages` (Laravel).
enum PaymentJourneyStage {
  proposalCreated,
  awaitingConnectOnboarding,
  awaitingPaymentMethod,
  awaitingAcceptance,
  downPaymentProcessing,
  downPaymentRequiresAction,
  downPaymentFailed,
  eventInProgress,
  completionRequested,
  counterNegotiation,
  supportReview,
  completionApproved,
  completionAutoApproved,
  finalPaymentProcessing,
  finalPaymentRequiresAction,
  finalPaymentFailed,
  finalTransferPending,
  financiallySettled,
  cancellationProcessing,
  cancelled,
  manualReview,
  disputed,
  unknown,
}

enum PaymentNextActionCode {
  completeConnectOnboarding,
  addPaymentMethod,
  reviewAndAccept,
  completeDownPayment,
  waitForEvent,
  submitCompletion,
  reviewCompletion,
  reviewCounter,
  resumeFinalPayment,
  retryFinalPayment,
  viewSupportReview,
  viewCancellation,
  viewSettlement,
  none,
  unknown,
}

PaymentJourneyStage parsePaymentJourneyStage(String? value) {
  switch (value) {
    case 'proposal_created':
      return PaymentJourneyStage.proposalCreated;
    case 'awaiting_connect_onboarding':
      return PaymentJourneyStage.awaitingConnectOnboarding;
    case 'awaiting_payment_method':
      return PaymentJourneyStage.awaitingPaymentMethod;
    case 'awaiting_acceptance':
      return PaymentJourneyStage.awaitingAcceptance;
    case 'down_payment_processing':
      return PaymentJourneyStage.downPaymentProcessing;
    case 'down_payment_requires_action':
      return PaymentJourneyStage.downPaymentRequiresAction;
    case 'down_payment_failed':
      return PaymentJourneyStage.downPaymentFailed;
    case 'event_in_progress':
      return PaymentJourneyStage.eventInProgress;
    case 'completion_requested':
      return PaymentJourneyStage.completionRequested;
    case 'counter_negotiation':
      return PaymentJourneyStage.counterNegotiation;
    case 'support_review':
      return PaymentJourneyStage.supportReview;
    case 'completion_approved':
      return PaymentJourneyStage.completionApproved;
    case 'completion_auto_approved':
      return PaymentJourneyStage.completionAutoApproved;
    case 'final_payment_processing':
      return PaymentJourneyStage.finalPaymentProcessing;
    case 'final_payment_requires_action':
      return PaymentJourneyStage.finalPaymentRequiresAction;
    case 'final_payment_failed':
      return PaymentJourneyStage.finalPaymentFailed;
    case 'final_transfer_pending':
      return PaymentJourneyStage.finalTransferPending;
    case 'financially_settled':
      return PaymentJourneyStage.financiallySettled;
    case 'cancellation_processing':
      return PaymentJourneyStage.cancellationProcessing;
    case 'cancelled':
      return PaymentJourneyStage.cancelled;
    case 'manual_review':
      return PaymentJourneyStage.manualReview;
    case 'disputed':
      return PaymentJourneyStage.disputed;
    default:
      return PaymentJourneyStage.unknown;
  }
}

String paymentJourneyStageWire(PaymentJourneyStage stage) {
  switch (stage) {
    case PaymentJourneyStage.proposalCreated:
      return 'proposal_created';
    case PaymentJourneyStage.awaitingConnectOnboarding:
      return 'awaiting_connect_onboarding';
    case PaymentJourneyStage.awaitingPaymentMethod:
      return 'awaiting_payment_method';
    case PaymentJourneyStage.awaitingAcceptance:
      return 'awaiting_acceptance';
    case PaymentJourneyStage.downPaymentProcessing:
      return 'down_payment_processing';
    case PaymentJourneyStage.downPaymentRequiresAction:
      return 'down_payment_requires_action';
    case PaymentJourneyStage.downPaymentFailed:
      return 'down_payment_failed';
    case PaymentJourneyStage.eventInProgress:
      return 'event_in_progress';
    case PaymentJourneyStage.completionRequested:
      return 'completion_requested';
    case PaymentJourneyStage.counterNegotiation:
      return 'counter_negotiation';
    case PaymentJourneyStage.supportReview:
      return 'support_review';
    case PaymentJourneyStage.completionApproved:
      return 'completion_approved';
    case PaymentJourneyStage.completionAutoApproved:
      return 'completion_auto_approved';
    case PaymentJourneyStage.finalPaymentProcessing:
      return 'final_payment_processing';
    case PaymentJourneyStage.finalPaymentRequiresAction:
      return 'final_payment_requires_action';
    case PaymentJourneyStage.finalPaymentFailed:
      return 'final_payment_failed';
    case PaymentJourneyStage.finalTransferPending:
      return 'final_transfer_pending';
    case PaymentJourneyStage.financiallySettled:
      return 'financially_settled';
    case PaymentJourneyStage.cancellationProcessing:
      return 'cancellation_processing';
    case PaymentJourneyStage.cancelled:
      return 'cancelled';
    case PaymentJourneyStage.manualReview:
      return 'manual_review';
    case PaymentJourneyStage.disputed:
      return 'disputed';
    case PaymentJourneyStage.unknown:
      return 'unknown';
  }
}

PaymentNextActionCode parsePaymentNextActionCode(String? value) {
  switch (value) {
    case 'complete_connect_onboarding':
      return PaymentNextActionCode.completeConnectOnboarding;
    case 'add_payment_method':
      return PaymentNextActionCode.addPaymentMethod;
    case 'review_and_accept':
      return PaymentNextActionCode.reviewAndAccept;
    case 'complete_down_payment':
      return PaymentNextActionCode.completeDownPayment;
    case 'wait_for_event':
      return PaymentNextActionCode.waitForEvent;
    case 'submit_completion':
      return PaymentNextActionCode.submitCompletion;
    case 'review_completion':
      return PaymentNextActionCode.reviewCompletion;
    case 'review_counter':
      return PaymentNextActionCode.reviewCounter;
    case 'resume_final_payment':
      return PaymentNextActionCode.resumeFinalPayment;
    case 'retry_final_payment':
      return PaymentNextActionCode.retryFinalPayment;
    case 'view_support_review':
      return PaymentNextActionCode.viewSupportReview;
    case 'view_cancellation':
      return PaymentNextActionCode.viewCancellation;
    case 'view_settlement':
      return PaymentNextActionCode.viewSettlement;
    case 'none':
    case null:
    case '':
      return PaymentNextActionCode.none;
    default:
      return PaymentNextActionCode.unknown;
  }
}

bool journeyStageNeedsPolling(PaymentJourneyStage stage) {
  return const {
    PaymentJourneyStage.downPaymentProcessing,
    PaymentJourneyStage.finalPaymentProcessing,
    PaymentJourneyStage.finalTransferPending,
    PaymentJourneyStage.cancellationProcessing,
    PaymentJourneyStage.completionRequested,
    PaymentJourneyStage.counterNegotiation,
  }.contains(stage);
}

class PaymentOverview {
  PaymentOverview({
    this.journeyStage = PaymentJourneyStage.unknown,
    this.settlementStatus,
    this.downPaymentPercentage,
    this.downPaymentPaidMinor,
    this.remainingPrincipalMinor,
    this.nextActionCode = PaymentNextActionCode.none,
    this.hasPaymentActivity = false,
  });

  final PaymentJourneyStage journeyStage;
  final String? settlementStatus;
  final String? downPaymentPercentage;
  final int? downPaymentPaidMinor;
  final int? remainingPrincipalMinor;
  final PaymentNextActionCode nextActionCode;
  final bool hasPaymentActivity;

  factory PaymentOverview.fromJson(Map<String, dynamic> json) {
    return PaymentOverview(
      journeyStage: parsePaymentJourneyStage(json['journey_stage']?.toString()),
      settlementStatus: json['settlement_status']?.toString(),
      downPaymentPercentage: json['down_payment_percentage']?.toString(),
      downPaymentPaidMinor: _readInt(json['down_payment_paid_minor']),
      remainingPrincipalMinor: _readInt(json['remaining_principal_minor']),
      nextActionCode:
          parsePaymentNextActionCode(json['next_action_code']?.toString()),
      hasPaymentActivity: json['has_payment_activity'] == true,
    );
  }
}

class JourneyReadiness {
  const JourneyReadiness({
    this.vmConnectReady = false,
    this.eoConnectReady = false,
    this.paymentMethodReady = false,
  });

  final bool vmConnectReady;
  final bool eoConnectReady;
  final bool paymentMethodReady;

  factory JourneyReadiness.fromJson(Map<String, dynamic>? json) {
    if (json == null) return JourneyReadiness();
    return JourneyReadiness(
      vmConnectReady: json['vm_connect_ready'] == true,
      eoConnectReady: json['eo_connect_ready'] == true,
      paymentMethodReady: json['payment_method_ready'] == true ||
          json['has_payment_method'] == true,
    );
  }
}

class JourneyAgreement {
  const JourneyAgreement({
    this.accepted = false,
    this.acceptedAt,
    this.acceptedBy,
  });

  final bool accepted;
  final DateTime? acceptedAt;
  final String? acceptedBy;

  factory JourneyAgreement.fromJson(Map<String, dynamic>? json) {
    if (json == null) return JourneyAgreement();
    return JourneyAgreement(
      accepted: json['accepted'] == true || json['is_accepted'] == true,
      acceptedAt: DateTime.tryParse(json['accepted_at']?.toString() ?? ''),
      acceptedBy: json['accepted_by']?.toString(),
    );
  }
}

class JourneyTotals {
  JourneyTotals({
    this.currency = 'USD',
    this.eventPrincipalMinor,
    this.downPaymentPercentage,
    this.downPaymentPrincipalMinor,
    this.downPaymentPaidMinor,
    this.remainingPrincipalMinor,
    this.estimatedStripeFeeMinor,
    this.chargeAmountMinor,
    this.groovkinCommissionMinor,
    this.organizerProceedsMinor,
  });

  final String currency;
  final int? eventPrincipalMinor;
  final String? downPaymentPercentage;
  final int? downPaymentPrincipalMinor;
  final int? downPaymentPaidMinor;
  final int? remainingPrincipalMinor;
  final int? estimatedStripeFeeMinor;
  final int? chargeAmountMinor;
  final int? groovkinCommissionMinor;
  final int? organizerProceedsMinor;

  factory JourneyTotals.fromJson(Map<String, dynamic>? json) {
    if (json == null) return JourneyTotals();
    return JourneyTotals(
      currency: (json['currency']?.toString() ?? 'USD').toUpperCase(),
      eventPrincipalMinor: _readInt(json['event_principal_minor']),
      downPaymentPercentage: json['down_payment_percentage']?.toString(),
      downPaymentPrincipalMinor: _readInt(json['down_payment_principal_minor']),
      downPaymentPaidMinor: _readInt(json['down_payment_paid_minor']),
      remainingPrincipalMinor: _readInt(json['remaining_principal_minor']),
      estimatedStripeFeeMinor: _readInt(
        json['estimated_stripe_fee_minor'] ??
            json['estimated_down_payment_stripe_fee_minor'] ??
            json['stripe_fee_minor'],
      ),
      chargeAmountMinor: _readInt(
        json['charge_amount_minor'] ?? json['total_charge_minor'],
      ),
      groovkinCommissionMinor: _readInt(
        json['groovkin_commission_minor'] ??
            json['target_total_groovkin_commission_minor'],
      ),
      organizerProceedsMinor: _readInt(
        json['organizer_proceeds_minor'] ?? json['eo_proceeds_minor'],
      ),
    );
  }
}

class JourneyPaymentSlice {
  JourneyPaymentSlice({
    this.status,
    this.principalMinor,
    this.stripeFeeMinor,
    this.chargeAmountMinor,
    this.paymentId,
    this.paidAt,
    this.transferStatus,
    this.transferAmountMinor,
    this.organizerProceedsMinor,
    this.groovkinCommissionMinor,
  });

  final String? status;
  final int? principalMinor;
  final int? stripeFeeMinor;
  final int? chargeAmountMinor;
  final int? paymentId;
  final DateTime? paidAt;
  final String? transferStatus;
  final int? transferAmountMinor;
  final int? organizerProceedsMinor;
  final int? groovkinCommissionMinor;

  bool get isSucceeded =>
      status == 'succeeded' || status == 'paid' || status == 'transferred';

  factory JourneyPaymentSlice.fromJson(Map<String, dynamic>? json) {
    if (json == null) return JourneyPaymentSlice();
    return JourneyPaymentSlice(
      status: json['status']?.toString(),
      principalMinor: _readInt(
        json['principal_minor'] ?? json['installment_principal_minor'],
      ),
      stripeFeeMinor: _readInt(
        json['stripe_fee_minor'] ?? json['vm_stripe_fee_top_up_minor'],
      ),
      chargeAmountMinor: _readInt(json['charge_amount_minor']),
      paymentId: _readInt(json['payment_id'] ?? json['id']),
      paidAt: DateTime.tryParse(
        json['paid_at']?.toString() ?? json['succeeded_at']?.toString() ?? '',
      ),
      transferStatus: json['transfer_status']?.toString(),
      transferAmountMinor: _readInt(json['transfer_amount_minor']),
      organizerProceedsMinor: _readInt(json['organizer_proceeds_minor']),
      groovkinCommissionMinor: _readInt(json['groovkin_commission_minor']),
    );
  }
}

class JourneyCounter {
  JourneyCounter({
    this.id,
    this.proposedPrincipalMinor,
    this.originalPrincipalMinor,
    this.message,
    this.status,
    this.counterSecondsRemaining,
    this.createdAt,
    this.history = const [],
  });

  final int? id;
  final int? proposedPrincipalMinor;
  final int? originalPrincipalMinor;
  final String? message;
  final String? status;
  final int? counterSecondsRemaining;
  final DateTime? createdAt;
  final List<Map<String, dynamic>> history;

  int? get differenceMinor {
    if (proposedPrincipalMinor == null || originalPrincipalMinor == null) {
      return null;
    }
    return proposedPrincipalMinor! - originalPrincipalMinor!;
  }

  factory JourneyCounter.fromJson(Map<String, dynamic>? json) {
    if (json == null) return JourneyCounter();
    final historyRaw = json['history'];
    return JourneyCounter(
      id: _readInt(json['id'] ?? json['counter_id']),
      proposedPrincipalMinor: _readInt(json['proposed_principal_minor']),
      originalPrincipalMinor: _readInt(
        json['original_principal_minor'] ?? json['event_principal_minor'],
      ),
      message: json['message']?.toString(),
      status: json['status']?.toString(),
      counterSecondsRemaining: _readInt(json['counter_seconds_remaining']),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      history: historyRaw is List
          ? historyRaw
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
          : const [],
    );
  }
}

class JourneyCompletion {
  JourneyCompletion({
    this.status,
    this.requestedAt,
    this.autoApproveAt,
    this.autoApproveSecondsRemaining,
    this.counterSecondsRemaining,
    this.latestCounter,
  });

  final String? status;
  final DateTime? requestedAt;
  final DateTime? autoApproveAt;
  final int? autoApproveSecondsRemaining;
  final int? counterSecondsRemaining;
  final JourneyCounter? latestCounter;

  factory JourneyCompletion.fromJson(Map<String, dynamic>? json) {
    if (json == null) return JourneyCompletion();
    final counter = json['latest_counter'] ?? json['counter'];
    return JourneyCompletion(
      status: json['status']?.toString(),
      requestedAt: DateTime.tryParse(json['requested_at']?.toString() ?? ''),
      autoApproveAt: DateTime.tryParse(
        json['auto_approve_at']?.toString() ??
            json['auto_approval_at']?.toString() ??
            '',
      ),
      autoApproveSecondsRemaining:
          _readInt(json['auto_approve_seconds_remaining']),
      counterSecondsRemaining: _readInt(json['counter_seconds_remaining']),
      latestCounter: counter is Map
          ? JourneyCounter.fromJson(Map<String, dynamic>.from(counter))
          : null,
    );
  }
}

class JourneyCancellation {
  JourneyCancellation({
    this.id,
    this.status,
    this.supportReference,
  });

  final int? id;
  final String? status;
  final String? supportReference;

  factory JourneyCancellation.fromJson(Map<String, dynamic>? json) {
    if (json == null) return JourneyCancellation();
    return JourneyCancellation(
      id: _readInt(json['id'] ?? json['cancellation_id']),
      status: json['status']?.toString(),
      supportReference: json['support_reference']?.toString(),
    );
  }
}

class JourneyPermissions {
  JourneyPermissions({
    this.canSubmitCompletion = false,
    this.canApproveCompletion = false,
    this.canCreateCounter = false,
    this.canAcceptCounter = false,
    this.canRejectCounter = false,
    this.canReviseCounter = false,
    this.canResumePayment = false,
    this.canRetryPayment = false,
    this.canCancel = false,
    this.canViewWallet = false,
    this.canEscalate = false,
  });

  final bool canSubmitCompletion;
  final bool canApproveCompletion;
  final bool canCreateCounter;
  final bool canAcceptCounter;
  final bool canRejectCounter;
  final bool canReviseCounter;
  final bool canResumePayment;
  final bool canRetryPayment;
  final bool canCancel;
  final bool canViewWallet;
  final bool canEscalate;

  factory JourneyPermissions.fromJson(Map<String, dynamic>? json) {
    if (json == null) return JourneyPermissions();
    bool flag(String a, [String? b]) =>
        json[a] == true || (b != null && json[b] == true);
    return JourneyPermissions(
      canSubmitCompletion: flag('can_submit_completion', 'submit_completion'),
      canApproveCompletion:
          flag('can_approve_completion', 'approve_completion'),
      canCreateCounter: flag('can_create_counter', 'create_counter'),
      canAcceptCounter: flag('can_accept_counter', 'accept_counter'),
      canRejectCounter: flag('can_reject_counter', 'reject_counter'),
      canReviseCounter: flag('can_revise_counter', 'revise_counter'),
      canResumePayment: flag('can_resume_payment', 'resume_payment'),
      canRetryPayment: flag('can_retry_payment', 'retry_payment'),
      canCancel: flag('can_cancel', 'request_cancellation'),
      canViewWallet: flag('can_view_wallet', 'view_wallet'),
      canEscalate: flag('can_escalate', 'escalate_completion'),
    );
  }
}

class JourneyNextAction {
  JourneyNextAction({
    this.code = PaymentNextActionCode.none,
    this.label,
    this.paymentId,
    this.counterId,
    this.cancellationId,
  });

  final PaymentNextActionCode code;
  final String? label;
  final int? paymentId;
  final int? counterId;
  final int? cancellationId;

  factory JourneyNextAction.fromJson(dynamic raw) {
    if (raw is String) {
      return JourneyNextAction(code: parsePaymentNextActionCode(raw));
    }
    if (raw is! Map) return JourneyNextAction();
    final json = Map<String, dynamic>.from(raw);
    return JourneyNextAction(
      code: parsePaymentNextActionCode(
        json['code']?.toString() ?? json['next_action_code']?.toString(),
      ),
      label: json['label']?.toString() ?? json['title']?.toString(),
      paymentId: _readInt(json['payment_id']),
      counterId: _readInt(json['counter_id']),
      cancellationId: _readInt(json['cancellation_id']),
    );
  }
}

class JourneyTimelineEvent {
  JourneyTimelineEvent({
    this.code,
    this.title,
    this.status,
    this.occurredAt,
    this.amountMinor,
    this.currency = 'USD',
    this.details = const {},
  });

  final String? code;
  final String? title;
  final String? status;
  final DateTime? occurredAt;
  final int? amountMinor;
  final String currency;
  final Map<String, dynamic> details;

  factory JourneyTimelineEvent.fromJson(Map<String, dynamic> json) {
    final detailsRaw = json['details'];
    return JourneyTimelineEvent(
      code: json['code']?.toString() ?? json['type']?.toString(),
      title: json['title']?.toString() ?? json['label']?.toString(),
      status: json['status']?.toString(),
      occurredAt: DateTime.tryParse(
        json['occurred_at']?.toString() ??
            json['created_at']?.toString() ??
            json['at']?.toString() ??
            '',
      ),
      amountMinor: _readInt(json['amount_minor'] ?? json['principal_minor']),
      currency: (json['currency']?.toString() ?? 'USD').toUpperCase(),
      details:
          detailsRaw is Map ? Map<String, dynamic>.from(detailsRaw) : const {},
    );
  }
}

/// Full role-aware payment journey from `GET /api/events/{event}/payment-journey`.
class PaymentJourney {
  PaymentJourney({
    required this.eventId,
    this.role,
    this.journeyStage = PaymentJourneyStage.unknown,
    this.settlementStatus,
    this.currency = 'USD',
    this.readiness = const JourneyReadiness(),
    this.agreement = const JourneyAgreement(),
    JourneyTotals? totals,
    JourneyPaymentSlice? downPayment,
    JourneyCompletion? completion,
    JourneyPaymentSlice? finalPayment,
    JourneyCancellation? cancellation,
    JourneyPermissions? permissions,
    JourneyNextAction? nextAction,
    this.timeline = const [],
  })  : totals = totals ?? JourneyTotals(),
        downPayment = downPayment ?? JourneyPaymentSlice(),
        completion = completion ?? JourneyCompletion(),
        finalPayment = finalPayment ?? JourneyPaymentSlice(),
        cancellation = cancellation ?? JourneyCancellation(),
        permissions = permissions ?? JourneyPermissions(),
        nextAction = nextAction ?? JourneyNextAction();

  final int eventId;
  final String? role;
  final PaymentJourneyStage journeyStage;
  final String? settlementStatus;
  final String currency;
  final JourneyReadiness readiness;
  final JourneyAgreement agreement;
  final JourneyTotals totals;
  final JourneyPaymentSlice downPayment;
  final JourneyCompletion completion;
  final JourneyPaymentSlice finalPayment;
  final JourneyCancellation cancellation;
  final JourneyPermissions permissions;
  final JourneyNextAction nextAction;
  final List<JourneyTimelineEvent> timeline;

  bool get isVenueManager =>
      role == 'venue_manager' || role == 'eventManager' || role == 'vm';

  bool get isEventOrganizer =>
      role == 'event_owner' ||
      role == 'eventOrganizer' ||
      role == 'eo' ||
      role == 'event_organizer';

  factory PaymentJourney.fromJson(Map<String, dynamic> json) {
    final totalsMap = _asMap(json['totals']) ??
        _asMap(json['summary']) ??
        <String, dynamic>{
          if (json['event_principal_minor'] != null)
            'event_principal_minor': json['event_principal_minor'],
          if (json['down_payment_percentage'] != null)
            'down_payment_percentage': json['down_payment_percentage'],
          if (json['down_payment_principal_minor'] != null)
            'down_payment_principal_minor':
                json['down_payment_principal_minor'],
          if (json['down_payment_paid_minor'] != null)
            'down_payment_paid_minor': json['down_payment_paid_minor'],
          if (json['remaining_principal_minor'] != null)
            'remaining_principal_minor': json['remaining_principal_minor'],
          if (json['currency'] != null) 'currency': json['currency'],
        };

    final timelineRaw = json['timeline'];
    return PaymentJourney(
      eventId: _readInt(json['event_id'] ?? json['id']) ?? 0,
      role: json['role']?.toString(),
      journeyStage: parsePaymentJourneyStage(
        json['journey_stage']?.toString() ?? json['stage']?.toString(),
      ),
      settlementStatus: json['settlement_status']?.toString(),
      currency: (json['currency']?.toString() ??
              totalsMap['currency']?.toString() ??
              'USD')
          .toUpperCase(),
      readiness: JourneyReadiness.fromJson(_asMap(json['readiness'])),
      agreement: JourneyAgreement.fromJson(_asMap(json['agreement'])),
      totals: JourneyTotals.fromJson(totalsMap),
      downPayment: JourneyPaymentSlice.fromJson(_asMap(json['down_payment'])),
      completion: JourneyCompletion.fromJson(_asMap(json['completion'])),
      finalPayment: JourneyPaymentSlice.fromJson(_asMap(json['final_payment'])),
      cancellation: JourneyCancellation.fromJson(_asMap(json['cancellation'])),
      permissions: JourneyPermissions.fromJson(_asMap(json['permissions'])),
      nextAction: JourneyNextAction.fromJson(
        json['next_action'] ?? json['next_action_code'],
      ),
      timeline: timelineRaw is List
          ? timelineRaw
              .whereType<Map>()
              .map((e) =>
                  JourneyTimelineEvent.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

int? _readInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

// Re-export helper used by tests that import journey models only.
PaymentApiException journeyUnauthorizedException() {
  return PaymentApiException(
    message:
        'You are not authorized to view payment information for this event.',
    code: 'unauthorized_event_payment_access',
    httpStatus: 403,
  );
}
