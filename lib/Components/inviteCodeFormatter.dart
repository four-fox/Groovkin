import 'package:flutter/services.dart';
import 'package:groovkin/utils/invite_code.dart';

/// Uppercases, allows A-Z/0-9, auto-inserts one hyphen after 4 characters,
/// and rejects pastes of the old long invite format.
class InviteCodeInputFormatter extends TextInputFormatter {
  const InviteCodeInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (inviteCodeExceedsCanonicalLength(newValue.text) &&
        newValue.text.length > oldValue.text.length + 1) {
      return oldValue;
    }
    final formatted = formatInviteCodeInput(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
