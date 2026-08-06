import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'payment_journey_models.dart';

class JourneyUiState {
  const JourneyUiState({
    required this.title,
    required this.explanation,
    required this.icon,
    required this.badge,
    this.primaryActionLabel,
    this.secondaryActionLabel,
  });

  final String title;
  final String explanation;
  final IconData icon;
  final String badge;
  final String? primaryActionLabel;
  final String? secondaryActionLabel;
}

class PaymentJourneyMapper {
  /// Resolves display state from settlement_status + journey_stage + transfer.
  /// Never treats final_payment.status == succeeded as financially settled.
  ///
  /// `final_transfer_pending` and `manual_review` are **not errors** — the
  /// backend automatically retries/reconciles the EO Stripe Connect transfer
  /// and the journey self-resolves to `financially_settled` in the background
  /// (typically within ~10 minutes). The user must never see a failure state,
  /// a retry button, or a "contact support" prompt for these two stages.
  static JourneyUiState uiFor(PaymentJourney journey) {
    final actionLabel =
        labelForNextAction(journey.nextAction.code) ?? journey.nextAction.label;
    final transferStatus = journey.finalPayment.transferStatus;
    final settled = isFinanciallySettled(journey.settlementStatus);

    // G — settlement_status is the only source of "Payment complete".
    if (settled) {
      return JourneyUiState(
        title: 'Payment complete',
        explanation: 'The event payment has been financially settled.',
        icon: Iconsax.tick_circle,
        badge: 'Settled',
        primaryActionLabel: actionLabel ??
            (journey.nextAction.code == PaymentNextActionCode.viewSettlement
                ? 'View Settlement'
                : null),
      );
    }

    // F — EO transfer to Stripe Connect already succeeded (checked before the
    // generic "finalizing" copy below, since transfer_status can resolve
    // slightly ahead of journey_stage moving off final_transfer_pending).
    if (isEoTransferSucceeded(transferStatus)) {
      return const JourneyUiState(
        title: 'Transferred to Stripe account',
        explanation:
            'The organizer proceeds were transferred to the connected Stripe account.',
        icon: Iconsax.card_tick,
        badge: 'Transferred',
      );
    }

    // E — payout reconciliation in progress. Self-resolving; no user action.
    if (journey.journeyStage == PaymentJourneyStage.manualReview ||
        journey.settlementStatus == 'manual_review') {
      return const JourneyUiState(
        title: 'Payment completed',
        explanation:
            'Your payout is being finalized. This resolves automatically — no action is needed.',
        icon: Iconsax.wallet_check,
        badge: 'Finalizing',
      );
    }

    // D — final payment succeeded, EO Connect transfer still finalizing.
    // Also self-resolving; no user action even if a transient transfer
    // failure is reported mid-flight, since the backend auto-retries.
    if (journey.journeyStage == PaymentJourneyStage.finalTransferPending) {
      return const JourneyUiState(
        title: 'Payment successful',
        explanation:
            'Finalizing payout to the organizer. This resolves automatically — no action is needed.',
        icon: Iconsax.send_2,
        badge: 'Finalizing',
      );
    }

    switch (journey.journeyStage) {
      case PaymentJourneyStage.proposalCreated:
        return JourneyUiState(
          title: 'Proposal created',
          explanation:
              'This event proposal is ready for the next payment step.',
          icon: Iconsax.document_text,
          badge: 'Proposal',
          primaryActionLabel: actionLabel,
        );
      case PaymentJourneyStage.awaitingConnectOnboarding:
        return JourneyUiState(
          title: 'Stripe setup required',
          explanation:
              'Complete Stripe verification before this payment can continue.',
          icon: Iconsax.card,
          badge: 'Action needed',
          primaryActionLabel: actionLabel ?? 'Complete Stripe Setup',
        );
      case PaymentJourneyStage.awaitingPaymentMethod:
        return JourneyUiState(
          title: 'Payment method required',
          explanation:
              'Add a secure card before accepting or completing payment.',
          icon: Iconsax.card_add,
          badge: 'Action needed',
          primaryActionLabel: actionLabel ?? 'Add Secure Card',
        );
      case PaymentJourneyStage.awaitingAcceptance:
        return JourneyUiState(
          title: 'Ready to accept',
          explanation: 'Review the payment summary and accept this event.',
          icon: Iconsax.tick_circle,
          badge: 'Ready',
          primaryActionLabel: actionLabel ?? 'Review and Accept',
        );
      case PaymentJourneyStage.downPaymentProcessing:
        return JourneyUiState(
          title: 'Down payment processing',
          explanation: 'Your down payment is being processed securely.',
          icon: Iconsax.timer_1,
          badge: 'Processing',
          primaryActionLabel: actionLabel,
        );
      case PaymentJourneyStage.downPaymentRequiresAction:
        return JourneyUiState(
          title: 'Payment authentication required',
          explanation:
              'Your bank requires verification to complete the down payment.',
          icon: Iconsax.shield_tick,
          badge: 'Authenticate',
          primaryActionLabel: actionLabel ?? 'Complete Payment',
        );
      case PaymentJourneyStage.downPaymentFailed:
        return JourneyUiState(
          title: 'Down payment failed',
          explanation:
              'The down payment could not be completed. Update your card or try again.',
          icon: Iconsax.close_circle,
          badge: 'Failed',
          primaryActionLabel: actionLabel ?? 'Retry Payment',
          secondaryActionLabel: 'Update Payment Method',
        );
      case PaymentJourneyStage.eventInProgress:
        return JourneyUiState(
          title: 'Event in progress',
          explanation:
              'Down payment paid. The remaining balance will be processed after event completion approval.',
          icon: Iconsax.calendar_1,
          badge: 'In progress',
          primaryActionLabel: actionLabel,
        );
      case PaymentJourneyStage.completionRequested:
        return JourneyUiState(
          title: 'Completion requested',
          explanation:
              'The Venue Manager has 48 hours to approve or submit a counter.',
          icon: Iconsax.clock,
          badge: 'Awaiting approval',
          primaryActionLabel: actionLabel,
        );
      case PaymentJourneyStage.counterNegotiation:
        return JourneyUiState(
          title: 'Counter negotiation',
          explanation:
              'A counter amount is open. Review the proposal before the countdown ends.',
          icon: Iconsax.convertshape,
          badge: 'Counter',
          primaryActionLabel: actionLabel ?? 'Review Counter',
        );
      case PaymentJourneyStage.supportReview:
        return JourneyUiState(
          title: 'Support review',
          explanation:
              'Groovkin support is reviewing this event. Status will update automatically.',
          icon: Iconsax.info_circle,
          badge: 'Support',
          primaryActionLabel: actionLabel,
        );
      case PaymentJourneyStage.completionApproved:
        return JourneyUiState(
          title: 'Completion approved',
          explanation: 'Completion was approved. Final payment is next.',
          icon: Iconsax.verify,
          badge: 'Approved',
          primaryActionLabel: actionLabel,
        );
      case PaymentJourneyStage.completionAutoApproved:
        return JourneyUiState(
          title: 'Completion auto-approved',
          explanation:
              'The 48-hour window ended without a response. Final payment will process separately.',
          icon: Iconsax.verify,
          badge: 'Auto-approved',
          primaryActionLabel: actionLabel,
        );
      case PaymentJourneyStage.finalPaymentProcessing:
        // A
        return JourneyUiState(
          title: 'Final payment processing',
          explanation: 'The remaining event balance is being processed.',
          icon: Iconsax.timer_1,
          badge: 'Processing',
          primaryActionLabel: actionLabel,
        );
      case PaymentJourneyStage.finalPaymentRequiresAction:
        // B
        return JourneyUiState(
          title: 'Payment authentication required',
          explanation:
              'Your bank requires verification to complete the remaining event payment.',
          icon: Iconsax.shield_tick,
          badge: 'Authenticate',
          primaryActionLabel: actionLabel ?? 'Complete Payment',
        );
      case PaymentJourneyStage.finalPaymentFailed:
        // C
        return JourneyUiState(
          title: 'Final payment failed',
          explanation: 'Update your payment method or retry the payment.',
          icon: Iconsax.close_circle,
          badge: 'Failed',
          primaryActionLabel: actionLabel ?? 'Retry Payment',
          secondaryActionLabel: 'Update Payment Method',
        );
      case PaymentJourneyStage.finalTransferPending:
        return const JourneyUiState(
          title: 'Payment successful',
          explanation:
              'Finalizing payout to the organizer. This resolves automatically — no action is needed.',
          icon: Iconsax.send_2,
          badge: 'Finalizing',
        );
      case PaymentJourneyStage.financiallySettled:
        // Stage alone is not authoritative — settlement_status gates copy above.
        // If we reach here, settlement_status was not financially_settled.
        return const JourneyUiState(
          title: 'Transferred to Stripe account',
          explanation:
              'The organizer proceeds were transferred to the connected Stripe account.',
          icon: Iconsax.card_tick,
          badge: 'Transferred',
        );
      case PaymentJourneyStage.cancellationProcessing:
        return JourneyUiState(
          title: 'Cancellation processing',
          explanation:
              'Cancellation financial work is in progress. Status will update automatically.',
          icon: Iconsax.timer_1,
          badge: 'Processing',
          primaryActionLabel: actionLabel,
        );
      case PaymentJourneyStage.cancelled:
        return JourneyUiState(
          title: 'Cancelled',
          explanation:
              'This event was cancelled. Refund or settlement details are available when returned by the server.',
          icon: Iconsax.close_circle,
          badge: 'Cancelled',
          primaryActionLabel: actionLabel,
        );
      case PaymentJourneyStage.manualReview:
        return const JourneyUiState(
          title: 'Payment completed',
          explanation:
              'Your payout is being finalized. This resolves automatically — no action is needed.',
          icon: Iconsax.wallet_check,
          badge: 'Finalizing',
        );
      case PaymentJourneyStage.disputed:
        return JourneyUiState(
          title: 'Disputed',
          explanation: 'A dispute is open for a payment on this event.',
          icon: Iconsax.warning_2,
          badge: 'Dispute',
          primaryActionLabel: actionLabel,
        );
      case PaymentJourneyStage.unknown:
        return JourneyUiState(
          title: 'Payment status',
          explanation: 'Refresh to load the latest payment journey.',
          icon: Iconsax.refresh,
          badge: 'Unknown',
          primaryActionLabel: actionLabel,
        );
    }
  }

  static String? labelForNextAction(PaymentNextActionCode code) {
    switch (code) {
      case PaymentNextActionCode.completeConnectOnboarding:
        return 'Complete Stripe Setup';
      case PaymentNextActionCode.addPaymentMethod:
        return 'Add Secure Card';
      case PaymentNextActionCode.reviewAndAccept:
        return 'Review and Accept';
      case PaymentNextActionCode.completeDownPayment:
        return 'Complete Payment';
      case PaymentNextActionCode.waitForEvent:
        return null;
      case PaymentNextActionCode.submitCompletion:
        return 'Mark Event Complete';
      case PaymentNextActionCode.reviewCompletion:
        return 'Review Completion';
      case PaymentNextActionCode.reviewCounter:
        return 'Review Counter';
      case PaymentNextActionCode.resumeFinalPayment:
        return 'Complete Payment';
      case PaymentNextActionCode.retryFinalPayment:
        return 'Retry Payment';
      case PaymentNextActionCode.viewSupportReview:
        return 'View Support Review';
      case PaymentNextActionCode.viewCancellation:
        return 'View Cancellation';
      case PaymentNextActionCode.viewSettlement:
        return 'View Settlement';
      case PaymentNextActionCode.none:
      case PaymentNextActionCode.unknown:
        return null;
    }
  }

  static String formatCountdown(int? seconds) {
    if (seconds == null) return '--';
    if (seconds <= 0) return 'Expired';
    final duration = Duration(seconds: seconds);
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    if (days > 0) return '${days}d ${hours}h remaining';
    if (hours > 0) return '${hours}h ${minutes}m remaining';
    return '${minutes}m remaining';
  }

  /// Friendly copy for raw backend status strings. Never surface technical
  /// codes like "manual_review" or "final_transfer_pending" directly.
  static String friendlySettlementStatusLabel(String? settlementStatus) {
    switch (settlementStatus) {
      case 'financially_settled':
        return 'Financially settled';
      case 'manual_review':
        return 'Finalizing payout';
      case 'final_transfer_pending':
        return 'Finalizing payout';
      case null:
        return '--';
      default:
        return settlementStatus.replaceAll('_', ' ');
    }
  }

  static String friendlyTransferStatusLabel(String? transferStatus) {
    if (transferStatus == null) return '--';
    if (isEoTransferSucceeded(transferStatus)) return 'Transferred';
    if (isEoTransferFailed(transferStatus)) return 'Finalizing';
    switch (transferStatus) {
      case 'pending':
      case 'processing':
        return 'Finalizing';
      default:
        return transferStatus.replaceAll('_', ' ');
    }
  }

  static String percentageLabel(String? raw) {
    if (raw == null || raw.isEmpty) return '--';
    final value = double.tryParse(raw);
    if (value == null) return raw;
    if (value == value.roundToDouble()) {
      return '${value.toInt()}%';
    }
    return '${value.toStringAsFixed(1)}%';
  }
}
