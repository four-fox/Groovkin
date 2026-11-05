import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/Components/searchRadiusSelector.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';
import 'package:groovkin/discovery/discovery_config.dart';
import 'package:groovkin/discovery/discovery_contract.dart';
import 'package:groovkin/discovery/discovery_repository.dart';
import 'package:groovkin/discovery/discovery_widgets.dart';

void main() {
  group('discovery parsing', () {
    test('parses a successful recommendation response', () {
      final page = parseDiscoveryPage(_recommendedBody());
      expect(page, isNotNull);
      expect(page!.engine, 'v2');
      expect(page.locationStatus, 'available');
      expect(page.location.radiusMiles, 25);
      expect(page.location.radiusApplied, isTrue);
      expect(page.location.allowedRadiiMiles, [10, 25, 50, 100, 300]);
      expect(page.meta.currentPage, 1);
      expect(page.meta.nextPage, isNull);
      expect(page.meta.total, 1);
      expect(page.events, hasLength(1));
      final event = page.events.single;
      expect(event.eventTitle, 'Hip Hop Night');
      expect(event.discovery!.matchType, 'personalized');
      expect(event.discovery!.reasonLabels.map((item) => item.label), [
        'Nearby event',
        'Music match',
      ]);
      expect(event.discovery!.matchedMusic.single.name, 'Hip-Hop');
      expect(event.discovery!.distanceMiles, 8);
      expect(event.discovery!.distanceLabel, '8 mi away');
    });

    test('parses a successful search response and nullable distance', () {
      final page = parseDiscoveryPage(_searchBody());
      final event = page!.events.single;
      expect(page.locationStatus, 'not_applied');
      expect(page.location.radiusApplied, isFalse);
      expect(page.filters!.hashtag, 'hiphop');
      expect(page.filters!.sort, 'relevance');
      expect(event.searchSignal!.reasonLabels.single.label, 'Hashtag match');
      expect(event.searchSignal!.distanceMiles, isNull);
      expect(event.searchSignal!.distanceLabel, isNull);
      expect(event.hashtags!.single.displayName, '#Hip-Hop');
    });

    test('parses empty events, pagination, and location unavailable', () {
      final page = parseDiscoveryPage({
        'status': true,
        'message': 'Recommended events.',
        'data': {
          'engine': 'v2',
          'location_status': 'unavailable',
          'location': {
            'source': 'none',
            'radius_miles': null,
            'radius_applied': false,
            'allowed_radii_miles': [10, 25, 50, 100, 300],
          },
          'meta': {
            'current_page': '2',
            'per_page': '12',
            'total': 0,
            'last_page': 2,
            'next_page': 3,
            'prev_page': null,
          },
          'events': [],
        },
      });
      expect(page!.locationStatus, 'unavailable');
      expect(page.events, isEmpty);
      expect(page.meta.currentPage, 2);
      expect(page.meta.nextPage, 3);
      expect(page.meta.prevPage, isNull);
      expect(
        recommendationEmptyMessage(locationStatus: 'unavailable', locationDenied: false),
        contains('valid location'),
      );
    });

    test('parses missing optional fields and null nested values', () {
      final page = parseDiscoveryPage({
        'status': true,
        'data': {
          'events': [
            {
              'id': '15',
              'event_title': 'Loose Event',
              'hashtags': null,
              'hardwares': 'nope',
              'services': [null, 'bad', {'name': 'Sound'}],
              'start_date_time': 'not-a-date',
              'discovery': {
                'match_type': 'discovery',
                'reasons': null,
                'reason_labels': [null, {'code': 'nearby'}],
                'matched_music': null,
                'distance_miles': null,
              },
              'search': null,
            },
          ],
        },
      });
      final event = page!.events.single;
      expect(event.id, 15);
      expect(event.startDateTime, isNull);
      expect(event.discovery!.isDiscovery, isTrue);
      expect(event.discovery!.reasonLabels, isEmpty);
      expect(event.discovery!.distanceMiles, isNull);
      expect(event.searchSignal, isNull);
      expect(
        DiscoveryCardCopy.fromEvent(event).badge,
        'Explore nearby',
      );
      expect(DiscoveryCardCopy.fromEvent(event).reasons, isNull);
      expect(DiscoveryCardCopy.fromEvent(event).distance, isNull);
    });

    test('does not invent a ranking reason when labels are absent', () {
      final event = EventData.fromJson({
        'id': 4,
        'discovery': {
          'match_type': 'personalized',
          'reasons': ['music_match'],
          'reason_labels': [],
          'matched_music': [
            {'name': 'Hip-Hop'}
          ],
        },
      });
      final copy = DiscoveryCardCopy.fromEvent(event);
      expect(copy.badge, 'For you');
      expect(copy.reasons, isNull);
      expect(copy.reasons, isNot(contains('Because you like')));
    });

    test('keeps older recommendation text when V2 metadata is absent', () {
      final event = EventData.fromJson({
        'id': 5,
        'recommendation': {
          'reasons': ['music_match'],
          'matched_music': [
            {'name': 'Jazz'}
          ],
        },
      });
      expect(
        DiscoveryCardCopy.fromEvent(event).reasons,
        'Because you like Jazz',
      );
    });
  });

  group('discovery routing', () {
    test('recognizes only the disabled error code on HTTP 403', () {
      expect(
        isDiscoveryV2Disabled(403, {
          'status': false,
          'message': 'Event discovery v2 is not enabled.',
          'error_code': 'discovery_v2_disabled',
        }),
        isTrue,
      );
      expect(
        isDiscoveryV2Disabled(403, {
          'status': false,
          'message': 'Forbidden',
          'error_code': 'event_forbidden',
        }),
        isFalse,
      );
      expect(isDiscoveryV2Disabled(401, {'error_code': 'discovery_v2_disabled'}), isFalse);
    });

    test('falls back to the old recommendation route once', () async {
      final transport = _ScriptedTransport({
        DiscoveryConfig.recommendedV2: const DiscoveryHttpResult(
          statusCode: 403,
          data: {
            'status': false,
            'data': null,
            'message': 'Event discovery v2 is not enabled.',
            'error_code': 'discovery_v2_disabled',
          },
        ),
        DiscoveryConfig.recommendedV1: DiscoveryHttpResult(
          statusCode: 200,
          data: _legacyBody(),
        ),
      });
      final repository = DiscoveryRepository(
        transport: transport,
        config: const DiscoveryConfig(enabled: true),
      );
      final first = await repository.recommended(page: 1, radius: 25);
      final second = await repository.recommended(page: 1, radius: 25);
      expect(first.usedLegacy, isTrue);
      expect(first.page!.engine, 'v1');
      expect(first.page!.events.single.eventTitle, 'Legacy Night');
      expect(second.page!.engine, 'v1');
      expect(second.usedLegacy, isFalse);
      expect(
        transport.paths.where((path) => path == DiscoveryConfig.recommendedV2),
        hasLength(1),
      );
      expect(
        transport.paths.where((path) => path == DiscoveryConfig.recommendedV1),
        hasLength(2),
      );
    });

    test('does not fall back on an unrelated forbidden response', () async {
      final transport = _ScriptedTransport({
        DiscoveryConfig.searchV2: const DiscoveryHttpResult(
          statusCode: 403,
          data: {
            'status': false,
            'message': 'Forbidden',
            'error_code': 'event_forbidden',
          },
        ),
      });
      final repository = DiscoveryRepository(
        transport: transport,
        config: const DiscoveryConfig(enabled: true),
      );
      final outcome = await repository.search(
        draft: DiscoverySearchDraft(text: 'reggae'),
        page: 1,
      );
      expect(outcome.usedLegacy, isFalse);
      expect(outcome.problem!.code, 'event_forbidden');
      expect(transport.paths, [DiscoveryConfig.searchV2]);
    });

    test('keeps a failed radius save temporary', () {
      final decision = RadiusPersistDecision.apply(
        previousConfirmed: 25,
        requested: 50,
        saveSucceeded: false,
      );
      expect(decision.requested, 50);
      expect(decision.confirmed, 25);
      expect(decision.pending, isTrue);
      final saved = RadiusPersistDecision.apply(
        previousConfirmed: 25,
        requested: 50,
        saveSucceeded: true,
      );
      expect(saved.confirmed, 50);
      expect(saved.pending, isFalse);
    });

    test('refreshes the matching list key only', () {
      expect(
        shouldRefreshDiscoveryList(
          ['v2-events-recommended'],
          DiscoveryConfig.recommendedInvalidationKey,
        ),
        isTrue,
      );
      expect(
        shouldRefreshDiscoveryList(
          ['v2-events-search'],
          DiscoveryConfig.recommendedInvalidationKey,
        ),
        isFalse,
      );
    });
  });

  group('discovery search query', () {
    test('encodes a hashtag without dropping the hash', () {
      final query = buildSearchQuery(
        DiscoverySearchDraft(text: '#hiphop'),
        page: 1,
      );
      expect(query['q'], '#hiphop');
      final encoded = encodeDiscoveryQuery(query);
      expect(encoded, contains('q=%23hiphop'));
      expect(encoded.contains('#'), isFalse);
    });

    test('keeps a leading zero in a ZIP and rejects a prefix', () {
      expect(isCompleteUsZip('08861'), isTrue);
      expect(isCompleteUsZip('08'), isFalse);
      expect(postalFieldMessage('08'), isNotNull);
      final query = buildSearchQuery(
        DiscoverySearchDraft(postalCode: '08861'),
        page: 1,
      );
      expect(query['postal_code'], '08861');
      expect(query['postal_code'], isA<String>());
      expect(query.containsKey('radius'), isFalse);
      expect(query.containsKey('latitude'), isFalse);
    });

    test('combines filters and repeats activity ids', () {
      final query = buildSearchQuery(
        DiscoverySearchDraft(
          text: 'Dance Battle',
          postalCode: '08861',
          activityIds: [4, 9],
          musicGenreId: 3,
          sort: 'soonest',
          applyRadius: true,
          radius: 25,
        ),
        page: 2,
        latitude: 40.5,
        longitude: -74.4,
      );
      expect(query['q'], 'Dance Battle');
      expect(query['activity_ids'], [4, 9]);
      expect(query['music_genre_id'], 3);
      expect(query['sort'], 'soonest');
      expect(query['radius'], 25);
      expect(query['page'], 2);
      expect(encodeDiscoveryQuery(query), contains('activity_ids%5B%5D=4'));
      expect(encodeDiscoveryQuery(query), contains('activity_ids%5B%5D=9'));
    });

    test('does not send nearest coordinates when the origin is missing', () {
      final query = buildSearchQuery(
        DiscoverySearchDraft(text: 'Jazz', sort: 'nearest', applyRadius: true),
        page: 1,
        latitude: 0,
        longitude: 0,
      );
      expect(query.containsKey('latitude'), isFalse);
      expect(query.containsKey('radius'), isFalse);
    });

    test('does not call search when no filter is meaningful', () async {
      final transport = _ScriptedTransport({});
      final repository = DiscoveryRepository(
        transport: transport,
        config: const DiscoveryConfig(enabled: true),
      );
      final outcome = await repository.search(
        draft: DiscoverySearchDraft(),
        page: 1,
      );
      expect(outcome.problem!.code, 'search_filters_required');
      expect(transport.paths, isEmpty);
    });

    test('pagination stops when next_page is null and drops duplicates', () {
      final page = parseDiscoveryPage(_recommendedBody())!;
      expect(page.meta.nextPage, isNull);
      expect(DiscoveryListCursor.fromPage(page).lastPage, page.meta.currentPage);
      final first = page.events.single;
      final second = EventData.fromJson({'id': 2, 'event_title': 'Other'});
      final merged = mergeDiscoveryEvents([first, second], [first, second]);
      expect(merged.map((event) => event.id), [1, 2]);
    });

    test('cancels stale requests and debounces typing', () {
      final gate = DiscoveryRequestGate();
      final first = gate.begin();
      final second = gate.begin();
      expect(gate.isCurrent(first), isFalse);
      expect(gate.isCurrent(second), isTrue);

      final debouncer = DiscoveryDebouncer(
        delay: const Duration(milliseconds: 50),
      );
      var runs = 0;
      debouncer.schedule(() => runs++);
      debouncer.schedule(() => runs++);
      debouncer.cancel();
      expect(runs, 0);
    });
  });

  group('discovery presentation', () {
    testWidgets('shows music and lifestyle labels from the backend', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DiscoveryMetaLines(
              badge: 'For you',
              reasons: 'Music match · Matches your interests',
              distance: '8 mi away',
            ),
          ),
        ),
      );
      expect(find.text('For you'), findsOneWidget);
      expect(find.text('Music match · Matches your interests'), findsOneWidget);
      expect(find.text('8 mi away'), findsOneWidget);
      expect(find.textContaining('score'), findsNothing);
    });

    testWidgets('shows discovery without a preference claim', (tester) async {
      final copy = DiscoveryCardCopy.fromEvent(EventData.fromJson({
        'discovery': {
          'match_type': 'discovery',
          'reason_labels': [
            {'code': 'nearby', 'label': 'Nearby event'}
          ],
          'distance_miles': 4,
        },
      }));
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DiscoveryMetaLines(
            badge: copy.badge,
            reasons: copy.reasons,
            distance: copy.distance,
          ),
        ),
      ));
      expect(find.text('Explore nearby'), findsOneWidget);
      expect(find.text('Nearby event'), findsOneWidget);
      expect(find.text('4 mi away'), findsOneWidget);
      expect(find.text('For you'), findsNothing);
    });

    testWidgets('radius selection reports the tapped miles', (tester) async {
      int? selected;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SearchRadiusSelector(
            selected: 25,
            onSelected: (value) => selected = value,
          ),
        ),
      ));
      await tester.tap(find.text('50 mi'));
      expect(selected, 50);
    });

    testWidgets('clearing filters removes the active summary', (tester) async {
      var cleared = false;
      final draft = DiscoverySearchDraft(text: '#hiphop', postalCode: '08861');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DiscoverySearchPanel(
            draft: draft,
            activities: const [],
            music: const [],
            radiusOptions: const [10, 25, 50, 100, 300],
            coordinatesAvailable: false,
            postalController: TextEditingController(text: '08861'),
            activityController: TextEditingController(),
            musicController: TextEditingController(),
            activeSummary: const ['#hiphop', 'ZIP 08861'],
            onSort: (_) {},
            onPostal: (_) {},
            onToggleRadius: (_) {},
            onRadius: (_) {},
            onToggleActivity: (_) {},
            onMusic: (_) {},
            onActivityText: (_) {},
            onMusicText: (_) {},
            onClear: () => cleared = true,
          ),
        ),
      ));
      await tester.tap(find.text('Filters'));
      await tester.pumpAndSettle();
      expect(find.text('Nearest needs a location.'), findsOneWidget);
      await tester.tap(find.text('Clear filters'));
      expect(cleared, isTrue);
    });
  });
}

Map<String, dynamic> _recommendedBody() => {
      'status': true,
      'message': 'Recommended events.',
      'data': {
        'engine': 'v2',
        'location_status': 'available',
        'location': {
          'source': 'request',
          'radius_miles': 25,
          'distance_unit': 'miles',
          'postal_code': '08861',
          'radius_applied': true,
          'allowed_radii_miles': [10, 25, 50, 100, 300],
        },
        'meta': {
          'current_page': 1,
          'per_page': 12,
          'total': 1,
          'last_page': 1,
          'next_page': null,
          'prev_page': null,
        },
        'events': [
          {
            'id': 1,
            'event_title': 'Hip Hop Night',
            'distance': 8,
            'hashtags': [],
            'hardwares': [],
            'services': [],
            'discovery': {
              'engine': 'v2',
              'match_type': 'personalized',
              'reasons': ['nearby', 'music_match'],
              'reason_labels': [
                {'code': 'nearby', 'label': 'Nearby event'},
                {'code': 'music_match', 'label': 'Music match'},
              ],
              'matched_music': [
                {'id': 1, 'name': 'Hip-Hop', 'source': 'tag'}
              ],
              'matched_lifestyles': [],
              'matched_hashtags': [],
              'matched_activities': [],
              'distance_miles': 8,
              'distance_unit': 'miles',
            },
          },
        ],
      },
    };

Map<String, dynamic> _searchBody() => {
      'status': true,
      'message': 'Events found.',
      'data': {
        'engine': 'v2',
        'location_status': 'not_applied',
        'location': {
          'source': 'none',
          'radius_miles': null,
          'distance_unit': 'miles',
          'radius_applied': false,
          'allowed_radii_miles': [10, 25, 50, 100, 300],
        },
        'filters': {
          'q': null,
          'hashtag': 'hiphop',
          'hashtags': ['hiphop'],
          'activity': null,
          'activity_ids': [],
          'music': null,
          'music_genre_id': null,
          'postal_code': null,
          'postal_match': null,
          'sort': 'relevance',
          'radius_applied': false,
        },
        'meta': {
          'current_page': 1,
          'per_page': 12,
          'total': 1,
          'last_page': 1,
          'next_page': null,
        },
        'events': [
          {
            'id': 1,
            'event_title': 'Tagged Event',
            'hashtags': [
              {'name': 'Hip-Hop', 'display_name': '#Hip-Hop'}
            ],
            'search': {
              'reasons': ['hashtag_match'],
              'reason_labels': [
                {'code': 'hashtag_match', 'label': 'Hashtag match'}
              ],
              'distance_miles': null,
              'distance_unit': 'miles',
            },
          },
        ],
      },
    };

Map<String, dynamic> _legacyBody() => {
      'status': true,
      'message': 'ok',
      'data': {
        'current_page': 1,
        'last_page': 1,
        'per_page': 12,
        'total': 1,
        'data': [
          {'id': 9, 'event_title': 'Legacy Night'}
        ],
      },
    };

class _ScriptedTransport implements DiscoveryTransport {
  _ScriptedTransport(this.responses);

  final Map<String, DiscoveryHttpResult> responses;
  final List<String> paths = [];

  @override
  Future<DiscoveryHttpResult> get(
    String path,
    Map<String, dynamic> query, {
    bool suppressErrorToast = false,
  }) async {
    paths.add(path);
    return responses[path] ??
        const DiscoveryHttpResult(statusCode: 500, data: {'status': false});
  }
}
