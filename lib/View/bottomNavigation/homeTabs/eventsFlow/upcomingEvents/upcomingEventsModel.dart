

// To parse this JSON data, do
//
//     final upcomingEventsModel = upcomingEventsModelFromJson(jsonString);

import 'dart:convert';

import '../../../../../links.dart';
import '../../organizerHomeModel/alleventsModel.dart';

UpcomingEventsModel upcomingEventsModelFromJson(String str) => UpcomingEventsModel.fromJson(json.decode(str));

String upcomingEventsModelToJson(UpcomingEventsModel data) => json.encode(data.toJson());

class UpcomingEventsModel {
  bool? status;
  Data? data;
  String? message;

  UpcomingEventsModel({
    this.status,
    this.data,
    this.message,
  });

  factory UpcomingEventsModel.fromJson(Map<String, dynamic> json) => UpcomingEventsModel(
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
  List<EventData>? data;
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
    data: json["data"] == null ? [] : List<EventData>.from(json["data"]!.map((x) => EventData.fromJson(x))),
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


class VenueUser {
  int? id;
  String? name;
  String? email;
  String? deviceToken;
  dynamic emailVerifiedAt;
  dynamic otp;
  String? createdAt;
  String? updatedAt;
  FluffyProfile? profile;

  VenueUser({
    this.id,
    this.name,
    this.email,
    this.deviceToken,
    this.emailVerifiedAt,
    this.otp,
    this.createdAt,
    this.updatedAt,
    this.profile,
  });

  factory VenueUser.fromJson(Map<String, dynamic> json) => VenueUser(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    deviceToken: json["device_token"],
    emailVerifiedAt: json["email_verified_at"],
    otp: json["otp"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    profile: json["profile"] == null ? null : FluffyProfile.fromJson(json["profile"]),
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
  };
}

class FluffyProfile {
  int? id;
  String? firstName;
  String? lastName;
  dynamic birthYear;
  String? phoneNumber;
  dynamic companyName;
  dynamic selectState;
  dynamic location;
  String? about;
  dynamic latitude;
  dynamic longitude;
  int? isInsurance;
  int? userId;
  String? createdAt;
  String? updatedAt;

  FluffyProfile({
    this.id,
    this.firstName,
    this.lastName,
    this.birthYear,
    this.phoneNumber,
    this.companyName,
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

  factory FluffyProfile.fromJson(Map<String, dynamic> json) => FluffyProfile(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    birthYear: json["birth_year"],
    phoneNumber: json["phone_number"],
    companyName: json["company_name"],
    selectState: json["select_state"],
    location: json["location"],
    about: json["about"],
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
    "about": about,
    "latitude": latitude,
    "longitude": longitude,
    "is_insurance": isInsurance,
    "user_id": userId,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}