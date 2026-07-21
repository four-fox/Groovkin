enum WalletRole {
  eventOwner,
  venueManager,
  unknown,
}

enum WalletTransactionDirection {
  credit,
  debit,
  neutral,
  unknown,
}

enum WalletTransactionCategory {
  downPayment,
  finalBalance,
  cancellationCharge,
  eventEarnings,
  eoTransfer,
  refund,
  dispute,
  unknown,
}

WalletRole parseWalletRole(String? value) {
  switch (value) {
    case 'event_owner':
    case 'eventOrganizer':
    case 'event_organizer':
      return WalletRole.eventOwner;
    case 'venue_manager':
    case 'eventManager':
      return WalletRole.venueManager;
    default:
      return WalletRole.unknown;
  }
}

WalletTransactionDirection parseWalletDirection(String? value) {
  switch (value) {
    case 'credit':
      return WalletTransactionDirection.credit;
    case 'debit':
      return WalletTransactionDirection.debit;
    case 'neutral':
      return WalletTransactionDirection.neutral;
    default:
      return WalletTransactionDirection.unknown;
  }
}

WalletTransactionCategory parseWalletCategory(String? value) {
  switch (value) {
    case 'down_payment':
      return WalletTransactionCategory.downPayment;
    case 'final_balance':
      return WalletTransactionCategory.finalBalance;
    case 'cancellation_charge':
      return WalletTransactionCategory.cancellationCharge;
    case 'event_earnings':
      return WalletTransactionCategory.eventEarnings;
    case 'eo_transfer':
      return WalletTransactionCategory.eoTransfer;
    case 'refund':
      return WalletTransactionCategory.refund;
    case 'dispute':
      return WalletTransactionCategory.dispute;
    default:
      return WalletTransactionCategory.unknown;
  }
}

String walletCategoryLabel(
  WalletTransactionCategory category, {
  required WalletRole role,
}) {
  switch (category) {
    case WalletTransactionCategory.downPayment:
      return role == WalletRole.eventOwner ? 'Event earnings' : 'Down payment';
    case WalletTransactionCategory.finalBalance:
      return role == WalletRole.eventOwner ? 'Event earnings' : 'Final payment';
    case WalletTransactionCategory.cancellationCharge:
      return 'Cancellation charge';
    case WalletTransactionCategory.eventEarnings:
      return 'Event earnings';
    case WalletTransactionCategory.eoTransfer:
      return 'Organizer transfer';
    case WalletTransactionCategory.refund:
      return role == WalletRole.eventOwner ? 'Refund reversal' : 'Refund';
    case WalletTransactionCategory.dispute:
      return 'Dispute';
    case WalletTransactionCategory.unknown:
      return 'Transaction';
  }
}

class WalletCurrencyBucket {
  WalletCurrencyBucket({
    required this.currency,
    this.netEarningsMinor,
    this.transferredToConnectMinor,
    this.pendingTransferMinor,
    this.groovkinCommissionMinor,
    this.refundedOrReversedMinor,
    this.manualReviewMinor,
    this.eventPrincipalPaidMinor,
    this.stripeFeesPaidMinor,
    this.totalChargedMinor,
    this.refundsReceivedMinor,
    this.pendingRefundsMinor,
  });

  final String currency;
  final int? netEarningsMinor;
  final int? transferredToConnectMinor;
  final int? pendingTransferMinor;
  final int? groovkinCommissionMinor;
  final int? refundedOrReversedMinor;
  final int? manualReviewMinor;
  final int? eventPrincipalPaidMinor;
  final int? stripeFeesPaidMinor;
  final int? totalChargedMinor;
  final int? refundsReceivedMinor;
  final int? pendingRefundsMinor;

  factory WalletCurrencyBucket.fromJson(Map<String, dynamic> json) {
    return WalletCurrencyBucket(
      currency: (json['currency']?.toString() ?? 'USD').toUpperCase(),
      netEarningsMinor: _readInt(json['net_earnings_minor']),
      transferredToConnectMinor: _readInt(json['transferred_to_connect_minor']),
      pendingTransferMinor: _readInt(json['pending_transfer_minor']),
      groovkinCommissionMinor: _readInt(json['groovkin_commission_minor']),
      refundedOrReversedMinor: _readInt(json['refunded_or_reversed_minor']),
      manualReviewMinor: _readInt(json['manual_review_minor']),
      eventPrincipalPaidMinor: _readInt(json['event_principal_paid_minor']),
      stripeFeesPaidMinor: _readInt(json['stripe_fees_paid_minor']),
      totalChargedMinor: _readInt(json['total_charged_minor']),
      refundsReceivedMinor: _readInt(json['refunds_received_minor']),
      pendingRefundsMinor: _readInt(json['pending_refunds_minor']),
    );
  }
}

class WalletSummary {
  WalletSummary({
    this.role = WalletRole.unknown,
    this.currency = 'USD',
    this.currencies = const [],
    this.totalEventPrincipalMinor,
    this.grossEarningsMinor,
    this.groovkinCommissionMinor,
    this.netEarningsMinor,
    this.transferredToConnectMinor,
    this.pendingTransferMinor,
    this.refundedOrReversedMinor,
    this.disputedMinor,
    this.manualReviewMinor,
    this.completedEventsCount,
    this.pendingEventsCount,
    this.eventPrincipalPaidMinor,
    this.stripeFeesPaidMinor,
    this.totalChargedMinor,
    this.refundsReceivedMinor,
    this.pendingRefundsMinor,
    this.activeEventCommitmentsMinor,
    this.eventsPaidCount,
  });

  final WalletRole role;
  final String currency;
  final List<WalletCurrencyBucket> currencies;
  final int? totalEventPrincipalMinor;
  final int? grossEarningsMinor;
  final int? groovkinCommissionMinor;
  final int? netEarningsMinor;
  final int? transferredToConnectMinor;
  final int? pendingTransferMinor;
  final int? refundedOrReversedMinor;
  final int? disputedMinor;
  final int? manualReviewMinor;
  final int? completedEventsCount;
  final int? pendingEventsCount;
  final int? eventPrincipalPaidMinor;
  final int? stripeFeesPaidMinor;
  final int? totalChargedMinor;
  final int? refundsReceivedMinor;
  final int? pendingRefundsMinor;
  final int? activeEventCommitmentsMinor;
  final int? eventsPaidCount;

  bool get isEventOwner => role == WalletRole.eventOwner;
  bool get isVenueManager => role == WalletRole.venueManager;

  factory WalletSummary.fromJson(Map<String, dynamic> json) {
    final currenciesRaw = json['currencies'];
    return WalletSummary(
      role: parseWalletRole(json['role']?.toString()),
      currency: (json['currency']?.toString() ?? 'USD').toUpperCase(),
      currencies: currenciesRaw is List
          ? currenciesRaw
              .whereType<Map>()
              .map((e) =>
                  WalletCurrencyBucket.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      totalEventPrincipalMinor: _readInt(json['total_event_principal_minor']),
      grossEarningsMinor: _readInt(json['gross_earnings_minor']),
      groovkinCommissionMinor: _readInt(json['groovkin_commission_minor']),
      netEarningsMinor: _readInt(json['net_earnings_minor']),
      transferredToConnectMinor: _readInt(json['transferred_to_connect_minor']),
      pendingTransferMinor: _readInt(json['pending_transfer_minor']),
      refundedOrReversedMinor: _readInt(json['refunded_or_reversed_minor']),
      disputedMinor: _readInt(json['disputed_minor']),
      manualReviewMinor: _readInt(json['manual_review_minor']),
      completedEventsCount: _readInt(json['completed_events_count']),
      pendingEventsCount: _readInt(json['pending_events_count']),
      eventPrincipalPaidMinor: _readInt(json['event_principal_paid_minor']),
      stripeFeesPaidMinor: _readInt(json['stripe_fees_paid_minor']),
      totalChargedMinor: _readInt(json['total_charged_minor']),
      refundsReceivedMinor: _readInt(json['refunds_received_minor']),
      pendingRefundsMinor: _readInt(json['pending_refunds_minor']),
      activeEventCommitmentsMinor:
          _readInt(json['active_event_commitments_minor']),
      eventsPaidCount: _readInt(json['events_paid_count']),
    );
  }
}

class WalletEventRef {
  WalletEventRef({this.id, this.title});

  final int? id;
  final String? title;

  factory WalletEventRef.fromJson(Map<String, dynamic>? json) {
    if (json == null) return WalletEventRef();
    return WalletEventRef(
      id: _readInt(json['id']),
      title: json['title']?.toString(),
    );
  }
}

class WalletTransaction {
  WalletTransaction({
    required this.id,
    this.reference,
    this.event,
    this.category = WalletTransactionCategory.unknown,
    this.direction = WalletTransactionDirection.unknown,
    this.status,
    this.currency = 'USD',
    this.principalMinor,
    this.stripeFeeMinor,
    this.groovkinCommissionMinor,
    this.netMinor,
    this.occurredAt,
    this.detailAvailable = false,
  });

  final String id;
  final String? reference;
  final WalletEventRef? event;
  final WalletTransactionCategory category;
  final WalletTransactionDirection direction;
  final String? status;
  final String currency;
  final int? principalMinor;
  final int? stripeFeeMinor;
  final int? groovkinCommissionMinor;
  final int? netMinor;
  final DateTime? occurredAt;
  final bool detailAvailable;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id']?.toString() ?? '',
      reference: json['reference']?.toString(),
      event: json['event'] is Map
          ? WalletEventRef.fromJson(Map<String, dynamic>.from(json['event']))
          : null,
      category: parseWalletCategory(json['category']?.toString()),
      direction: parseWalletDirection(json['direction']?.toString()),
      status: json['status']?.toString(),
      currency: (json['currency']?.toString() ?? 'USD').toUpperCase(),
      principalMinor: _readInt(json['principal_minor']),
      stripeFeeMinor: _readInt(json['stripe_fee_minor']),
      groovkinCommissionMinor: _readInt(json['groovkin_commission_minor']),
      netMinor: _readInt(json['net_minor']),
      occurredAt: DateTime.tryParse(json['occurred_at']?.toString() ?? ''),
      detailAvailable: json['detail_available'] == true,
    );
  }
}

class WalletTransactionPage {
  WalletTransactionPage({
    required this.items,
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 20,
    this.total = 0,
  });

  final List<WalletTransaction> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  bool get hasMore => currentPage < lastPage;

  factory WalletTransactionPage.fromJson(dynamic raw) {
    if (raw is List) {
      return WalletTransactionPage(
        items: raw
            .whereType<Map>()
            .map(
                (e) => WalletTransaction.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
    }
    if (raw is! Map) {
      return WalletTransactionPage(items: const []);
    }
    final json = Map<String, dynamic>.from(raw);
    final data = json['data'] ?? json['transactions'] ?? json['items'];
    final meta =
        json['meta'] is Map ? Map<String, dynamic>.from(json['meta']) : json;
    final list = data is List ? data : const [];
    return WalletTransactionPage(
      items: list
          .whereType<Map>()
          .map((e) => WalletTransaction.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      currentPage: _readInt(meta['current_page']) ?? 1,
      lastPage: _readInt(meta['last_page']) ?? 1,
      perPage: _readInt(meta['per_page']) ?? 20,
      total: _readInt(meta['total']) ?? list.length,
    );
  }
}

class WalletTransactionDetail {
  WalletTransactionDetail({
    required this.id,
    this.reference,
    this.event,
    this.category = WalletTransactionCategory.unknown,
    this.direction = WalletTransactionDirection.unknown,
    this.status,
    this.currency = 'USD',
    this.principalMinor,
    this.stripeFeeMinor,
    this.groovkinCommissionMinor,
    this.netMinor,
    this.occurredAt,
    this.transferStatus,
    this.refundStatus,
    this.disputeStatus,
    this.supportReference,
    this.manualReviewReason,
    this.safeErrorMessage,
    this.timeline = const [],
  });

  final String id;
  final String? reference;
  final WalletEventRef? event;
  final WalletTransactionCategory category;
  final WalletTransactionDirection direction;
  final String? status;
  final String currency;
  final int? principalMinor;
  final int? stripeFeeMinor;
  final int? groovkinCommissionMinor;
  final int? netMinor;
  final DateTime? occurredAt;
  final String? transferStatus;
  final String? refundStatus;
  final String? disputeStatus;
  final String? supportReference;
  final String? manualReviewReason;
  final String? safeErrorMessage;
  final List<Map<String, dynamic>> timeline;

  factory WalletTransactionDetail.fromJson(Map<String, dynamic> json) {
    final timelineRaw = json['timeline'];
    return WalletTransactionDetail(
      id: json['id']?.toString() ?? '',
      reference: json['reference']?.toString(),
      event: json['event'] is Map
          ? WalletEventRef.fromJson(Map<String, dynamic>.from(json['event']))
          : null,
      category: parseWalletCategory(json['category']?.toString()),
      direction: parseWalletDirection(json['direction']?.toString()),
      status: json['status']?.toString(),
      currency: (json['currency']?.toString() ?? 'USD').toUpperCase(),
      principalMinor: _readInt(json['principal_minor']),
      stripeFeeMinor: _readInt(json['stripe_fee_minor']),
      groovkinCommissionMinor: _readInt(json['groovkin_commission_minor']),
      netMinor: _readInt(json['net_minor']),
      occurredAt: DateTime.tryParse(json['occurred_at']?.toString() ?? ''),
      transferStatus: json['transfer_status']?.toString(),
      refundStatus: json['refund_status']?.toString(),
      disputeStatus: json['dispute_status']?.toString(),
      supportReference: json['support_reference']?.toString(),
      manualReviewReason: json['manual_review_reason']?.toString(),
      safeErrorMessage: json['safe_error_message']?.toString() ??
          json['error_message']?.toString(),
      timeline: timelineRaw is List
          ? timelineRaw
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
          : const [],
    );
  }
}

class WalletTransfer {
  WalletTransfer({
    required this.id,
    this.label,
    this.status,
    this.amountMinor,
    this.currency = 'USD',
    this.occurredAt,
    this.event,
  });

  final String id;
  final String? label;
  final String? status;
  final int? amountMinor;
  final String currency;
  final DateTime? occurredAt;
  final WalletEventRef? event;

  factory WalletTransfer.fromJson(Map<String, dynamic> json) {
    return WalletTransfer(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? json['title']?.toString(),
      status: json['status']?.toString(),
      amountMinor: _readInt(json['amount_minor']),
      currency: (json['currency']?.toString() ?? 'USD').toUpperCase(),
      occurredAt: DateTime.tryParse(
        json['occurred_at']?.toString() ?? json['created_at']?.toString() ?? '',
      ),
      event: json['event'] is Map
          ? WalletEventRef.fromJson(Map<String, dynamic>.from(json['event']))
          : null,
    );
  }
}

class WalletPayoutsResponse {
  WalletPayoutsResponse({
    this.actualBankPayoutTrackingEnabled = false,
    this.message,
    this.transfers = const [],
  });

  final bool actualBankPayoutTrackingEnabled;
  final String? message;
  final List<WalletTransfer> transfers;

  factory WalletPayoutsResponse.fromJson(Map<String, dynamic> json) {
    final transfersRaw = json['transfers'] ?? json['payouts'] ?? json['data'];
    return WalletPayoutsResponse(
      actualBankPayoutTrackingEnabled:
          json['actual_bank_payout_tracking_enabled'] == true,
      message: json['message']?.toString(),
      transfers: transfersRaw is List
          ? transfersRaw
              .whereType<Map>()
              .map((e) => WalletTransfer.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}

class WalletTransactionFilters {
  WalletTransactionFilters({
    this.type,
    this.status,
    this.eventId,
    this.currency,
    this.dateFrom,
    this.dateTo,
    this.direction,
  });

  final String? type;
  final String? status;
  final int? eventId;
  final String? currency;
  final String? dateFrom;
  final String? dateTo;
  final String? direction;

  Map<String, dynamic> toQuery({required int page, int perPage = 20}) {
    return {
      'page': page,
      'per_page': perPage,
      if (type != null && type!.isNotEmpty) 'type': type,
      if (status != null && status!.isNotEmpty) 'status': status,
      if (eventId != null) 'event_id': eventId,
      if (currency != null && currency!.isNotEmpty) 'currency': currency,
      if (dateFrom != null && dateFrom!.isNotEmpty) 'date_from': dateFrom,
      if (dateTo != null && dateTo!.isNotEmpty) 'date_to': dateTo,
      if (direction != null && direction!.isNotEmpty) 'direction': direction,
    };
  }
}

int? _readInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}
