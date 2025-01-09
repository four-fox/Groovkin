// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  bool? status;
  Data? data;
  String? message;

  ProfileModel({
    this.status,
    this.data,
    this.message,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
  int? id;
  String? name;
  String? email;
  String? deviceToken;
  dynamic emailVerifiedAt;
  dynamic otp;
  String? createdAt;
  String? updatedAt;
  String? activeRole;
  Profile? profile;
  ProfilePicture? profilePicture;

  Data({
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
    this.activeRole,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        deviceToken: json["device_token"],
        emailVerifiedAt: json["email_verified_at"],
        otp: json["otp"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        activeRole: json["active_role"],
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
        profilePicture: json["profile_picture"] == null
            ? null
            : ProfilePicture.fromJson(json['profile_picture']),
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
        "active_role": activeRole,
      };
}

class Profile {
  int? id;
  String? firstName;
  String? lastName;
  dynamic birthYear;
  String? phoneNumber;
  String? about;
  String? companyName;
  String? selectState;
  String? country;
  dynamic location;
  dynamic latitude;
  dynamic longitude;
  int? isInsurance;
  int? userId;
  DateTime? createdAt;
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
    this.about,
    this.country,
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
        country: json["country"],
        longitude: json["longitude"],
        isInsurance: json["is_insurance"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        about: json["about"],
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
        "country": country,
        "longitude": longitude,
        "is_insurance": isInsurance,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
      };
}

class ProfilePicture {
  final int id;
  final String mediaFor;
  final String? thumbnail;
  final String mediaPath;
  final String mediaType;
  final String galleryableType;
  final int galleryableId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfilePicture({
    required this.id,
    required this.mediaFor,
    this.thumbnail,
    required this.mediaPath,
    required this.mediaType,
    required this.galleryableType,
    required this.galleryableId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Method to parse JSON into ProfilePicture object
  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
      id: json['id'],
      mediaFor: json['media_for'],
      thumbnail: json['thumbnail'],
      mediaPath: json['media_path'],
      mediaType:  json['media_type'],
      galleryableType: json['galleryable_type'],
      galleryableId: json['galleryable_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert ProfilePicture object into JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_for': mediaFor,
      'thumbnail': thumbnail,
      'media_path': mediaPath,
      'media_type': mediaType,
      'galleryable_type': galleryableType,
      'galleryable_id': galleryableId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
