


// To parse this JSON data, do
//
//     final venuListModel = venuListModelFromJson(jsonString);

import 'dart:convert';

import '../../../../links.dart';

VenueListModel venueListModelFromJson(String str) => VenueListModel.fromJson(json.decode(str));

String venueListModelToJson(VenueListModel data) => json.encode(data.toJson());

class VenueListModel {
  bool? status;
  Data? data;
  String? message;

  VenueListModel({
    this.status,
    this.data,
    this.message,
  });

  factory VenueListModel.fromJson(Map<String, dynamic> json) => VenueListModel(
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
  List<VenueByLatLng>? data;
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
    data: json["data"] == null ? [] : List<VenueByLatLng>.from(json["data"]!.map((x) => VenueByLatLng.fromJson(x))),
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

class VenueByLatLng {
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
  num? distance;
  User? user;
  VenueProperty? venueProperty;
  List<ProfilePicture>? profilePicture;
  List<dynamic>? amenities;
  List<dynamic>? licensesAndPermit;
  List<dynamic>? houseEventCapabilities;

  VenueByLatLng({
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
    this.distance,
    this.user,
    this.venueProperty,
    this.profilePicture,
    this.amenities,
    this.licensesAndPermit,
    this.houseEventCapabilities,
  });

  factory VenueByLatLng.fromJson(Map<String, dynamic> json) => VenueByLatLng(
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
    distance: json["distance"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    venueProperty: json["venue_property"] == null ? null : VenueProperty.fromJson(json["venue_property"]),
    profilePicture: json["profile_picture"] == null ? [] : List<ProfilePicture>.from(json["profile_picture"]!.map((x) => ProfilePicture.fromJson(x))),
    amenities: json["amenities"] == null ? [] : List<dynamic>.from(json["amenities"]!.map((x) => x)),
    licensesAndPermit: json["licenses_and_permit"] == null ? [] : List<dynamic>.from(json["licenses_and_permit"]!.map((x) => x)),
    houseEventCapabilities: json["house_event_capabilities"] == null ? [] : List<dynamic>.from(json["house_event_capabilities"]!.map((x) => x)),
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
    "distance": distance,
    "user": user?.toJson(),
    "venue_property": venueProperty?.toJson(),
    "profile_picture": profilePicture == null ? [] : List<dynamic>.from(profilePicture!.map((x) => x.toJson())),
    "amenities": amenities == null ? [] : List<dynamic>.from(amenities!.map((x) => x)),
    "licenses_and_permit": licensesAndPermit == null ? [] : List<dynamic>.from(licensesAndPermit!.map((x) => x)),
    "house_event_capabilities": houseEventCapabilities == null ? [] : List<dynamic>.from(houseEventCapabilities!.map((x) => x)),
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

class User {
  int? id;
  String? name;
  String? email;
  String? deviceToken;
  dynamic emailVerifiedAt;
  dynamic otp;
  String? createdAt;
  String? updatedAt;
  Profile? profile;
  ProfilePicture? profilePicture;

  User({
    this.id,
    this.name,
    this.email,
    this.deviceToken,
    this.emailVerifiedAt,
    this.otp,
    this.createdAt,
    this.updatedAt,
    this.profile,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    deviceToken: json["device_token"],
    emailVerifiedAt: json["email_verified_at"],
    otp: json["otp"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
    profilePicture: json["profile_picture"] == null ? null : ProfilePicture.fromJson(json["profile_picture"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "device_token": deviceToken,
    "email_verified_at": emailVerifiedAt,
    "otp": otp,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "profile": profile?.toJson(),
    "profile_picture": profilePicture?.toJson(),
  };
}

class Profile {
  int? id;
  String? firstName;
  String? lastName;
  dynamic birthYear;
  String? phoneNumber;
  dynamic companyName;
  dynamic selectState;
  dynamic location;
  dynamic latitude;
  dynamic longitude;
  int? isInsurance;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Profile({
    this.id,
    this.firstName,
    this.lastName,
    this.birthYear,
    this.phoneNumber,
    this.companyName,
    this.selectState,
    this.location,
    this.latitude,
    this.longitude,
    this.isInsurance,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    birthYear: json["birth_year"],
    phoneNumber: json["phone_number"],
    companyName: json["company_name"],
    selectState: json["select_state"],
    location: json["location"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    isInsurance: json["is_insurance"],
    userId: json["user_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "birth_year": birthYear,
    "phone_number": phoneNumber,
    "company_name": companyName,
    "select_state": selectState,
    "location": location,
    "latitude": latitude,
    "longitude": longitude,
    "is_insurance": isInsurance,
    "user_id": userId,
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
