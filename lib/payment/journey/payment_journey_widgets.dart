import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:intl/intl.dart';
import '../payment_models.dart';
import 'payment_journey_controller.dart';
import 'payment_journey_mapper.dart';
import 'payment_journey_models.dart';

/// Embeddable "Payment & Event Status" section for Event Detail.
class EventPaymentJourneySection extends StatelessWidget {
  const EventPaymentJourneySection({super.key, required this.eventId});

  final int eventId;

  @override
  Widget build(BuildContext context) {
    final controller = paymentJourneyController(eventId);
    return GetBuilder<PaymentJourneyController>(
      init: controller,
      tag: 'payment_journey_$eventId',
      builder: (controller) {
        if (controller.state == PaymentWorkflowState.authorizationError) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment & Event Status',
                style: poppinsMediumStyle(
                  context: context,
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              if (controller.state == PaymentWorkflowState.loading &&
                  controller.journey == null)
                _LoadingCard()
              else if (controller.journey == null)
                _ErrorCard(
                  message: controller.errorMessage ??
                      'Unable to load payment status.',
                  onRetry: controller.refreshJourney,
                )
              else
                PaymentJourneyCard(controller: controller),
            ],
          ),
        );
      },
    );
  }
}

class PaymentJourneyCard extends StatelessWidget {
  const PaymentJourneyCard({super.key, required this.controller});

  final PaymentJourneyController controller;

  @override
  Widget build(BuildContext context) {
    final journey = controller.journey!;
    final ui = controller.ui;
    final money = MoneyFormatter();
    final currency = journey.totals.currency;
    final theme = Theme.of(context);
    final pct = PaymentJourneyMapper.percentageLabel(
      journey.totals.downPaymentPercentage,
    );
    final paid = journey.totals.downPaymentPaidMinor ??
        journey.downPayment.principalMinor ??
        journey.totals.downPaymentPrincipalMinor;
    final remaining = journey.totals.remainingPrincipalMinor;

    return Container(
      width: double.infinity,
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
          Row(
            children: [
              Icon(ui.icon, color: DynamicColor.yellowClr, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ui.title,
                  style: poppinsMediumStyle(
                    context: context,
                    fontSize: 16,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              _Badge(label: ui.badge),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ui.explanation,
            style: poppinsRegularStyle(
              context: context,
              fontSize: 13,
              color: DynamicColor.grayClr,
            ),
          ),
          const SizedBox(height: 12),
          _MoneyRow(
            label: 'Event total',
            value: money.formatMinor(
              journey.totals.eventPrincipalMinor,
              currency: currency,
            ),
          ),
          _MoneyRow(
            label: 'Down payment paid ($pct)',
            value: money.formatMinor(paid, currency: currency),
          ),
          _MoneyRow(
            label: 'Remaining balance',
            value: money.formatMinor(remaining, currency: currency),
            emphasized: true,
          ),
          if (journey.isVenueManager) ...[
            _MoneyRow(
              label: 'Stripe processing fee',
              value: money.formatMinor(
                journey.downPayment.stripeFeeMinor ??
                    journey.totals.estimatedStripeFeeMinor,
                currency: currency,
              ),
            ),
            _MoneyRow(
              label: 'Total amount charged',
              value: money.formatMinor(
                journey.downPayment.chargeAmountMinor ??
                    journey.totals.chargeAmountMinor,
                currency: currency,
              ),
            ),
          ],
          if (journey.isEventOrganizer) ...[
            _MoneyRow(
              label: 'Groovkin commission',
              value: money.formatMinor(
                journey.downPayment.groovkinCommissionMinor ??
                    journey.totals.groovkinCommissionMinor,
                currency: currency,
              ),
            ),
            _MoneyRow(
              label: 'Organizer proceeds',
              value: money.formatMinor(
                journey.downPayment.organizerProceedsMinor ??
                    journey.totals.organizerProceedsMinor,
                currency: currency,
              ),
            ),
            if (journey.downPayment.transferStatus != null ||
                journey.finalPayment.transferStatus != null)
              _MoneyRow(
                label: 'Transfer status',
                value: journey.finalPayment.transferStatus ??
                    journey.downPayment.transferStatus ??
                    '--',
              ),
          ],
          if (journey.settlementStatus != null) ...[
            const SizedBox(height: 4),
            _MoneyRow(
              label: 'Settlement status',
              value: journey.settlementStatus!.replaceAll('_', ' '),
            ),
          ],
          if (journey.completion.autoApproveSecondsRemaining != null) ...[
            const SizedBox(height: 8),
            Text(
              'Auto-approval: ${PaymentJourneyMapper.formatCountdown(journey.completion.autoApproveSecondsRemaining)}',
              style: poppinsRegularStyle(
                context: context,
                fontSize: 12,
                color: DynamicColor.yellowClr,
              ),
            ),
            if (journey.completion.requestedAt != null)
              Text(
                'Requested ${_formatTime(journey.completion.requestedAt!)}',
                style: poppinsRegularStyle(
                  context: context,
                  fontSize: 12,
                  color: DynamicColor.grayClr,
                ),
              ),
          ],
          if (journey.completion.latestCounter?.id != null) ...[
            const SizedBox(height: 10),
            _CounterBlock(
              counter: journey.completion.latestCounter!,
              currency: currency,
              permissions: journey.permissions,
              onAccept: () => controller
                  .acceptCounter(journey.completion.latestCounter!.id!),
              onReject: () => controller
                  .rejectCounter(journey.completion.latestCounter!.id!),
            ),
          ],
          if (journey.timeline.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Timeline',
              style: poppinsMediumStyle(
                context: context,
                fontSize: 14,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 6),
            ...journey.timeline.take(6).map(
                  (event) => _TimelineTile(event: event),
                ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: controller.actionInFlight
                      ? null
                      : () => controller.refreshJourney(),
                  child: const Text('Refresh'),
                ),
              ),
              if (ui.primaryActionLabel != null)
                Expanded(
                  child: CustomButton(
                    heights: 45,

                    borderClr: Colors.transparent,
                    onTap: controller.actionInFlight
                        ? null
                        : controller.runPrimaryAction,
                    text: controller.actionInFlight
                        ? 'Working...'
                        : ui.primaryActionLabel!,
                  ),
                ),
            ],
          ),
          if (journey.permissions.canSubmitCompletion &&
              journey.nextAction.code !=
                  PaymentNextActionCode.submitCompletion) ...[
            const SizedBox(height: 8),
            CustomButton(
              heights: 40,
              borderClr: Colors.transparent,
              onTap: controller.actionInFlight
                  ? null
                  : controller.submitCompletion,
              text: 'Mark Event Complete',
            ),
          ],
          if (journey.permissions.canApproveCompletion) ...[
            const SizedBox(height: 8),
            CustomButton(
              heights: 40,
              borderClr: Colors.transparent,
              onTap: controller.actionInFlight
                  ? null
                  : controller.approveCompletion,
              text: 'Approve Completion',
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime value) {
    return DateFormat.yMMMd().add_jm().format(value.toLocal());
  }
}

class _CounterBlock extends StatelessWidget {
  const _CounterBlock({
    required this.counter,
    required this.currency,
    required this.permissions,
    required this.onAccept,
    required this.onReject,
  });

  final JourneyCounter counter;
  final String currency;
  final JourneyPermissions permissions;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final money = MoneyFormatter();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Open counter',
            style: poppinsMediumStyle(
              context: context,
              fontSize: 14,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Proposed: ${money.formatMinor(counter.proposedPrincipalMinor, currency: currency)}',
            style: poppinsRegularStyle(
              context: context,
              fontSize: 13,
              color: DynamicColor.whiteClr,
            ),
          ),
          if (counter.originalPrincipalMinor != null)
            Text(
              'Original: ${money.formatMinor(counter.originalPrincipalMinor, currency: currency)}',
              style: poppinsRegularStyle(
                context: context,
                fontSize: 12,
                color: DynamicColor.grayClr,
              ),
            ),
          if (counter.message != null && counter.message!.isNotEmpty)
            Text(
              counter.message!,
              style: poppinsRegularStyle(
                context: context,
                fontSize: 12,
                color: DynamicColor.grayClr,
              ),
            ),
          if (counter.counterSecondsRemaining != null)
            Text(
              PaymentJourneyMapper.formatCountdown(
                counter.counterSecondsRemaining,
              ),
              style: poppinsRegularStyle(
                context: context,
                fontSize: 12,
                color: DynamicColor.yellowClr,
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (permissions.canAcceptCounter)
                Expanded(
                  child: CustomButton(
                    heights: 36,
                    borderClr: Colors.transparent,
                    onTap: onAccept,
                    text: 'Accept',
                  ),
                ),
              if (permissions.canAcceptCounter && permissions.canRejectCounter)
                const SizedBox(width: 8),
              if (permissions.canRejectCounter)
                Expanded(
                  child: CustomButton(
                    heights: 36,
                    borderClr: DynamicColor.yellowClr,
                    backgroundClr: false,
                    onTap: onReject,
                    text: 'Reject',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.event});

  final JourneyTimelineEvent event;

  @override
  Widget build(BuildContext context) {
    final money = MoneyFormatter();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 8, color: DynamicColor.yellowClr),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title ?? event.code?.replaceAll('_', ' ') ?? 'Update',
                  style: poppinsMediumStyle(
                    context: context,
                    fontSize: 13,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                if (event.status != null)
                  Text(
                    event.status!,
                    style: poppinsRegularStyle(
                      context: context,
                      fontSize: 11,
                      color: DynamicColor.grayClr,
                    ),
                  ),
                if (event.amountMinor != null)
                  Text(
                    money.formatMinor(
                      event.amountMinor,
                      currency: event.currency,
                    ),
                    style: poppinsRegularStyle(
                      context: context,
                      fontSize: 12,
                      color: DynamicColor.yellowClr,
                    ),
                  ),
                if (event.occurredAt != null)
                  Text(
                    DateFormat.yMMMd().add_jm().format(
                          event.occurredAt!.toLocal(),
                        ),
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
    );
  }
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
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

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: DynamicColor.yellowClr.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: poppinsRegularStyle(
          context: context,
          fontSize: 11,
          color: DynamicColor.yellowClr,
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DynamicColor.darkGrayClr,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: DynamicColor.yellowClr,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading payment status...',
            style: poppinsRegularStyle(
              context: context,
              fontSize: 13,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DynamicColor.darkGrayClr,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: poppinsRegularStyle(
              context: context,
              fontSize: 13,
              color: DynamicColor.grayClr,
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
