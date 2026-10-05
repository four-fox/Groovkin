import 'package:groovkin/utils/json_parsers.dart';

class EventCounterOffer {
  EventCounterOffer({
    this.id,
    this.senderRole,
    this.senderName,
    this.proposedPrincipalMinor,
    this.message,
    this.stage,
    this.status,
    this.createdAt,
  });

  final int? id;
  final String? senderRole;
  final String? senderName;
  final int? proposedPrincipalMinor;
  final String? message;
  final String? stage;
  final String? status;
  final DateTime? createdAt;

  factory EventCounterOffer.fromJson(Map<String, dynamic>? json) {
    if (json == null) return EventCounterOffer();
    return EventCounterOffer(
      id: parseInt(json['id']),
      senderRole: parseString(json['sender_role'] ?? json['role']),
      senderName: parseString(
          json['sender_name'] ?? json['sender'] ?? json['created_by_name']),
      proposedPrincipalMinor: parseInt(json['proposed_principal_minor'] ??
          json['amount_minor'] ??
          json['proposed_amount_minor']),
      message: parseString(json['message'] ?? json['comment']),
      stage: parseString(json['stage'] ?? json['counter_stage']),
      status: parseString(json['status']),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  bool get isCompletion =>
      (stage ?? '').toLowerCase().contains('completion');
}

class EventCounterState {
  const EventCounterState({
    this.canCounter = false,
    this.canAcceptCounter = false,
    this.canRejectCounter = false,
    this.canCounterAgain = false,
    this.canEditEvent = false,
    this.canEditEventCost = false,
    this.canAcceptEvent = false,
    this.canDeclineEvent = false,
    this.canMarkComplete = false,
    this.canApproveFinalPayment = false,
    this.counterStage,
    this.currentAgreedAmountMinor,
    this.activeCounterAmountMinor,
    this.paidAmountMinor,
    this.remainingAmountMinor,
    this.settlementAdjustmentRequired = false,
    this.currency = 'USD',
    this.autoApproveAt,
    this.activeCounter,
    this.history = const [],
  });

  final bool canCounter;
  final bool canAcceptCounter;
  final bool canRejectCounter;
  final bool canCounterAgain;
  final bool canEditEvent;
  final bool canEditEventCost;
  final bool canAcceptEvent;
  final bool canDeclineEvent;
  final bool canMarkComplete;
  final bool canApproveFinalPayment;
  final String? counterStage;
  final int? currentAgreedAmountMinor;
  final int? activeCounterAmountMinor;
  final int? paidAmountMinor;
  final int? remainingAmountMinor;
  final bool settlementAdjustmentRequired;
  final String currency;
  final DateTime? autoApproveAt;
  final EventCounterOffer? activeCounter;
  final List<EventCounterOffer> history;

  factory EventCounterState.fromJson(dynamic raw) {
    var json = parseMap(raw) ?? {};
    final data = parseMap(json['data']);
    if (data != null && (data.containsKey('counter') || data.containsKey('can_counter'))) {
      json = data;
    }
    final nested = parseMap(json['counter']) ?? json;
    final active = parseMap(nested['active_counter']);
    final historyRaw =
        nested['counter_history'] ?? nested['history'] ?? nested['counters'];
    return EventCounterState(
      canCounter: parseBool(nested['can_counter']),
      canAcceptCounter: parseBool(nested['can_accept_counter']),
      canRejectCounter: parseBool(nested['can_reject_counter']),
      canCounterAgain: parseBool(nested['can_counter_again']),
      canEditEvent: parseBool(nested['can_edit_event']),
      canEditEventCost: parseBool(nested['can_edit_event_cost']),
      canAcceptEvent: parseBool(nested['can_accept_event']),
      canDeclineEvent: parseBool(nested['can_decline_event']),
      canMarkComplete: parseBool(nested['can_mark_complete']),
      canApproveFinalPayment: parseBool(nested['can_approve_final_payment']),
      counterStage: parseString(nested['counter_stage'] ?? nested['stage']),
      currentAgreedAmountMinor: parseInt(
          nested['current_agreed_amount_minor'] ?? nested['agreed_amount_minor']),
      activeCounterAmountMinor: parseInt(nested['active_counter_amount_minor']),
      paidAmountMinor: parseInt(nested['paid_amount_minor']),
      remainingAmountMinor: parseInt(nested['remaining_amount_minor']),
      settlementAdjustmentRequired:
          parseBool(nested['settlement_adjustment_required']),
      currency: parseString(nested['currency']) ?? 'USD',
      autoApproveAt: DateTime.tryParse(
          nested['auto_approve_at']?.toString() ?? ''),
      activeCounter:
          active == null ? null : EventCounterOffer.fromJson(active),
      history: _parseHistory(historyRaw),
    );
  }

  static List<EventCounterOffer> _parseHistory(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) =>
            EventCounterOffer.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  bool get hasActiveCounter =>
      activeCounter?.id != null ||
      (activeCounterAmountMinor != null && activeCounterAmountMinor! > 0);

  bool get isCompletionStage {
    final stage = (counterStage ?? activeCounter?.stage ?? '').toLowerCase();
    return stage.contains('completion');
  }

  int get visibleRemainingMinor {
    final remaining = remainingAmountMinor;
    if (remaining == null) return 0;
    if (remaining < 0) return 0;
    return remaining;
  }
}

/// Server-flag driven action visibility. Each action is independently gated.
class EventActionFlags {
  const EventActionFlags({
    required this.acceptEvent,
    required this.declineEvent,
    required this.counter,
    required this.acceptCounter,
    required this.rejectCounter,
    required this.counterAgain,
    required this.editEvent,
    required this.markComplete,
    required this.approveFinalPayment,
    this.message,
  });

  final bool acceptEvent;
  final bool declineEvent;
  final bool counter;
  final bool acceptCounter;
  final bool rejectCounter;
  final bool counterAgain;
  final bool editEvent;
  final bool markComplete;
  final bool approveFinalPayment;
  final String? message;

  factory EventActionFlags.fromCounter({
    required EventCounterState counter,
    DateTime? eventEnd,
    DateTime? now,
  }) {
    final ended = eventEnd != null &&
        !(now ?? DateTime.now()).isBefore(eventEnd);
    return EventActionFlags(
      acceptEvent: counter.canAcceptEvent && !counter.hasActiveCounter,
      declineEvent: counter.canDeclineEvent,
      counter: counter.canCounter,
      acceptCounter: counter.canAcceptCounter,
      rejectCounter: counter.canRejectCounter,
      counterAgain: counter.canCounterAgain,
      editEvent: counter.canEditEvent,
      markComplete: counter.canMarkComplete && ended,
      approveFinalPayment: counter.canApproveFinalPayment,
      message: !ended && counter.canMarkComplete
          ? 'Mark Complete is hidden until the event end time. Backend still needs a server-side completion time guard.'
          : null,
    );
  }

  int get visibleCount => [
        acceptEvent,
        declineEvent,
        counter,
        acceptCounter,
        rejectCounter,
        counterAgain,
        editEvent,
        markComplete,
        approveFinalPayment,
      ].where((visible) => visible).length;
}
