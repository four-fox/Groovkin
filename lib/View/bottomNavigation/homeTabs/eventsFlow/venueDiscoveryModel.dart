class CompactVenue {
  const CompactVenue({
    required this.id,
    this.venueName,
    this.image,
    this.addressLabel = '',
    this.city,
    this.state,
    this.location,
    this.latitude,
    this.longitude,
    this.maxOccupancy,
    this.maxSeating,
    this.distance,
  });

  final int id;
  final String? venueName;
  final String? image;
  final String addressLabel;
  final String? city;
  final String? state;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? maxOccupancy;
  final String? maxSeating;
  final VenueDistance? distance;

  factory CompactVenue.fromJson(Map<String, dynamic> json) => CompactVenue(
        id: _int(json['id']) ?? 0,
        venueName: _string(json['venue_name']),
        image: _string(json['image']),
        addressLabel: _string(json['address_label']) ?? '',
        city: _string(json['city']),
        state: _string(json['state']),
        location: _string(json['location']),
        latitude: _double(json['latitude']),
        longitude: _double(json['longitude']),
        maxOccupancy: _string(json['max_occupancy']),
        maxSeating: _string(json['max_seating']),
        distance: json['distance'] is Map
            ? VenueDistance.fromJson(
                Map<String, dynamic>.from(json['distance'] as Map))
            : null,
      );
}

class VenueDistance {
  const VenueDistance({this.value, this.unit});

  final double? value;
  final String? unit;

  factory VenueDistance.fromJson(Map<String, dynamic> json) => VenueDistance(
        value: _double(json['value']),
        unit: _string(json['unit']),
      );
}

class VenueDiscoveryPage {
  const VenueDiscoveryPage({
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 12,
    this.total = 0,
    this.venues = const [],
  });

  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final List<CompactVenue> venues;

  factory VenueDiscoveryPage.fromEnvelope(Map<String, dynamic> json) {
    final raw = json['data'];
    final data = raw is Map ? Map<String, dynamic>.from(raw) : const {};
    final rows = data['data'] is List ? data['data'] as List : const [];
    return VenueDiscoveryPage(
      currentPage: _int(data['current_page']) ?? 1,
      lastPage: _int(data['last_page']) ?? 1,
      perPage: _int(data['per_page']) ?? 12,
      total: _int(data['total']) ?? rows.length,
      venues: rows
          .whereType<Map>()
          .map((row) => CompactVenue.fromJson(Map<String, dynamic>.from(row)))
          .where((venue) => venue.id > 0)
          .toList(),
    );
  }
}

class VenueMarkerResult {
  const VenueMarkerResult({
    this.venues = const [],
    this.count = 0,
    this.limit = 200,
    this.truncated = false,
    this.totalEligible = 0,
    this.radius,
    this.origin,
  });

  final List<CompactVenue> venues;
  final int count;
  final int limit;
  final bool truncated;
  final int totalEligible;
  final VenueDistance? radius;
  final VenueOrigin? origin;

  factory VenueMarkerResult.fromEnvelope(Map<String, dynamic> json) {
    final raw = json['data'];
    final data = raw is Map ? Map<String, dynamic>.from(raw) : const {};
    final rows = data['venues'] is List ? data['venues'] as List : const [];
    return VenueMarkerResult(
      venues: rows
          .whereType<Map>()
          .map((row) => CompactVenue.fromJson(Map<String, dynamic>.from(row)))
          .where((venue) => venue.id > 0)
          .toList(),
      count: _int(data['count']) ?? rows.length,
      limit: _int(data['limit']) ?? 200,
      truncated: data['truncated'] == true,
      totalEligible: _int(data['total_eligible']) ?? rows.length,
      radius: data['radius'] is Map
          ? VenueDistance.fromJson(
              Map<String, dynamic>.from(data['radius'] as Map))
          : null,
      origin: data['origin'] is Map
          ? VenueOrigin.fromJson(
              Map<String, dynamic>.from(data['origin'] as Map))
          : null,
    );
  }
}

class VenueOrigin {
  const VenueOrigin({this.latitude, this.longitude});

  final double? latitude;
  final double? longitude;

  factory VenueOrigin.fromJson(Map<String, dynamic> json) => VenueOrigin(
        latitude: _double(json['latitude']),
        longitude: _double(json['longitude']),
      );
}

String? _string(dynamic value) =>
    value == null || value.toString().trim().isEmpty ? null : value.toString();
int? _int(dynamic value) =>
    value is int ? value : int.tryParse(value?.toString() ?? '');
double? _double(dynamic value) =>
    value is num ? value.toDouble() : double.tryParse(value?.toString() ?? '');
