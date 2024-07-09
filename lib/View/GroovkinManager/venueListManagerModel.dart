


// To parse this JSON data, do
//
//     final allVenueModel = allVenueModelFromJson(jsonString);

import 'dart:convert';

import '../../links.dart';

AllVenueModel allVenueModelFromJson(String str) => AllVenueModel.fromJson(json.decode(str));

String allVenueModelToJson(AllVenueModel data) => json.encode(data.toJson());

class AllVenueModel {
  bool? status;
  Data? data;
  String? message;

  AllVenueModel({
    this.status,
    this.data,
    this.message,
  });

  factory AllVenueModel.fromJson(Map<String, dynamic> json) => AllVenueModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  int? currentPage;
  List<VenuesObject>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<VenuesObject>.from(json["data"]!.map((x) => VenuesObject.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class VenuesObject {
  int? id;
  String? location;
  String? venueName;
  String? streetAddress;
  String? state;
  String? zipCode;
  String? phoneNumber;
  String? latitude;
  String? longitude;
  int? userId;
  String? createdAt;
  String? updatedAt;
  VenueProperty? venueProperty;
  List<ProfilePicture>? profilePicture;
  List<Ity>? amenities;
  List<dynamic>? licensesAndPermit;
  List<Ity>? houseEventCapabilities;

  VenuesObject({
    this.id,
    this.location,
    this.venueName,
    this.streetAddress,
    this.state,
    this.zipCode,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.venueProperty,
    this.profilePicture,
    this.amenities,
    this.licensesAndPermit,
    this.houseEventCapabilities,
  });

  factory VenuesObject.fromJson(Map<String, dynamic> json) => VenuesObject(
    id: json["id"],
    location: json["location"],
    venueName: json["venue_name"],
    streetAddress: json["street_address"],
    state: json["state"],
    zipCode: json["zip_code"],
    phoneNumber: json["phone_number"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    userId: json["user_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    venueProperty: json["venue_property"] == null ? null : VenueProperty.fromJson(json["venue_property"]),
    profilePicture: json["profile_picture"] == null ? [] : List<ProfilePicture>.from(json["profile_picture"]!.map((x) => ProfilePicture.fromJson(x))),
    amenities: json["amenities"] == null ? [] : List<Ity>.from(json["amenities"]!.map((x) => Ity.fromJson(x))),
    licensesAndPermit: json["licenses_and_permit"] == null ? [] : List<dynamic>.from(json["licenses_and_permit"]!.map((x) => x)),
    houseEventCapabilities: json["house_event_capabilities"] == null ? [] : List<Ity>.from(json["house_event_capabilities"]!.map((x) => Ity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location": location,
    "venue_name": venueName,
    "street_address": streetAddress,
    "state": state,
    "zip_code": zipCode,
    "phone_number": phoneNumber,
    "latitude": latitude,
    "longitude": longitude,
    "user_id": userId,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "venue_property": venueProperty?.toJson(),
    "profile_picture": profilePicture == null ? [] : List<dynamic>.from(profilePicture!.map((x) => x.toJson())),
    "amenities": amenities == null ? [] : List<dynamic>.from(amenities!.map((x) => x.toJson())),
    "licenses_and_permit": licensesAndPermit == null ? [] : List<dynamic>.from(licensesAndPermit!.map((x) => x)),
    "house_event_capabilities": houseEventCapabilities == null ? [] : List<dynamic>.from(houseEventCapabilities!.map((x) => x.toJson())),
  };
}

class Ity {
  int? id;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Ity({
    this.id,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Ity.fromJson(Map<String, dynamic> json) => Ity(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "pivot": pivot?.toJson(),
  };
}

class Pivot {
  int? venueId;
  int? venueItemId;

  Pivot({
    this.venueId,
    this.venueItemId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    venueId: json["venue_id"],
    venueItemId: json["venue_item_id"],
  );

  Map<String, dynamic> toJson() => {
    "venue_id": venueId,
    "venue_item_id": venueItemId,
  };
}

class ProfilePicture {
  int? id;
  String? mediaFor;
  dynamic thumbnail;
  String? mediaPath;
  String? mediaType;
  String? galleryableType;
  int? galleryableId;
  String? createdAt;
  String? updatedAt;

  ProfilePicture({
    this.id,
    this.mediaFor,
    this.thumbnail,
    this.mediaPath,
    this.mediaType,
    this.galleryableType,
    this.galleryableId,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfilePicture.fromJson(Map<String, dynamic> json) => ProfilePicture(
    id: json["id"],
    mediaFor: json["media_for"],
    thumbnail: json["thumbnail"],
    mediaPath: json["media_path"],
    mediaType: json["media_type"],
    galleryableType: json["galleryable_type"],
    galleryableId: json["galleryable_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "media_for": mediaFor,
    "thumbnail": thumbnail,
    "media_path": mediaPath,
    "media_type": mediaType,
    "galleryable_type": galleryableType,
    "galleryable_id": galleryableId,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class VenueProperty {
  int? id;
  String? maxOccupancy;
  String? maxSeating;
  String? maxHour;
  String? openingHours;
  String? closingHours;
  int? venueId;
  int? userId;
  String? createdAt;
  String? updatedAt;

  VenueProperty({
    this.id,
    this.maxOccupancy,
    this.maxSeating,
    this.maxHour,
    this.openingHours,
    this.closingHours,
    this.venueId,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory VenueProperty.fromJson(Map<String, dynamic> json) => VenueProperty(
    id: json["id"],
    maxOccupancy: json["max_occupancy"],
    maxSeating: json["max_seating"],
    maxHour: json["max_hour"],
    openingHours: json["opening_hours"],
    closingHours: json["closing_hours"],
    venueId: json["venue_id"],
    userId: json["user_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "max_occupancy": maxOccupancy,
    "max_seating": maxSeating,
    "max_hour": maxHour,
    "opening_hours": openingHours,
    "closing_hours": closingHours,
    "venue_id": venueId,
    "user_id": userId,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
