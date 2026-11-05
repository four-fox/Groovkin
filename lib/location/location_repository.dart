import 'package:groovkin/Components/Network/API.dart';

abstract class LocationCatalogSource {
  Future<dynamic> countries();

  Future<dynamic> states(String countryCode);

  Future<dynamic> cities({
    required String countryCode,
    required String stateCode,
  });

  Future<dynamic> checkEligibility(Map<String, dynamic> body);
}

class LocationRepository implements LocationCatalogSource {
  LocationRepository({API? api}) : _api = api ?? API();

  final API _api;

  Future<dynamic> countries() {
    return _api.getApi(url: 'location/countries', isLoader: false);
  }

  Future<dynamic> states(String countryCode) {
    return _api.getApi(
      url: 'location/states',
      queryParameters: {'country_code': countryCode},
      isLoader: false,
    );
  }

  Future<dynamic> cities({
    required String countryCode,
    required String stateCode,
  }) {
    return _api.getApi(
      url: 'location/cities',
      queryParameters: {
        'country_code': countryCode,
        'state_code': stateCode,
      },
      isLoader: false,
    );
  }

  Future<dynamic> checkEligibility(Map<String, dynamic> body) {
    return _api.postApi(
      body,
      'location/check-eligibility',
      auth: false,
      showProgress: false,
      suppressErrorToast: true,
    );
  }
}
