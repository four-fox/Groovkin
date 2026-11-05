import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/Network/backend_error.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/RecommendedForUserModel.dart'
    as recommended_feed;
import 'package:groovkin/View/bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';
import 'package:groovkin/utils/json_parsers.dart';

import 'discovery_config.dart';
import 'discovery_contract.dart';

class DiscoveryHttpResult {
  const DiscoveryHttpResult({required this.statusCode, this.data});

  final int statusCode;
  final dynamic data;
}

abstract class DiscoveryTransport {
  Future<DiscoveryHttpResult> get(
    String path,
    Map<String, dynamic> query, {
    bool suppressErrorToast = false,
  });
}

class ApiDiscoveryTransport implements DiscoveryTransport {
  @override
  Future<DiscoveryHttpResult> get(
    String path,
    Map<String, dynamic> query, {
    bool suppressErrorToast = false,
  }) async {
    final response = await API().getApi(
      url: path,
      isLoader: false,
      suppressErrorToast: suppressErrorToast,
      queryParameters: query.isEmpty ? null : query,
    );
    return DiscoveryHttpResult(
      statusCode: (response?.statusCode as int?) ?? 0,
      data: response?.data,
    );
  }
}

class DiscoveryPage {
  const DiscoveryPage({
    required this.engine,
    required this.events,
    required this.meta,
    this.locationStatus,
    this.location = const DiscoveryLocationContext(),
    this.filters,
    this.message,
  });

  final String engine;
  final String? locationStatus;
  final DiscoveryLocationContext location;
  final DiscoveryMeta meta;
  final DiscoveryAppliedFilters? filters;
  final List<EventData> events;
  final String? message;

  bool get isV2 => engine == 'v2';
}

class DiscoveryOutcome {
  const DiscoveryOutcome._({this.page, this.problem, this.usedLegacy = false});

  final DiscoveryPage? page;
  final DiscoveryProblem? problem;
  final bool usedLegacy;

  bool get isSuccess => page != null && problem == null;

  factory DiscoveryOutcome.success(DiscoveryPage page, {bool usedLegacy = false}) {
    return DiscoveryOutcome._(page: page, usedLegacy: usedLegacy);
  }

  factory DiscoveryOutcome.failure(DiscoveryProblem problem, {bool usedLegacy = false}) {
    return DiscoveryOutcome._(problem: problem, usedLegacy: usedLegacy);
  }
}

class DiscoveryRepository {
  DiscoveryRepository({
    required this.transport,
    DiscoveryConfig? config,
  }) : config = config ?? DiscoveryConfig.compileTime;

  final DiscoveryTransport transport;
  final DiscoveryConfig config;

  /// Set after the backend explicitly reports `discovery_v2_disabled`.
  /// Cleared by an explicit refresh so a later release can be picked up
  /// without an infinite retry loop inside one request.
  bool serverDisabled = false;

  static final DiscoveryRepository shared = DiscoveryRepository(
    transport: ApiDiscoveryTransport(),
  );

  Future<DiscoveryOutcome> recommended({
    required int page,
    required int radius,
    double? latitude,
    double? longitude,
    List<int>? allowedRadii,
    bool forceV2 = false,
  }) async {
    final query = buildRecommendedQuery(
      page: page,
      radius: radius,
      latitude: latitude,
      longitude: longitude,
      allowedRadii: allowedRadii,
    );
    final useV2 = config.enabled && (forceV2 || !serverDisabled);
    if (!useV2) {
      return _legacy(
        path: DiscoveryConfig.recommendedV1,
        query: query,
      );
    }
    final result = await transport.get(
      DiscoveryConfig.recommendedV2,
      query,
      suppressErrorToast: true,
    );
    discoveryLog(
      'recommended v2 status=${result.statusCode} code=${_code(result.data)}',
    );
    if (isDiscoveryV2Disabled(result.statusCode, result.data)) {
      serverDisabled = true;
      discoveryLog('recommended fell back to ${DiscoveryConfig.recommendedV1}');
      return _legacy(
        path: DiscoveryConfig.recommendedV1,
        query: query,
        usedLegacy: true,
      );
    }
    return _interpret(result);
  }

  Future<DiscoveryOutcome> search({
    required DiscoverySearchDraft draft,
    required int page,
    double? latitude,
    double? longitude,
    List<int>? allowedRadii,
    bool forceV2 = false,
  }) async {
    if (!draft.hasMeaningfulFilter) {
      return DiscoveryOutcome.failure(
        const DiscoveryProblem(
          code: 'search_filters_required',
          message: 'Add a search term or filter first.',
        ),
      );
    }
    final useV2 = config.enabled && (forceV2 || !serverDisabled);
    if (!useV2) {
      return _legacySearch(draft, page);
    }
    final query = buildSearchQuery(
      draft,
      page: page,
      latitude: latitude,
      longitude: longitude,
      allowedRadii: allowedRadii,
    );
    final result = await transport.get(
      DiscoveryConfig.searchV2,
      query,
      suppressErrorToast: true,
    );
    discoveryLog(
      'search v2 status=${result.statusCode} code=${_code(result.data)}',
    );
    if (isDiscoveryV2Disabled(result.statusCode, result.data)) {
      serverDisabled = true;
      discoveryLog(
        'search fell back to ${DiscoveryConfig.searchV1}; V2-only filters are not applied',
      );
      return _legacySearch(draft, page, usedLegacy: true);
    }
    return _interpret(result);
  }

  Future<List<DiscoveryCatalogOption>> catalog(String type) async {
    final result = await transport.get(
      'show-category-with-items',
      {'type': type},
      suppressErrorToast: true,
    );
    if (result.statusCode != 200) return const [];
    final kind = type == DiscoveryConfig.musicCatalogType ? 'music' : 'activity';
    return parseCatalogOptions(result.data, kind: kind);
  }

  Future<DiscoveryOutcome> _legacySearch(
    DiscoverySearchDraft draft,
    int page, {
    bool usedLegacy = false,
  }) {
    final text = draft.text.trim().isNotEmpty
        ? draft.text.trim()
        : draft.postalCode.trim();
    return _legacy(
      path: DiscoveryConfig.searchV1,
      query: {
        'search': text,
        'page': page < 1 ? 1 : page,
      },
      usedLegacy: usedLegacy,
    );
  }

  Future<DiscoveryOutcome> _legacy({
    required String path,
    required Map<String, dynamic> query,
    bool usedLegacy = false,
  }) async {
    final result = await transport.get(path, query);
    discoveryLog('legacy $path status=${result.statusCode} code=${_code(result.data)}');
    if (result.statusCode == 401) {
      return DiscoveryOutcome.failure(
        _problem(result),
        usedLegacy: usedLegacy,
      );
    }
    final page = parseLegacyEventPage(result.data);
    if (result.statusCode == 200 && page != null) {
      return DiscoveryOutcome.success(page, usedLegacy: usedLegacy);
    }
    return DiscoveryOutcome.failure(_problem(result), usedLegacy: usedLegacy);
  }

  DiscoveryOutcome _interpret(DiscoveryHttpResult result) {
    if (result.statusCode == 401) {
      return DiscoveryOutcome.failure(_problem(result));
    }
    if (result.statusCode == 200) {
      final page = parseDiscoveryPage(result.data);
      if (page != null && _statusOk(result.data)) {
        return DiscoveryOutcome.success(page);
      }
      return DiscoveryOutcome.failure(
        DiscoveryProblem(
          statusCode: result.statusCode,
          code: _code(result.data) ?? 'invalid_payload',
          message: discoveryErrorMessage(
            _code(result.data),
            fallback: _message(result.data) ??
                'Event discovery returned an unreadable response.',
          ),
        ),
      );
    }
    return DiscoveryOutcome.failure(_problem(result));
  }

  DiscoveryProblem _problem(DiscoveryHttpResult result) {
    final code = _code(result.data);
    final retryable = result.statusCode == 429 ||
        result.statusCode == 0 ||
        result.statusCode >= 500 ||
        code == 'discovery_unavailable';
    return DiscoveryProblem(
      statusCode: result.statusCode,
      code: code,
      retryable: retryable,
      field: code == 'invalid_postal_code' ? 'postal_code' : null,
      message: discoveryErrorMessage(
        code,
        fallback: result.statusCode == 429
            ? 'Too many searches. Wait a moment, then try again.'
            : result.statusCode >= 500
                ? 'Event discovery is temporarily unavailable. Try again.'
                : backendErrorMessage(result.data),
      ),
    );
  }
}

bool _statusOk(dynamic body) {
  final root = parseMap(body);
  if (root == null) return false;
  if (root['status'] == false) return false;
  return true;
}

String? _code(dynamic body) {
  final root = parseMap(body);
  if (root == null) return null;
  return parseString(root['error_code']) ??
      parseString(parseMap(root['data'])?['error_code']);
}

String? _message(dynamic body) => parseString(parseMap(body)?['message']);

DiscoveryPage? parseDiscoveryPage(dynamic body) {
  final root = parseMap(body);
  if (root == null) return null;
  final data = parseMap(root['data']);
  if (data == null) return null;
  final rawEvents = data['events'];
  if (rawEvents != null && rawEvents is! List) return null;
  return DiscoveryPage(
    engine: parseString(data['engine']) ?? 'v2',
    locationStatus: parseString(data['location_status']),
    location: DiscoveryLocationContext.parse(data['location']),
    filters: DiscoveryAppliedFilters.tryParse(data['filters']),
    meta: DiscoveryMeta.parse(data['meta']),
    message: parseString(root['message']),
    events: _events(rawEvents),
  );
}

DiscoveryPage? parseLegacyEventPage(dynamic body) {
  final root = parseMap(body);
  if (root == null || root['status'] == false) return null;
  final data = parseMap(root['data']);
  if (data == null || data['data'] is! List) return null;
  EventsListModel model;
  try {
    model = EventsListModel.fromJson(root);
  } catch (_) {
    return null;
  }
  final page = model.data;
  final current = page?.currentPage ?? 1;
  final last = page?.lastPage ?? current;
  return DiscoveryPage(
    engine: 'v1',
    meta: DiscoveryMeta(
      currentPage: current,
      perPage: page?.perPage ?? 12,
      total: page?.total ?? page?.data.length ?? 0,
      lastPage: last,
      nextPage: current < last ? current + 1 : null,
    ),
    message: model.message,
    events: page?.data ?? const [],
  );
}

List<EventData> _events(dynamic raw) {
  if (raw is! List) return const [];
  final events = <EventData>[];
  for (final item in raw) {
    final map = parseMap(item);
    if (map == null) continue;
    try {
      events.add(EventData.fromJson(coerceDiscoveryEventMap(map)));
    } catch (error) {
      discoveryLog('skipped unreadable event id=${map['id']}');
    }
  }
  return events;
}

List<EventData> mergeDiscoveryEvents(
  List<EventData> existing,
  List<EventData> incoming,
) {
  final merged = List<EventData>.from(existing);
  final seen = merged.map((event) => event.id).whereType<int>().toSet();
  for (final event in incoming) {
    final id = event.id;
    if (id != null && !seen.add(id)) continue;
    merged.add(event);
  }
  return merged;
}

/// Pagination fields the existing list widgets already understand.
/// `nextPageUrl` carries V2 `meta.next_page` so a null next page stops scrolling.
class DiscoveryListCursor {
  const DiscoveryListCursor({
    required this.currentPage,
    required this.lastPage,
    required this.nextPage,
    required this.perPage,
    required this.total,
  });

  final int currentPage;
  final int lastPage;
  final int? nextPage;
  final int perPage;
  final int total;

  factory DiscoveryListCursor.fromPage(DiscoveryPage page) {
    final hasNext = page.meta.nextPage != null;
    final current = page.meta.currentPage;
    return DiscoveryListCursor(
      currentPage: current,
      lastPage: hasNext
          ? (page.meta.lastPage > current ? page.meta.lastPage : current + 1)
          : current,
      nextPage: page.meta.nextPage,
      perPage: page.meta.perPage,
      total: page.meta.total,
    );
  }
}

int legacyCompatibleLastPage(DiscoveryPage page) =>
    DiscoveryListCursor.fromPage(page).lastPage;

recommended_feed.RecommendedEventsModel recommendedModelFromPage(
  DiscoveryPage page, {
  List<EventData>? events,
}) {
  final cursor = DiscoveryListCursor.fromPage(page);
  return recommended_feed.RecommendedEventsModel(
    status: true,
    message: page.message,
    data: recommended_feed.Data(
      currentPage: cursor.currentPage,
      lastPage: cursor.lastPage,
      perPage: cursor.perPage,
      total: cursor.total,
      nextPageUrl: cursor.nextPage,
      data: events ?? page.events,
    ),
  );
}

recommended_feed.RecommendedEventsModel emptyRecommendedModel({String? message}) {
  return recommended_feed.RecommendedEventsModel(
    status: false,
    message: message,
    data: recommended_feed.Data(data: [], currentPage: 1, lastPage: 1),
  );
}

EventsListModel eventListFromPage(
  DiscoveryPage page, {
  List<EventData>? events,
}) {
  final cursor = DiscoveryListCursor.fromPage(page);
  return EventsListModel(
    status: true,
    message: page.message,
    data: Data(
      currentPage: cursor.currentPage,
      lastPage: cursor.lastPage,
      perPage: cursor.perPage,
      total: cursor.total,
      nextPageUrl: cursor.nextPage,
      data: events ?? page.events,
    ),
  );
}

EventsListModel emptyEventList({bool success = true, String? message}) {
  return EventsListModel(
    status: success,
    message: message,
    data: Data(data: <EventData>[]),
  );
}
