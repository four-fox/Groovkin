/// Canonical invite-code contract: XXXX-XXXX (A-Z, 0-9).
final kCanonicalInviteCodeRegExp = RegExp(r'^[A-Z0-9]{4}-[A-Z0-9]{4}$');

const kInviteCodeHint = 'XXXX-XXXX';

const kInviteCodeFormatError =
    'Invite code must be 8 letters or numbers with a hyphen, like AB12-CD34.';

/// Trim surrounding whitespace and uppercase letters. Does not strip the hyphen.
String normalizeInviteCode(String raw) => raw.trim().toUpperCase();

int inviteCodeAlphanumericLength(String raw) {
  return normalizeInviteCode(raw).replaceAll(RegExp(r'[^A-Z0-9]'), '').length;
}

bool inviteCodeExceedsCanonicalLength(String raw) {
  return inviteCodeAlphanumericLength(raw) > 8;
}

/// Formats typed/pasted input toward XXXX-XXXX. Extra characters beyond 8
/// alphanumerics are not kept. Does not invent a hyphen until 5+ chars exist.
String formatInviteCodeInput(String raw) {
  final alnum = StringBuffer();
  for (final rune in normalizeInviteCode(raw).runes) {
    final ch = String.fromCharCode(rune);
    if (RegExp(r'[A-Z0-9]').hasMatch(ch)) {
      alnum.write(ch);
      if (alnum.length == 8) break;
    }
  }
  final chars = alnum.toString();
  if (chars.length <= 4) return chars;
  return '${chars.substring(0, 4)}-${chars.substring(4)}';
}

bool isCanonicalInviteCode(String raw) {
  return kCanonicalInviteCodeRegExp.hasMatch(normalizeInviteCode(raw));
}

/// Value that must be sent to the backend. Returns null when empty after trim
/// or when the input is not exactly 8 alphanumeric characters (optionally
/// hyphenated). Unhyphenated 8-character input is formatted to XXXX-XXXX.
String? canonicalInviteCodeOrNull(String raw) {
  if (inviteCodeExceedsCanonicalLength(raw)) return null;
  final normalized = normalizeInviteCode(raw);
  if (normalized.isEmpty) return null;
  if (isCanonicalInviteCode(normalized)) return normalized;
  if (inviteCodeAlphanumericLength(raw) != 8) return null;
  final formatted = formatInviteCodeInput(normalized);
  if (isCanonicalInviteCode(formatted)) return formatted;
  return null;
}
