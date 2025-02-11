

// To parse this JSON data, do
//
//     final chatInnerDataModel = chatInnerDataModelFromJson(jsonString);

import 'dart:convert';
import 'dart:convert' as j;
import '../View/counters/messagesModel.dart';
import '../links.dart';

ChatInnerDataModel chatInnerDataModelFromJson(String str) => ChatInnerDataModel.fromJson(json.decode(str));

String chatInnerDataModelToJson(ChatInnerDataModel data) => json.encode(data.toJson());

class ChatInnerDataModel {
  bool? status;
  Data? data;
  String? message;

  ChatInnerDataModel({
    this.status,
    this.data,
    this.message,
  });

  factory ChatInnerDataModel.fromJson(Map<String, dynamic> json) => ChatInnerDataModel(
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
  List<ChatData>? data;
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
    data: json["data"] == null ? [] : List<ChatData>.from(json["data"]!.map((x) => ChatData.fromJson(x))),
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

class ChatData {
  int? id;
  int? senderId;
  int? receiverId;
  String? sourceId;
  int? parentId;
  String? conversationId;
  String? msg;
  String? media;
  String? fileType;
  String? reply;
  int? deleteBy;
  int? isDeleted;
  int? isSeen;
  int? isEventRequest;
  String? eventRequestAccepted;
  int? flaggedBy;
  String? type;
  String? createdAt;
  String? updatedAt;
  String? user;
  String? parentChat;
  String? event;

  ChatData({
    this.id,
    this.senderId,
    this.receiverId,
    this.sourceId,
    this.parentId,
    this.conversationId,
    this.msg,
    this.media,
    this.fileType,
    this.reply,
    this.deleteBy,
    this.isDeleted,
    this.isSeen,
    this.type,
    this.isEventRequest,
    this.eventRequestAccepted,
    this.flaggedBy,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.parentChat,
    this.event,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
    id: json["id"],
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    sourceId: json["source_id"].toString(),
    parentId: json["parent_id"],
    conversationId: json["conversation_id"],
    msg: json["msg"],
    media: json["media"] == null
        ? null
        : json["media"] == "null"
        ? null
        : json["media"] is String
        ? j.json.encode(List<Media>.from(j.json
        .decode(json["media"])
        .map((x) => Media.fromJson(x))))
        : j.json.encode(List<Media>.from(j.json
        .decode(j.json.encode(json["media"]))
        .map((x) => Media.fromJson(x)))),
    fileType: json["file_type"],
    reply: json["reply"],
    deleteBy: json["delete_by"],
    isDeleted: json["is_deleted"],
    isSeen: json["is_seen"],
    isEventRequest: json["is_event_request"],
    eventRequestAccepted: json["event_request_accepted"],
    flaggedBy: json["flagged_by"],
    type: json["type"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    user: json["user"] == null
        ? null
        : j.json.encode(User.fromJson(json["user"])),
    parentChat: json["parent_chat"] == null ? null : j.json.encode(ChatData.fromJson(json["parent_chat"])),
    event: json["event"] == null ? null : j.json.encode(Event.fromJson(json["event"])),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender_id": senderId,
    "receiver_id": receiverId,
    "source_id": sourceId,
    "parent_id": parentId,
    "conversation_id": conversationId,
    "msg": msg,
    "media": media,
    "file_type": fileType,
    "reply": reply,
    "delete_by": deleteBy,
    "is_deleted": isDeleted,
    "is_seen": isSeen,
    "is_event_request": isEventRequest,
    "event_request_accepted": eventRequestAccepted,
    "flagged_by": flaggedBy,
    "type": type,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user": user,
    "parent_chat": parentChat,
    "event": event,
  };
}

class Event {
  int? id;
  String? eventTitle;
  String? featuring;
  String? about;
  String? themeOfEvent;
  DateTime? startDateTime;
  DateTime? endDateTime;
  dynamic maxCapacity;
  String? rate;
  String? downPayment;
  String? balanceDue;
  String? totalAmount;
  String? rateType;
  String? paymentSchedule;
  String? comment;
  String? location;
  String? latitude;
  String? longitude;
  dynamic description;
  int? userId;
  int? venueId;
  dynamic acceptedBy;
  dynamic parentId;
  int? saveDraft;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ProfilePicture>? profilePicture;
  Venue? venue;
  BannerImage? bannerImage;

  Event({
    this.id,
    this.eventTitle,
    this.featuring,
    this.about,
    this.themeOfEvent,
    this.startDateTime,
    this.endDateTime,
    this.maxCapacity,
    this.rate,
    this.downPayment,
    this.balanceDue,
    this.totalAmount,
    this.rateType,
    this.paymentSchedule,
    this.comment,
    this.location,
    this.latitude,
    this.longitude,
    this.description,
    this.userId,
    this.venueId,
    this.acceptedBy,
    this.parentId,
    this.saveDraft,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.profilePicture,
    this.venue,
    this.bannerImage,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    eventTitle: json["event_title"],
    featuring: json["featuring"],
    about: json["about"],
    themeOfEvent: json["theme_of_event"],
    startDateTime: json["start_date_time"] == null ? null : DateTime.parse(json["start_date_time"]),
    endDateTime: json["end_date_time"] == null ? null : DateTime.parse(json["end_date_time"]),
    maxCapacity: json["max_capacity"],
    rate: json["rate"],
    downPayment: json["down_payment"],
    balanceDue: json["balance_due"],
    totalAmount: json["total_amount"],
    rateType: json["rate_type"],
    paymentSchedule: json["payment_schedule"],
    comment: json["comment"],
    location: json["location"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    description: json["description"],
    userId: json["user_id"],
    venueId: json["venue_id"],
    acceptedBy: json["accepted_by"],
    parentId: json["parent_id"],
    saveDraft: json["save_draft"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    profilePicture: json["profile_picture"] == null ? [] : List<ProfilePicture>.from(json["profile_picture"]!.map((x) => ProfilePicture.fromJson(x))),
    bannerImage: json["banner_image"] == null ? null : BannerImage.fromJson(json["banner_image"]),
    venue: json["venue"] == null ? null : Venue.fromJson(json["venue"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_title": eventTitle,
    "featuring": featuring,
    "about": about,
    "theme_of_event": themeOfEvent,
    "start_date_time": startDateTime?.toIso8601String(),
    "end_date_time": endDateTime?.toIso8601String(),
    "max_capacity": maxCapacity,
    "rate": rate,
    "down_payment": downPayment,
    "balance_due": balanceDue,
    "total_amount": totalAmount,
    "rate_type": rateType,
    "payment_schedule": paymentSchedule,
    "comment": comment,
    "location": location,
    "latitude": latitude,
    "longitude": longitude,
    "description": description,
    "user_id": userId,
    "venue_id": venueId,
    "accepted_by": acceptedBy,
    "parent_id": parentId,
    "save_draft": saveDraft,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "profile_picture": profilePicture == null ? [] : List<dynamic>.from(profilePicture!.map((x) => x.toJson())),
    "banner_image": bannerImage?.toJson(),
    "venue": venue?.toJson(),
  };
}


class BannerImage {
  int? id;
  String? mediaFor;
  dynamic thumbnail;
  String? mediaPath;
  String? mediaType;
  String? galleryableType;
  int? galleryableId;
  DateTime? createdAt;
  DateTime? updatedAt;

  BannerImage({
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

  factory BannerImage.fromJson(Map<String, dynamic> json) => BannerImage(
    id: json["id"],
    mediaFor: json["media_for"],
    thumbnail: json["thumbnail"],
    mediaPath: json["media_path"],
    mediaType: json["media_type"],
    galleryableType: json["galleryable_type"],
    galleryableId: json["galleryable_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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

class Venue {
  int? id;
  String? location;
  String? venueName;
  String? streetAddress;
  String? state;
  dynamic city;
  String? zipCode;
  String? phoneNumber;
  String? latitude;
  String? longitude;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  List<ProfilePicture>? profilePicture;

  Venue({
    this.id,
    this.location,
    this.venueName,
    this.streetAddress,
    this.state,
    this.city,
    this.zipCode,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.profilePicture,
  });

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
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
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    profilePicture: json["profile_picture"] == null ? [] : List<ProfilePicture>.from(json["profile_picture"]!.map((x) => ProfilePicture.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location": location,
    "venue_name": venueName,
    "street_address": streetAddress,
    "state": state,
    "city": city,
    "zip_code": zipCode,
    "phone_number": phoneNumber,
    "latitude": latitude,
    "longitude": longitude,
    "user_id": userId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
    "profile_picture": profilePicture == null ? [] : List<dynamic>.from(profilePicture!.map((x) => x.toJson())),
  };
}


class User {
  int? id;
  String? name;
  String? email;
  dynamic deviceToken;
  dynamic referralCode;
  dynamic emailVerifiedAt;
  dynamic otp;
  String? customerId;
  dynamic connectAccountId;
  int? isConnectedAccountExist;
  String? activeRole;
  dynamic status;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
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
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
  };
}