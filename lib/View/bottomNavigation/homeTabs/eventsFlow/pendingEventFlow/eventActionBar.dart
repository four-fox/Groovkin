import 'package:flutter/material.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/model/event_counter_model.dart';
import 'package:groovkin/payment/payment_models.dart';
import 'package:groovkin/utils/money.dart';

const kAcceptEventKey = Key('action_accept_event');
const kDeclineEventKey = Key('action_decline_event');
const kCounterKey = Key('action_counter');
const kAcceptCounterKey = Key('action_accept_counter');
const kRejectCounterKey = Key('action_reject_counter');
const kCounterAgainKey = Key('action_counter_again');
const kEditEventKey = Key('action_edit_event');
const kMarkCompleteKey = Key('action_mark_complete');
const kApproveFinalPaymentKey = Key('action_approve_final_payment');

class EventActionBar extends StatelessWidget {
  const EventActionBar({
    super.key,
    required this.flags,
    this.busy = false,
    this.onAcceptEvent,
    this.onDeclineEvent,
    this.onCounter,
    this.onAcceptCounter,
    this.onRejectCounter,
    this.onCounterAgain,
    this.onEditEvent,
    this.onMarkComplete,
    this.onApproveFinalPayment,
  });

  final EventActionFlags flags;
  final bool busy;
  final VoidCallback? onAcceptEvent;
  final VoidCallback? onDeclineEvent;
  final VoidCallback? onCounter;
  final VoidCallback? onAcceptCounter;
  final VoidCallback? onRejectCounter;
  final VoidCallback? onCounterAgain;
  final VoidCallback? onEditEvent;
  final VoidCallback? onMarkComplete;
  final VoidCallback? onApproveFinalPayment;

  @override
  Widget build(BuildContext context) {
    if (flags.visibleCount == 0) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (flags.acceptEvent)
              _primary(
                key: kAcceptEventKey,
                label: busy ? 'Working...' : 'Accept Event',
                onTap: busy ? null : onAcceptEvent,
              ),
            if (flags.approveFinalPayment)
              _primary(
                key: kApproveFinalPaymentKey,
                label: busy ? 'Working...' : 'Approve Final Payment',
                onTap: busy ? null : onApproveFinalPayment,
              ),
            if (flags.acceptCounter)
              _primary(
                key: kAcceptCounterKey,
                label: busy ? 'Working...' : 'Accept Counter',
                onTap: busy ? null : onAcceptCounter,
              ),
            if (flags.counter)
              _secondary(
                key: kCounterKey,
                theme: theme,
                label: busy ? 'Working...' : 'Counter',
                onTap: busy ? null : onCounter,
              ),
            if (flags.counterAgain)
              _secondary(
                key: kCounterAgainKey,
                theme: theme,
                label: busy ? 'Working...' : 'Counter Again',
                onTap: busy ? null : onCounterAgain,
              ),
            if (flags.editEvent)
              _secondary(
                key: kEditEventKey,
                theme: theme,
                label: 'Edit Event',
                onTap: busy ? null : onEditEvent,
              ),
            if (flags.markComplete)
              _secondary(
                key: kMarkCompleteKey,
                theme: theme,
                label: busy ? 'Working...' : 'Mark Complete',
                onTap: busy ? null : onMarkComplete,
              ),
            if (flags.declineEvent)
              _destructive(
                key: kDeclineEventKey,
                label: 'Decline Event',
                onTap: busy ? null : onDeclineEvent,
              ),
            if (flags.rejectCounter)
              _destructive(
                key: kRejectCounterKey,
                label: 'Reject Counter',
                onTap: busy ? null : onRejectCounter,
              ),
          ],
        ),
      ),
    );
  }

  Widget _primary({
    required Key key,
    required String label,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        button: true,
        label: label,
        child: CustomButton(
          key: key,
          heights: 46,
          borderClr: Colors.transparent,
          color1: DynamicColor.greenClr,
          color2: DynamicColor.greenClr,
          backgroundClr: false,
          onTap: onTap,
          text: label,
        ),
      ),
    );
  }

  Widget _secondary({
    required Key key,
    required ThemeData theme,
    required String label,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        button: true,
        label: label,
        child: CustomButton(
          key: key,
          heights: 46,
          backgroundClr: false,
          color1: DynamicColor.secondaryClr,
          color2: DynamicColor.yellowClr,
          borderClr: DynamicColor.yellowClr,
          textClr: theme.scaffoldBackgroundColor,
          onTap: onTap,
          text: label,
        ),
      ),
    );
  }

  Widget _destructive({
    required Key key,
    required String label,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        button: true,
        label: label,
        child: CustomButton(
          key: key,
          heights: 46,
          backgroundClr: false,
          color1: DynamicColor.redClr.withValues(alpha: 0.85),
          color2: DynamicColor.redClr.withValues(alpha: 0.7),
          borderClr: Colors.transparent,
          onTap: onTap,
          text: label,
        ),
      ),
    );
  }
}

Future<void> showPriceCounterSheet({
  required BuildContext context,
  required int agreedMinor,
  required String currency,
  required Future<bool> Function(int minor, String message) onSubmit,
  bool again = false,
}) async {
  final amountController = TextEditingController();
  final messageController = TextEditingController();
  final money = MoneyFormatter();
  String? error;
  var submitting = false;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final bottom = MediaQuery.of(sheetContext).viewInsets.bottom;
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 16 + bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  again ? 'Counter Again' : 'Counter',
                  style: poppinsMediumStyle(
                    context: sheetContext,
                    fontSize: 18,
                    color: Theme.of(sheetContext).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current agreed price ${money.formatMinor(agreedMinor, currency: currency)}',
                  style: poppinsRegularStyle(
                    context: sheetContext,
                    fontSize: 14,
                    color: DynamicColor.grayClr,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Your proposed price',
                    prefixText: r'$ ',
                    errorText: error,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Message (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  heights: 46,
                  borderClr: Colors.transparent,
                  onTap: submitting
                      ? null
                      : () async {
                          final minor =
                              dollarsToMinorUnits(amountController.text);
                          if (minor == null) {
                            setSheetState(() =>
                                error = 'Enter a valid amount, e.g. 2700.00');
                            return;
                          }
                          setSheetState(() {
                            error = null;
                            submitting = true;
                          });
                          final ok = await onSubmit(
                            minor,
                            messageController.text.trim(),
                          );
                          if (ok && sheetContext.mounted) {
                            Navigator.of(sheetContext).pop();
                          } else {
                            setSheetState(() => submitting = false);
                          }
                        },
                  text: submitting ? 'Submitting...' : 'Submit Counter',
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
