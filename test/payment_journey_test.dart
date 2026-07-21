import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/payment/journey/payment_journey_mapper.dart';
import 'package:groovkin/payment/journey/payment_journey_models.dart';
import 'package:groovkin/payment/payment_deep_links.dart';

void main() {
  group('PaymentJourneyStage parsing', () {
    test('parses all documented stages', () {
      expect(
        parsePaymentJourneyStage('event_in_progress'),
        PaymentJourneyStage.eventInProgress,
      );
      expect(
        parsePaymentJourneyStage('final_payment_requires_action'),
        PaymentJourneyStage.finalPaymentRequiresAction,
      );
      expect(
        parsePaymentJourneyStage('financially_settled'),
        PaymentJourneyStage.financiallySettled,
      );
      expect(
        parsePaymentJourneyStage('completion_auto_approved'),
        PaymentJourneyStage.completionAutoApproved,
      );
      expect(
        paymentJourneyStageWire(PaymentJourneyStage.downPaymentFailed),
        'down_payment_failed',
      );
    });
  });

  group('Payment journey payload', () {
    test('parses 20% down payment in-progress journey', () {
      final journey = PaymentJourney.fromJson({
        'event_id': 101,
        'role': 'venue_manager',
        'journey_stage': 'event_in_progress',
        'settlement_status': 'down_payment_succeeded',
        'currency': 'usd',
        'readiness': {
          'vm_connect_ready': true,
          'eo_connect_ready': true,
          'payment_method_ready': true,
        },
        'totals': {
          'event_principal_minor': 100000,
          'down_payment_percentage': '20.0000',
          'down_payment_paid_minor': 20000,
          'remaining_principal_minor': 80000,
          'estimated_stripe_fee_minor': 650,
          'charge_amount_minor': 20650,
        },
        'down_payment': {
          'status': 'succeeded',
          'principal_minor': 20000,
          'stripe_fee_minor': 650,
          'charge_amount_minor': 20650,
          'payment_id': 55,
        },
        'permissions': {
          'can_submit_completion': false,
          'can_approve_completion': false,
        },
        'next_action': {'code': 'wait_for_event'},
        'timeline': [
          {
            'code': 'down_payment_paid',
            'title': 'Down payment paid',
            'status': 'succeeded',
            'amount_minor': 20000,
            'occurred_at': '2026-07-20T10:00:00+00:00',
          }
        ],
      });

      expect(journey.eventId, 101);
      expect(journey.journeyStage, PaymentJourneyStage.eventInProgress);
      expect(journey.totals.eventPrincipalMinor, 100000);
      expect(journey.totals.downPaymentPaidMinor, 20000);
      expect(journey.totals.remainingPrincipalMinor, 80000);
      expect(journey.downPayment.isSucceeded, isTrue);
      expect(journey.nextAction.code, PaymentNextActionCode.waitForEvent);
      expect(journey.timeline.single.title, 'Down payment paid');
      expect(journey.isVenueManager, isTrue);
    });

    test('parses 30% remaining balance after down payment', () {
      final journey = PaymentJourney.fromJson({
        'event_id': 202,
        'role': 'event_owner',
        'journey_stage': 'event_in_progress',
        'totals': {
          'event_principal_minor': 100000,
          'down_payment_percentage': '30.0000',
          'down_payment_paid_minor': 30000,
          'remaining_principal_minor': 70000,
          'groovkin_commission_minor': 10000,
          'organizer_proceeds_minor': 90000,
        },
        'next_action': {'code': 'submit_completion'},
        'permissions': {'can_submit_completion': true},
      });

      expect(journey.totals.downPaymentPaidMinor, 30000);
      expect(journey.totals.remainingPrincipalMinor, 70000);
      expect(journey.permissions.canSubmitCompletion, isTrue);
      expect(journey.nextAction.code, PaymentNextActionCode.submitCompletion);
      expect(journey.isEventOrganizer, isTrue);
    });

    test('parses completion request with 48h countdown', () {
      final journey = PaymentJourney.fromJson({
        'event_id': 7,
        'journey_stage': 'completion_requested',
        'completion': {
          'status': 'requested',
          'requested_at': '2026-07-20T12:00:00+00:00',
          'auto_approve_seconds_remaining': 172800,
        },
        'next_action': {'code': 'review_completion'},
        'permissions': {
          'can_approve_completion': true,
          'can_create_counter': true
        },
      });

      expect(journey.journeyStage, PaymentJourneyStage.completionRequested);
      expect(journey.completion.autoApproveSecondsRemaining, 172800);
      expect(
        PaymentJourneyMapper.formatCountdown(172800),
        contains('2d'),
      );
    });

    test('parses counter negotiation and difference', () {
      final journey = PaymentJourney.fromJson({
        'event_id': 9,
        'journey_stage': 'counter_negotiation',
        'completion': {
          'latest_counter': {
            'id': 3,
            'proposed_principal_minor': 90000,
            'original_principal_minor': 100000,
            'message': 'Venue closed early',
            'counter_seconds_remaining': 604800,
          }
        },
        'next_action': {'code': 'review_counter'},
        'permissions': {
          'can_accept_counter': true,
          'can_reject_counter': true,
          'can_revise_counter': true,
        },
      });

      expect(journey.completion.latestCounter!.differenceMinor, -10000);
      expect(journey.permissions.canAcceptCounter, isTrue);
    });

    test('parses final requires action / failed / settled / transfer pending',
        () {
      expect(
        parsePaymentJourneyStage('final_payment_requires_action'),
        PaymentJourneyStage.finalPaymentRequiresAction,
      );
      expect(
        parsePaymentJourneyStage('final_payment_failed'),
        PaymentJourneyStage.finalPaymentFailed,
      );
      expect(
        parsePaymentJourneyStage('final_transfer_pending'),
        PaymentJourneyStage.finalTransferPending,
      );
      expect(
        parsePaymentJourneyStage('financially_settled'),
        PaymentJourneyStage.financiallySettled,
      );

      final settled = PaymentJourney.fromJson({
        'event_id': 1,
        'journey_stage': 'financially_settled',
        'final_payment': {
          'status': 'succeeded',
          'transfer_status': 'transferred',
          'transfer_amount_minor': 72000,
        },
        'next_action': {'code': 'view_settlement'},
      });
      expect(settled.finalPayment.transferStatus, 'transferred');
      expect(
        PaymentJourneyMapper.uiFor(settled).title,
        'Financially settled',
      );
    });

    test('maps next-action codes to labels', () {
      expect(
        PaymentJourneyMapper.labelForNextAction(
          PaymentNextActionCode.resumeFinalPayment,
        ),
        'Complete Payment',
      );
      expect(
        PaymentJourneyMapper.labelForNextAction(
          PaymentNextActionCode.retryFinalPayment,
        ),
        'Retry Payment',
      );
      expect(
        PaymentJourneyMapper.labelForNextAction(
          PaymentNextActionCode.waitForEvent,
        ),
        isNull,
      );
    });

    test('UI states never use placeholder confirmation copy', () {
      for (final stage in PaymentJourneyStage.values) {
        final journey = PaymentJourney(
          eventId: 1,
          journeyStage: stage,
        );
        final ui = PaymentJourneyMapper.uiFor(journey);
        expect(ui.title.toLowerCase(), isNot(contains('confirmed')));
        expect(ui.explanation, isNot(contains('backend has confirmed')));
      }
    });
  });

  group('Payment overview compact field', () {
    test('parses event detail payment_overview', () {
      final overview = PaymentOverview.fromJson({
        'journey_stage': 'event_in_progress',
        'settlement_status': 'down_payment_succeeded',
        'down_payment_percentage': '20.0000',
        'down_payment_paid_minor': 20000,
        'remaining_principal_minor': 80000,
        'next_action_code': 'wait_for_event',
        'has_payment_activity': true,
      });
      expect(overview.journeyStage, PaymentJourneyStage.eventInProgress);
      expect(overview.downPaymentPaidMinor, 20000);
      expect(overview.nextActionCode, PaymentNextActionCode.waitForEvent);
    });
  });

  group('Deep links', () {
    test('parses event payment and wallet deep links', () {
      expect(
        PaymentDeepLink.parse('groovkin://events/55/payment')!.workflow,
        'event_payment',
      );
      expect(
        PaymentDeepLink.parse('groovkin://wallet')!.workflow,
        'wallet',
      );
      expect(
        PaymentDeepLink.parse(
          'groovkin://wallet/transactions/payment:55',
        )!
            .transactionId,
        'payment:55',
      );
    });
  });

  group('Polling helpers', () {
    test('processing stages request bounded polling', () {
      expect(
          journeyStageNeedsPolling(PaymentJourneyStage.finalPaymentProcessing),
          isTrue);
      expect(journeyStageNeedsPolling(PaymentJourneyStage.eventInProgress),
          isFalse);
    });
  });
}
