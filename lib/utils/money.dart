/// Integer minor-unit money helpers. Avoids floating-point for API payloads.
int? dollarsToMinorUnits(String input) {
  final cleaned = input.trim().replaceAll(RegExp(r'[\$,\s]'), '');
  if (cleaned.isEmpty || cleaned.startsWith('-')) return null;
  final parts = cleaned.split('.');
  if (parts.length > 2) return null;
  final dollarText = parts[0].isEmpty ? '0' : parts[0];
  if (!RegExp(r'^\d+$').hasMatch(dollarText)) return null;
  var centsText = parts.length == 2 ? parts[1] : '00';
  if (centsText.length > 2) return null;
  if (centsText.isEmpty) centsText = '00';
  if (!RegExp(r'^\d+$').hasMatch(centsText)) return null;
  centsText = centsText.padRight(2, '0');
  final dollars = int.tryParse(dollarText);
  final cents = int.tryParse(centsText);
  if (dollars == null || cents == null) return null;
  return dollars * 100 + cents;
}

class EventCounterEndpoints {
  static String list(int eventId) => 'events/$eventId/counters';
  static String create(int eventId) => 'events/$eventId/counters';
  static String accept(int counterId) => 'counters/$counterId/accept';
  static String reject(int counterId) => 'counters/$counterId/reject';
  static String counterAgain(int counterId) => 'counters/$counterId/counter';
  static String approveCompletion(int eventId) =>
      'events/$eventId/completion/approve';
}
