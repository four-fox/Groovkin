import 'package:groovkin/location/location_contract.dart';
import 'package:groovkin/utils/json_parsers.dart';

enum SocialRegisterOutcome {
  authenticated,
  needsLocation,
  rejected,
  expiredCredential,
  failed,
}

class SocialRegisterDecision {
  const SocialRegisterDecision({
    required this.outcome,
    this.message = '',
    this.code,
  });

  final SocialRegisterOutcome outcome;
  final String message;
  final String? code;

  bool get needsLocation => outcome == SocialRegisterOutcome.needsLocation;
}

const _locationErrorKeys = <String>{
  'country',
  'country_code',
  'select_state',
  'state',
  'state_code',
  'city',
  'zip_code',
  'zip',
  'postal_code',
};

/// Decides what a `/api/register` social response means.
///
/// A Groovkin session token means the account already exists or was created.
/// Location onboarding is only for a response that refuses creation because
/// country, state, or ZIP is missing. Other failures stay failures.
SocialRegisterDecision decideSocialRegister(
  dynamic response, {
  required bool locationWasAttached,
}) {
  final status = _statusOf(response);
  final body = _bodyOf(response);
  if (status == null || status == 0) {
    return const SocialRegisterDecision(
      outcome: SocialRegisterOutcome.failed,
      message: kLocationNetworkMessage,
    );
  }

  if (_hasSessionToken(body)) {
    return const SocialRegisterDecision(
      outcome: SocialRegisterOutcome.authenticated,
    );
  }

  if (status >= 500) {
    final location = interpretLocationResponse(response);
    return SocialRegisterDecision(
      outcome: SocialRegisterOutcome.failed,
      message: location.message,
      code: location.code,
    );
  }

  if (_isExpiredCredential(status, body)) {
    return SocialRegisterDecision(
      outcome: SocialRegisterOutcome.expiredCredential,
      message: _messageOf(body).isEmpty
          ? 'Google sign-in expired. Please continue with Google again.'
          : _messageOf(body),
      code: _codeOf(body),
    );
  }

  if (_isDuplicateAccount(body)) {
    return SocialRegisterDecision(
      outcome: SocialRegisterOutcome.rejected,
      message: _messageOf(body).isEmpty
          ? 'This Google account is already registered. Sign in instead.'
          : _messageOf(body),
      code: _codeOf(body),
    );
  }

  final location = interpretLocationResponse(response);
  if (!locationWasAttached && _needsLocationOnboarding(location, body)) {
    return SocialRegisterDecision(
      outcome: SocialRegisterOutcome.needsLocation,
      message: location.message,
      code: location.code ?? kLocationRequired,
    );
  }

  if (location.kind == LocationCheckKind.network) {
    return SocialRegisterDecision(
      outcome: SocialRegisterOutcome.failed,
      message: location.message,
      code: location.code,
    );
  }

  return SocialRegisterDecision(
    outcome: SocialRegisterOutcome.rejected,
    message: location.message.isEmpty ? _messageOf(body) : location.message,
    code: location.code ?? _codeOf(body),
  );
}

class PendingSocialCredential {
  String? platform;
  String? token;

  bool get isHeld =>
      platform != null && platform!.isNotEmpty && (token ?? '').isNotEmpty;

  void hold(String platform, String token) {
    this.platform = platform;
    this.token = token;
  }

  void clear() {
    platform = null;
    token = null;
  }
}

bool _needsLocationOnboarding(LocationCheckResult location, Map body) {
  if (location.code == kLocationRequired) return true;
  if (location.code == kLocationNotSupported && location.kind == LocationCheckKind.rejected) {
    return true;
  }
  if (_onlyLocationValidation(body)) return true;
  final requires = body['requires_location'] == true ||
      parseMap(body['data'])?['requires_location'] == true;
  if (requires) return true;
  final message = _messageOf(body).toLowerCase();
  if (message.isEmpty) return false;
  const hints = ['country', 'zip', 'postal', 'select_state', 'state code'];
  return hints.any(message.contains) &&
      (message.contains('required') || message.contains('missing'));
}

bool _onlyLocationValidation(Map body) {
  final errors = body['errors'];
  if (errors is! Map || errors.isEmpty) return false;
  for (final key in errors.keys) {
    if (!_locationErrorKeys.contains(key.toString())) return false;
  }
  return true;
}

bool _isDuplicateAccount(Map body) {
  final code = (_codeOf(body) ?? '').toLowerCase();
  const codes = {
    'email_taken',
    'already_registered',
    'account_exists',
    'duplicate_account',
  };
  if (codes.contains(code)) return true;
  final message = _messageOf(body).toLowerCase();
  return message.contains('already been taken') ||
      message.contains('already registered') ||
      message.contains('already exists');
}

bool _isExpiredCredential(int status, Map body) {
  final code = (_codeOf(body) ?? '').toLowerCase();
  const codes = {
    'invalid_token',
    'token_expired',
    'google_token_expired',
    'credential_expired',
  };
  if (codes.contains(code)) return true;
  if (status == 401) {
    final message = _messageOf(body).toLowerCase();
    if (message.contains('unauthenticated')) return false;
    return message.contains('token') ||
        message.contains('credential') ||
        message.contains('expired');
  }
  final message = _messageOf(body).toLowerCase();
  return message.contains('expired') &&
      (message.contains('token') || message.contains('credential'));
}

bool _hasSessionToken(Map body) {
  final data = parseMap(body['data']) ?? body;
  final token = parseString(data['token'] ?? body['token']);
  return token != null && token.isNotEmpty;
}

int? _statusOf(dynamic response) {
  if (response is Map) {
    return parseInt(response['statusCode'] ?? response['status_code']);
  }
  try {
    return response?.statusCode as int?;
  } catch (_) {
    return null;
  }
}

Map<String, dynamic> _bodyOf(dynamic response) {
  if (response is Map<String, dynamic>) return response;
  if (response is Map) return Map<String, dynamic>.from(response);
  try {
    final data = response?.data;
    final parsed = parseMap(data);
    if (parsed != null) return parsed;
  } catch (_) {}
  return const {};
}

String? _codeOf(Map body) {
  final data = parseMap(body['data']);
  return parseString(body['code']) ??
      parseString(body['error_code']) ??
      parseString(data?['code']) ??
      parseString(data?['error_code']);
}

String _messageOf(Map body) {
  final data = parseMap(body['data']);
  return parseString(body['message']) ?? parseString(data?['message']) ?? '';
}
