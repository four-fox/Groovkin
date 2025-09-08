// To parse this JSON data, do
//
//     final chatNewUserModel = chatNewUserModelFromJson(jsonString);

import 'dart:convert';

import 'package:groovkin/Components/colors.dart';

import '../Components/Network/Url.dart';
import '../links.dart';

ChatNewUserModel chatNewUserModelFromJson(String str) =>
    ChatNewUserModel.fromJson(json.decode(str));

String chatNewUserModelToJson(ChatNewUserModel data) =>
    json.encode(data.toJson());

class ChatNewUserModel {
  bool? status;
  Data? data;
  String? message;

  ChatNewUserModel({
    this.status,
    this.data,
    this.message,
  });

  factory ChatNewUserModel.fromJson(Map<String, dynamic> json) =>
      ChatNewUserModel(
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
  List<UserData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
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
        data: json["data"] == null
            ? []
            : List<UserData>.from(
                json["data"]!.map((x) => UserData.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class UserData {
  int? id;
  String? name;
  String? email;
  String? deviceToken;
  dynamic referralCode;
  dynamic emailVerifiedAt;
  dynamic otp;
  dynamic customerId;
  dynamic connectAccountId;
  int? isConnectedAccountExist;
  String? activeRole;
  dynamic status;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  Profile? profile;
  String? profilePicture;

  UserData({
    this.id,
    this.name,
    this.email,
    this.deviceToken,
    this.referralCode,
    this.emailVerifiedAt,
    this.otp,
    this.customerId,
    this.connectAccountId,
    this.isConnectedAccountExist,
    this.activeRole,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.profile,
    this.profilePicture,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        deviceToken: json["device_token"],
        referralCode: json["referral_code"],
        emailVerifiedAt: json["email_verified_at"],
        otp: json["otp"],
        customerId: json["customer_id"],
        connectAccountId: json["connect_account_id"],
        isConnectedAccountExist: json["is_connected_account_exist"],
        activeRole: json["active_role"],
        status: json["status"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
        profilePicture: json["profile_picture"] == null
            ? groupPlaceholder
            : Url().imageUrl + json["profile_picture"]['media_path'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "device_token": deviceToken,
        "referral_code": referralCode,
        "email_verified_at": emailVerifiedAt,
        "otp": otp,
        "customer_id": customerId,
        "connect_account_id": connectAccountId,
        "is_connected_account_exist": isConnectedAccountExist,
        "active_role": activeRole,
        "status": status,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "profile": profile?.toJson(),
        "profile_picture": profilePicture,
      };
}

class Profile {
  int? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? birthYear;
  String? phoneNumber;
  String? companyName;
  String? country;
  String? selectState;
  dynamic location;
  String? about;
  dynamic latitude;
  dynamic longitude;
  int? isInsurance;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Profile({
    this.id,
    this.firstName,
    this.fullName,
    this.lastName,
    this.birthYear,
    this.phoneNumber,
    this.companyName,
    this.country,
    this.selectState,
    this.location,
    this.about,
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
        fullName:
            "${json["first_name"] ?? ""} ${json["last_name"] ?? ""}".trim(),
        birthYear: json["birth_year"],
        phoneNumber: json["phone_number"],
        companyName: json["company_name"],
        country: json["country"],
        selectState: json["select_state"],
        location: json["location"],
        about: json["about"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        isInsurance: json["is_insurance"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "birth_year": birthYear,
        "phone_number": phoneNumber,
        "company_name": companyName,
        "country": country,
        "select_state": selectState,
        "location": location,
        "about": about,
        "latitude": latitude,
        "longitude": longitude,
        "is_insurance": isInsurance,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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
  DateTime? createdAt;
  DateTime? updatedAt;

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
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "media_for": mediaFor,
        "thumbnail": thumbnail,
        "media_path": mediaPath,
        "media_type": mediaType,
        "galleryable_type": galleryableType,
        "galleryable_id": galleryableId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
