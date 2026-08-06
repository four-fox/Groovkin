import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/payment/journey/completion_review_widgets.dart';
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

    test('parses eo_proceeds_transferred_minor', () {
      final journey = PaymentJourney.fromJson({
        'event_id': 1,
        'journey_stage': 'financially_settled',
        'settlement_status': 'financially_settled',
        'totals': {
          'eo_proceeds_transferred_minor': 72000,
        },
        'final_payment': {
          'status': 'succeeded',
          'transfer_status': 'transferred',
        },
      });
      expect(journey.totals.eoProceedsTransferredMinor, 72000);
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

  group('Final payment settlement UI states', () {
    test('final payment succeeded with transfer pending is not settled', () {
      final journey = PaymentJourney.fromJson({
        'event_id': 1,
        'role': 'venue_manager',
        'journey_stage': 'final_transfer_pending',
        'settlement_status': 'final_payment_succeeded',
        'final_payment': {
          'status': 'succeeded',
          'transfer_status': 'pending',
          'payment_id': 99,
        },
        'next_action': {'code': 'none'},
      });

      expect(journey.finalPayment.isSucceeded, isTrue);
      expect(isFinanciallySettled(journey.settlementStatus), isFalse);

      final ui = PaymentJourneyMapper.uiFor(journey);
      expect(ui.title, 'Payment successful');
      expect(ui.explanation, contains('Finalizing payout'));
      expect(ui.title, isNot(contains('Payment complete')));
      expect(ui.title, isNot(contains('Financially settled')));
      expect(
          ui.explanation.toLowerCase(), isNot(contains('financially settled')));
    });

    test(
        'final_transfer_pending and manual_review are self-resolving, not errors',
        () {
      // final_transfer_pending: no error, no retry action, waiting copy only.
      final transferPending = PaymentJourney.fromJson({
        'event_id': 2,
        'journey_stage': 'final_transfer_pending',
        'settlement_status': 'final_payment_succeeded',
        'final_payment': {
          'status': 'succeeded',
          'transfer_status': 'pending',
        },
        'next_action': {'code': 'none'},
      });
      final transferPendingUi = PaymentJourneyMapper.uiFor(transferPending);
      expect(transferPendingUi.title, 'Payment successful');
      expect(transferPendingUi.primaryActionLabel, isNull);
      expect(transferPendingUi.secondaryActionLabel, isNull);
      expect(transferPendingUi.title.toLowerCase(), isNot(contains('fail')));
      expect(transferPendingUi.title.toLowerCase(), isNot(contains('review')));
      expect(journeyStageNeedsPolling(transferPending.journeyStage), isTrue);
      expect(journeyStageStopsPolling(transferPending.journeyStage), isFalse);

      // manual_review: backend auto-reconciles the transfer; never a
      // user-actionable error. Must not show "needs review"/"contact support".
      final manualReview = PaymentJourney.fromJson({
        'event_id': 3,
        'journey_stage': 'manual_review',
        'settlement_status': 'manual_review',
        'final_payment': {
          'status': 'succeeded',
          'transfer_status': 'failed',
        },
        'next_action': {'code': 'view_support_review'},
      });
      final manualReviewUi = PaymentJourneyMapper.uiFor(manualReview);
      expect(manualReviewUi.title, 'Payment completed');
      expect(manualReviewUi.explanation, contains('payout is being finalized'));
      expect(manualReviewUi.primaryActionLabel, isNull);
      expect(manualReviewUi.secondaryActionLabel, isNull);
      expect(manualReviewUi.title.toLowerCase(), isNot(contains('fail')));
      expect(manualReviewUi.title.toLowerCase(), isNot(contains('review')));
      expect(
        manualReviewUi.explanation.toLowerCase(),
        isNot(contains('support')),
      );
      expect(journeyStageNeedsPolling(manualReview.journeyStage), isTrue);
      expect(journeyStageStopsPolling(manualReview.journeyStage), isFalse);

      // A transient transfer_status == failed mid-flight before the backend
      // flips journey_stage to manual_review must still read as waiting, not
      // a hard failure requiring user action.
      final byTransfer = PaymentJourney.fromJson({
        'event_id': 4,
        'journey_stage': 'final_transfer_pending',
        'settlement_status': 'final_payment_succeeded',
        'final_payment': {
          'status': 'succeeded',
          'transfer_status': 'failed',
        },
        'next_action': {'code': 'none'},
      });
      final byTransferUi = PaymentJourneyMapper.uiFor(byTransfer);
      expect(byTransferUi.primaryActionLabel, isNull);
      expect(byTransferUi.title.toLowerCase(), isNot(contains('fail')));
    });

    test('transfer succeeded shows Transferred to Stripe account', () {
      final journey = PaymentJourney.fromJson({
        'event_id': 4,
        'journey_stage': 'final_transfer_pending',
        'settlement_status': 'final_transfer_succeeded',
        'final_payment': {
          'status': 'succeeded',
          'transfer_status': 'transferred',
        },
        'totals': {'eo_proceeds_transferred_minor': 72000},
        'next_action': {'code': 'none'},
      });

      final ui = PaymentJourneyMapper.uiFor(journey);
      expect(ui.title, 'Transferred to Stripe account');
      expect(ui.explanation, contains('connected Stripe account'));
      expect(ui.explanation.toLowerCase(), isNot(contains('paid to bank')));
      expect(journey.totals.eoProceedsTransferredMinor, 72000);
    });

    test('financially settled only from settlement_status', () {
      final settled = PaymentJourney.fromJson({
        'event_id': 5,
        'journey_stage': 'financially_settled',
        'settlement_status': 'financially_settled',
        'final_payment': {
          'status': 'succeeded',
          'transfer_status': 'transferred',
        },
        'next_action': {'code': 'view_settlement'},
      });
      final settledUi = PaymentJourneyMapper.uiFor(settled);
      expect(settledUi.title, 'Payment complete');
      expect(
        settledUi.explanation,
        'The event payment has been financially settled.',
      );

      // Same stage without settlement_status must NOT claim Payment complete.
      final stageOnly = PaymentJourney.fromJson({
        'event_id': 6,
        'journey_stage': 'financially_settled',
        'final_payment': {
          'status': 'succeeded',
          'transfer_status': 'transferred',
        },
      });
      expect(
        PaymentJourneyMapper.uiFor(stageOnly).title,
        isNot('Payment complete'),
      );

      // final_payment.status alone must never imply settled.
      final paymentOnly = PaymentJourney.fromJson({
        'event_id': 7,
        'journey_stage': 'final_transfer_pending',
        'settlement_status': 'final_payment_succeeded',
        'final_payment': {'status': 'succeeded'},
      });
      expect(paymentOnly.finalPayment.isSucceeded, isTrue);
      expect(isFinanciallySettled(paymentOnly.settlementStatus), isFalse);
      expect(
        PaymentJourneyMapper.uiFor(paymentOnly).title,
        'Payment successful',
      );
    });

    test('no Paid to bank copy exists in settlement UI states', () {
      final samples = [
        PaymentJourney.fromJson({
          'event_id': 1,
          'journey_stage': 'final_transfer_pending',
          'settlement_status': 'final_payment_succeeded',
          'final_payment': {
            'status': 'succeeded',
            'transfer_status': 'pending'
          },
        }),
        PaymentJourney.fromJson({
          'event_id': 2,
          'journey_stage': 'manual_review',
          'settlement_status': 'manual_review',
          'final_payment': {'status': 'succeeded', 'transfer_status': 'failed'},
        }),
        PaymentJourney.fromJson({
          'event_id': 3,
          'journey_stage': 'completion_approved',
          'settlement_status': 'final_transfer_succeeded',
          'final_payment': {
            'status': 'succeeded',
            'transfer_status': 'transferred',
          },
        }),
        PaymentJourney.fromJson({
          'event_id': 4,
          'journey_stage': 'financially_settled',
          'settlement_status': 'financially_settled',
          'final_payment': {
            'status': 'succeeded',
            'transfer_status': 'transferred',
          },
        }),
      ];

      for (final journey in samples) {
        final ui = PaymentJourneyMapper.uiFor(journey);
        expect(ui.title.toLowerCase(), isNot(contains('paid to bank')));
        expect(ui.explanation.toLowerCase(), isNot(contains('paid to bank')));
      }
    });

    test('VM requires-action flow', () {
      final journey = PaymentJourney.fromJson({
        'event_id': 8,
        'role': 'venue_manager',
        'journey_stage': 'final_payment_requires_action',
        'settlement_status': 'final_payment_requires_action',
        'final_payment': {
          'status': 'requires_action',
          'payment_id': 44,
        },
        'next_action': {
          'code': 'resume_final_payment',
          'payment_id': 44,
        },
        'permissions': {'can_resume_payment': true},
      });

      final ui = PaymentJourneyMapper.uiFor(journey);
      expect(ui.title, 'Payment authentication required');
      expect(
        ui.explanation,
        contains('verification to complete the remaining event payment'),
      );
      expect(ui.primaryActionLabel, 'Complete Payment');
      expect(
        journey.nextAction.code,
        PaymentNextActionCode.resumeFinalPayment,
      );
    });

    test('failed payment retry', () {
      final journey = PaymentJourney.fromJson({
        'event_id': 9,
        'role': 'venue_manager',
        'journey_stage': 'final_payment_failed',
        'settlement_status': 'final_payment_failed',
        'final_payment': {
          'status': 'failed',
          'payment_id': 45,
        },
        'next_action': {
          'code': 'retry_final_payment',
          'payment_id': 45,
        },
        'permissions': {'can_retry_payment': true},
      });

      final ui = PaymentJourneyMapper.uiFor(journey);
      expect(ui.title, 'Final payment failed');
      expect(ui.explanation, contains('Update your payment method'));
      expect(ui.primaryActionLabel, 'Retry Payment');
      expect(ui.secondaryActionLabel, 'Update Payment Method');
    });

    test('final payment processing copy', () {
      final journey = PaymentJourney.fromJson({
        'event_id': 10,
        'journey_stage': 'final_payment_processing',
        'final_payment': {'status': 'processing'},
      });
      final ui = PaymentJourneyMapper.uiFor(journey);
      expect(ui.title, 'Final payment processing');
      expect(ui.explanation,
          contains('remaining event balance is being processed'));
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
    test(
        'final payment processing, transfer pending, and manual review all poll',
        () {
      expect(
        journeyStageNeedsPolling(PaymentJourneyStage.finalPaymentProcessing),
        isTrue,
      );
      expect(
        journeyStageNeedsPolling(PaymentJourneyStage.finalTransferPending),
        isTrue,
      );
      // manual_review self-resolves via backend transfer reconciliation and
      // must keep refreshing until financially_settled — it is NOT terminal.
      expect(
        journeyStageNeedsPolling(PaymentJourneyStage.manualReview),
        isTrue,
      );
      expect(
        journeyStageNeedsPolling(PaymentJourneyStage.eventInProgress),
        isFalse,
      );
      expect(
        journeyStageNeedsPolling(PaymentJourneyStage.completionRequested),
        isFalse,
      );
      expect(
        journeyStageNeedsPolling(PaymentJourneyStage.downPaymentProcessing),
        isFalse,
      );
    });

    test('polling stops correctly for terminal / interactive stages', () {
      expect(
        journeyStageStopsPolling(PaymentJourneyStage.financiallySettled),
        isTrue,
      );
      expect(
        journeyStageStopsPolling(PaymentJourneyStage.finalPaymentFailed),
        isTrue,
      );
      expect(
        journeyStageStopsPolling(
          PaymentJourneyStage.finalPaymentRequiresAction,
        ),
        isTrue,
      );
      expect(
        journeyStageStopsPolling(PaymentJourneyStage.cancelled),
        isTrue,
      );
      expect(
        journeyStageStopsPolling(PaymentJourneyStage.disputed),
        isTrue,
      );
      expect(
        journeyStageStopsPolling(PaymentJourneyStage.finalPaymentProcessing),
        isFalse,
      );
      expect(
        journeyStageStopsPolling(PaymentJourneyStage.finalTransferPending),
        isFalse,
      );
      // manual_review does not stop polling — it auto-resolves in the
      // background and the app must keep refreshing until settled.
      expect(
        journeyStageStopsPolling(PaymentJourneyStage.manualReview),
        isFalse,
      );

      // Transition: once settled, needs-polling is false and stops is true.
      expect(
        journeyStageNeedsPolling(PaymentJourneyStage.financiallySettled),
        isFalse,
      );
    });

    test('wallet refresh is gated on settlement_status financially_settled',
        () {
      expect(isFinanciallySettled('financially_settled'), isTrue);
      expect(isFinanciallySettled('final_payment_succeeded'), isFalse);
      expect(isFinanciallySettled('final_transfer_pending'), isFalse);
      expect(isFinanciallySettled('manual_review'), isFalse);
      expect(isFinanciallySettled(null), isFalse);
    });
  });

  group('Friendly status labels', () {
    test('never surface raw technical status codes to users', () {
      expect(
        PaymentJourneyMapper.friendlySettlementStatusLabel('manual_review'),
        isNot('manual_review'),
      );
      expect(
        PaymentJourneyMapper.friendlySettlementStatusLabel(
          'final_transfer_pending',
        ),
        isNot('final_transfer_pending'),
      );
      expect(
        PaymentJourneyMapper.friendlySettlementStatusLabel('manual_review')
            .toLowerCase(),
        isNot(contains('manual_review')),
      );
      expect(
        PaymentJourneyMapper.friendlyTransferStatusLabel('failed')
            .toLowerCase(),
        isNot(contains('failed')),
      );
      expect(
        PaymentJourneyMapper.friendlyTransferStatusLabel('transferred'),
        'Transferred',
      );
      expect(
        PaymentJourneyMapper.friendlySettlementStatusLabel(
          'financially_settled',
        ),
        'Financially settled',
      );
    });
  });

  group('Completion review (approve vs counter) parsing', () {
    test('parses spec-shaped completion_requested journey for VM', () {
      final journey = PaymentJourney.fromJson({
        'event_id': 2,
        'role': 'venue_manager',
        'currency': 'usd',
        'journey_stage': 'completion_requested',
        'settlement_status': 'final_payment_pending',
        'agreement': {
          'event_principal_minor': 12000,
          'remaining_principal_minor': 9600,
        },
        'completion': {
          'status': 'requested',
          'completion_requested_at': '2026-08-05T22:40:00Z',
          'auto_approve_at': '2026-08-07T22:40:00Z',
          'seconds_remaining': 172800,
          'latest_counter': {
            'id': 5,
            'status': 'open',
            'proposed_principal_minor': 9500,
            'message': 'Agreed adjustment',
            'negotiation_expires_at': '2026-08-12T22:40:00Z',
            'seconds_remaining': 604800,
          },
        },
        'final_payment': {
          'payment_id': null,
          'status': 'not_started',
          'remaining_principal_minor': 9600,
          'estimated_total_charge_minor': 9950,
          'requires_action': false,
        },
        'permissions': {
          'can_submit_completion': false,
          'can_approve_completion': true,
          'can_create_counter': true,
          'can_accept_counter': false,
          'can_revise_counter': false,
          'can_reject_counter': false,
          'can_resume_payment': false,
          'can_retry_payment': false,
        },
        'next_action': {
          'code': 'review_completion',
          'title': 'Review completion',
        },
      });

      // Agreement money is backfilled into totals.
      expect(journey.totals.eventPrincipalMinor, 12000);
      expect(journey.totals.remainingPrincipalMinor, 9600);

      // completion.seconds_remaining maps to the auto-approve countdown.
      expect(journey.completion.autoApproveSecondsRemaining, 172800);
      expect(journey.completion.requestedAt, isNotNull);

      // latest_counter with spec field names.
      final counter = journey.completion.latestCounter!;
      expect(counter.id, 5);
      expect(counter.isOpen, isTrue);
      expect(counter.proposedPrincipalMinor, 9500);
      expect(counter.counterSecondsRemaining, 604800);
      expect(counter.negotiationExpiresAt, isNotNull);

      // final_payment spec fields.
      expect(journey.finalPayment.remainingPrincipalMinor, 9600);
      expect(journey.finalPayment.estimatedTotalChargeMinor, 9950);
      expect(journey.finalPayment.requiresAction, isFalse);

      // Permission-driven UI flags.
      expect(journey.permissions.canApproveCompletion, isTrue);
      expect(journey.permissions.canCreateCounter, isTrue);
      expect(journey.permissions.canAcceptCounter, isFalse);
    });

    test('counter isOpen covers open and revised only', () {
      expect(JourneyCounter.fromJson({'status': 'open'}).isOpen, isTrue);
      expect(JourneyCounter.fromJson({'status': 'revised'}).isOpen, isTrue);
      expect(JourneyCounter.fromJson({'status': 'accepted'}).isOpen, isFalse);
      expect(JourneyCounter.fromJson({'status': 'rejected'}).isOpen, isFalse);
      expect(JourneyCounter.fromJson({'status': 'expired'}).isOpen, isFalse);
    });

    test('final payment requires_action flag and status helpers', () {
      final requiresAction = JourneyPaymentSlice.fromJson({
        'status': 'requires_action',
        'requires_action': true,
      });
      expect(requiresAction.isRequiresAction, isTrue);
      expect(requiresAction.isFailed, isFalse);

      final failed = JourneyPaymentSlice.fromJson({'status': 'failed'});
      expect(failed.isFailed, isTrue);

      final processing = JourneyPaymentSlice.fromJson({'status': 'processing'});
      expect(processing.isProcessing, isTrue);
    });
  });

  group('Dollar input to integer minor units', () {
    test('converts valid dollar strings to minor units', () {
      expect(parseDollarsToMinor('95'), 9500);
      expect(parseDollarsToMinor('95.50'), 9550);
      expect(parseDollarsToMinor('0'), 0);
      expect(parseDollarsToMinor(r'$1,200'), 120000);
      expect(parseDollarsToMinor(' 200.00 '), 20000);
    });

    test('rejects invalid, negative, and sub-cent input', () {
      expect(parseDollarsToMinor(''), isNull);
      expect(parseDollarsToMinor('abc'), isNull);
      expect(parseDollarsToMinor('-5'), isNull);
      expect(parseDollarsToMinor('1.999'), isNull);
    });
  });
}
