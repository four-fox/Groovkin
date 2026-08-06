import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:intl/intl.dart';
import '../payment_models.dart';
import '../payment_repository.dart';
import 'payment_journey_controller.dart';
import 'payment_journey_mapper.dart';
import 'payment_journey_models.dart';

/// Parses a dollars string ("95", "95.50") into integer minor units.
/// Returns null for empty/invalid/negative/sub-cent input.
int? parseDollarsToMinor(String input) {
  final trimmed = input.trim().replaceAll(',', '').replaceAll('\$', '');
  if (trimmed.isEmpty) return null;
  final value = double.tryParse(trimmed);
  if (value == null || value < 0) return null;
  final minor = (value * 100).round();
  // Defensive: reject sub-cent precision (e.g. 1.999) instead of rounding it.
  if ((value * 100 - minor).abs() > 1e-6) return null;
  return minor;
}

/// Live countdown driven by a server-provided `seconds_remaining` value.
/// Ticks locally each second; parent rebuilds (journey refresh) re-anchor it.
class JourneyCountdownText extends StatefulWidget {
  const JourneyCountdownText({
    super.key,
    required this.secondsRemaining,
    this.prefix = '',
    this.style,
  });

  final int? secondsRemaining;
  final String prefix;
  final TextStyle? style;

  @override
  State<JourneyCountdownText> createState() => _JourneyCountdownTextState();
}

class _JourneyCountdownTextState extends State<JourneyCountdownText> {
  Timer? _timer;
  late DateTime _anchor;

  @override
  void initState() {
    super.initState();
    _anchor = DateTime.now();
    _startTicker();
  }

  @override
  void didUpdateWidget(covariant JourneyCountdownText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.secondsRemaining != widget.secondsRemaining) {
      _anchor = DateTime.now();
      _startTicker();
    }
  }

  void _startTicker() {
    _timer?.cancel();
    if (widget.secondsRemaining == null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
      if (_secondsLeft <= 0) _timer?.cancel();
    });
  }

  int get _secondsLeft {
    final base = widget.secondsRemaining;
    if (base == null) return 0;
    final elapsed = DateTime.now().difference(_anchor).inSeconds;
    return base - elapsed;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.secondsRemaining == null) return const SizedBox.shrink();
    return Text(
      '${widget.prefix}${PaymentJourneyMapper.formatCountdown(_secondsLeft)}',
      style: widget.style ??
          poppinsRegularStyle(
            context: context,
            fontSize: 12,
            color: DynamicColor.yellowClr,
          ),
    );
  }
}

/// Completion Review section: status, balances, auto-approve countdown, and
/// Approve / Counter actions. Rendering is driven only by
/// `journey.permissions` and `journey.completion` (never role/status guesses).
class CompletionReviewCard extends StatelessWidget {
  const CompletionReviewCard({super.key, required this.controller});

  final PaymentJourneyController controller;

  @override
  Widget build(BuildContext context) {
    final journey = controller.journey;
    if (journey == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final money = MoneyFormatter();
    final currency = journey.currency;
    final permissions = journey.permissions;
    final completion = journey.completion;
    final counter = completion.latestCounter;
    final counterIsOpen = counter?.id != null && counter!.isOpen;

    final remainingMinor = journey.finalPayment.remainingPrincipalMinor ??
        journey.totals.remainingPrincipalMinor;
    final estimatedChargeMinor = journey.finalPayment.estimatedTotalChargeMinor ??
        journey.totals.chargeAmountMinor;

    final rows = <Widget>[
      _row(context, 'Completion status',
          _friendlyCompletionStatus(completion.status)),
      _row(
        context,
        'Remaining balance',
        money.formatMinor(remainingMinor, currency: currency),
        emphasized: true,
      ),
      if (journey.isVenueManager && estimatedChargeMinor != null)
        _row(
          context,
          'Estimated total charge',
          money.formatMinor(estimatedChargeMinor, currency: currency),
        ),
    ];

    return _JourneyCardShell(
      title: 'Completion Review',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...rows,
          if (completion.requestedAt != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Requested ${DateFormat.yMMMd().add_jm().format(completion.requestedAt!.toLocal())}',
                style: poppinsRegularStyle(
                  context: context,
                  fontSize: 12,
                  color: DynamicColor.grayClr,
                ),
              ),
            ),
          if (completion.autoApproveSecondsRemaining != null &&
              !counterIsOpen) ...[
            const SizedBox(height: 6),
            JourneyCountdownText(
              secondsRemaining: completion.autoApproveSecondsRemaining,
              prefix: 'Auto-approves in ',
            ),
            Text(
              'If no action is taken, completion auto-approves and the remaining balance is charged.',
              style: poppinsRegularStyle(
                context: context,
                fontSize: 11,
                color: DynamicColor.grayClr,
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Approve is intentionally hidden whenever the backend pauses it
          // (permissions.can_approve_completion == false while a counter is open).
          if (permissions.canApproveCompletion)
            CustomButton(
              heights: 42,
              borderClr: Colors.transparent,
              onTap: controller.actionInFlight
                  ? null
                  : () => _confirmApprove(context, journey),
              text: controller.actionInFlight
                  ? 'Working...'
                  : 'Approve Completion',
            ),
          if (permissions.canApproveCompletion && permissions.canCreateCounter)
            const SizedBox(height: 8),
          if (permissions.canCreateCounter)
            CustomButton(
              heights: 42,
              borderClr: DynamicColor.yellowClr,
              backgroundClr: false,
              onTap: controller.actionInFlight
                  ? null
                  : () => showCounterFormSheet(
                        context: context,
                        controller: controller,
                      ),
              text: 'Counter Amount',
            ),
          if (!permissions.canApproveCompletion &&
              !permissions.canCreateCounter &&
              !permissions.canAcceptCounter &&
              !permissions.canReviseCounter &&
              !permissions.canRejectCounter &&
              !counterIsOpen)
            Text(
              _readOnlyStatusText(journey),
              style: poppinsRegularStyle(
                context: context,
                fontSize: 13,
                color: theme.primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmApprove(
      BuildContext context, PaymentJourney journey) async {
    final money = MoneyFormatter();
    final remaining = journey.finalPayment.remainingPrincipalMinor ??
        journey.totals.remainingPrincipalMinor;
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Approve completion?'),
        content: Text(
          'The remaining balance of ${money.formatMinor(remaining, currency: journey.currency)} will be charged to the saved card.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.approveCompletion();
  }

  String _friendlyCompletionStatus(String? status) {
    switch (status) {
      case 'requested':
        return 'Awaiting review';
      case 'countered':
        return 'Counter in negotiation';
      case 'approved':
        return 'Approved';
      case 'auto_approved':
        return 'Auto-approved';
      case 'support_review':
        return 'With Groovkin support';
      default:
        return status?.replaceAll('_', ' ') ?? '--';
    }
  }

  String _readOnlyStatusText(PaymentJourney journey) {
    if (isFinanciallySettled(journey.settlementStatus)) {
      return 'Financially settled.';
    }
    switch (journey.journeyStage) {
      case PaymentJourneyStage.finalTransferPending:
        return 'Processing payout to organizer.';
      case PaymentJourneyStage.finalPaymentProcessing:
        return 'Completion approved — processing final payment.';
      case PaymentJourneyStage.completionApproved:
      case PaymentJourneyStage.completionAutoApproved:
        return 'Completion approved — processing final payment.';
      case PaymentJourneyStage.eventInProgress:
        return 'Waiting for the organizer to submit completion.';
      case PaymentJourneyStage.supportReview:
        return 'This completion is with Groovkin support.';
      default:
        return 'No completion action needed from you right now.';
    }
  }

  Widget _row(BuildContext context, String label, String value,
      {bool emphasized = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: poppinsRegularStyle(
                context: context,
                fontSize: 13,
                color: DynamicColor.grayClr,
              ),
            ),
          ),
          Text(
            value,
            style: poppinsMediumStyle(
              context: context,
              fontSize: emphasized ? 14 : 13,
              color: emphasized
                  ? DynamicColor.yellowClr
                  : Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Latest counter with expiry countdown and Accept / Revise / Reject actions
/// per backend permissions.
class CounterReviewCard extends StatelessWidget {
  const CounterReviewCard({super.key, required this.controller});

  final PaymentJourneyController controller;

  @override
  Widget build(BuildContext context) {
    final journey = controller.journey;
    final counter = journey?.completion.latestCounter;
    if (journey == null || counter?.id == null) return const SizedBox.shrink();
    if (!counter!.isOpen) return const SizedBox.shrink();
    final money = MoneyFormatter();
    final currency = journey.currency;
    final permissions = journey.permissions;

    return _JourneyCardShell(
      title: 'Open Counter',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Proposed: ${money.formatMinor(counter.proposedPrincipalMinor, currency: currency)}',
            style: poppinsMediumStyle(
              context: context,
              fontSize: 15,
              color: DynamicColor.yellowClr,
            ),
          ),
          if (counter.originalPrincipalMinor != null)
            Text(
              'Agreed event total: ${money.formatMinor(counter.originalPrincipalMinor, currency: currency)}',
              style: poppinsRegularStyle(
                context: context,
                fontSize: 12,
                color: DynamicColor.grayClr,
              ),
            ),
          if (counter.message != null && counter.message!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              counter.message!,
              style: poppinsRegularStyle(
                context: context,
                fontSize: 13,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
          const SizedBox(height: 6),
          JourneyCountdownText(
            secondsRemaining: counter.counterSecondsRemaining ??
                journey.completion.counterSecondsRemaining,
            prefix: 'Counter expires in ',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (permissions.canAcceptCounter)
                Expanded(
                  child: CustomButton(
                    heights: 40,
                    borderClr: Colors.transparent,
                    onTap: controller.actionInFlight
                        ? null
                        : () => _confirmAccept(context, journey, counter),
                    text: 'Accept',
                  ),
                ),
              if (permissions.canAcceptCounter &&
                  (permissions.canReviseCounter ||
                      permissions.canRejectCounter))
                const SizedBox(width: 8),
              if (permissions.canReviseCounter)
                Expanded(
                  child: CustomButton(
                    heights: 40,
                    borderClr: DynamicColor.yellowClr,
                    backgroundClr: false,
                    onTap: controller.actionInFlight
                        ? null
                        : () => showCounterFormSheet(
                              context: context,
                              controller: controller,
                              reviseCounterId: counter.id,
                            ),
                    text: 'Revise',
                  ),
                ),
              if (permissions.canReviseCounter && permissions.canRejectCounter)
                const SizedBox(width: 8),
              if (permissions.canRejectCounter)
                Expanded(
                  child: CustomButton(
                    heights: 40,
                    borderClr: DynamicColor.redClr,
                    backgroundClr: false,
                    onTap: controller.actionInFlight
                        ? null
                        : () => controller.rejectCounter(counter.id!),
                    text: 'Reject',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAccept(
    BuildContext context,
    PaymentJourney journey,
    JourneyCounter counter,
  ) async {
    final money = MoneyFormatter();
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Accept counter?'),
        content: Text(
          'Accepting charges the countered amount of ${money.formatMinor(counter.proposedPrincipalMinor, currency: journey.currency)}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Accept'),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.acceptCounter(counter.id!);
  }
}

/// Counter create / revise bottom sheet. Amount entered in dollars, converted
/// to integer minor units before send. Client-side guard: cannot exceed the
/// agreed event principal (backend enforces the same with a 422).
Future<void> showCounterFormSheet({
  required BuildContext context,
  required PaymentJourneyController controller,
  int? reviseCounterId,
}) async {
  final journey = controller.journey;
  if (journey == null) return;
  final eventPrincipalMinor = journey.totals.eventPrincipalMinor;
  final amountController = TextEditingController();
  final messageController = TextEditingController();
  String? errorText;
  bool submitting = false;
  final money = MoneyFormatter();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: DynamicColor.darkGrayClr,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          final theme = Theme.of(sheetContext);
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reviseCounterId == null ? 'Counter Amount' : 'Revise Counter',
                  style: poppinsMediumStyle(
                    context: sheetContext,
                    fontSize: 17,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  eventPrincipalMinor != null
                      ? 'Propose a different final amount (up to ${money.formatMinor(eventPrincipalMinor, currency: journey.currency)}).'
                      : 'Propose a different final amount.',
                  style: poppinsRegularStyle(
                    context: sheetContext,
                    fontSize: 12,
                    color: DynamicColor.grayClr,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: poppinsRegularStyle(
                    context: sheetContext,
                    fontSize: 15,
                    color: theme.primaryColor,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Amount (${journey.currency})',
                    prefixText: '\$ ',
                    errorText: errorText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: messageController,
                  maxLength: 2000,
                  maxLines: 3,
                  style: poppinsRegularStyle(
                    context: sheetContext,
                    fontSize: 14,
                    color: theme.primaryColor,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Message (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                CustomButton(
                  heights: 44,
                  borderClr: Colors.transparent,
                  onTap: submitting
                      ? null
                      : () async {
                          final minor =
                              parseDollarsToMinor(amountController.text);
                          if (minor == null) {
                            setSheetState(() =>
                                errorText = 'Enter a valid amount, e.g. 95.00');
                            return;
                          }
                          if (eventPrincipalMinor != null &&
                              minor > eventPrincipalMinor) {
                            setSheetState(() => errorText =
                                'Amount can\'t exceed the agreed event total (${money.formatMinor(eventPrincipalMinor, currency: journey.currency)}).');
                            return;
                          }
                          setSheetState(() {
                            errorText = null;
                            submitting = true;
                          });
                          final ok = reviseCounterId == null
                              ? await controller.createCounter(
                                  proposedPrincipalMinor: minor,
                                  message: messageController.text.trim(),
                                )
                              : await controller.reviseCounter(
                                  counterId: reviseCounterId,
                                  proposedPrincipalMinor: minor,
                                  message: messageController.text.trim(),
                                );
                          if (ok && sheetContext.mounted) {
                            Navigator.of(sheetContext).pop();
                          } else {
                            setSheetState(() => submitting = false);
                          }
                        },
                  text: submitting
                      ? 'Submitting...'
                      : (reviseCounterId == null
                          ? 'Submit Counter'
                          : 'Submit Revision'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

/// Final payment side-effects (§6): processing / succeeded / requires_action /
/// failed. Resume & Retry gated by backend permissions only.
class FinalPaymentStatusCard extends StatelessWidget {
  const FinalPaymentStatusCard({super.key, required this.controller});

  final PaymentJourneyController controller;

  @override
  Widget build(BuildContext context) {
    final journey = controller.journey;
    if (journey == null) return const SizedBox.shrink();
    final finalPayment = journey.finalPayment;
    final permissions = journey.permissions;
    final settled = isFinanciallySettled(journey.settlementStatus);
    final transferPending =
        journey.journeyStage == PaymentJourneyStage.finalTransferPending ||
            journey.journeyStage == PaymentJourneyStage.manualReview;

    String? statusText;
    if (settled) {
      statusText = 'Financially settled. This event is fully paid.';
    } else if (finalPayment.isSucceeded && transferPending) {
      statusText = 'Payment received — processing payout to organizer.';
    } else if (finalPayment.isProcessing ||
        journey.journeyStage == PaymentJourneyStage.finalPaymentProcessing) {
      statusText = 'Processing final payment...';
    } else if (finalPayment.isRequiresAction) {
      statusText = 'Final payment needs card authentication.';
    } else if (finalPayment.isFailed) {
      statusText = 'Final payment failed.';
    }
    if (statusText == null) return const SizedBox.shrink();

    return _JourneyCardShell(
      title: 'Final Payment',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (finalPayment.isProcessing ||
                  journey.journeyStage ==
                      PaymentJourneyStage.finalPaymentProcessing ||
                  transferPending && !settled)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: DynamicColor.yellowClr,
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  statusText,
                  style: poppinsRegularStyle(
                    context: context,
                    fontSize: 13,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          if (permissions.canResumePayment) ...[
            const SizedBox(height: 10),
            CustomButton(
              heights: 40,
              borderClr: Colors.transparent,
              onTap: controller.actionInFlight
                  ? null
                  : controller.resumeFinalPaymentAction,
              text: 'Authenticate Payment',
            ),
          ],
          if (permissions.canRetryPayment) ...[
            const SizedBox(height: 10),
            CustomButton(
              heights: 40,
              borderClr: Colors.transparent,
              onTap: controller.actionInFlight
                  ? null
                  : controller.retryFinalPaymentAction,
              text: 'Retry Payment',
            ),
          ],
        ],
      ),
    );
  }
}

/// Audit timeline from GET /api/events/{event}/completion/history.
class CompletionHistoryList extends StatefulWidget {
  const CompletionHistoryList({super.key, required this.eventId});

  final int eventId;

  @override
  State<CompletionHistoryList> createState() => _CompletionHistoryListState();
}

class _CompletionHistoryListState extends State<CompletionHistoryList> {
  final PaymentRepository _repository = PaymentRepository();
  List<_HistoryEntry> _entries = const [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final raw = await _repository.getCompletionHistory(widget.eventId);
      if (!mounted) return;
      setState(() {
        _entries = _parseHistory(raw);
        _loaded = true;
      });
    } catch (_) {
      // History is a nice-to-have audit view; keep the screen usable.
      if (mounted) setState(() => _loaded = true);
    }
  }

  List<_HistoryEntry> _parseHistory(List<dynamic> raw) {
    final entries = <_HistoryEntry>[];

    void addAll(Iterable items, String fallbackLabel) {
      for (final item in items) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        entries.add(_HistoryEntry(
          label: map['title']?.toString() ??
              map['type']?.toString().replaceAll('_', ' ') ??
              fallbackLabel,
          status: map['status']?.toString(),
          amountMinor: _historyInt(
            map['proposed_principal_minor'] ?? map['amount_minor'],
          ),
          message: map['message']?.toString(),
          at: DateTime.tryParse(
            map['created_at']?.toString() ??
                map['occurred_at']?.toString() ??
                '',
          ),
        ));
      }
    }

    for (final item in raw) {
      if (item is Map) {
        final map = Map<String, dynamic>.from(item);
        // Shape A: { completion_requests: [...], counters: [...] }
        final requests = map['completion_requests'];
        final counters = map['counters'];
        if (requests is List || counters is List) {
          if (requests is List) addAll(requests, 'Completion requested');
          if (counters is List) addAll(counters, 'Counter');
          continue;
        }
        // Shape B: flat list of audit entries.
        addAll([map], 'Update');
      }
    }
    entries.sort((a, b) {
      final at = a.at, bt = b.at;
      if (at == null && bt == null) return 0;
      if (at == null) return 1;
      if (bt == null) return -1;
      return bt.compareTo(at);
    });
    return entries;
  }

  int? _historyInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _entries.isEmpty) return const SizedBox.shrink();
    final money = MoneyFormatter();
    return _JourneyCardShell(
      title: 'History',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _entries
            .take(10)
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Icon(Icons.circle,
                          size: 8, color: DynamicColor.yellowClr),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.label +
                                (entry.status != null
                                    ? ' — ${entry.status}'
                                    : ''),
                            style: poppinsMediumStyle(
                              context: context,
                              fontSize: 13,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          if (entry.amountMinor != null)
                            Text(
                              money.formatMinor(entry.amountMinor),
                              style: poppinsRegularStyle(
                                context: context,
                                fontSize: 12,
                                color: DynamicColor.yellowClr,
                              ),
                            ),
                          if (entry.message != null &&
                              entry.message!.isNotEmpty)
                            Text(
                              entry.message!,
                              style: poppinsRegularStyle(
                                context: context,
                                fontSize: 12,
                                color: DynamicColor.grayClr,
                              ),
                            ),
                          if (entry.at != null)
                            Text(
                              DateFormat.yMMMd()
                                  .add_jm()
                                  .format(entry.at!.toLocal()),
                              style: poppinsRegularStyle(
                                context: context,
                                fontSize: 11,
                                color: DynamicColor.grayClr,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _HistoryEntry {
  const _HistoryEntry({
    required this.label,
    this.status,
    this.amountMinor,
    this.message,
    this.at,
  });

  final String label;
  final String? status;
  final int? amountMinor;
  final String? message;
  final DateTime? at;
}

class _JourneyCardShell extends StatelessWidget {
  const _JourneyCardShell({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DynamicColor.darkGrayClr,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DynamicColor.yellowClr.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: poppinsMediumStyle(
              context: context,
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
