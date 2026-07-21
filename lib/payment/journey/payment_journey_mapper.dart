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
  });

  final String title;
  final String explanation;
  final IconData icon;
  final String badge;
  final String? primaryActionLabel;
}

class PaymentJourneyMapper {
  static JourneyUiState uiFor(PaymentJourney journey) {
    final actionLabel =
        labelForNextAction(journey.nextAction.code) ?? journey.nextAction.label;

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
        return JourneyUiState(
          title: 'Final payment processing',
          explanation: 'The remaining event balance is being processed.',
          icon: Iconsax.timer_1,
          badge: 'Processing',
          primaryActionLabel: actionLabel,
        );
      case PaymentJourneyStage.finalPaymentRequiresAction:
        return JourneyUiState(
          title: 'Payment authentication required',
          explanation:
              'Your bank requires verification to complete the remaining event payment.',
          icon: Iconsax.shield_tick,
          badge: 'Authenticate',
          primaryActionLabel: actionLabel ?? 'Complete Payment',
        );
      case PaymentJourneyStage.finalPaymentFailed:
        return JourneyUiState(
          title: 'Final payment failed',
          explanation:
              'The remaining balance could not be charged. Update your payment method or retry.',
          icon: Iconsax.close_circle,
          badge: 'Failed',
          primaryActionLabel: actionLabel ?? 'Retry Payment',
        );
      case PaymentJourneyStage.finalTransferPending:
        return JourneyUiState(
          title: 'Organizer transfer pending',
          explanation:
              'Final payment succeeded. Organizer proceeds are being transferred to Stripe.',
          icon: Iconsax.send_2,
          badge: 'Transfer pending',
          primaryActionLabel: actionLabel,
        );
      case PaymentJourneyStage.financiallySettled:
        return JourneyUiState(
          title: 'Financially settled',
          explanation: 'Payments and transfers for this event are complete.',
          icon: Iconsax.tick_circle,
          badge: 'Settled',
          primaryActionLabel: actionLabel,
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
        return JourneyUiState(
          title: 'Manual review',
          explanation:
              'This payment needs manual review before it can continue.',
          icon: Iconsax.info_circle,
          badge: 'Review',
          primaryActionLabel: actionLabel,
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
