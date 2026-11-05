import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/location/location_contract.dart';
import 'package:groovkin/location/location_controller.dart';
import 'package:groovkin/location/location_repository.dart';

class _Response {
  _Response(this.statusCode, this.data);

  final int statusCode;
  final dynamic data;
}

void main() {
  const adminMessage =
      'Groovkin is not currently accepting registrations or hosting events in your area.';

  test('catalog parsers accept a list or a wrapped data object', () {
    final wrapped = _Response(200, {
      'status': true,
      'data': [
        {'country_code': 'US', 'name': 'United States'},
      ],
    });
    final places = parseLocationPlaces(wrapped, codeKey: 'country_code');
    expect(places.single.code, 'US');
    expect(places.single.name, 'United States');

    final nested = {
      'data': {
        'cities': [
          {'name': 'Newark'},
          {'name': 'Newark'},
        ],
      },
    };
    expect(parseCityNames(nested), ['Newark']);
  });

  test('allowed and restrictions-disabled responses continue registration', () {
    final allowed = interpretLocationResponse(_Response(200, {
      'status': true,
      'allowed': true,
      'code': kLocationAllowed,
      'message': 'Registration is available in your area.',
      'data': {
        'allowed': true,
        'code': kLocationAllowed,
        'message': 'Registration is available in your area.',
      },
    }));
    expect(allowed.allowed, isTrue);
    expect(allowed.code, kLocationAllowed);

    final disabled = interpretLocationResponse(_Response(200, {
      'status': true,
      'allowed': true,
      'code': kLocationRestrictionsDisabled,
      'message': 'Registration is available in your area.',
    }));
    expect(disabled.allowed, isTrue);
    expect(disabled.restrictionsDisabled, isTrue);
  });

  test('a 422 uses the admin message and does not invent one', () {
    const custom = 'Custom area message from the admin panel.';
    final result = interpretLocationResponse(_Response(422, {
      'status': false,
      'allowed': false,
      'code': kLocationNotSupported,
      'message': custom,
      'error_code': kLocationNotSupported,
      'data': {
        'allowed': false,
        'code': kLocationNotSupported,
        'message': custom,
      },
    }));
    expect(result.allowed, isFalse);
    expect(result.code, kLocationNotSupported);
    expect(result.message, custom);
    expect(result.message, isNot(adminMessage));
    expect(result.feedback, LocationFeedback.popup);
  });

  test('postal and geography codes map to fields, not a second allowlist', () {
    final postal = interpretLocationResponse(_Response(422, {
      'code': kPostalInvalid,
      'message': 'Enter a valid ZIP.',
      'allowed': false,
    }));
    expect(postal.field, 'postal');
    expect(postal.feedback, LocationFeedback.field);
    expect(postal.message, 'Enter a valid ZIP.');

    final mismatch = interpretLocationResponse(_Response(422, {
      'code': kGeographyMismatch,
      'message': 'That ZIP does not match the selected state.',
      'allowed': false,
    }));
    expect(mismatch.field, 'state');
    expect(mismatch.feedback, LocationFeedback.field);
  });

  test('network and server failures are retries, not an unsupported area', () {
    expect(interpretLocationResponse(null).kind, LocationCheckKind.network);
    expect(
      interpretLocationResponse(_Response(0, null)).kind,
      LocationCheckKind.network,
    );
    final server = interpretLocationResponse(_Response(503, {
      'message': 'upstream down',
    }));
    expect(server.kind, LocationCheckKind.server);
    expect(server.code, kLocationCheckFailed);
    expect(server.message, 'upstream down');

    final checkFailed = interpretLocationResponse(_Response(200, {
      'allowed': false,
      'code': kLocationCheckFailed,
      'message': 'try later',
    }));
    expect(checkFailed.kind, LocationCheckKind.server);
  });

  test('postal codes stay strings, including a leading zero', () {
    const draft = LocationDraft(
      countryCode: 'US',
      countryName: 'United States',
      stateCode: 'NJ',
      stateName: 'New Jersey',
      postalCode: '08861',
    );
    final body = eligibilityRequestBody(draft);
    expect(body['postal_code'], '08861');
    expect(body['postal_code'], isA<String>());
    expect(body.containsKey('city'), isFalse);

    final fields = registrationLocationFields(draft, includeCodes: true);
    expect(fields['zip_code'], '08861');
    expect(fields['country'], 'United States');
    expect(fields['select_state'], 'New Jersey');
    expect(fields['country_code'], 'US');
    expect(fields['state_code'], 'NJ');

    final namesOnly = registrationLocationFields(draft, includeCodes: false);
    expect(namesOnly.containsKey('country_code'), isFalse);
    expect(namesOnly.containsKey('state_code'), isFalse);
    expect(normalizePostal(' 08861 '), '08861');
  });

  test('country and state changes drop incompatible values', () {
    const draft = LocationDraft(
      countryCode: 'US',
      countryName: 'United States',
      stateCode: 'NJ',
      stateName: 'New Jersey',
      city: 'Newark',
      postalCode: '08861',
    );
    final clearedCountry = draft.clearedForCountry();
    expect(clearedCountry.countryCode, isNull);
    expect(clearedCountry.stateCode, isNull);
    expect(clearedCountry.city, isNull);
    expect(clearedCountry.postalCode, isEmpty);

    final clearedState = draft.clearedForState();
    expect(clearedState.countryCode, 'US');
    expect(clearedState.stateCode, isNull);
    expect(clearedState.city, isNull);
    expect(clearedState.postalCode, isEmpty);
  });

  test('local validation does not claim an area is unsupported', () {
    expect(
      localLocationValidation(const LocationDraft(), catalogsReady: false),
      isNull,
    );
    final missing = localLocationValidation(
      const LocationDraft(),
      catalogsReady: true,
    );
    expect(missing?.code, kLocationRequired);
    expect(missing?.message, isNot(adminMessage));
  });

  test('rapid catalog loads ignore a stale response', () async {
    final source = _ScriptedSource();
    final controller = LocationAvailabilityController(repository: source);
    final first = controller.loadCountries();
    final second = controller.loadCountries();
    source.countryResponses[1].complete(_Response(200, {
      'data': [
        {'country_code': 'US', 'name': 'United States'},
      ],
    }));
    source.countryResponses[0].complete(_Response(200, {
      'data': [
        {'country_code': 'PK', 'name': 'Pakistan'},
      ],
    }));
    await Future.wait([first, second]);
    expect(controller.countries.single.code, 'US');
    expect(controller.catalogsReady, isTrue);
  });

  test('changing country clears the previous state and postal code', () async {
    final source = _ScriptedSource();
    final controller = LocationAvailabilityController(repository: source);
    controller.draft = const LocationDraft(
      countryCode: 'US',
      countryName: 'United States',
      stateCode: 'NJ',
      stateName: 'New Jersey',
      postalCode: '08861',
    );
    controller.postalController.text = '08861';
    final selection = controller.selectCountry(
      const LocationPlace(code: 'PK', name: 'Pakistan'),
    );
    expect(controller.draft.stateCode, isNull);
    expect(controller.draft.postalCode, isEmpty);
    expect(controller.postalController.text, isEmpty);
    source.stateResponses.single.complete(_Response(200, {
      'data': [
        {'state_code': 'SD', 'name': 'Sindh'},
      ],
    }));
    await selection;
    expect(controller.states.single.code, 'SD');
  });

  test('one eligibility check is shared while it is in flight', () async {
    final source = _ScriptedSource();
    final controller = LocationAvailabilityController(repository: source);
    controller.catalogsReady = true;
    controller.draft = const LocationDraft(
      countryCode: 'US',
      countryName: 'United States',
      stateCode: 'NJ',
      stateName: 'New Jersey',
      postalCode: '08861',
    );
    final first = controller.gateRegistration();
    final second = controller.gateRegistration();
    expect(source.eligibilityCalls, 1);
    source.eligibility.complete(_Response(200, {
      'allowed': true,
      'code': kLocationAllowed,
      'message': 'Registration is available in your area.',
    }));
    final results = await Future.wait([first, second]);
    expect(results.every((result) => result.allowed), isTrue);
    expect(source.eligibilityCalls, 1);
    final cached = await controller.gateRegistration();
    expect(cached.allowed, isTrue);
    expect(source.eligibilityCalls, 1);
  });
}

class _ScriptedSource implements LocationCatalogSource {
  final List<Completer<dynamic>> countryResponses = [];
  final List<Completer<dynamic>> stateResponses = [];
  final Completer<dynamic> eligibility = Completer<dynamic>();
  int eligibilityCalls = 0;

  @override
  Future<dynamic> countries() {
    final completer = Completer<dynamic>();
    countryResponses.add(completer);
    return completer.future;
  }

  @override
  Future<dynamic> states(String countryCode) {
    final completer = Completer<dynamic>();
    stateResponses.add(completer);
    return completer.future;
  }

  @override
  Future<dynamic> cities({
    required String countryCode,
    required String stateCode,
  }) async {
    return _Response(200, {'data': <Map<String, dynamic>>[]});
  }

  @override
  Future<dynamic> checkEligibility(Map<String, dynamic> body) {
    eligibilityCalls++;
    expect(body['postal_code'], '08861');
    expect(body['postal_code'], isA<String>());
    return eligibility.future;
  }
}
