import 'package:groovkin/utils/json_parsers.dart';
import 'package:intl/intl.dart';

/// Backend role values. UI storage still uses User / eventOrganizer / eventManager.
const kRoleUser = 'user';
const kRoleEventOwner = 'event_owner';
const kRoleVenueManager = 'venue_manager';

const kInviteTypeRegularUser = 'regular_user';
const kInviteTypeVenueManager = 'venue_manager';

const kClosedEventStatuses = {
  'accepted',
  'declined',
  'cancelled',
  'completed',
  'acknowledged',
};

const kBackendDateTimePattern = 'yyyy-MM-dd HH:mm:ss';

const kKnownErrorMessages = <String, String>{
  'invite_invalid': 'Invalid invite code.',
  'invite_email_mismatch':
      'This invite code was issued to a different email address.',
  'invite_email_required': 'Email is required.',
  'invite_expired': 'This invitation has expired.',
  'invite_used': 'This invitation has already been used.',
  'invite_inactive': 'This invitation is no longer active.',
  'invite_role_mismatch':
      'This invite code cannot be used for this account type.',
  'invite_required': 'A valid invite code is required for this account type.',
  'invite_unauthorized':
      'Only Event Organizers are permitted to create/list these invites.',
  'event_not_found': 'Event not found.',
  'event_forbidden': 'You do not have access to this event.',
  'event_not_editable': 'Event cannot be edited in its current state.',
  'counter_not_permitted': 'Event cannot be countered in its current state.',
  'invalid_status_transition':
      'The requested event action is no longer valid.',
  'venue_access_denied': 'This event does not belong to a venue you manage.',
  'validation_error': 'Please check the highlighted fields and try again.',
};

String? backendErrorCode(dynamic response) {
  final body = _responseBody(response);
  if (body is! Map) return null;
  final direct = parseString(body['error_code']);
  if (direct != null) return direct;
  final data = parseMap(body['data']);
  return parseString(data?['error_code']);
}

String? messageForErrorCode(String? code) {
  if (code == null || code.isEmpty) return null;
  return kKnownErrorMessages[code];
}

dynamic _responseBody(dynamic response) {
  if (response is Map) return response;
  try {
    return response?.data ?? response;
  } catch (_) {
    return response;
  }
}

bool isBackendSuccess(dynamic response) {
  if (response == null) return false;
  int? statusCode;
  try {
    statusCode = response.statusCode as int?;
  } catch (_) {
    statusCode = parseInt(_responseBody(response) is Map
        ? (_responseBody(response) as Map)['status_code']
        : null);
  }
  if (statusCode != null && statusCode != 200 && statusCode != 201) {
    return false;
  }
  final body = _responseBody(response);
  if (body is Map && body['status'] == false) return false;
  return statusCode == 200 ||
      statusCode == 201 ||
      (body is Map && body['status'] == true);
}

String? storageRoleFromBackend(String? backendRole) {
  switch (backendRole) {
    case kRoleUser:
      return 'User';
    case kRoleEventOwner:
      return 'eventOrganizer';
    case kRoleVenueManager:
      return 'eventManager';
    default:
      return null;
  }
}

String backendRoleFromStorage(String? storageRole) {
  switch (storageRole) {
    case 'User':
      return kRoleUser;
    case 'eventManager':
      return kRoleVenueManager;
    case 'eventOrganizer':
      return kRoleEventOwner;
    default:
      return kRoleUser;
  }
}

/// Never send `event_organizer` except the backend's documented switch-profile alias.
String switchProfileRole(String? storageRole) {
  return backendRoleFromStorage(storageRole);
}

int? parseEventIdFromPayload(dynamic payload) {
  final root = parseMap(payload) ?? {};
  final data = parseMap(root['data']) ?? root;
  final event = parseMap(data['event']) ?? data;
  return parseInt(event['id'] ?? data['event_id'] ?? root['id']);
}

List<String> parseInvalidateLists(dynamic payload) {
  final root = parseMap(payload) ?? {};
  final data = parseMap(root['data']) ?? root;
  final raw = data['invalidate_lists'] ?? root['invalidate_lists'];
  return parseStringList(raw);
}

bool shouldResetEventChoices({
  required bool isNewEvent,
  required bool isDuplicate,
}) {
  return isNewEvent || isDuplicate;
}

bool shouldShowPreApprovalCounter({
  required bool canCounterRequest,
  String? status,
  bool chatExists = false,
}) {
  if (!canCounterRequest) return false;
  if (kClosedEventStatuses.contains(status)) return false;
  return true;
}

bool shouldShowEoRevise({
  required bool canReviseRequest,
  required bool canEditRequest,
  String? status,
  String? requestStatus,
}) {
  if (canReviseRequest || canEditRequest) return true;
  return status == 'pending' ||
      status == 'countered' ||
      requestStatus == 'countered';
}

String statusAfterResubmit(dynamic payload, {String fallback = 'pending'}) {
  final root = parseMap(payload) ?? {};
  final data = parseMap(root['data']) ?? root;
  return parseString(data['status']) ??
      parseString(data['request_status']) ??
      fallback;
}

bool isResubmittedPayload(dynamic payload) {
  final root = parseMap(payload) ?? {};
  final data = parseMap(root['data']) ?? root;
  return parseBool(data['resubmitted'] ?? root['resubmitted']);
}

Map<String, dynamic> eventCreateCatalogQuery({
  required String type,
  int? eventId,
  bool isPersistedEdit = false,
}) {
  final query = <String, dynamic>{'type': type};
  if (isPersistedEdit && eventId != null) {
    query['event_id'] = eventId;
  } else {
    query['context'] = 'event_create';
  }
  return query;
}

Map<String, String> vmHomeEndpoints({required String section}) {
  switch (section) {
    case 'requests':
      return {
        'url': 'show-venue-requested-events',
        'section': 'requests',
      };
    case 'history':
      return {
        'url': 'show-venue-my-events',
        'section': 'history',
      };
    case 'scheduled':
    default:
      return {
        'url': 'show-venue-my-events',
        'section': 'scheduled',
      };
  }
}

String formatBackendDateTime(DateTime dateTime) {
  return DateFormat(kBackendDateTimePattern).format(dateTime);
}

String? combineBackendDateTime({
  String? dateYmd,
  String? timeText,
}) {
  final date = dateYmd?.trim();
  if (date == null || date.isEmpty) return null;
  final parsed = parseEventTimeParts(timeText);
  final hour = parsed.$1.toString().padLeft(2, '0');
  final minute = parsed.$2.toString().padLeft(2, '0');
  final second = parsed.$3.toString().padLeft(2, '0');
  return '$date $hour:$minute:$second';
}

(int, int, int) parseEventTimeParts(String? timeText) {
  final raw = timeText?.trim() ?? '';
  if (raw.isEmpty) return (0, 0, 0);

  DateTime? parsed;
  final formats = <DateFormat>[
    DateFormat('h:mm a'),
    DateFormat('hh:mm a'),
    DateFormat.jm(),
    DateFormat('HH:mm a'),
    DateFormat('HH:mm:ss'),
    DateFormat('HH:mm'),
  ];
  for (final format in formats) {
    try {
      parsed = format.parse(raw);
      break;
    } catch (_) {}
  }
  if (parsed != null) {
    return (parsed.hour, parsed.minute, parsed.second);
  }

  final token = raw.split(RegExp(r'\s+')).first;
  final parts = token.split(':');
  if (parts.length >= 2) {
    var hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    final second = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;
    final meridian = raw.toLowerCase();
    if (meridian.contains('pm') && hour < 12) hour += 12;
    if (meridian.contains('am') && hour == 12) hour = 0;
    return (hour, minute, second);
  }
  return (0, 0, 0);
}

int paginationCurrentPage(dynamic payload) {
  final data = _paginatedMap(payload);
  return parseInt(data['current_page']) ?? 1;
}

int paginationLastPage(dynamic payload) {
  final data = _paginatedMap(payload);
  return parseInt(data['last_page']) ?? 1;
}

List<dynamic> paginationItems(dynamic payload) {
  final data = _paginatedMap(payload);
  final items = data['data'];
  return items is List ? items : const [];
}

Map<String, dynamic> _paginatedMap(dynamic payload) {
  final root = parseMap(payload) ?? {};
  final data = parseMap(root['data']) ?? root;
  if (data['data'] is List && data.containsKey('current_page')) {
    return data;
  }
  final nested = parseMap(data['data']);
  if (nested != null && nested['data'] is List) return nested;
  return data;
}
