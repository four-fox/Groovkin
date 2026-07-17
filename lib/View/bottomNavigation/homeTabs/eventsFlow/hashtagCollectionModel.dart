import 'package:dio/dio.dart' as form;

enum HashtagCollectionType {
  music('music_choice', 'Music'),
  activity('activity_choice', 'Activity');

  const HashtagCollectionType(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static HashtagCollectionType fromApiValue(String? value) {
    return value == activity.apiValue ? activity : music;
  }
}

String normalizeHashtag(String value) {
  return value
      .trim()
      .replaceFirst(RegExp(r'^#+'), '')
      .replaceAll(RegExp(r'[\s\p{P}]', unicode: true), '')
      .toLowerCase();
}

String cleanHashtag(String value) {
  return value.trim().replaceFirst(RegExp(r'^#+'), '').trim();
}

List<String> parseHashtagText(String value) {
  final seen = <String>{};
  final tags = <String>[];
  for (final raw in value.split(RegExp(r'[,;\n]'))) {
    final cleaned = cleanHashtag(raw);
    final normalized = normalizeHashtag(cleaned);
    if (cleaned.isNotEmpty && normalized.isNotEmpty && seen.add(normalized)) {
      tags.add(cleaned);
    }
  }
  return tags;
}

class HashtagCollectionResponse {
  HashtagCollectionResponse({
    this.status,
    this.message,
    this.data = const [],
  });

  final bool? status;
  final String? message;
  final List<HashtagCollection> data;

  factory HashtagCollectionResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return HashtagCollectionResponse(
      status: json['status'],
      message: json['message'],
      data: rawData is List
          ? rawData
              .whereType<Map>()
              .map((x) => HashtagCollection.fromJson(
                    Map<String, dynamic>.from(x),
                  ))
              .toList()
          : rawData is Map
              ? [
                  HashtagCollection.fromJson(
                    Map<String, dynamic>.from(rawData),
                  )
                ]
              : const [],
    );
  }
}

class HashtagCollection {
  HashtagCollection({
    this.id,
    this.title = '',
    this.type,
    this.isActive = true,
    this.hashtagsCount = 0,
    this.eventsCount = 0,
    this.hashtags = const [],
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String title;
  final String? type;
  final bool isActive;
  final int hashtagsCount;
  final int eventsCount;
  final List<HashtagCollectionItem> hashtags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get typeLabel => HashtagCollectionType.fromApiValue(type).label;

  factory HashtagCollection.fromJson(Map<String, dynamic> json) {
    final rawHashtags = json['hashtags'];
    return HashtagCollection(
      id: json['id'],
      title: (json['title'] ?? json['name'] ?? '').toString(),
      type: json['type']?.toString(),
      isActive: json['is_active'] ?? true,
      hashtagsCount: json['hashtags_count'] ?? 0,
      eventsCount: json['events_count'] ?? 0,
      hashtags: rawHashtags is List
          ? rawHashtags
              .whereType<Map>()
              .map((x) => HashtagCollectionItem.fromJson(
                    Map<String, dynamic>.from(x),
                  ))
              .toList()
          : const [],
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'is_active': isActive,
        'hashtags_count': hashtagsCount,
        'events_count': eventsCount,
        'hashtags': hashtags.map((x) => x.toJson()).toList(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

class HashtagCollectionItem {
  HashtagCollectionItem({
    this.id,
    this.name = '',
    String? displayName,
  }) : displayName = displayName ?? '#$name';

  final int? id;
  final String name;
  final String displayName;

  factory HashtagCollectionItem.fromJson(Map<String, dynamic> json) {
    final name = (json['name'] ?? '').toString();
    return HashtagCollectionItem(
      id: json['id'],
      name: name,
      displayName: (json['display_name'] ?? '#$name').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'display_name': displayName,
      };
}

class EventHashtag {
  EventHashtag({this.name = '', String? displayName})
      : displayName = displayName ?? '#$name';

  final String name;
  final String displayName;

  factory EventHashtag.fromJson(Map<String, dynamic> json) {
    final name = (json['name'] ?? '').toString();
    return EventHashtag(
      name: name,
      displayName: (json['display_name'] ?? '#$name').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'display_name': displayName,
      };
}

class EventCollectionHashtag extends EventHashtag {
  EventCollectionHashtag({
    super.name,
    super.displayName,
    this.editableAtEventLevel = false,
    this.normalizedName,
  });

  final bool editableAtEventLevel;
  final String? normalizedName;

  factory EventCollectionHashtag.fromJson(Map<String, dynamic> json) {
    final name = (json['name'] ?? '').toString();
    return EventCollectionHashtag(
      name: name,
      displayName: (json['display_name'] ?? '#$name').toString(),
      editableAtEventLevel: json['editable_at_event_level'] ?? false,
      normalizedName: json['normalized_name']?.toString(),
    );
  }
}

class EventHashtagCollection {
  EventHashtagCollection({
    this.id,
    this.title,
    this.type,
    this.hashtags = const [],
  });

  final int? id;
  final String? title;
  final String? type;
  final List<EventCollectionHashtag> hashtags;

  factory EventHashtagCollection.fromJson(Map<String, dynamic> json) {
    final rawHashtags = json['hashtags'];
    return EventHashtagCollection(
      id: json['id'],
      title: json['title']?.toString(),
      type: json['type']?.toString(),
      hashtags: rawHashtags is List
          ? rawHashtags
              .whereType<Map>()
              .map((x) => EventCollectionHashtag.fromJson(
                    Map<String, dynamic>.from(x),
                  ))
              .toList()
          : const [],
    );
  }
}

class EventManualHashtag extends EventHashtag {
  EventManualHashtag({
    super.name,
    super.displayName,
    this.editableAtEventLevel = true,
    this.normalizedName,
  });

  final bool editableAtEventLevel;
  final String? normalizedName;

  factory EventManualHashtag.fromJson(Map<String, dynamic> json) {
    final name = (json['name'] ?? '').toString();
    return EventManualHashtag(
      name: name,
      displayName: (json['display_name'] ?? '#$name').toString(),
      editableAtEventLevel: json['editable_at_event_level'] ?? true,
      normalizedName: json['normalized_name']?.toString(),
    );
  }
}

class CreateHashtagCollectionRequest {
  CreateHashtagCollectionRequest({
    required this.title,
    required this.type,
    required this.hashtags,
  });

  final String title;
  final String type;
  final List<String> hashtags;

  form.FormData toFormData() {
    final data = form.FormData();
    data.fields.add(MapEntry('title', title.trim()));
    data.fields.add(MapEntry('type', type));
    for (final tag in hashtags) {
      data.fields.add(MapEntry('hashtags[]', cleanHashtag(tag)));
    }
    return data;
  }
}

class UpdateHashtagCollectionRequest extends CreateHashtagCollectionRequest {
  UpdateHashtagCollectionRequest({
    required this.collectionId,
    required super.title,
    required super.type,
    required super.hashtags,
  });

  final int collectionId;

  @override
  form.FormData toFormData() {
    final data = super.toFormData();
    data.fields.add(MapEntry('collection_id', collectionId.toString()));
    return data;
  }
}

class CollectionRemovalResult {
  CollectionRemovalResult({this.deleted = 0, this.deactivated = 0});

  final int deleted;
  final int deactivated;

  factory CollectionRemovalResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final map = data is Map ? data : const {};
    return CollectionRemovalResult(
      deleted: map['deleted'] ?? 0,
      deactivated: map['deactivated'] ?? 0,
    );
  }
}

class EventHashtagPayload {
  EventHashtagPayload({
    this.manualHashtags,
    this.collectionIds,
  });

  final List<String>? manualHashtags;
  final List<int>? collectionIds;

  void addToFormData(form.FormData data) {
    if (manualHashtags != null) {
      for (final tag in manualHashtags!) {
        data.fields.add(MapEntry('manual_hashtags[]', cleanHashtag(tag)));
      }
      // if (manualHashtags!.isEmpty) {
      //   data.fields.add(const MapEntry('manual_hashtags', '[]'));
      // }
    }

    if (collectionIds != null) {
      for (final id in collectionIds!) {
        data.fields.add(MapEntry('collection_ids[]', id.toString()));
      }
      // if (collectionIds!.isEmpty) {
      //   data.fields.add(const MapEntry('collection_ids', '[]'));
      // }
    }
  }
}
