import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/model/invite_model.dart';
import 'package:groovkin/utils/backend_contract.dart';
import 'package:groovkin/utils/invite_code.dart';

void main() {
  group('canonical invite format', () {
    test('accepts XXXX-XXXX letters and digits', () {
      for (final code in ['9AXG-8JXL', 'NAUK-CKZ9', 'AB12-CD34', 'Z3LL-905L']) {
        expect(isCanonicalInviteCode(code), isTrue, reason: code);
      }
    });

    test('rejects unhyphenated-as-canonical, short, and old long format', () {
      expect(isCanonicalInviteCode('12345678'), isFalse);
      expect(isCanonicalInviteCode('NAUKCKZ9'), isFalse);
      expect(isCanonicalInviteCode('ABC-1234'), isFalse);
      expect(isCanonicalInviteCode('ABCD-12345'), isFalse);
      expect(isCanonicalInviteCode('1E1A-540D-C658-5E10'), isFalse);
      expect(inviteCodeExceedsCanonicalLength('1E1A-540D-C658-5E10'), isTrue);
      expect(canonicalInviteCodeOrNull('ABC-1234'), isNull);
      expect(canonicalInviteCodeOrNull('ABCD-12345'), isNull);
      expect(canonicalInviteCodeOrNull('1E1A-540D-C658-5E10'), isNull);
      expect(canonicalInviteCodeOrNull('NAUKCKZ9'), 'NAUK-CKZ9');
    });

    test('normalizes lowercase and surrounding spaces without dropping hyphen', () {
      expect(normalizeInviteCode('nauk-ckz9'), 'NAUK-CKZ9');
      expect(normalizeInviteCode('  9axg-8jxl '), '9AXG-8JXL');
      expect(isCanonicalInviteCode('  nauk-ckz9  '), isTrue);
      expect(canonicalInviteCodeOrNull('  9axg-8jxl '), '9AXG-8JXL');
    });

    test('auto-hyphen formats 8 alphanumeric characters', () {
      expect(formatInviteCodeInput('naukckz9'), 'NAUK-CKZ9');
      expect(formatInviteCodeInput('9axg-8jxl'), '9AXG-8JXL');
    });
  });

  group('invite response parsing', () {
    test('keeps backend code unchanged and treats SMTP failure as created', () {
      const code = '9AXG-8JXL';
      final invite = parseInviteRecord({
        'status': true,
        'data': {
          'id': 12,
          'invite_type': 'regular_user',
          'role': 'user',
          'email': 'friend@example.com',
          'code': code,
          'status': 'active',
          'is_active': true,
          'max_uses': 1,
          'used_count': 0,
          'expires_at': '2026-10-02T18:00:00.000000Z',
          'email_sent': false,
          'email_error':
              'Invite was created but email could not be sent. Copy and share the code instead.',
          'share_text': 'Join Groovkin as Regular User. Invite code: $code',
        },
      });

      expect(isBackendSuccess({'status': true, 'data': invite}), isTrue);
      expect(invite!.code, code);
      expect(invite.code, isNot(contains('1E1A-540D')));
      expect(invite.emailSent, isFalse);
      expect(invite.createdSuccessfully, isTrue);
      expect(invite.shareText, contains(code));
    });

    test('parses venue manager invite with canonical code as String', () {
      final invite = parseInviteRecord({
        'status': true,
        'data': {
          'invite_type': 'venue_manager',
          'role': 'venue_manager',
          'email': 'venue.manager@example.com',
          'code': '9AXG-8JXL',
          'status': 'active',
          'email_sent': true,
        },
      });
      expect(invite!.inviteType, kInviteTypeVenueManager);
      expect(invite.role, kRoleVenueManager);
      expect(invite.code, isA<String>());
      expect(invite.code, '9AXG-8JXL');
      expect(isCanonicalInviteCode(invite.code!), isTrue);
    });
  });
}
