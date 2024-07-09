


// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

import 'package:groovkin/links.dart';

import '../../Components/Network/Url.dart';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  bool? status;
  Data? data;
  String? message;

  ChatModel({
    this.status,
    this.data,
    this.message,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
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
  List<MessageItem>? data;
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
    data: json["data"] == null ? [] : List<MessageItem>.from(json["data"]!.map((x) => MessageItem.fromJson(x))),
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

class MessageItem {
  int? id;
  int? senderId;
  int? receiverId;
  int? sourceId;
  dynamic parentId;
  String? conversationId;
  String? msg;
  List<Media>? media;
  dynamic fileType;
  dynamic reply;
  dynamic deleteBy;
  int? isDeleted;
  int? isSeen;
  int? isEventRequest;
  dynamic eventRequestAccepted;
  int? flaggedBy;
  String? createdAt;
  String? updatedAt;
  User? user;
  dynamic parentChat;

  MessageItem({
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

  factory MessageItem.fromJson(Map<String, dynamic> json) => MessageItem(
    id: json["id"],
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    sourceId: json["source_id"],
    parentId: json["parent_id"],
    conversationId: json["conversation_id"],
    msg: json["msg"],
    media: json["media"] == null ? [] : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
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
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    parentChat: json["parent_chat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender_id": senderId,
    "receiver_id": receiverId,
    "source_id": sourceId,
    "parent_id": parentId,
    "conversation_id": conversationId,
    "msg": msg,
    "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
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
    "user": user?.toJson(),
    "parent_chat": parentChat,
  };
}
class Media {
  String? fileType;
  String? filename;

  Media({
    this.fileType,
    this.filename,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    fileType: json["file_type"],
    filename:Url().imageUrl+ json["filename"],
  );

  Map<String, dynamic> toJson() => {
    "file_type": fileType,
    "filename": filename,
  };
}

class EventRequest {
  int? id;
  String? eventTitle;
  String? featuring;
  String? about;
  String? themeOfEvent;
  DateTime? startDateTime;
  DateTime? endDateTime;
  String? maxCapacity;
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
  String? status;
  String? createdAt;
  String? updatedAt;

  EventRequest({
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
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory EventRequest.fromJson(Map<String, dynamic> json) => EventRequest(
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
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
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
    "status": status,
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

  User({
    this.id,
    this.name,
    this.email,
    this.deviceToken,
    this.emailVerifiedAt,
    this.otp,
    this.createdAt,
    this.updatedAt,
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
  };
}