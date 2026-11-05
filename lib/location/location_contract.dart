import 'package:groovkin/utils/json_parsers.dart';

const kLocationAllowed = 'LOCATION_ALLOWED';
const kLocationRestrictionsDisabled = 'LOCATION_RESTRICTIONS_DISABLED';
const kLocationNotSupported = 'LOCATION_NOT_SUPPORTED';
const kLocationRequired = 'LOCATION_REQUIRED';
const kPostalInvalid = 'POSTAL_INVALID';
const kCountryUnknown = 'COUNTRY_UNKNOWN';
const kCountryNotSupported = 'COUNTRY_NOT_SUPPORTED';
const kStateUnknown = 'STATE_UNKNOWN';
const kStateNotSupported = 'STATE_NOT_SUPPORTED';
const kCityUnknown = 'CITY_UNKNOWN';
const kCityNotSupported = 'CITY_NOT_SUPPORTED';
const kGeographyUnverified = 'GEOGRAPHY_UNVERIFIED';
const kGeographyMismatch = 'GEOGRAPHY_MISMATCH';
const kGeographyAmbiguous = 'GEOGRAPHY_AMBIGUOUS';
const kLocationCheckFailed = 'LOCATION_CHECK_FAILED';

const kLocationNetworkMessage =
    'We could not check your area. Check your connection and try again.';
const kLocationServerMessage =
    'Location check is temporarily unavailable. Please try again.';

/// Postal codes stay strings so values such as 08861 keep their leading zero.
String normalizePostal(String raw) => raw.trim();

class LocationPlace {
  const LocationPlace({required this.code, required this.name});

  final String code;
  final String name;
}

class LocationDraft {
  const LocationDraft({
    this.countryCode,
    this.countryName,
    this.stateCode,
    this.stateName,
    this.city,
    this.postalCode = '',
  });

  final String? countryCode;
  final String? countryName;
  final String? stateCode;
  final String? stateName;
  final String? city;
  final String postalCode;

  String get selectionKey =>
      '${countryCode ?? ''}|${stateCode ?? ''}|${city ?? ''}|$postalCode';

  LocationDraft clearedForCountry() => const LocationDraft();

  LocationDraft clearedForState() => LocationDraft(
        countryCode: countryCode,
        countryName: countryName,
      );

  LocationDraft copyWith({
    String? countryCode,
    String? countryName,
    String? stateCode,
    String? stateName,
    String? city,
    String? postalCode,
    bool clearState = false,
    bool clearCity = false,
  }) {
    return LocationDraft(
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      stateCode: clearState ? null : stateCode ?? this.stateCode,
      stateName: clearState ? null : stateName ?? this.stateName,
      city: clearCity || clearState ? null : city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
    );
  }
}

enum LocationCheckKind { allowed, rejected, network, server }

enum LocationFeedback { popup, field }

class LocationCheckResult {
  const LocationCheckResult({
    required this.kind,
    required this.message,
    this.code,
    this.field,
    this.feedback = LocationFeedback.popup,
  });

  final LocationCheckKind kind;
  final String message;
  final String? code;
  final String? field;
  final LocationFeedback feedback;

  bool get allowed => kind == LocationCheckKind.allowed;

  bool get restrictionsDisabled => code == kLocationRestrictionsDisabled;

  factory LocationCheckResult.allowed({String? code, String message = ''}) {
    return LocationCheckResult(
      kind: LocationCheckKind.allowed,
      code: code,
      message: message,
    );
  }

  factory LocationCheckResult.network() {
    return const LocationCheckResult(
      kind: LocationCheckKind.network,
      message: kLocationNetworkMessage,
    );
  }

  factory LocationCheckResult.server([String? message]) {
    return LocationCheckResult(
      kind: LocationCheckKind.server,
      code: kLocationCheckFailed,
      message: (message == null || message.trim().isEmpty)
          ? kLocationServerMessage
          : message.trim(),
    );
  }
}

class ConfirmedLocation {
  const ConfirmedLocation({
    this.countryName = '',
    this.stateName = '',
    this.postalCode = '',
    this.city,
    this.countryCode,
    this.stateCode,
  });

  final String countryName;
  final String stateName;
  final String postalCode;
  final String? city;
  final String? countryCode;
  final String? stateCode;

  bool sameAs(LocationDraft draft) {
    return sameVisible(draft) &&
        _same(countryCode, draft.countryCode) &&
        _same(stateCode, draft.stateCode);
  }

  /// Names and postal code only. Catalog codes can be filled in later
  /// without counting as a user edit.
  bool sameVisible(LocationDraft draft) {
    return _same(countryName, draft.countryName) &&
        _same(stateName, draft.stateName) &&
        normalizePostal(postalCode) == normalizePostal(draft.postalCode) &&
        _same(city, draft.city);
  }

  static bool _same(String? a, String? b) =>
      (a ?? '').trim() == (b ?? '').trim();
}

List<LocationPlace> parseLocationPlaces(
  dynamic body, {
  required String codeKey,
  String nameKey = 'name',
}) {
  final rows = _catalogRows(body);
  final places = <LocationPlace>[];
  for (final row in rows) {
    final code = parseString(row[codeKey]);
    final name = parseString(row[nameKey]) ?? code;
    if (code == null || name == null) continue;
    places.add(LocationPlace(code: code, name: name));
  }
  return places;
}

List<String> parseCityNames(dynamic body) {
  final rows = _catalogRows(body);
  final names = <String>[];
  for (final row in rows) {
    final name = parseString(row['name'] ?? row['city']);
    if (name != null && !names.contains(name)) names.add(name);
  }
  return names;
}

List<Map<String, dynamic>> _catalogRows(dynamic body) {
  final root = _unwrapBody(body);
  if (root is List) {
    return root.map(parseMap).whereType<Map<String, dynamic>>().toList();
  }
  final map = parseMap(root);
  if (map == null) return const [];
  final data = map['data'];
  if (data is List) {
    return data.map(parseMap).whereType<Map<String, dynamic>>().toList();
  }
  final nested = parseMap(data);
  if (nested != null) {
    for (final key in ['data', 'countries', 'states', 'cities']) {
      final value = nested[key];
      if (value is List) {
        return value.map(parseMap).whereType<Map<String, dynamic>>().toList();
      }
    }
  }
  for (final key in ['countries', 'states', 'cities']) {
    final value = map[key];
    if (value is List) {
      return value.map(parseMap).whereType<Map<String, dynamic>>().toList();
    }
  }
  return const [];
}

dynamic _unwrapBody(dynamic body) {
  if (body == null) return null;
  try {
    final data = body.data;
    if (data != null) return data;
  } catch (_) {}
  return body;
}

int? _statusCode(dynamic response) {
  try {
    return response.statusCode as int?;
  } catch (_) {
    return null;
  }
}

LocationCheckResult interpretLocationResponse(dynamic response) {
  if (response == null) return LocationCheckResult.network();
  final statusCode = _statusCode(response);
  if (statusCode == null || statusCode == 0) {
    return LocationCheckResult.network();
  }
  if (statusCode >= 500) {
    return LocationCheckResult.server(_messageOf(response));
  }

  final body = parseMap(_unwrapBody(response)) ?? const <String, dynamic>{};
  final data = parseMap(body['data']);
  final code = parseString(body['code']) ??
      parseString(body['error_code']) ??
      parseString(data?['code']) ??
      parseString(data?['error_code']);
  final message = _messageOf(response) ?? '';
  final allowedFlag = body['allowed'] ?? data?['allowed'];
  final allowed = allowedFlag == true ||
      code == kLocationAllowed ||
      code == kLocationRestrictionsDisabled;

  if (statusCode == 200 && allowed && code != kLocationCheckFailed) {
    return LocationCheckResult.allowed(code: code, message: message);
  }

  if (code == kLocationCheckFailed || statusCode >= 500) {
    return LocationCheckResult.server(
      message.isEmpty ? null : message,
    );
  }

  final field = fieldForLocationCode(code);
  return LocationCheckResult(
    kind: LocationCheckKind.rejected,
    code: code,
    message: message.isEmpty
        ? 'Groovkin could not accept this location.'
        : message,
    field: field,
    feedback: feedbackForLocationCode(code),
  );
}

String? _messageOf(dynamic response) {
  final body = parseMap(_unwrapBody(response));
  if (body == null) return null;
  final data = parseMap(body['data']);
  return parseString(body['message']) ?? parseString(data?['message']);
}

String? fieldForLocationCode(String? code) {
  switch (code) {
    case kPostalInvalid:
      return 'postal';
    case kCountryUnknown:
    case kCountryNotSupported:
      return 'country';
    case kStateUnknown:
    case kStateNotSupported:
    case kGeographyMismatch:
      return 'state';
    case kCityUnknown:
    case kCityNotSupported:
      return 'city';
    default:
      return null;
  }
}

LocationFeedback feedbackForLocationCode(String? code) {
  switch (code) {
    case kPostalInvalid:
    case kCountryUnknown:
    case kCountryNotSupported:
    case kStateUnknown:
    case kStateNotSupported:
    case kCityUnknown:
    case kCityNotSupported:
    case kGeographyMismatch:
    case kLocationRequired:
      return LocationFeedback.field;
    default:
      return LocationFeedback.popup;
  }
}

/// Local checks before the preflight call. These are not area-restriction claims.
LocationCheckResult? localLocationValidation(
  LocationDraft draft, {
  required bool catalogsReady,
}) {
  if (!catalogsReady) return null;
  if ((draft.countryCode ?? '').isEmpty) {
    return const LocationCheckResult(
      kind: LocationCheckKind.rejected,
      code: kLocationRequired,
      field: 'country',
      feedback: LocationFeedback.field,
      message: 'Select a country.',
    );
  }
  if ((draft.stateCode ?? '').isEmpty) {
    return const LocationCheckResult(
      kind: LocationCheckKind.rejected,
      code: kLocationRequired,
      field: 'state',
      feedback: LocationFeedback.field,
      message: 'Select a state.',
    );
  }
  if (normalizePostal(draft.postalCode).isEmpty) {
    return const LocationCheckResult(
      kind: LocationCheckKind.rejected,
      code: kPostalInvalid,
      field: 'postal',
      feedback: LocationFeedback.field,
      message: 'Enter your ZIP or postal code.',
    );
  }
  return null;
}

Map<String, dynamic> eligibilityRequestBody(LocationDraft draft) {
  return <String, dynamic>{
    'country_code': draft.countryCode,
    'state_code': draft.stateCode,
    'postal_code': normalizePostal(draft.postalCode),
    if ((draft.city ?? '').trim().isNotEmpty) 'city': draft.city!.trim(),
  };
}

/// Existing profile columns stay `country`, `select_state`, and `zip_code`.
/// Catalog codes are added only after a structured selection so login does
/// not send an empty code that conflicts with a saved name.
Map<String, String> registrationLocationFields(
  LocationDraft draft, {
  required bool includeCodes,
}) {
  final fields = <String, String>{};
  final country = _text(draft.countryName) ?? _text(draft.countryCode);
  final state = _text(draft.stateName) ?? _text(draft.stateCode);
  final postal = normalizePostal(draft.postalCode);
  if (country != null) fields['country'] = country;
  if (state != null) fields['select_state'] = state;
  if (postal.isNotEmpty) fields['zip_code'] = postal;
  final city = _text(draft.city);
  if (city != null) fields['city'] = city;
  if (includeCodes) {
    final countryCode = _text(draft.countryCode);
    final stateCode = _text(draft.stateCode);
    if (countryCode != null) fields['country_code'] = countryCode;
    if (stateCode != null) fields['state_code'] = stateCode;
  }
  return fields;
}

String? _text(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return null;
  return text;
}

bool isLocationErrorCode(String? code) {
  if (code == null || code.isEmpty) return false;
  const codes = {
    kLocationNotSupported,
    kLocationRequired,
    kPostalInvalid,
    kCountryUnknown,
    kCountryNotSupported,
    kStateUnknown,
    kStateNotSupported,
    kCityUnknown,
    kCityNotSupported,
    kGeographyUnverified,
    kGeographyMismatch,
    kGeographyAmbiguous,
    kLocationCheckFailed,
  };
  return codes.contains(code);
}
