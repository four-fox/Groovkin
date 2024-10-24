


// To parse this JSON data, do
//
//     final venueDetailsModel = venueDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

import '../../Components/Network/API.dart';
import '../../Components/Network/Url.dart';

VenueDetailsModel venueDetailsModelFromJson(String str) => VenueDetailsModel.fromJson(json.decode(str));

String venueDetailsModelToJson(VenueDetailsModel data) => json.encode(data.toJson());

class VenueDetailsModel {
  bool? status;
  VenueDetailsData? data;
  String? message;

  VenueDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory VenueDetailsModel.fromJson(Map<String, dynamic> json) => VenueDetailsModel(
    status: json["status"],
    data: json["data"] == null ? null : VenueDetailsData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
  };
}

class VenueDetailsData {
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
  User? user;
  String? city;
  VenueProperty? venueProperty;
  List<ProfilePicture>? profilePicture;
  List<Amenity>? amenities;
  List<Amenity>? licensesAndPermit;
  List<Amenity>? houseEventCapabilities;

  VenueDetailsData({
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
    this.city,

    this.user,
    this.venueProperty,
    this.profilePicture,
    this.amenities,
    this.licensesAndPermit,
    this.houseEventCapabilities,
  });

  factory VenueDetailsData.fromJson(Map<String, dynamic> json) => VenueDetailsData(
    id: json["id"],
    location: json["location"],
    venueName: json["venue_name"],
    streetAddress: json["street_address"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zip_code"],
    phoneNumber: json["phone_number"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    userId: json["user_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    venueProperty: json["venue_property"] == null ? null : VenueProperty.fromJson(json["venue_property"]),
    profilePicture: json["profile_picture"] == null ? [] : List<ProfilePicture>.from(json["profile_picture"]!.map((x) => ProfilePicture.fromJson(x))),
    amenities: json["amenities"] == null ? [] : List<Amenity>.from(json["amenities"]!.map((x) => Amenity.fromJson(x))),
    licensesAndPermit: json["licenses_and_permit"] == null ? [] : List<Amenity>.from(json["licenses_and_permit"]!.map((x) => Amenity.fromJson(x))),
    houseEventCapabilities: json["house_event_capabilities"] == null ? [] : List<Amenity>.from(json["house_event_capabilities"]!.map((x) => Amenity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location": location,
    "venue_name": venueName,
    "street_address": streetAddress,
    "state": state,
    "city": city,
    "user": user?.toJson(),
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
    "licenses_and_permit": licensesAndPermit == null ? [] : List<dynamic>.from(licensesAndPermit!.map((x) => x.toJson())),
    "house_event_capabilities": houseEventCapabilities == null ? [] : List<dynamic>.from(houseEventCapabilities!.map((x) => x.toJson())),
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
  RxBool? isFollow = false.obs;
  String? role;
  Following? follower;
  Following? following;
  bool? isDelete;

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
    this.isFollow,
    this.role,
    this.follower,
    this.following,
    this.isDelete,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    isFollow: json["isFollow"] == null?false.obs:true.obs,
    deviceToken: json["device_token"],
    emailVerifiedAt: json["email_verified_at"],
    otp: json["otp"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
    profilePicture:json["profile_picture"] == null?null: ProfilePicture.fromJson(json["profile_picture"]),
    role: json["role"]==null?null: json["role"]["name"],
    follower: json["follower"] == null ? null : Following.fromJson(json["follower"]),
    following: json["following"] == null ? null : Following.fromJson(json["following"]),
    isDelete: json["deleted_at"],
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
    "profile_picture": profilePicture,
    "role": role,
    
  };
}

class Following {
  int? id;
  int? userId;
  int? followerId;
  String? type;
  String? status;
  dynamic createdAt;
  dynamic updatedAt;

  Following({
    this.id,
    this.userId,
    this.followerId,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Following.fromJson(Map<String, dynamic> json) => Following(
    id: json["id"],
    userId: json["user_id"],
    followerId: json["follower_id"],
    type: json["type"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "follower_id": followerId,
    "type": type,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
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
  String? about;
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
    this.about,
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
    about: json["about"],
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
    "about": about,
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

class Amenity {
  int? id;
  int? userId;
  int? venueId;
  int? venueItemId;
  String? type;
  String? createdAt;
  String? updatedAt;
  VenueItem? venueItem;

  Amenity({
    this.id,
    this.userId,
    this.venueId,
    this.venueItemId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.venueItem,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
    id: json["id"],
    userId: json["user_id"],
    venueId: json["venue_id"],
    venueItemId: json["venue_item_id"],
    type: json["type"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    venueItem: json["venue_item"] == null ? null : VenueItem.fromJson(json["venue_item"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "venue_id": venueId,
    "venue_item_id": venueItemId,
    "type": type,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "venue_item": venueItem?.toJson(),
  };
}

class VenueItem {
  int? id;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;

  VenueItem({
    this.id,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory VenueItem.fromJson(Map<String, dynamic> json) => VenueItem(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "created_at": createdAt,
    "updated_at": updatedAt,
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
    mediaPath: json["media_path"] != null?Url().imageUrl+json["media_path"]:dummyProfile,
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