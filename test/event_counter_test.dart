import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/pendingEventFlow/eventActionBar.dart';
import 'package:groovkin/model/event_counter_model.dart';
import 'package:groovkin/utils/money.dart';

void main() {
  group('dollarsToMinorUnits', () {
    test('converts display dollars to integer minor units', () {
      expect(dollarsToMinorUnits('2700.00'), 270000);
      expect(dollarsToMinorUnits('2700'), 270000);
      expect(dollarsToMinorUnits(r'$2,700.00'), 270000);
      expect(dollarsToMinorUnits('2.7'), 270);
      expect(dollarsToMinorUnits('-10'), isNull);
      expect(dollarsToMinorUnits('abc'), isNull);
    });
  });

  group('EventCounterEndpoints', () {
    test('uses structured counter routes', () {
      expect(EventCounterEndpoints.list(44), 'events/44/counters');
      expect(EventCounterEndpoints.create(44), 'events/44/counters');
      expect(EventCounterEndpoints.accept(9), 'counters/9/accept');
      expect(EventCounterEndpoints.reject(9), 'counters/9/reject');
      expect(EventCounterEndpoints.counterAgain(9), 'counters/9/counter');
      expect(
        EventCounterEndpoints.approveCompletion(44),
        'events/44/completion/approve',
      );
    });
  });

  group('EventCounterState parsing', () {
    test('parses nested counter object, flags, history, and money', () {
      final state = EventCounterState.fromJson({
        'counter': {
          'can_counter': 1,
          'can_accept_counter': 1,
          'can_reject_counter': 0,
          'can_counter_again': 1,
          'can_edit_event': 1,
          'can_edit_event_cost': 0,
          'can_accept_event': 0,
          'can_decline_event': 0,
          'can_mark_complete': 0,
          'can_approve_final_payment': 0,
          'counter_stage': 'pre_event',
          'current_agreed_amount_minor': 300000,
          'active_counter_amount_minor': 270000,
          'paid_amount_minor': 75000,
          'remaining_amount_minor': 225000,
          'settlement_adjustment_required': 0,
          'currency': 'USD',
          'active_counter': {
            'id': 12,
            'sender_role': 'venue_manager',
            'proposed_principal_minor': 270000,
            'message': 'Can you do 2700?',
            'stage': 'pre_event',
            'status': 'active',
          },
          'counter_history': [
            {
              'id': 10,
              'sender_role': 'venue_manager',
              'proposed_principal_minor': 270000,
              'status': 'superseded',
            },
            {
              'id': 11,
              'sender_role': 'event_owner',
              'proposed_principal_minor': 285000,
              'status': 'superseded',
            },
          ],
        },
      });

      expect(state.canCounter, isTrue);
      expect(state.canAcceptCounter, isTrue);
      expect(state.canRejectCounter, isFalse);
      expect(state.canCounterAgain, isTrue);
      expect(state.canEditEvent, isTrue);
      expect(state.canEditEventCost, isFalse);
      expect(state.canAcceptEvent, isFalse);
      expect(state.currentAgreedAmountMinor, 300000);
      expect(state.activeCounterAmountMinor, 270000);
      expect(state.paidAmountMinor, 75000);
      expect(state.remainingAmountMinor, 225000);
      expect(state.settlementAdjustmentRequired, isFalse);
      expect(state.hasActiveCounter, isTrue);
      expect(state.activeCounter?.id, 12);
      expect(state.history, hasLength(2));
      expect(state.visibleRemainingMinor, 225000);
    });

    test('null counter payload is safe and clamps negative remaining', () {
      final empty = EventCounterState.fromJson(null);
      expect(empty.canCounter, isFalse);
      expect(empty.hasActiveCounter, isFalse);
      expect(empty.history, isEmpty);

      final adjusted = EventCounterState.fromJson({
        'remaining_amount_minor': -100,
        'settlement_adjustment_required': 1,
      });
      expect(adjusted.settlementAdjustmentRequired, isTrue);
      expect(adjusted.visibleRemainingMinor, 0);
    });
  });

  group('EventActionFlags', () {
    test('hides Mark Complete before event end even if server flag is true', () {
      const counter = EventCounterState(canMarkComplete: true);
      final beforeEnd = EventActionFlags.fromCounter(
        counter: counter,
        eventEnd: DateTime(2099, 1, 1),
        now: DateTime(2026, 1, 1),
      );
      final afterEnd = EventActionFlags.fromCounter(
        counter: counter,
        eventEnd: DateTime(2020, 1, 1),
        now: DateTime(2026, 1, 1),
      );
      expect(beforeEnd.markComplete, isFalse);
      expect(afterEnd.markComplete, isTrue);
    });

    test('does not show Accept Event while an active counter exists', () {
      final flags = EventActionFlags.fromCounter(
        counter: EventCounterState(
          canAcceptEvent: true,
          activeCounterAmountMinor: 270000,
          activeCounter: EventCounterOffer(id: 1),
        ),
      );
      expect(flags.acceptEvent, isFalse);
    });
  });

  group('EventActionBar rendering', () {
    testWidgets('renders each permitted action exactly once', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: EventActionBar(
              flags: const EventActionFlags(
                acceptEvent: true,
                declineEvent: true,
                counter: true,
                acceptCounter: true,
                rejectCounter: true,
                counterAgain: true,
                editEvent: true,
                markComplete: true,
                approveFinalPayment: true,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(kAcceptEventKey), findsOneWidget);
      expect(find.byKey(kDeclineEventKey), findsOneWidget);
      expect(find.byKey(kCounterKey), findsOneWidget);
      expect(find.byKey(kAcceptCounterKey), findsOneWidget);
      expect(find.byKey(kRejectCounterKey), findsOneWidget);
      expect(find.byKey(kCounterAgainKey), findsOneWidget);
      expect(find.byKey(kEditEventKey), findsOneWidget);
      expect(find.byKey(kMarkCompleteKey), findsOneWidget);
      expect(find.byKey(kApproveFinalPaymentKey), findsOneWidget);
      expect(find.text('Accept Event'), findsOneWidget);
      expect(find.text('Decline Event'), findsOneWidget);
      expect(find.text('Counter'), findsOneWidget);
      expect(find.text('Accept Counter'), findsOneWidget);
      expect(find.text('Reject Counter'), findsOneWidget);
      expect(find.text('Counter Again'), findsOneWidget);
      expect(find.text('Edit Event'), findsOneWidget);
      expect(find.text('Mark Complete'), findsOneWidget);
      expect(find.text('Approve Final Payment'), findsOneWidget);
    });

    testWidgets('renders nothing when every flag is false', (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: EventActionBar(
              flags: EventActionFlags(
                acceptEvent: false,
                declineEvent: false,
                counter: false,
                acceptCounter: false,
                rejectCounter: false,
                counterAgain: false,
                editEvent: false,
                markComplete: false,
                approveFinalPayment: false,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(kAcceptEventKey), findsNothing);
      expect(find.byKey(kDeclineEventKey), findsNothing);
      expect(find.byKey(kCounterKey), findsNothing);
      expect(find.byKey(kAcceptCounterKey), findsNothing);
      expect(find.byKey(kRejectCounterKey), findsNothing);
      expect(find.byKey(kCounterAgainKey), findsNothing);
      expect(find.byKey(kEditEventKey), findsNothing);
      expect(find.byKey(kMarkCompleteKey), findsNothing);
      expect(find.byKey(kApproveFinalPaymentKey), findsNothing);
    });
  });
}
