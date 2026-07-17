import 'package:intl/intl.dart';

enum PaymentWorkflowState {
  initial,
  loading,
  refreshing,
  ready,
  submitting,
  processing,
  requiresAction,
  success,
  empty,
  validationError,
  networkError,
  authorizationError,
  retryableFailure,
  nonRetryableFailure,
  supportReview,
  manualReview,
  disputed,
  refunded,
  partiallyRefunded,
}

enum GroovkinPaymentStatus {
  created,
  processing,
  requiresAction,
  succeeded,
  failed,
  cancelled,
  manualReview,
  partiallyRefunded,
  refunded,
  disputed,
  unknown,
}

enum CompletionStatus {
  requested,
  countered,
  approved,
  autoApproved,
  paymentProcessing,
  paymentRequiresAction,
  paymentFailed,
  supportReview,
  manualReview,
  financiallySettled,
  cancelled,
  unknown,
}

enum CancellationStatus {
  quoteCreated,
  confirmed,
  paymentRequired,
  paymentProcessing,
  paymentRequiresAction,
  paymentFailed,
  refundPending,
  refundProcessing,
  transferReversalPending,
  supportReview,
  manualReview,
  financiallySettled,
  cancelled,
  unknown,
}

String? readErrorCode(Map<String, dynamic> json) {
  final directCode = json['code'];
  if (directCode is String) return directCode;
  final data = json['data'];
  if (data is Map<String, dynamic> && data['code'] is String) {
    return data['code'] as String;
  }
  return null;
}

class PaymentApiException implements Exception {
  PaymentApiException({
    required this.message,
    this.code,
    this.httpStatus,
    this.retryable = false,
    this.validationErrors = const {},
  });

  final String message;
  final String? code;
  final int? httpStatus;
  final bool retryable;
  final Map<String, String> validationErrors;

  factory PaymentApiException.fromResponse(dynamic response) {
    final data = response?.data;
    final status = response?.statusCode;
    if (data is Map<String, dynamic>) {
      final errors = <String, String>{};
      final rawErrors = data['errors'];
      if (rawErrors is Map) {
        for (final entry in rawErrors.entries) {
          final value = entry.value;
          errors[entry.key.toString()] =
              value is List ? value.first.toString() : value.toString();
        }
      }
      final code = readErrorCode(data);
      final message = (errors.isNotEmpty ? errors.values.first : null) ??
          data['data']?.toString() ??
          data['message']?.toString() ??
          'Payment request failed.';
      return PaymentApiException(
        message: message,
        code: code,
        httpStatus: status,
        retryable: status == 0 ||
            status == 408 ||
            status == 409 ||
            status == 429 ||
            status >= 500,
        validationErrors: errors,
      );
    }
    return PaymentApiException(
      message: 'Payment request failed.',
      httpStatus: status,
      retryable: status == null || status == 0 || status >= 500,
    );
  }

  @override
  String toString() => message;
}

class MoneyFormatter {
  static const _zeroDecimalCurrencies = {
    'BIF',
    'CLP',
    'DJF',
    'GNF',
    'JPY',
    'KMF',
    'KRW',
    'MGA',
    'PYG',
    'RWF',
    'UGX',
    'VND',
    'VUV',
    'XAF',
    'XOF',
    'XPF',
  };

  String formatMinor(
    int? minor, {
    String currency = 'USD',
    String? locale,
    String pendingText = 'Pending',
  }) {
    if (minor == null) return pendingText;
    final isZeroDecimal =
        _zeroDecimalCurrencies.contains(currency.toUpperCase());
    final value = isZeroDecimal ? minor : minor / 100;
    return NumberFormat.simpleCurrency(
      locale: locale,
      name: currency.toUpperCase(),
      decimalDigits: isZeroDecimal ? 0 : 2,
    ).format(value);
  }
}

class StripeConnectStatus {
  StripeConnectStatus({
    this.accountId,
    this.chargesEnabled = false,
    this.payoutsEnabled = false,
    this.detailsSubmitted = false,
    this.onboardingComplete = false,
    this.requirementsDue = const [],
  });

  final String? accountId;
  final bool chargesEnabled;
  final bool payoutsEnabled;
  final bool detailsSubmitted;
  final bool onboardingComplete;
  final List<String> requirementsDue;

  factory StripeConnectStatus.fromJson(Map<String, dynamic> json) {
    return StripeConnectStatus(
      accountId: json['account_id']?.toString(),
      chargesEnabled: json['charges_enabled'] == true,
      payoutsEnabled: json['payouts_enabled'] == true,
      detailsSubmitted: json['details_submitted'] == true,
      onboardingComplete: json['onboarding_complete'] == true,
      requirementsDue: json['requirements_due'] is List
          ? List<String>.from(json['requirements_due'].map((e) => e.toString()))
          : const [],
    );
  }
}

class StripeOnboardingLink {
  StripeOnboardingLink({this.accountId, required this.url});

  final String? accountId;
  final String url;

  factory StripeOnboardingLink.fromJson(Map<String, dynamic> json) {
    final onboarding = json['onboarding'];
    return StripeOnboardingLink(
      accountId: json['account_id']?.toString(),
      url: onboarding is Map
          ? onboarding['url'].toString()
          : json['url'].toString(),
    );
  }
}

class SetupIntentResponse {
  SetupIntentResponse({
    required this.id,
    required this.clientSecret,
    this.customer,
    this.status,
    required this.publishableKey,
  });

  final String id;
  final String clientSecret;
  final String? customer;
  final String? status;
  final String publishableKey;

  factory SetupIntentResponse.fromJson(Map<String, dynamic> json) {
    final clientSecret = json['client_secret']?.toString().trim() ?? '';
    final publishableKey = json['publishable_key']?.toString().trim() ?? '';
    // Avoid `.toString()` on null, which becomes the literal "null".
    if (clientSecret.isEmpty ||
        clientSecret == 'null' ||
        publishableKey.isEmpty ||
        publishableKey == 'null') {
      throw PaymentApiException(
        message: 'Payment setup is temporarily unavailable.',
        code: 'stripe_configuration_missing',
      );
    }
    return SetupIntentResponse(
      id: json['id']?.toString() ?? '',
      clientSecret: clientSecret,
      customer: json['customer']?.toString(),
      status: json['status']?.toString(),
      publishableKey: publishableKey,
    );
  }
}

class PaymentMethodCard {
  PaymentMethodCard({
    required this.id,
    required this.paymentMethodId,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    this.isDefault = false,
    this.status = 'active',
  });

  final int id;
  final String paymentMethodId;
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;
  final bool isDefault;
  final String status;

  bool get isExpired {
    final now = DateTime.now();
    return expYear < now.year || (expYear == now.year && expMonth < now.month);
  }

  factory PaymentMethodCard.fromJson(Map<String, dynamic> json) {
    return PaymentMethodCard(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      paymentMethodId: json['payment_method_id'].toString(),
      brand: json['brand']?.toString() ?? 'card',
      last4: json['last4']?.toString() ?? '',
      expMonth: json['exp_month'] is int
          ? json['exp_month']
          : int.parse(json['exp_month'].toString()),
      expYear: json['exp_year'] is int
          ? json['exp_year']
          : int.parse(json['exp_year'].toString()),
      isDefault: json['default'] == true,
      status: json['status']?.toString() ?? 'active',
    );
  }
}

class PaymentSummary {
  PaymentSummary({
    this.currency = 'USD',
    this.eventPrincipalMinor,
    this.downPaymentPercentage,
    this.downPaymentPrincipalMinor,
    this.remainingPrincipalMinor,
    this.estimatedDownPaymentStripeFeeMinor,
    this.targetTotalGroovkinCommissionMinor,
    this.chargeAmountMinor,
  });

  final String currency;
  final int? eventPrincipalMinor;
  final String? downPaymentPercentage;
  final int? downPaymentPrincipalMinor;
  final int? remainingPrincipalMinor;
  final int? estimatedDownPaymentStripeFeeMinor;
  final int? targetTotalGroovkinCommissionMinor;
  final int? chargeAmountMinor;

  factory PaymentSummary.fromJson(Map<String, dynamic> json) {
    return PaymentSummary(
      currency: json['currency']?.toString() ?? 'USD',
      eventPrincipalMinor: _readInt(json['event_principal_minor']),
      downPaymentPercentage: json['down_payment_percentage']?.toString(),
      downPaymentPrincipalMinor: _readInt(json['down_payment_principal_minor']),
      remainingPrincipalMinor: _readInt(json['remaining_principal_minor']),
      estimatedDownPaymentStripeFeeMinor:
          _readInt(json['estimated_down_payment_stripe_fee_minor']),
      targetTotalGroovkinCommissionMinor:
          _readInt(json['target_total_groovkin_commission_minor']),
      chargeAmountMinor:
          _readInt(json['charge_amount_minor'] ?? json['total_charge_minor']),
    );
  }
}

class PaymentRecord {
  PaymentRecord({
    this.id,
    this.uuid,
    this.status = GroovkinPaymentStatus.unknown,
    this.installmentType,
    this.installmentPrincipalMinor,
    this.vmStripeFeeTopUpMinor,
    this.chargeAmountMinor,
    this.currency = 'USD',
  });

  final int? id;
  final String? uuid;
  final GroovkinPaymentStatus status;
  final String? installmentType;
  final int? installmentPrincipalMinor;
  final int? vmStripeFeeTopUpMinor;
  final int? chargeAmountMinor;
  final String currency;

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      id: _readInt(json['id'] ?? json['payment_id']),
      uuid: json['uuid']?.toString(),
      status: _paymentStatus(json['status']?.toString()),
      installmentType: json['installment_type']?.toString(),
      installmentPrincipalMinor: _readInt(json['installment_principal_minor']),
      vmStripeFeeTopUpMinor: _readInt(json['vm_stripe_fee_top_up_minor']),
      chargeAmountMinor: _readInt(json['charge_amount_minor']),
      currency: json['currency']?.toString() ?? 'USD',
    );
  }
}

class EventAcceptanceResult {
  EventAcceptanceResult({
    required this.paymentRequired,
    this.clientSecret,
    this.publishableKey,
    this.payment,
    this.summary,
  });

  final bool paymentRequired;
  final String? clientSecret;
  final String? publishableKey;
  final PaymentRecord? payment;
  final PaymentSummary? summary;

  factory EventAcceptanceResult.fromJson(Map<String, dynamic> json) {
    return EventAcceptanceResult(
      paymentRequired: json['payment_required'] == true,
      clientSecret: json['client_secret']?.toString(),
      publishableKey: json['publishable_key']?.toString(),
      payment: json['payment'] is Map
          ? PaymentRecord.fromJson(Map<String, dynamic>.from(json['payment']))
          : null,
      summary: json['summary'] is Map
          ? PaymentSummary.fromJson(Map<String, dynamic>.from(json['summary']))
          : null,
    );
  }
}

class ResumeAuthenticationResult {
  ResumeAuthenticationResult({
    required this.paymentId,
    required this.clientSecret,
    this.publishableKey,
    this.uuid,
  });

  final int paymentId;
  final String clientSecret;
  final String? publishableKey;
  final String? uuid;

  factory ResumeAuthenticationResult.fromJson(Map<String, dynamic> json) {
    return ResumeAuthenticationResult(
      paymentId: _readInt(json['payment_id'])!,
      clientSecret: json['client_secret'].toString(),
      publishableKey: json['publishable_key']?.toString(),
      uuid: json['uuid']?.toString(),
    );
  }
}

class CompletionStatusResponse {
  CompletionStatusResponse({
    this.status = CompletionStatus.unknown,
    this.autoApproveSecondsRemaining,
    this.counterSecondsRemaining,
    this.latestCounter,
    this.history = const [],
  });

  final CompletionStatus status;
  final int? autoApproveSecondsRemaining;
  final int? counterSecondsRemaining;
  final CompletionCounter? latestCounter;
  final List<dynamic> history;

  factory CompletionStatusResponse.fromJson(Map<String, dynamic> json) {
    final counter = json['latest_counter'] ?? json['counter'];
    return CompletionStatusResponse(
      status: _completionStatus(
          json['status']?.toString() ?? json['completion_status']?.toString()),
      autoApproveSecondsRemaining:
          _readInt(json['auto_approve_seconds_remaining']),
      counterSecondsRemaining: _readInt(json['counter_seconds_remaining']),
      latestCounter: counter is Map
          ? CompletionCounter.fromJson(Map<String, dynamic>.from(counter))
          : null,
      history: json['history'] is List ? json['history'] : const [],
    );
  }
}

class CompletionCounter {
  CompletionCounter({
    this.id,
    this.proposedPrincipalMinor,
    this.message,
    this.status,
    this.counterSecondsRemaining,
  });

  final int? id;
  final int? proposedPrincipalMinor;
  final String? message;
  final String? status;
  final int? counterSecondsRemaining;

  factory CompletionCounter.fromJson(Map<String, dynamic> json) {
    return CompletionCounter(
      id: _readInt(json['id']),
      proposedPrincipalMinor: _readInt(json['proposed_principal_minor']),
      message: json['message']?.toString(),
      status: json['status']?.toString(),
      counterSecondsRemaining: _readInt(json['counter_seconds_remaining']),
    );
  }
}

class CancellationPolicy {
  CancellationPolicy({required this.raw});

  final Map<String, dynamic> raw;

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) =>
      CancellationPolicy(raw: json);
}

class CancellationQuote {
  CancellationQuote({
    this.id,
    this.policyVersion,
    this.eventTimezoneSnapshot,
    this.daysBeforeEvent,
    this.tier,
    this.eventPrincipalMinor,
    this.depositMinor,
    this.paidPrincipalMinor,
    this.cancellationLiabilityMinor,
    this.additionalPrincipalDueMinor,
    this.principalRefundDueMinor,
    this.estimatedStripeFeeMinor,
    this.commissionAdjustmentMinor,
    this.transferReversalMinor,
    this.expiresAt,
    this.manualReviewReasons = const [],
    this.raw = const {},
  });

  final int? id;
  final String? policyVersion;
  final String? eventTimezoneSnapshot;
  final int? daysBeforeEvent;
  final String? tier;
  final int? eventPrincipalMinor;
  final int? depositMinor;
  final int? paidPrincipalMinor;
  final int? cancellationLiabilityMinor;
  final int? additionalPrincipalDueMinor;
  final int? principalRefundDueMinor;
  final int? estimatedStripeFeeMinor;
  final int? commissionAdjustmentMinor;
  final int? transferReversalMinor;
  final DateTime? expiresAt;
  final List<String> manualReviewReasons;
  final Map<String, dynamic> raw;

  factory CancellationQuote.fromJson(Map<String, dynamic> json) {
    return CancellationQuote(
      id: _readInt(json['id'] ?? json['cancellation_id']),
      policyVersion: json['policy_version']?.toString(),
      eventTimezoneSnapshot: json['event_timezone_snapshot']?.toString(),
      daysBeforeEvent: _readInt(json['days_before_event']),
      tier: json['tier']?.toString(),
      eventPrincipalMinor: _readInt(json['event_principal_minor']),
      depositMinor:
          _readInt(json['deposit_minor'] ?? json['deposit_principal_minor']),
      paidPrincipalMinor: _readInt(json['paid_principal_minor']),
      cancellationLiabilityMinor:
          _readInt(json['cancellation_liability_minor']),
      additionalPrincipalDueMinor:
          _readInt(json['additional_principal_due_minor']),
      principalRefundDueMinor: _readInt(json['principal_refund_due_minor']),
      estimatedStripeFeeMinor: _readInt(json['estimated_stripe_fee_minor']),
      commissionAdjustmentMinor: _readInt(json['commission_adjustment_minor']),
      transferReversalMinor: _readInt(json['transfer_reversal_minor']),
      expiresAt: DateTime.tryParse(json['expires_at']?.toString() ?? ''),
      manualReviewReasons: json['manual_review_reasons'] is List
          ? List<String>.from(
              json['manual_review_reasons'].map((e) => e.toString()))
          : const [],
      raw: json,
    );
  }
}

class CancellationDetail {
  CancellationDetail({
    this.id,
    this.status = CancellationStatus.unknown,
    this.payment,
    this.supportReference,
    this.manualReviewReason,
    this.raw = const {},
  });

  final int? id;
  final CancellationStatus status;
  final PaymentRecord? payment;
  final String? supportReference;
  final String? manualReviewReason;
  final Map<String, dynamic> raw;

  factory CancellationDetail.fromJson(Map<String, dynamic> json) {
    return CancellationDetail(
      id: _readInt(json['id'] ?? json['cancellation_id']),
      status: _cancellationStatus(json['status']?.toString()),
      payment: json['payment'] is Map
          ? PaymentRecord.fromJson(Map<String, dynamic>.from(json['payment']))
          : null,
      supportReference: json['support_reference']?.toString(),
      manualReviewReason: json['manual_review_reason']?.toString(),
      raw: json,
    );
  }
}

int? _readInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

GroovkinPaymentStatus _paymentStatus(String? value) {
  switch (value) {
    case 'created':
      return GroovkinPaymentStatus.created;
    case 'processing':
      return GroovkinPaymentStatus.processing;
    case 'requires_action':
      return GroovkinPaymentStatus.requiresAction;
    case 'succeeded':
      return GroovkinPaymentStatus.succeeded;
    case 'failed':
      return GroovkinPaymentStatus.failed;
    case 'cancelled':
      return GroovkinPaymentStatus.cancelled;
    case 'manual_review':
      return GroovkinPaymentStatus.manualReview;
    case 'partially_refunded':
      return GroovkinPaymentStatus.partiallyRefunded;
    case 'refunded':
      return GroovkinPaymentStatus.refunded;
    case 'disputed':
      return GroovkinPaymentStatus.disputed;
    default:
      return GroovkinPaymentStatus.unknown;
  }
}

CompletionStatus _completionStatus(String? value) {
  switch (value) {
    case 'requested':
      return CompletionStatus.requested;
    case 'countered':
      return CompletionStatus.countered;
    case 'approved':
      return CompletionStatus.approved;
    case 'auto_approved':
      return CompletionStatus.autoApproved;
    case 'payment_processing':
      return CompletionStatus.paymentProcessing;
    case 'payment_requires_action':
      return CompletionStatus.paymentRequiresAction;
    case 'payment_failed':
      return CompletionStatus.paymentFailed;
    case 'support_review':
      return CompletionStatus.supportReview;
    case 'manual_review':
      return CompletionStatus.manualReview;
    case 'financially_settled':
      return CompletionStatus.financiallySettled;
    case 'cancelled':
      return CompletionStatus.cancelled;
    default:
      return CompletionStatus.unknown;
  }
}

CancellationStatus _cancellationStatus(String? value) {
  switch (value) {
    case 'quote_created':
      return CancellationStatus.quoteCreated;
    case 'confirmed':
      return CancellationStatus.confirmed;
    case 'payment_required':
      return CancellationStatus.paymentRequired;
    case 'payment_processing':
      return CancellationStatus.paymentProcessing;
    case 'payment_requires_action':
      return CancellationStatus.paymentRequiresAction;
    case 'payment_failed':
      return CancellationStatus.paymentFailed;
    case 'refund_pending':
      return CancellationStatus.refundPending;
    case 'refund_processing':
      return CancellationStatus.refundProcessing;
    case 'transfer_reversal_pending':
      return CancellationStatus.transferReversalPending;
    case 'support_review':
      return CancellationStatus.supportReview;
    case 'manual_review':
      return CancellationStatus.manualReview;
    case 'financially_settled':
      return CancellationStatus.financiallySettled;
    case 'cancelled':
      return CancellationStatus.cancelled;
    default:
      return CancellationStatus.unknown;
  }
}
