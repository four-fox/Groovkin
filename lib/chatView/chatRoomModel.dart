// To parse this JSON data, do
//
//     final chatRoomModel = chatRoomModelFromJson(jsonString);

import 'dart:convert';

import 'package:groovkin/Components/Network/Url.dart';
import 'package:groovkin/Components/colors.dart';

import '../links.dart';

ChatRoomModel chatRoomModelFromJson(String str) =>
    ChatRoomModel.fromJson(json.decode(str));

String chatRoomModelToJson(ChatRoomModel data) => json.encode(data.toJson());

class ChatRoomModel {
  bool? status;
  Data? data;
  String? message;

  ChatRoomModel({
    this.status,
    this.data,
    this.message,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => ChatRoomModel(
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
  List<ChatRoomObject>? data;
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
        data: json["data"] == null
            ? []
            : List<ChatRoomObject>.from(
                json["data"]!.map((x) => ChatRoomObject.fromJson(x))),
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

class ChatRoomObject {
  int? id;
  int? userId;
  int? addresserId;
  dynamic sourceId;
  String? conversationId;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  LastMessage? lastMessage;

  ChatRoomObject({
    this.id,
    this.userId,
    this.addresserId,
    this.sourceId,
    this.conversationId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.lastMessage,
  });

  factory ChatRoomObject.fromJson(Map<String, dynamic> json) => ChatRoomObject(
        id: json["id"],
        userId: json["user_id"],
        addresserId: json["addresser_id"],
        sourceId: json["source_id"],
        conversationId: json["conversation_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        lastMessage: json["last_message"] == null
            ? null
            : LastMessage.fromJson(json["last_message"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "addresser_id": addresserId,
        "source_id": sourceId,
        "conversation_id": conversationId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "last_message": lastMessage?.toJson(),
      };
}

class LastMessage {
  int? id;
  int? senderId;
  int? receiverId;
  dynamic sourceId;
  dynamic parentId;
  String? conversationId;
  String? msg;
  dynamic media;
  dynamic fileType;
  dynamic reply;
  dynamic deleteBy;
  int? isDeleted;
  int? isSeen;
  int? isEventRequest;
  dynamic eventRequestAccepted;
  int? flaggedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  LastMessage({
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
    this.isEventRequest,
    this.eventRequestAccepted,
    this.flaggedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        sourceId: json["source_id"],
        parentId: json["parent_id"],
        conversationId: json["conversation_id"],
        msg: json["msg"],
        media: json["media"],
        fileType: json["file_type"],
        reply: json["reply"],
        deleteBy: json["delete_by"],
        isDeleted: json["is_deleted"],
        isSeen: json["is_seen"],
        isEventRequest: json["is_event_request"],
        eventRequestAccepted: json["event_request_accepted"],
        flaggedBy: json["flagged_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class User {
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
  String? profilePicture;
  Profile? profile;

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
    this.profile,
    this.profilePicture,
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
        "profile_picture": profilePicture,
        "active_role": activeRole,
        "status": status,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "profile": profile?.toJson(),
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
    this.lastName,
    this.fullName,
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
        fullName: "${json["first_name"]} ${json["last_name"]}",
        lastName: json["last_name"],
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
