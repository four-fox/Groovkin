import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/Components/Network/backend_error.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/venueDiscoveryModel.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';

void main() {
  group('recommendation metadata', () {
    test('parses known reasons and matched values', () {
      final event = EventData.fromJson({
        'id': 10,
        'event_title': 'Reggae Outdoors',
        'recommendation': {
          'reasons': [
            'music_match',
            'activity_match',
            'hashtag_match',
            'future_reason',
          ],
          'matched_music': [
            {'id': 12, 'name': 'Reggae'}
          ],
          'matched_activities': [
            {'id': 4, 'name': 'Outdoor'}
          ],
          'matched_hashtags': [
            {'name': 'LiveMusic', 'display_name': '#LiveMusic'}
          ],
        },
      });

      expect(event.recommendation, isNotNull);
      expect(
        event.recommendation!.reasons,
        ['music_match', 'activity_match', 'hashtag_match'],
      );
      expect(event.recommendation!.matchedMusic.single.name, 'Reggae');
      expect(event.recommendation!.matchedActivities.single.name, 'Outdoor');
      expect(
        event.recommendation!.matchedHashtags.single.displayName,
        '#LiveMusic',
      );
      expect(event.recommendation!.displayReason, 'Because you like Reggae');
    });

    test('accepts a non-followed event and missing recommendation metadata',
        () {
      final recommended = EventData.fromJson({
        'id': 11,
        'user': {'id': 99, 'following': null},
        'recommendation': {
          'reasons': ['music_match'],
          'matched_music': [
            {'name': 'Jazz'}
          ],
        },
      });
      final ordinary = EventData.fromJson({'id': 12});

      expect(recommended.id, 11);
      expect(
          recommended.recommendation!.displayReason, 'Because you like Jazz');
      expect(ordinary.recommendation, isNull);
    });

    test('parses optional numeric distance in miles', () {
      expect(EventData.fromJson({'distance': 5}).distance, 5.0);
      expect(EventData.fromJson({'distance': '7.25'}).distance, 7.25);
      expect(EventData.fromJson({}).distance, isNull);
    });
  });

  group('compact venue discovery', () {
    test('parses nullable compact list fields and paginator', () {
      final page = VenueDiscoveryPage.fromEnvelope({
        'status': true,
        'data': {
          'current_page': 1,
          'last_page': 3,
          'per_page': 12,
          'total': 25,
          'data': [
            {
              'id': 1,
              'venue_name': 'Groove Garden',
              'address_label': 'Brooklyn, NY',
              'latitude': 40.785,
              'longitude': '-74.006',
              'max_occupancy': '200',
              'max_seating': null,
              'distance': {'value': 5, 'unit': 'miles'},
            },
            {'id': 2, 'address_label': null},
          ],
        },
      });

      expect(page.currentPage, 1);
      expect(page.lastPage, 3);
      expect(page.venues, hasLength(2));
      expect(page.venues.first.maxOccupancy, '200');
      expect(page.venues.first.maxSeating, isNull);
      expect(page.venues.first.distance!.value, 5.0);
      expect(page.venues.last.addressLabel, isEmpty);
    });

    test('parses marker cap metadata and skips no data assumptions', () {
      final result = VenueMarkerResult.fromEnvelope({
        'data': {
          'venues': [
            {'id': 4, 'latitude': null, 'longitude': null}
          ],
          'count': 1,
          'limit': 200,
          'truncated': true,
          'total_eligible': 240,
          'radius': {'value': 50, 'unit': 'miles'},
          'origin': {'latitude': 40, 'longitude': -74},
        },
      });

      expect(result.truncated, isTrue);
      expect(result.totalEligible, 240);
      expect(result.radius!.value, 50);
      expect(result.origin!.longitude, -74);
    });
  });

  group('backend error envelopes', () {
    test('prefers field error then data then message', () {
      expect(
        backendErrorMessage({
          'errors': {'venue_id': 'Venue unavailable'},
          'data': 'Fallback data',
          'message': 'Validation Failed',
        }, field: 'venue_id'),
        'Venue unavailable',
      );
      expect(
        backendErrorMessage({'data': 'Specific data', 'message': 'Generic'}),
        'Specific data',
      );
      expect(backendErrorMessage({'message': 'Generic'}), 'Generic');
    });
  });
}
