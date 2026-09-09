String backendErrorMessage(
  dynamic response, {
  String? field,
  String fallback = 'Something went wrong. Please try again.',
}) {
  dynamic body = response;
  if (response is! Map) {
    try {
      body = response?.data ?? response;
    } catch (_) {
      body = response;
    }
  }
  if (body is! Map) return fallback;

  final errors = body['errors'];
  if (errors is Map) {
    dynamic value;
    if (field != null) value = errors[field];
    value ??= errors.isNotEmpty ? errors.values.first : null;
    final parsed = _messageValue(value);
    if (parsed != null) return parsed;
  }

  final dataMessage = _messageValue(body['data']);
  if (dataMessage != null) return dataMessage;
  final message = _messageValue(body['message']);
  return message ?? fallback;
}

String? _messageValue(dynamic value) {
  if (value is String && value.trim().isNotEmpty) return value.trim();
  if (value is List && value.isNotEmpty) return _messageValue(value.first);
  return null;
}
