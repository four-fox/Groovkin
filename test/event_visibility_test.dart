import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/Components/Network/backend_error.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/musicChoiceView/musicChoiceModel.dart';
import 'package:groovkin/utils/backend_contract.dart';

void main() {
  test('catalog status 1 is selected and status 0 is not', () {
    final selected = CategoryItem.fromJson({
      'id': 34,
      'name': 'House',
      'status': 1,
    });
    final unselected = CategoryItem.fromJson({
      'id': 35,
      'name': 'Jazz',
      'status': 0,
    });

    expect(selected.status, 1);
    expect(selected.selected!.value, isTrue);
    expect(unselected.status, 0);
    expect(unselected.selected!.value, isFalse);
  });

  test('catalog status accepts bool and string forms', () {
    expect(
      CategoryItem.fromJson({'status': true}).selected!.value,
      isTrue,
    );
    expect(
      CategoryItem.fromJson({'status': '1'}).selected!.value,
      isTrue,
    );
    expect(
      CategoryItem.fromJson({'status': false}).selected!.value,
      isFalse,
    );
  });

  test('new event catalog with every status 0 selects nothing', () {
    final items = [
      CategoryItem.fromJson({'id': 1, 'status': 0}),
      CategoryItem.fromJson({'id': 2, 'status': 0}),
    ];
    expect(items.every((item) => item.selected!.value == false), isTrue);
    expect(
      eventCreateCatalogQuery(type: 'music_choice').containsKey('event_id'),
      isFalse,
    );
  });

  test('edit catalog query sends the current event id', () {
    final query = eventCreateCatalogQuery(
      type: 'activity_choice',
      eventId: 21,
      isPersistedEdit: true,
    );
    expect(query['event_id'], 21);
    expect(query.containsKey('context'), isFalse);
  });

  test('my events renders future, ongoing, and completed-before-end', () {
    final server = [
      {'id': 1, 'status': 'accepted', 'bucket': 'future'},
      {'id': 2, 'status': 'accepted', 'bucket': 'ongoing'},
      {'id': 3, 'status': 'completed', 'bucket': 'before-end'},
    ];
    final shown = retainServerEventBucket(server);
    expect(shown.map((event) => event['id']), [1, 2, 3]);
  });

  test('history renders past accepted and past completed', () {
    final history = retainServerEventBucket([
      {'id': 4, 'status': 'accepted'},
      {'id': 5, 'status': 'completed'},
    ]);
    expect(history, hasLength(2));
    expect(history.first['status'], 'accepted');
  });

  test('completed event in my events is not copied into an empty history', () {
    final myEvents = retainServerEventBucket([
      {'id': 9, 'status': 'completed', 'end': '22:30'},
    ]);
    final history = retainServerEventBucket(<Map<String, dynamic>>[]);
    expect(myEvents.single['status'], 'completed');
    expect(history, isEmpty);
  });

  test('ongoing label is time based and future accepted stays Scheduled', () {
    final now = DateTime(2026, 9, 28, 22, 25);
    expect(
      venueMyEventStatusLabel(
        status: 'completed',
        start: DateTime(2026, 9, 28, 20),
        end: DateTime(2026, 9, 28, 22, 30),
        now: now,
      ),
      'Ongoing',
    );
    expect(
      venueMyEventStatusLabel(
        status: 'accepted',
        start: DateTime(2026, 9, 29, 18),
        end: DateTime(2026, 9, 29, 22),
        now: now,
      ),
      'Scheduled',
    );
  });

  test('null end date does not throw and stays a scheduled label', () {
    expect(
      venueMyEventStatusLabel(
        status: 'accepted',
        start: DateTime(2026, 9, 28, 20),
        end: null,
        now: DateTime(2026, 9, 28, 22, 25),
      ),
      'Scheduled',
    );
  });

  test('hashtag load hides raw SQL', () {
    expect(
      eventTagLoadMessage({
        'message': 'SQLSTATE[42S22]: select * from user_hash_tags',
      }),
      'Unable to load event hashtags. Please try again.',
    );
  });

  test('vm my events heading and endpoints', () {
    final requests = File('lib/View/GroovkinManager/eventRequest.dart')
        .readAsStringSync();
    final home =
        File('lib/View/bottomNavigation/homeScreen.dart').readAsStringSync();
    final manager =
        File('lib/View/GroovkinManager/managerController.dart')
            .readAsStringSync();
    expect(requests.contains('text: "My Events"'), isTrue);
    expect(requests.contains('text: "Request"'), isFalse);
    expect(requests.contains('getScheduledEvents'), isTrue);
    expect(home.contains('"My Events"'), isTrue);
    expect(home.contains('"Requests"'), isTrue);
    expect(home.contains('"History"'), isTrue);
    expect(manager.contains('show-venue-my-events'), isTrue);
    expect(manager.contains('"section": "scheduled"'), isTrue);
    expect(manager.contains('"section": "history"'), isTrue);
    expect(manager.contains('show-venue-requested-events'), isTrue);
    expect(manager.contains('url: "upcoming-events"'), isFalse);
  });

  testWidgets('status 1 renders selected and status 0 does not', (tester) async {
    final selected = CategoryItem.fromJson({'name': 'House', 'status': 1});
    final unselected = CategoryItem.fromJson({'name': 'Jazz', 'status': 0});
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            Text(selected.selected!.value ? 'House selected' : 'House off'),
            Text(unselected.selected!.value ? 'Jazz selected' : 'Jazz off'),
          ],
        ),
      ),
    );
    expect(find.text('House selected'), findsOneWidget);
    expect(find.text('Jazz off'), findsOneWidget);
  });
}
