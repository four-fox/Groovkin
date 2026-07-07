import 'package:dio/dio.dart' as form;
import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/hashtagCollectionModel.dart';

void main() {
  group('Hashtag collection models', () {
    test('parses collection response with nullable and empty fields', () {
      final response = HashtagCollectionResponse.fromJson({
        'status': true,
        'data': [
          {
            'id': 4,
            'title': '80s Rock Music',
            'type': 'music_choice',
            'is_active': true,
            'hashtags_count': 2,
            'events_count': 1,
            'hashtags': [
              {'id': 15, 'name': 'BonJovi', 'display_name': '#BonJovi'},
              {'id': 16, 'name': 'Metallica'},
            ],
          },
          {'id': 7, 'title': 'Activity', 'hashtags': null},
        ],
      });

      expect(response.data, hasLength(2));
      expect(response.data.first.title, '80s Rock Music');
      expect(response.data.first.hashtags.last.displayName, '#Metallica');
      expect(response.data.last.hashtags, isEmpty);
    });

    test('parses event owner hashtag source rows', () {
      final collection = EventHashtagCollection.fromJson({
        'id': 4,
        'title': '80s Rock Music',
        'type': 'music_choice',
        'hashtags': [
          {
            'name': 'BonJovi',
            'display_name': '#BonJovi',
            'editable_at_event_level': false,
          }
        ],
      });
      final manual = EventManualHashtag.fromJson({
        'name': 'Downtown',
        'display_name': '#Downtown',
        'editable_at_event_level': true,
      });

      expect(collection.hashtags.single.editableAtEventLevel, isFalse);
      expect(manual.editableAtEventLevel, isTrue);
    });
  });

  group('Hashtag helpers', () {
    test('normalizes duplicates and parses comma text', () {
      expect(normalizeHashtag(' #BonJovi! '), normalizeHashtag('bonjovi'));
      expect(
        parseHashtagText('#BonJovi, bonjovi, Metallica\nHairbands'),
        ['BonJovi', 'Metallica', 'Hairbands'],
      );
    });

    test('serializes omitted versus empty event update fields', () {
      final omitted = EventHashtagPayload();
      final empty = EventHashtagPayload(
        manualHashtags: const [],
        collectionIds: const [],
      );
      final populated = EventHashtagPayload(
        manualHashtags: const ['FridayNight'],
        collectionIds: const [4, 7],
      );

      final omittedData = formDataFields(omitted);
      final emptyData = formDataFields(empty);
      final populatedData = formDataFields(populated);

      expect(omittedData, isEmpty);
      expect(emptyData['manual_hashtags'], '[]');
      expect(emptyData['collection_ids'], '[]');
      expect(populatedData['manual_hashtags[]'], 'FridayNight');
      expect(populatedData['collection_ids[]'], '7');
    });
  });
}

Map<String, String> formDataFields(EventHashtagPayload payload) {
  final data = form.FormData();
  payload.addToFormData(data);
  return {
    for (final field in data.fields) field.key: field.value,
  };
}
