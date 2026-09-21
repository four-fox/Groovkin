import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userEventDetailsModel.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/hashtagCollectionModel.dart';
import 'package:groovkin/View/profile/profileModel.dart';
import 'package:groovkin/utils/json_parsers.dart';
import 'package:groovkin/utils/search_radius.dart';

void main() {
  group('search radius', () {
    test('uses backend allowed radii and falls back', () {
      expect(
        parseAllowedSearchRadii([10, 25, 50, 100, 300]),
        [10, 25, 50, 100, 300],
      );
      expect(parseAllowedSearchRadii(null), kDefaultSearchRadiiMiles);
      expect(sanitizeSearchRadius(300), 300);
      expect(sanitizeSearchRadius(12), 25);
    });
  });

  group('profile completion payload', () {
    test('parses completion flags and zip/state/radius', () {
      final profile = ProfileModel.fromJson({
        'status': true,
        'data': {
          'id': 9,
          'name': 'New User',
          'requires_profile_completion': true,
          'is_complete_profile': false,
          'is_new_account': true,
          'missing_profile_fields': ['zip_code', 'select_state'],
          'profile_completion_fields': [
            'display_name',
            'zip_code',
            'select_state'
          ],
          'allowed_search_radii_miles': [10, 25, 50, 100, 300],
          'search_radius_miles': 300,
          'profile': {
            'id': 4,
            'display_name': 'New User',
            'zip_code': '33101',
            'select_state': 'FL',
            'search_radius_miles': 300,
          },
        },
      });

      expect(profile.data!.requiresProfileCompletion, isTrue);
      expect(profile.data!.missingProfileFields, ['zip_code', 'select_state']);
      expect(profile.data!.profile!.zipCode, '33101');
      expect(profile.data!.profile!.selectState, 'FL');
      expect(profile.data!.searchRadiusMiles, 300);
      expect(profile.data!.allowedSearchRadiiMiles.contains(100), isTrue);
    });
  });

  group('duplicate prefill hashtags', () {
    test('parses manual hashtags from string values', () {
      final tags = parseManualHashtags(['algreen', 'livemusic']);
      expect(tags.map((tag) => tag.name), ['algreen', 'livemusic']);

      final details = EventDetails.fromJson({
        'event_title': 'Copy',
        'manual_hashtags': [
          'algreen',
          {'name': 'soul'}
        ],
        'can_revise_request': true,
        'can_resubmit_request': false,
        'can_edit_request': true,
        'request_status': 'countered',
        'is_counter_active': 1,
      });
      expect(
          details.manualHashtags!.map((tag) => tag.name), ['algreen', 'soul']);
      expect(details.canReviseRequest, isTrue);
      expect(details.canEditRequest, isTrue);
      expect(details.requestStatus, 'countered');
      expect(details.isCounterActive!.value, 1);
    });
  });

  group('json helpers', () {
    test('parseBool understands laravel flags', () {
      expect(parseBool(true), isTrue);
      expect(parseBool(1), isTrue);
      expect(parseBool('0'), isFalse);
      expect(parseBool(null), isFalse);
    });
  });
}
