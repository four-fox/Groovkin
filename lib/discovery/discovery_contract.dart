import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:groovkin/utils/json_parsers.dart';
import 'package:groovkin/utils/search_radius.dart';

import 'discovery_config.dart';

void discoveryLog(String message) {
  if (kDebugMode) {
    debugPrint('[discovery] $message');
  }
}

/// Device coordinates that are safe to send. `(0, 0)` and one-sided pairs are not.
class DiscoveryCoordinate {
  const DiscoveryCoordinate({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  static DiscoveryCoordinate? tryCreate(double? latitude, double? longitude) {
    if (latitude == null || longitude == null) return null;
    if (latitude == 0 && longitude == 0) return null;
    if (latitude < -90 || latitude > 90) return null;
    if (longitude < -180 || longitude > 180) return null;
    return DiscoveryCoordinate(latitude: latitude, longitude: longitude);
  }
}

/// Five-digit US ZIP. Leading zeros stay in the string. Prefixes such as `08` are incomplete.
bool isCompleteUsZip(String value) => RegExp(r'^\d{5}$').hasMatch(value.trim());

String? postalFieldMessage(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty || isCompleteUsZip(trimmed)) return null;
  return 'Enter a 5-digit ZIP code. A shorter prefix is not a search.';
}

class DiscoveryReasonLabel {
  const DiscoveryReasonLabel({required this.code, required this.label});

  final String code;
  final String label;

  static DiscoveryReasonLabel? tryParse(dynamic raw) {
    final map = parseMap(raw);
    if (map == null) return null;
    final label = parseString(map['label']);
    if (label == null) return null;
    return DiscoveryReasonLabel(
      code: parseString(map['code']) ?? '',
      label: label,
    );
  }
}

class DiscoveryNamedMatch {
  const DiscoveryNamedMatch({this.id, required this.name, this.source});

  final int? id;
  final String name;
  final String? source;

  static DiscoveryNamedMatch? tryParse(dynamic raw) {
    final map = parseMap(raw);
    if (map == null) return null;
    final name = parseString(map['name']);
    if (name == null) return null;
    return DiscoveryNamedMatch(
      id: parseInt(map['id']),
      name: name,
      source: parseString(map['source']),
    );
  }
}

class DiscoverySignal {
  const DiscoverySignal({
    this.engine,
    this.matchType,
    this.reasons = const [],
    this.reasonLabels = const [],
    this.matchedMusic = const [],
    this.matchedLifestyles = const [],
    this.matchedHashtags = const [],
    this.matchedActivities = const [],
    this.distanceMiles,
    this.distanceUnit = 'miles',
  });

  final String? engine;
  final String? matchType;
  final List<String> reasons;
  final List<DiscoveryReasonLabel> reasonLabels;
  final List<DiscoveryNamedMatch> matchedMusic;
  final List<DiscoveryNamedMatch> matchedLifestyles;
  final List<DiscoveryNamedMatch> matchedHashtags;
  final List<DiscoveryNamedMatch> matchedActivities;
  final double? distanceMiles;
  final String distanceUnit;

  bool get isPersonalized => matchType == 'personalized';
  bool get isDiscovery => matchType == 'discovery';

  String? get distanceLabel {
    final miles = distanceMiles;
    if (miles == null) return null;
    final text = miles == miles.roundToDouble()
        ? miles.toInt().toString()
        : miles.toStringAsFixed(1);
    return '$text mi away';
  }

  static DiscoverySignal? tryParse(dynamic raw) {
    final map = parseMap(raw);
    if (map == null) return null;
    return DiscoverySignal(
      engine: parseString(map['engine']),
      matchType: parseString(map['match_type']),
      reasons: parseStringList(map['reasons']),
      reasonLabels: _labels(map['reason_labels']),
      matchedMusic: _named(map['matched_music']),
      matchedLifestyles: _named(map['matched_lifestyles']),
      matchedHashtags: _named(map['matched_hashtags']),
      matchedActivities: _named(map['matched_activities']),
      distanceMiles: parseDouble(map['distance_miles']),
      distanceUnit: parseString(map['distance_unit']) ?? 'miles',
    );
  }

  static List<DiscoveryReasonLabel> _labels(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .map(DiscoveryReasonLabel.tryParse)
        .whereType<DiscoveryReasonLabel>()
        .toList(growable: false);
  }

  static List<DiscoveryNamedMatch> _named(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .map(DiscoveryNamedMatch.tryParse)
        .whereType<DiscoveryNamedMatch>()
        .toList(growable: false);
  }
}

class DiscoveryLocationContext {
  const DiscoveryLocationContext({
    this.source = 'none',
    this.radiusMiles,
    this.distanceUnit = 'miles',
    this.postalCode,
    this.radiusApplied = false,
    this.allowedRadiiMiles = kDefaultSearchRadiiMiles,
  });

  final String source;
  final int? radiusMiles;
  final String distanceUnit;
  final String? postalCode;
  final bool radiusApplied;
  final List<int> allowedRadiiMiles;

  static DiscoveryLocationContext parse(dynamic raw) {
    final map = parseMap(raw) ?? const {};
    final allowed = parseAllowedSearchRadii(map['allowed_radii_miles']);
    return DiscoveryLocationContext(
      source: parseString(map['source']) ?? 'none',
      radiusMiles: parseInt(map['radius_miles']),
      distanceUnit: parseString(map['distance_unit']) ?? 'miles',
      postalCode: parseString(map['postal_code']),
      radiusApplied: parseBool(map['radius_applied']),
      allowedRadiiMiles: allowed,
    );
  }
}

class DiscoveryMeta {
  const DiscoveryMeta({
    this.currentPage = 1,
    this.perPage = 12,
    this.total = 0,
    this.lastPage = 1,
    this.nextPage,
    this.prevPage,
  });

  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final int? nextPage;
  final int? prevPage;

  static DiscoveryMeta parse(dynamic raw) {
    final map = parseMap(raw) ?? const {};
    return DiscoveryMeta(
      currentPage: parseInt(map['current_page']) ?? 1,
      perPage: parseInt(map['per_page']) ?? 12,
      total: parseInt(map['total']) ?? 0,
      lastPage: parseInt(map['last_page']) ?? 1,
      nextPage: _positivePage(map['next_page']),
      prevPage: _positivePage(map['prev_page']),
    );
  }

  static int? _positivePage(dynamic value) {
    if (value == null) return null;
    final page = parseInt(value);
    if (page == null || page < 1) return null;
    return page;
  }
}

class DiscoveryAppliedFilters {
  const DiscoveryAppliedFilters({
    this.query,
    this.hashtag,
    this.hashtags = const [],
    this.activity,
    this.activityIds = const [],
    this.music,
    this.musicGenreId,
    this.postalCode,
    this.sort = 'relevance',
    this.radiusApplied = false,
  });

  final String? query;
  final String? hashtag;
  final List<String> hashtags;
  final String? activity;
  final List<int> activityIds;
  final String? music;
  final int? musicGenreId;
  final String? postalCode;
  final String sort;
  final bool radiusApplied;

  static DiscoveryAppliedFilters? tryParse(dynamic raw) {
    final map = parseMap(raw);
    if (map == null) return null;
    return DiscoveryAppliedFilters(
      query: parseString(map['q']),
      hashtag: parseString(map['hashtag']),
      hashtags: parseStringList(map['hashtags']),
      activity: parseString(map['activity']),
      activityIds: parseIntList(map['activity_ids']),
      music: parseString(map['music']),
      musicGenreId: parseInt(map['music_genre_id']),
      postalCode: parseString(map['postal_code']),
      sort: parseString(map['sort']) ?? 'relevance',
      radiusApplied: parseBool(map['radius_applied']),
    );
  }
}

class DiscoveryProblem {
  const DiscoveryProblem({
    required this.message,
    this.statusCode,
    this.code,
    this.retryable = false,
    this.field,
  });

  final String message;
  final int? statusCode;
  final String? code;
  final bool retryable;
  final String? field;

  bool get isUnauthorized => statusCode == 401;
  bool get isRateLimited => statusCode == 429;
}

const Map<String, String> kDiscoveryErrorMessages = {
  'discovery_v2_disabled': 'Event discovery v2 is not enabled.',
  'invalid_radius': 'Choose a radius of 10, 25, 50, 100, or 300 miles.',
  'invalid_coordinates':
      'That location could not be used. Update your location and try again.',
  'invalid_postal_code': 'Enter a valid 5-digit ZIP code.',
  'coordinates_required':
      'Nearest sort needs a location. Turn on location or choose one.',
  'invalid_sort': 'That sort option is not available.',
  'invalid_hashtag': 'Enter a valid hashtag.',
  'invalid_search': 'Update your search and try again.',
  'invalid_page': 'That page is not available.',
  'invalid_per_page': 'That page size is not available.',
  'search_filters_required': 'Add a search term or filter first.',
  'discovery_unavailable':
      'Event discovery is temporarily unavailable. Try again.',
};

String discoveryErrorMessage(String? code, {String? fallback}) {
  if (code != null && kDiscoveryErrorMessages.containsKey(code)) {
    return kDiscoveryErrorMessages[code]!;
  }
  final text = fallback?.trim();
  if (text != null && text.isNotEmpty) return text;
  return 'Something went wrong. Please try again.';
}

bool isDiscoveryV2Disabled(int? statusCode, dynamic body) {
  if (statusCode != 403) return false;
  final root = parseMap(body);
  if (root == null) return false;
  final direct = parseString(root['error_code']);
  if (direct == DiscoveryConfig.disabledCode) return true;
  final data = parseMap(root['data']);
  return parseString(data?['error_code']) == DiscoveryConfig.disabledCode;
}

class DiscoverySearchDraft {
  DiscoverySearchDraft({
    this.text = '',
    this.postalCode = '',
    this.activityText = '',
    this.musicText = '',
    this.activityIds = const [],
    this.musicGenreId,
    this.sort = 'relevance',
    this.applyRadius = false,
    this.radius = 50,
  });

  String text;
  String postalCode;
  String activityText;
  String musicText;
  List<int> activityIds;
  int? musicGenreId;
  String sort;
  bool applyRadius;
  int radius;

  static const sorts = ['relevance', 'nearest', 'soonest', 'newest'];

  bool get hasMeaningfulFilter {
    if (text.trim().isNotEmpty) return true;
    if (isCompleteUsZip(postalCode)) return true;
    if (activityIds.isNotEmpty) return true;
    if (activityText.trim().isNotEmpty) return true;
    if (musicGenreId != null) return true;
    if (musicText.trim().isNotEmpty) return true;
    return false;
  }

  String get normalizedSort => sorts.contains(sort) ? sort : 'relevance';

  DiscoverySearchDraft copy() => DiscoverySearchDraft(
        text: text,
        postalCode: postalCode,
        activityText: activityText,
        musicText: musicText,
        activityIds: List<int>.from(activityIds),
        musicGenreId: musicGenreId,
        sort: sort,
        applyRadius: applyRadius,
        radius: radius,
      );
}

class DiscoveryCatalogOption {
  const DiscoveryCatalogOption({
    required this.id,
    required this.name,
    required this.kind,
  });

  final int id;
  final String name;
  final String kind;
}

List<DiscoveryCatalogOption> parseCatalogOptions(
  dynamic body, {
  required String kind,
}) {
  final root = parseMap(body) ?? (body is List ? {'data': body} : null);
  if (root == null) return const [];
  final rows = root['data'];
  if (rows is! List) return const [];
  final options = <DiscoveryCatalogOption>[];
  final seen = <int>{};
  for (final row in rows) {
    final map = parseMap(row);
    if (map == null) continue;
    final items = map['category_items'] ?? map['event_items'] ?? map['items'];
    if (items is! List) continue;
    for (final item in items) {
      final itemMap = parseMap(item);
      if (itemMap == null) continue;
      final id = parseInt(itemMap['id']);
      final name = parseString(itemMap['name']);
      if (id == null || name == null || !seen.add(id)) continue;
      options.add(DiscoveryCatalogOption(id: id, name: name, kind: kind));
    }
  }
  return options;
}

Map<String, dynamic> buildRecommendedQuery({
  required int page,
  required int radius,
  double? latitude,
  double? longitude,
  int perPage = 12,
  List<int>? allowedRadii,
}) {
  final query = <String, dynamic>{
    'page': page < 1 ? 1 : page,
    'per_page': perPage.clamp(1, 30),
    'radius': sanitizeSearchRadius(radius, allowed: allowedRadii),
  };
  final point = DiscoveryCoordinate.tryCreate(latitude, longitude);
  if (point != null) {
    query['latitude'] = point.latitude;
    query['longitude'] = point.longitude;
  }
  return query;
}

Map<String, dynamic> buildSearchQuery(
  DiscoverySearchDraft draft, {
  required int page,
  double? latitude,
  double? longitude,
  int perPage = 12,
  List<int>? allowedRadii,
}) {
  final query = <String, dynamic>{
    'page': page < 1 ? 1 : page,
    'per_page': perPage.clamp(1, 30),
    'sort': draft.normalizedSort,
  };
  final text = draft.text.trim();
  if (text.isNotEmpty) query['q'] = text;
  final zip = draft.postalCode.trim();
  if (isCompleteUsZip(zip)) query['postal_code'] = zip;
  if (draft.activityIds.isNotEmpty) {
    query['activity_ids'] = List<int>.from(draft.activityIds);
  } else {
    final activity = draft.activityText.trim();
    if (activity.isNotEmpty) query['activity'] = activity;
  }
  if (draft.musicGenreId != null) {
    query['music_genre_id'] = draft.musicGenreId;
  } else {
    final music = draft.musicText.trim();
    if (music.isNotEmpty) query['music'] = music;
  }
  final point = DiscoveryCoordinate.tryCreate(latitude, longitude);
  final wantsCoordinates =
      (draft.applyRadius || draft.normalizedSort == 'nearest') && point != null;
  if (wantsCoordinates) {
    query['latitude'] = point.latitude;
    query['longitude'] = point.longitude;
  }
  if (draft.applyRadius && point != null) {
    query['radius'] = sanitizeSearchRadius(draft.radius, allowed: allowedRadii);
  }
  return query;
}

/// Encodes a query the same way an HTTP client must, so `#` cannot become a fragment.
String encodeDiscoveryQuery(Map<String, dynamic> query) {
  final parts = <String>[];
  query.forEach((key, value) {
    if (value == null) return;
    if (value is List) {
      for (final item in value) {
        parts.add(
          '${Uri.encodeQueryComponent('$key[]')}=${Uri.encodeQueryComponent('$item')}',
        );
      }
      return;
    }
    parts.add(
      '${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent('$value')}',
    );
  });
  return parts.join('&');
}

class RadiusPersistDecision {
  const RadiusPersistDecision({
    required this.requested,
    required this.confirmed,
    required this.pending,
  });

  final int requested;
  final int confirmed;
  final bool pending;

  static RadiusPersistDecision apply({
    required int previousConfirmed,
    required int requested,
    required bool saveSucceeded,
  }) {
    if (saveSucceeded) {
      return RadiusPersistDecision(
        requested: requested,
        confirmed: requested,
        pending: false,
      );
    }
    return RadiusPersistDecision(
      requested: requested,
      confirmed: previousConfirmed,
      pending: true,
    );
  }
}

class DiscoveryRequestGate {
  int generation = 0;

  int begin() => ++generation;

  bool isCurrent(int token) => token == generation;
}

class DiscoveryDebouncer {
  DiscoveryDebouncer({this.delay = const Duration(milliseconds: 600)});

  final Duration delay;
  Timer? _timer;

  void schedule(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() => _timer?.cancel();
}

bool shouldRefreshDiscoveryList(List<String> keys, String expected) {
  final target = expected.toLowerCase();
  return keys.any((key) => key.toLowerCase() == target);
}

String recommendationEmptyMessage({
  required String? locationStatus,
  required bool locationDenied,
}) {
  if (locationStatus == 'unavailable') {
    return 'A valid location is required for nearby recommendations. '
        'Use your current location or save one on your profile. '
        'A ZIP code alone does not create a radius search.';
  }
  if (locationDenied) {
    return 'Location permission is off. Groovkin can still use a location saved on your profile. '
        'If none is saved, nearby recommendations stay empty.';
  }
  return 'No events in this radius yet.';
}

String searchEmptyMessage() => 'No events match these filters.';

/// Coerce a V2 event object so the existing event parser cannot throw on nulls.
Map<String, dynamic> coerceDiscoveryEventMap(Map<String, dynamic> json) {
  final copy = Map<String, dynamic>.from(json);
  const listKeys = [
    'hashtags',
    'hardwares',
    'services',
    'genre',
    'profile_picture',
    'eventMusicChoiceTags',
    'eventActivityChoiceTags',
  ];
  for (final key in listKeys) {
    final value = copy[key];
    if (value == null) continue;
    if (value is! List) {
      copy[key] = <dynamic>[];
      continue;
    }
    copy[key] = value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
  for (final key in ['venue', 'user', 'banner_image', 'recommendation']) {
    if (copy[key] != null && copy[key] is! Map) copy[key] = null;
  }
  for (final key in ['start_date_time', 'end_date_time']) {
    final value = copy[key];
    if (value == null) continue;
    try {
      DateTime.parse(value.toString());
    } catch (_) {
      copy[key] = null;
    }
  }
  final id = parseInt(copy['id']);
  if (id != null) copy['id'] = id;
  return copy;
}
