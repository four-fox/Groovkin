

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
  String? createdAt;
  String? updatedAt;
  String? user;
  String? parentChat;

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
    this.isEventRequest,
    this.eventRequestAccepted,
    this.flaggedBy,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.parentChat,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
    id: json["id"],
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    sourceId: json["source_id"] ?? "null",
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
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    user: json["user"] == null
        ? null
        : j.json.encode(User.fromJson(json["user"])),
    parentChat: json["parent_chat"] == null ? null : j.json.encode(ChatData.fromJson(json["parent_chat"])),
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
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user": user,
    "parent_chat": parentChat,
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