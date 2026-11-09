import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/Components/mediaModel.dart';
import 'package:groovkin/auth/profile_zip.dart';
import 'package:groovkin/auth/social_register_decision.dart';
import 'package:groovkin/location/location_contract.dart';
import 'package:groovkin/location/location_controller.dart';
import 'package:groovkin/location/location_repository.dart';
import 'package:groovkin/utils/event_media.dart';

class _Response {
  _Response(this.statusCode, this.data);

  final int statusCode;
  final dynamic data;
}

void main() {
  group('event media', () {
    test('accepts JPG and PNG and rejects videos', () {
      expect(
        classifyEventFile(
          path: 'banner.JPG',
          header: const [0xFF, 0xD8, 0xFF, 0xE0],
        ).accept,
        isTrue,
      );
      expect(
        classifyEventFile(
          path: 'photo.png',
          header: const [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A],
        ).accept,
        isTrue,
      );
      for (final name in ['clip.mp4', 'a.mov', 'a.avi', 'a.mkv', 'a.webm', 'a.3gp']) {
        final verdict = classifyEventFile(path: name);
        expect(verdict.accept, isFalse, reason: name);
        expect(verdict.isVideo, isTrue, reason: name);
        expect(verdict.message, eventVideoRejectedMessage);
      }
    });

    test('sniffs video bytes when the extension or mime type lies', () {
      const ftyp = [0, 0, 0, 0x18, 0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32];
      final renamed = classifyEventFile(
        path: 'not-a-photo.jpg',
        mimeType: 'application/octet-stream',
        header: ftyp,
      );
      expect(renamed.isVideo, isTrue);
      expect(renamed.accept, isFalse);

      final missingExtension = classifyEventFile(
        path: 'camera-upload',
        mimeType: 'application/octet-stream',
        header: const [0xFF, 0xD8, 0xFF, 0xDB],
      );
      expect(missingExtension.accept, isTrue);
      expect(missingExtension.isVideo, isFalse);
    });

    test('a mixed selection never treats the video as uploadable', () async {
      final dir = await Directory.systemTemp.createTemp('groovkin-event-media');
      final jpg = File('${dir.path}/banner.jpg')
        ..writeAsBytesSync(const [0xFF, 0xD8, 0xFF, 0xD9]);
      final png = File('${dir.path}/gallery.png')
        ..writeAsBytesSync(const [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);
      final mp4 = File('${dir.path}/clip.mp4')..writeAsBytesSync(
          const [0, 0, 0, 0x18, 0x66, 0x74, 0x79, 0x70, 0x69, 0x73, 0x6F, 0x6D],
        );
      final gate = await guardEventUploads(
        attachments: [
          MediaClass(filename: png.path, fileType: 'png'),
          MediaClass(filename: mp4.path, fileType: 'mp4', thumbnail: '/tmp/thumb.png'),
        ],
        bannerPath: jpg.path,
      );
      expect(gate.canSubmit, isFalse);
      expect(gate.clearBanner, isFalse);
      expect(gate.rejected.single.filename, mp4.path);
      expect(gate.message, eventVideoRejectedMessage);
      expect(eventAttachmentIsVideo(gate.rejected.single), isTrue);
      await dir.delete(recursive: true);
    });

    test('a valid banner is not cleared', () async {
      final dir = await Directory.systemTemp.createTemp('groovkin-banner');
      final jpg = File('${dir.path}/flyer.jpg')
        ..writeAsBytesSync(const [0xFF, 0xD8, 0xFF, 0xD9]);
      final gate = await guardEventUploads(
        attachments: [
          MediaClass(filename: jpg.path, fileType: 'jpg'),
        ],
        bannerPath: jpg.path,
      );
      expect(gate.canSubmit, isTrue);
      expect(gate.clearBanner, isFalse);
      expect(gate.rejected, isEmpty);
      await dir.delete(recursive: true);
    });
  });

  group('signup reset', () {
    test('a new role drops the previous country, state, and ZIP', () async {
      final controller = LocationAvailabilityController(repository: _QuietCatalog());
      controller.draft = const LocationDraft(
        countryCode: 'US',
        countryName: 'United States',
        stateCode: 'NJ',
        stateName: 'New Jersey',
        city: 'Newark',
        postalCode: '08861',
      );
      controller.postalController.text = '08861';
      controller.fieldError = 'Select a state.';
      controller.confirmed = const ConfirmedLocation(
        countryName: 'United States',
        stateName: 'New Jersey',
        postalCode: '08861',
      );

      expect(controller.draft.postalCode, '08861');
      controller.resetRegistrationDraft();

      expect(controller.draft.countryCode, isNull);
      expect(controller.draft.stateCode, isNull);
      expect(controller.draft.city, isNull);
      expect(controller.draft.postalCode, isEmpty);
      expect(controller.postalController.text, isEmpty);
      expect(controller.fieldError, isNull);
      expect(controller.confirmed, isNull);
    });

    test('a late state catalog cannot restore a reset draft', () async {
      final source = _HoldStates();
      final controller = LocationAvailabilityController(repository: source);
      controller.draft = const LocationDraft(
        countryCode: 'US',
        countryName: 'United States',
        postalCode: '08861',
      );
      controller.postalController.text = '08861';
      final selection = controller.selectCountry(
        const LocationPlace(code: 'US', name: 'United States'),
      );
      controller.resetRegistrationDraft();
      source.statesResponse.complete(_Response(200, {
        'data': [
          {'state_code': 'NJ', 'name': 'New Jersey'},
        ],
      }));
      await selection;
      expect(controller.draft.countryCode, isNull);
      expect(controller.draft.stateName, isNull);
      expect(controller.draft.postalCode, isEmpty);
      expect(controller.states, isEmpty);
    });

    test('changing state clears the previous city and ZIP', () async {
      final controller = LocationAvailabilityController(repository: _QuietCatalog());
      controller.draft = const LocationDraft(
        countryCode: 'US',
        countryName: 'United States',
        stateCode: 'NJ',
        stateName: 'New Jersey',
        city: 'Newark',
        postalCode: '08861',
      );
      controller.postalController.text = '08861';
      await controller.selectState(const LocationPlace(code: 'NY', name: 'New York'));
      expect(controller.draft.countryCode, 'US');
      expect(controller.draft.stateCode, 'NY');
      expect(controller.draft.city, isNull);
      expect(controller.draft.postalCode, isEmpty);
      expect(controller.postalController.text, isEmpty);
    });

    test('google credentials do not survive a new role', () {
      final social = PendingSocialCredential()..hold('google', 'ya29.secret');
      expect(social.isHeld, isTrue);
      social.clear();
      expect(social.isHeld, isFalse);
      expect(social.token, isNull);
    });
  });

  group('home ZIP', () {
    test('reads ZIP from the auth payload without opening profile', () {
      final model = profileModelFromAuthPayload({
        'token': 'sanctum',
        'user_details': {
          'id': 7,
          'name': 'Ava',
          'profile': {
            'zip_code': '08861',
            'select_state': 'New Jersey',
            'country': 'United States',
          },
        },
      });
      expect(model, isNotNull);
      expect(model!.data!.profile!.zipCode, '08861');
      expect(zipFromAuthPayload({
        'data': {
          'user_details': {
            'profile': {'zip_code': '08861'},
          },
        },
      }), '08861');
    });

    test('a missing ZIP does not invent one', () {
      expect(
        profileModelFromAuthPayload({
          'user_details': {
            'id': 7,
            'profile': {'select_state': 'NJ'},
          },
        }),
        isNull,
      );
    });

    test('logout and a newer user ignore a delayed profile response', () {
      final gate = ProfileLoadGate()..start('user-a');
      final firstEpoch = gate.epoch;
      gate.invalidate();
      expect(gate.accepts(epoch: firstEpoch, userId: 'user-a'), isFalse);

      gate.start('user-b');
      final second = gate.epoch;
      expect(gate.accepts(epoch: second, userId: 'user-b'), isTrue);
      expect(gate.accepts(epoch: second, userId: 'user-a'), isFalse);
    });
  });

  group('google authentication', () {
    test('an existing account with a session logs in directly', () {
      final decision = decideSocialRegister(
        _Response(200, {
          'data': {
            'token': 'sanctum-token',
            'user_details': {
              'id': 4,
              'active_role': 'user',
              'profile': {'zip_code': '08861'},
            },
          },
        }),
        locationWasAttached: false,
      );
      expect(decision.outcome, SocialRegisterOutcome.authenticated);
    });

    test('a new account without location continues registration', () {
      final decision = decideSocialRegister(
        _Response(422, {
          'message': 'The country field is required.',
          'errors': {
            'country': ['The country field is required.'],
            'select_state': ['The select state field is required.'],
            'zip_code': ['The zip code field is required.'],
          },
          'code': kLocationRequired,
        }),
        locationWasAttached: false,
      );
      expect(decision.needsLocation, isTrue);
      expect(decision.outcome, isNot(SocialRegisterOutcome.authenticated));
    });

    test('a blocked ZIP keeps the admin message and does not log in', () {
      const admin =
          'Groovkin is not currently accepting registrations or hosting events in your area.';
      final decision = decideSocialRegister(
        _Response(422, {
          'message': admin,
          'code': kLocationNotSupported,
          'allowed': false,
        }),
        locationWasAttached: true,
      );
      expect(decision.outcome, SocialRegisterOutcome.rejected);
      expect(decision.message, admin);
    });

    test('an uncovered probe still opens location collection', () {
      final decision = decideSocialRegister(
        _Response(422, {
          'message': 'Location is required before a new account can be created.',
          'code': kLocationNotSupported,
          'allowed': false,
        }),
        locationWasAttached: false,
      );
      expect(decision.needsLocation, isTrue);
    });

    test('duplicate, expired, and network failures are not treated as a new user', () {
      final duplicate = decideSocialRegister(
        _Response(422, {
          'message': 'The email has already been taken.',
          'errors': {
            'email': ['The email has already been taken.'],
          },
        }),
        locationWasAttached: false,
      );
      expect(duplicate.outcome, SocialRegisterOutcome.rejected);
      expect(duplicate.needsLocation, isFalse);

      final expired = decideSocialRegister(
        _Response(401, {
          'message': 'Google credential expired.',
          'error_code': 'credential_expired',
        }),
        locationWasAttached: false,
      );
      expect(expired.outcome, SocialRegisterOutcome.expiredCredential);

      final offline = decideSocialRegister(
        _Response(0, {'message': 'Network error'}),
        locationWasAttached: false,
      );
      expect(offline.outcome, SocialRegisterOutcome.failed);

      final server = decideSocialRegister(
        _Response(500, {'message': 'Server error'}),
        locationWasAttached: false,
      );
      expect(server.outcome, SocialRegisterOutcome.failed);
      expect(server.needsLocation, isFalse);
    });
  });
}

class _QuietCatalog implements LocationCatalogSource {
  @override
  Future<dynamic> countries() async => _Response(200, {'data': []});

  @override
  Future<dynamic> states(String countryCode) async =>
      _Response(200, {'data': []});

  @override
  Future<dynamic> cities({
    required String countryCode,
    required String stateCode,
  }) async =>
      _Response(200, {'data': []});

  @override
  Future<dynamic> checkEligibility(Map<String, dynamic> body) async =>
      _Response(200, {'allowed': true, 'code': kLocationAllowed});
}

class _HoldStates implements LocationCatalogSource {
  final Completer<dynamic> statesResponse = Completer<dynamic>();

  @override
  Future<dynamic> countries() async => _Response(200, {'data': []});

  @override
  Future<dynamic> states(String countryCode) => statesResponse.future;

  @override
  Future<dynamic> cities({
    required String countryCode,
    required String stateCode,
  }) async =>
      _Response(200, {'data': []});

  @override
  Future<dynamic> checkEligibility(Map<String, dynamic> body) async =>
      _Response(200, {'allowed': true});
}
