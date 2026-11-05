import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/location/location_contract.dart';
import 'package:groovkin/location/location_repository.dart';

class LocationAvailabilityController extends GetxController {
  LocationAvailabilityController({LocationCatalogSource? repository})
      : _repository = repository ?? LocationRepository();

  final LocationCatalogSource _repository;
  final postalController = TextEditingController();

  List<LocationPlace> countries = const [];
  List<LocationPlace> states = const [];
  List<String> cities = const [];
  LocationDraft draft = const LocationDraft();
  ConfirmedLocation? confirmed;
  bool loadingCountries = false;
  bool loadingStates = false;
  bool loadingCities = false;
  bool catalogsReady = false;
  bool catalogsFailed = false;
  bool checking = false;
  String? fieldError;
  String? fieldErrorTarget;
  int _countryGeneration = 0;
  int _stateGeneration = 0;
  int _cityGeneration = 0;
  int _checkGeneration = 0;
  String? _allowedKey;
  Future<LocationCheckResult>? _inFlight;

  bool get eligibilityIsCurrent =>
      _allowedKey != null && _allowedKey == draft.selectionKey;

  @override
  void onInit() {
    super.onInit();
    loadCountries();
  }

  Future<void> loadCountries() async {
    final generation = ++_countryGeneration;
    loadingCountries = true;
    catalogsFailed = false;
    update();
    final response = await _repository.countries();
    if (generation != _countryGeneration) return;
    final status = _statusCode(response);
    final places = status == 200
        ? parseLocationPlaces(response, codeKey: 'country_code')
        : <LocationPlace>[];
    countries = places;
    catalogsReady = places.isNotEmpty;
    catalogsFailed = status != 200;
    loadingCountries = false;
    _matchSavedCountry();
    update();
  }

  Future<void> selectCountry(LocationPlace? place) async {
    _invalidateEligibility();
    fieldError = null;
    fieldErrorTarget = null;
    if (place == null) {
      draft = draft.clearedForCountry();
      postalController.clear();
      states = const [];
      cities = const [];
      update();
      return;
    }
    draft = LocationDraft(
      countryCode: place.code,
      countryName: place.name,
    );
    postalController.clear();
    states = const [];
    cities = const [];
    update();
    await _loadStates(place.code);
  }

  Future<void> selectState(LocationPlace? place) async {
    _invalidateEligibility();
    fieldError = null;
    fieldErrorTarget = null;
    final countryCode = draft.countryCode;
    if (place == null || countryCode == null) {
      draft = draft.clearedForState();
      postalController.clear();
      cities = const [];
      update();
      return;
    }
    draft = LocationDraft(
      countryCode: draft.countryCode,
      countryName: draft.countryName,
      stateCode: place.code,
      stateName: place.name,
    );
    postalController.clear();
    cities = const [];
    update();
    await _loadCities(countryCode, place.code);
  }

  void selectCity(String? city) {
    _invalidateEligibility();
    fieldError = null;
    fieldErrorTarget = null;
    draft = draft.copyWith(city: city, clearCity: city == null);
    update();
  }

  void setPostal(String value) {
    final postal = normalizePostal(value);
    if (postal == draft.postalCode) return;
    _invalidateEligibility();
    if (fieldErrorTarget == 'postal') {
      fieldError = null;
      fieldErrorTarget = null;
    }
    draft = draft.copyWith(postalCode: postal);
    update();
  }

  void applySaved({
    String? countryName,
    String? stateName,
    String? postalCode,
    String? city,
    String? countryCode,
    String? stateCode,
  }) {
    final postal = normalizePostal(postalCode ?? '');
    confirmed = ConfirmedLocation(
      countryName: countryName?.trim() ?? '',
      stateName: stateName?.trim() ?? '',
      postalCode: postal,
      city: _blankToNull(city),
      countryCode: _blankToNull(countryCode),
      stateCode: _blankToNull(stateCode),
    );
    draft = LocationDraft(
      countryCode: confirmed!.countryCode,
      countryName: confirmed!.countryName,
      stateCode: confirmed!.stateCode,
      stateName: confirmed!.stateName,
      city: confirmed!.city,
      postalCode: postal,
    );
    postalController.text = postal;
    _invalidateEligibility();
    _matchSavedCountry();
    update();
  }

  void restoreConfirmed() {
    final saved = confirmed;
    if (saved == null) return;
    applySaved(
      countryName: saved.countryName,
      stateName: saved.stateName,
      postalCode: saved.postalCode,
      city: saved.city,
      countryCode: saved.countryCode,
      stateCode: saved.stateCode,
    );
  }

  bool get locationMatchesConfirmed {
    final saved = confirmed;
    if (saved == null) return false;
    return saved.sameVisible(draft);
  }

  Future<LocationCheckResult> gateRegistration() {
    if (!catalogsReady) {
      return Future.value(
        LocationCheckResult.allowed(code: kLocationRestrictionsDisabled),
      );
    }
    final local = localLocationValidation(draft, catalogsReady: true);
    if (local != null) {
      _applyField(local);
      return Future.value(local);
    }
    if (eligibilityIsCurrent) {
      return Future.value(LocationCheckResult.allowed(
        code: kLocationAllowed,
      ));
    }
    return checkEligibility();
  }

  Future<LocationCheckResult> checkEligibility() {
    final existing = _inFlight;
    if (checking && existing != null) return existing;
    final generation = ++_checkGeneration;
    checking = true;
    update();
    final future = _check(generation);
    _inFlight = future;
    return future;
  }

  Future<LocationCheckResult> _check(int generation) async {
    try {
      final response = await _repository.checkEligibility(
        eligibilityRequestBody(draft),
      );
      if (generation != _checkGeneration) {
        return LocationCheckResult.network();
      }
      final result = interpretLocationResponse(response);
      if (result.allowed) {
        _allowedKey = draft.selectionKey;
        fieldError = null;
        fieldErrorTarget = null;
      } else {
        _invalidateEligibility();
        _applyField(result);
      }
      return result;
    } catch (_) {
      if (generation != _checkGeneration) {
        return LocationCheckResult.network();
      }
      _invalidateEligibility();
      return LocationCheckResult.network();
    } finally {
      if (generation == _checkGeneration) {
        checking = false;
        _inFlight = null;
        update();
      }
    }
  }

  Map<String, String> fieldsForSubmit({required bool includeCodes}) {
    return registrationLocationFields(draft, includeCodes: includeCodes);
  }

  void _applyField(LocationCheckResult result) {
    if (result.feedback == LocationFeedback.field && result.field != null) {
      fieldError = result.message;
      fieldErrorTarget = result.field;
      update();
    }
  }

  void _invalidateEligibility() {
    _allowedKey = null;
  }

  Future<void> _loadStates(String countryCode) async {
    final generation = ++_stateGeneration;
    loadingStates = true;
    update();
    final response = await _repository.states(countryCode);
    if (generation != _stateGeneration || draft.countryCode != countryCode) {
      return;
    }
    states = _statusCode(response) == 200
        ? parseLocationPlaces(response, codeKey: 'state_code')
        : <LocationPlace>[];
    loadingStates = false;
    _matchSavedState();
    update();
  }

  Future<void> _loadCities(String countryCode, String stateCode) async {
    final generation = ++_cityGeneration;
    loadingCities = true;
    update();
    final response = await _repository.cities(
      countryCode: countryCode,
      stateCode: stateCode,
    );
    if (generation != _cityGeneration ||
        draft.countryCode != countryCode ||
        draft.stateCode != stateCode) {
      return;
    }
    cities = _statusCode(response) == 200 ? parseCityNames(response) : <String>[];
    if (draft.city != null && !cities.contains(draft.city)) {
      draft = draft.copyWith(clearCity: true);
    }
    loadingCities = false;
    update();
  }

  void _matchSavedCountry() {
    final savedCode = draft.countryCode;
    final savedName = draft.countryName;
    LocationPlace? match;
    for (final place in countries) {
      if (savedCode != null && place.code == savedCode) {
        match = place;
        break;
      }
      if (savedName != null &&
          place.name.toLowerCase() == savedName.toLowerCase()) {
        match = place;
        break;
      }
    }
    if (match == null) return;
    final stateCode = draft.stateCode;
    final stateName = draft.stateName;
    final city = draft.city;
    final postal = draft.postalCode;
    draft = LocationDraft(
      countryCode: match.code,
      countryName: match.name,
      stateCode: stateCode,
      stateName: stateName,
      city: city,
      postalCode: postal,
    );
    _absorbCatalogMatch();
    _loadStates(match.code);
  }

  void _matchSavedState() {
    final savedCode = draft.stateCode;
    final savedName = draft.stateName;
    if (savedCode == null && (savedName == null || savedName.isEmpty)) return;
    LocationPlace? match;
    for (final place in states) {
      if (savedCode != null && place.code == savedCode) {
        match = place;
        break;
      }
      if (savedName != null &&
          place.name.toLowerCase() == savedName.toLowerCase()) {
        match = place;
        break;
      }
    }
    if (match == null || draft.countryCode == null) return;
    draft = draft.copyWith(
      stateCode: match.code,
      stateName: match.name,
    );
    _absorbCatalogMatch();
    _loadCities(draft.countryCode!, match.code);
  }

  void _absorbCatalogMatch() {
    final saved = confirmed;
    if (saved == null) return;
    if (normalizePostal(saved.postalCode) != normalizePostal(draft.postalCode)) {
      return;
    }
    if (!_sameText(saved.city, draft.city) && (saved.city ?? '').isNotEmpty) {
      return;
    }
    confirmed = ConfirmedLocation(
      countryName: draft.countryName ?? saved.countryName,
      stateName: draft.stateName ?? saved.stateName,
      postalCode: saved.postalCode,
      city: draft.city ?? saved.city,
      countryCode: draft.countryCode ?? saved.countryCode,
      stateCode: draft.stateCode ?? saved.stateCode,
    );
  }

  bool _sameText(String? a, String? b) => (a ?? '').trim() == (b ?? '').trim();

  int? _statusCode(dynamic response) {
    try {
      return response.statusCode as int?;
    } catch (_) {
      return null;
    }
  }

  String? _blankToNull(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty || text.toLowerCase() == 'null') return null;
    return text;
  }
}
