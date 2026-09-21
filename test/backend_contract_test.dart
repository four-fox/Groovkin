import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/Components/Network/backend_error.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userEventDetailsModel.dart';
import 'package:groovkin/model/invite_model.dart';
import 'package:groovkin/utils/backend_contract.dart';

void main() {
  group('invite response parsing', () {
    test('parses regular user invite and treats SMTP failure as created', () {
      final invite = parseInviteRecord({
        'status': true,
        'data': {
          'id': 12,
          'invite_type': 'regular_user',
          'role': 'user',
          'email': 'friend@example.com',
          'code': 'A1B2-C3D4-E5F6-7788',
          'status': 'active',
          'is_active': true,
          'max_uses': 1,
          'used_count': 0,
          'expires_at': '2026-10-02T18:00:00.000000Z',
          'email_sent': false,
          'email_error':
              'Invite was created but email could not be sent. Copy and share the code instead.',
          'share_text':
              'Join Groovkin as Regular User. Invite code: A1B2-C3D4-E5F6-7788',
        },
      });

      expect(isBackendSuccess({'status': true, 'data': invite}), isTrue);
      expect(invite!.code, 'A1B2-C3D4-E5F6-7788');
      expect(invite.emailSent, isFalse);
      expect(invite.createdSuccessfully, isTrue);
      expect(invite.shareText, contains('A1B2-C3D4-E5F6-7788'));
    });

    test('parses venue manager invite', () {
      final invite = parseInviteRecord({
        'status': true,
        'data': {
          'invite_type': 'venue_manager',
          'role': 'venue_manager',
          'email': 'venue.manager@example.com',
          'code': '9F3A-10BC-44DE-87FF',
          'status': 'active',
          'email_sent': true,
        },
      });
      expect(invite!.inviteType, kInviteTypeVenueManager);
      expect(invite.role, kRoleVenueManager);
    });
  });

  group('error_code mapping', () {
    test('maps known invite and event codes before generic message', () {
      expect(
        backendErrorMessage({
          'status': false,
          'error_code': 'invite_email_mismatch',
          'data': 'ignored',
          'message': 'Forbidden',
        }),
        'This invite code was issued to a different email address.',
      );
      expect(
        backendErrorMessage({
          'status': false,
          'error_code': 'event_forbidden',
          'message': 'Forbidden',
        }),
        'You do not have access to this event.',
      );
      expect(
        backendErrorMessage({
          'status': false,
          'data': 'Human readable message',
          'message': 'Forbidden',
        }),
        'Human readable message',
      );
    });
  });

  group('duplicate event identity', () {
    test('uses the new event id not the source id', () {
      final payload = {
        'status': true,
        'data': {
          'id': 99,
          'source_event_id': 10,
          'manual_hashtags': ['algreen'],
          'service_id': [],
          'music_choice_tag': [],
          'activity_choice_tag': [],
        },
      };
      expect(parseEventIdFromPayload(payload), 99);
      expect(parseEventIdFromPayload(payload), isNot(10));
    });
  });

  group('event choices reset', () {
    test('new and duplicate events reset services/music/activities', () {
      expect(
        shouldResetEventChoices(isNewEvent: true, isDuplicate: false),
        isTrue,
      );
      expect(
        shouldResetEventChoices(isNewEvent: false, isDuplicate: true),
        isTrue,
      );
      expect(
        shouldResetEventChoices(isNewEvent: false, isDuplicate: false),
        isFalse,
      );
      expect(
        eventCreateCatalogQuery(type: 'music_choice')['context'],
        'event_create',
      );
      expect(
        eventCreateCatalogQuery(
          type: 'services',
          eventId: 44,
          isPersistedEdit: true,
        )['event_id'],
        44,
      );
    });
  });

  group('pre-approval counter visibility', () {
    test('shows counter from can_counter_request even if chat exists', () {
      expect(
        shouldShowPreApprovalCounter(
          canCounterRequest: true,
          status: 'pending',
          chatExists: true,
        ),
        isTrue,
      );
      expect(
        shouldShowPreApprovalCounter(
          canCounterRequest: false,
          status: 'pending',
          chatExists: false,
        ),
        isFalse,
      );
      expect(
        shouldShowPreApprovalCounter(
          canCounterRequest: true,
          status: 'accepted',
        ),
        isFalse,
      );
    });
  });

  group('resubmit status', () {
    test('countered becomes pending after resubmit response', () {
      expect(
        statusAfterResubmit({
          'status': true,
          'data': {
            'id': 44,
            'status': 'pending',
            'resubmitted': 1,
          },
        }),
        'pending',
      );
      expect(
        isResubmittedPayload({
          'data': {'resubmitted': 1}
        }),
        isTrue,
      );
    });
  });

  group('pagination parsing', () {
    test('reads laravel pagination inside data', () {
      final payload = {
        'status': true,
        'data': {
          'current_page': 1,
          'last_page': 3,
          'data': [
            {'id': 1},
            {'id': 2},
          ],
        },
      };
      expect(paginationCurrentPage(payload), 1);
      expect(paginationLastPage(payload), 3);
      expect(paginationItems(payload), hasLength(2));
    });
  });

  group('invalidation keys', () {
    test('parses invalidate_lists from mutation data', () {
      expect(
        parseInvalidateLists({
          'status': true,
          'data': {
            'invalidate_lists': [
              'show-requested-events',
              'show-venue-requested-events',
            ],
          },
        }),
        [
          'show-requested-events',
          'show-venue-requested-events',
        ],
      );
    });
  });

  group('VM tab endpoint mapping', () {
    test('uses venue-scoped endpoints and explicit sections', () {
      expect(vmHomeEndpoints(section: 'scheduled')['url'],
          'show-venue-my-events');
      expect(vmHomeEndpoints(section: 'scheduled')['section'], 'scheduled');
      expect(vmHomeEndpoints(section: 'requests')['url'],
          'show-venue-requested-events');
      expect(vmHomeEndpoints(section: 'history')['section'], 'history');
    });
  });

  group('datetime payloads', () {
    test('formats naive backend datetimes without Z', () {
      expect(
        combineBackendDateTime(dateYmd: '2026-09-22', timeText: '8:00 PM'),
        '2026-09-22 20:00:00',
      );
      expect(
        combineBackendDateTime(dateYmd: '2026-09-22', timeText: '20:00'),
        '2026-09-22 20:00:00',
      );
      expect(
        formatBackendDateTime(DateTime(2026, 9, 22, 20, 0, 0)),
        '2026-09-22 20:00:00',
      );
      expect(
        combineBackendDateTime(dateYmd: '2026-09-22', timeText: '8:00 PM')!
            .contains('Z'),
        isFalse,
      );
    });
  });

  group('event details negotiation fields', () {
    test('parses can_edit_request and counter_comment', () {
      final details = EventDetails.fromJson({
        'id': 44,
        'status': 'countered',
        'request_status': 'countered',
        'negotiation_stage': 'pre_approval',
        'is_counter_active': 1,
        'can_counter_request': 1,
        'can_revise_request': 1,
        'can_resubmit_request': 1,
        'can_edit_request': 1,
        'counter_comment': 'Please lower the hourly rate to 80',
      });
      expect(details.canEditRequest, isTrue);
      expect(details.canCounterRequest, isTrue);
      expect(details.counterComment, 'Please lower the hourly rate to 80');
      expect(details.negotiationStage, 'pre_approval');
      expect(
        shouldShowEoRevise(
          canReviseRequest: details.canReviseRequest,
          canEditRequest: details.canEditRequest,
          status: details.status,
          requestStatus: details.requestStatus,
        ),
        isTrue,
      );
    });
  });

  group('roles', () {
    test('maps storage and backend roles without event_organizer', () {
      expect(backendRoleFromStorage('eventOrganizer'), kRoleEventOwner);
      expect(backendRoleFromStorage('eventManager'), kRoleVenueManager);
      expect(storageRoleFromBackend('event_owner'), 'eventOrganizer');
      expect(switchProfileRole('eventOrganizer'), isNot('event_organizer'));
    });
  });
}
