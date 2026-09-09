import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/Network/backend_error.dart';

import 'venueDiscoveryModel.dart';

class VenueDiscoveryRepository {
  Future<VenueDiscoveryPage> discover({
    double? latitude,
    double? longitude,
    required int radius,
    String? search,
    int page = 1,
    int perPage = 12,
  }) async {
    final response = await API().getApi(
      url: 'discover-venues',
      isLoader: false,
      queryParameters: _query(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        search: search,
        page: page,
        perPage: perPage,
      ),
    );
    if (response.statusCode == 200) {
      return VenueDiscoveryPage.fromEnvelope(
        Map<String, dynamic>.from(response.data),
      );
    }
    throw VenueDiscoveryException(
      backendErrorMessage(response),
      statusCode: response.statusCode,
    );
  }

  Future<VenueMarkerResult> markers({
    double? latitude,
    double? longitude,
    required int radius,
    String? search,
  }) async {
    final response = await API().getApi(
      url: 'discover-venues/markers',
      isLoader: false,
      queryParameters: _query(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        search: search,
      ),
    );
    if (response.statusCode == 200) {
      return VenueMarkerResult.fromEnvelope(
        Map<String, dynamic>.from(response.data),
      );
    }
    throw VenueDiscoveryException(
      backendErrorMessage(response),
      statusCode: response.statusCode,
    );
  }

  Map<String, dynamic> _query({
    double? latitude,
    double? longitude,
    required int radius,
    String? search,
    int? page,
    int? perPage,
  }) {
    final query = <String, dynamic>{};
    if (_usableLocation(latitude, longitude)) {
      query
        ..['latitude'] = latitude
        ..['longitude'] = longitude
        ..['radius'] = radius.clamp(1, 50);
    }
    final cleanSearch = search?.trim() ?? '';
    if (cleanSearch.length >= 2) query['search'] = cleanSearch;
    if (page != null) query['page'] = page;
    if (perPage != null) query['per_page'] = perPage.clamp(1, 50);
    return query;
  }

  bool _usableLocation(double? latitude, double? longitude) =>
      latitude != null &&
      longitude != null &&
      latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180 &&
      !(latitude == 0 && longitude == 0);
}

class VenueDiscoveryException implements Exception {
  const VenueDiscoveryException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
