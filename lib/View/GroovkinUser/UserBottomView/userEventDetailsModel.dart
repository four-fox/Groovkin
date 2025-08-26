// To parse this JSON data, do
//
//     final userEventDetailsModel = userEventDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:groovkin/View/GroovkinManager/venueDetailsModel.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';

UserEventDetailsModel userEventDetailsModelFromJson(String str) =>
    UserEventDetailsModel.fromJson(json.decode(str));

String userEventDetailsModelToJson(UserEventDetailsModel data) =>
    json.encode(data.toJson());

class UserEventDetailsModel {
  bool? status;
  EventDetails? data;
  String? message;

  UserEventDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory UserEventDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserEventDetailsModel(
        status: json["status"],
        data: json["data"] == null ? null : EventDetails.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class EventDetails {
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
  DateTime? createdAt;
  DateTime? updatedAt;
  int? eventsGoingCount;
  dynamic ratingAvgRateNum;
  int? eventsInterestedCount;
  RxInt? eventGoingOrInterested;
  RxInt? isEventComplete;
  RxInt? isCounterActive;
  Venue? venue;
  List<BannerImage>? profilePicture;
  BannerImage? bannerImage;
  User? user;
  List<Service>? services;
  List<HardwareProvide>? hardwareProvide;
  List<MusicGenre>? musicGenre;
  List<EventMusicChoiceTag>? eventMusicChoiceTags;
  List<EventActivityChoiceTag>? eventActivityChoiceTags;
  List<Rating>? rating;
  EventDetails({
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
    this.eventsGoingCount,
    this.eventsInterestedCount,
    this.eventGoingOrInterested,
    this.isEventComplete,
    this.isCounterActive,
    this.venue,
    this.profilePicture,
    this.bannerImage,
    this.user,
    this.services,
    this.hardwareProvide,
    this.musicGenre,
    this.eventMusicChoiceTags,
    this.eventActivityChoiceTags,
    this.ratingAvgRateNum,
    this.rating,
  });

  factory EventDetails.fromJson(Map<String, dynamic> json) => EventDetails(
        id: json["id"],
        eventTitle: json["event_title"],
        featuring: json["featuring"],
        about: json["about"],
        themeOfEvent: json["theme_of_event"],
        startDateTime: json["start_date_time"] == null
            ? null
            : DateTime.parse(json["start_date_time"]),
        endDateTime: json["end_date_time"] == null
            ? null
            : DateTime.parse(json["end_date_time"]),
        ratingAvgRateNum: json["ratings_avg_rate_num"] ?? 0,
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
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        eventsGoingCount: json["events_going_count"],
        eventsInterestedCount: json["events_interested_count"],
        eventGoingOrInterested: RxInt(json["event_going_or_interested"]),
        isEventComplete: RxInt(json["is_event_complete"]),
        isCounterActive: RxInt(json["is_counter_active"]),
        venue: json["venue"] == null ? null : Venue.fromJson(json["venue"]),
        profilePicture: json["profile_picture"] == null
            ? []
            : List<BannerImage>.from(
                json["profile_picture"]!.map((x) => BannerImage.fromJson(x))),
        bannerImage: json["banner_image"] == null
            ? null
            : BannerImage.fromJson(json["banner_image"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
        hardwareProvide: json["hardware_provide"] == null
            ? []
            : List<HardwareProvide>.from(json["hardware_provide"]!
                .map((x) => HardwareProvide.fromJson(x))),
        musicGenre: json["music_genre"] == null
            ? []
            : List<MusicGenre>.from(
                json["music_genre"]!.map((x) => MusicGenre.fromJson(x))),
        eventMusicChoiceTags: json["event_music_choice_tags"] == null
            ? []
            : List<EventMusicChoiceTag>.from(json["event_music_choice_tags"]!
                .map((x) => EventMusicChoiceTag.fromJson(x))),
        eventActivityChoiceTags: json["event_activity_choice_tags"] == null
            ? []
            : List<EventActivityChoiceTag>.from(
                json["event_activity_choice_tags"]!
                    .map((x) => EventActivityChoiceTag.fromJson(x))),
        rating: json["ratings"] == null
            ? []
            : List<Rating>.from(
                json["ratings"]!.map((x) => Rating.fromJson(x))),
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "events_going_count": eventsGoingCount,
        "events_interested_count": eventsInterestedCount,
        "event_going_or_interested": eventGoingOrInterested,
        "is_event_complete": isEventComplete,
        "is_counter_active": isCounterActive,
        "venue": venue?.toJson(),
        "profile_picture": profilePicture == null
            ? []
            : List<dynamic>.from(profilePicture!.map((x) => x.toJson())),
        "banner_image": bannerImage?.toJson(),
        "user": user?.toJson(),
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        "hardware_provide": hardwareProvide == null
            ? []
            : List<dynamic>.from(hardwareProvide!.map((x) => x.toJson())),
        "music_genre": musicGenre == null
            ? []
            : List<dynamic>.from(musicGenre!.map((x) => x.toJson())),
        "event_music_choice_tags": eventMusicChoiceTags == null
            ? []
            : List<dynamic>.from(eventMusicChoiceTags!.map((x) => x.toJson())),
        "event_activity_choice_tags": eventActivityChoiceTags == null
            ? []
            : List<dynamic>.from(
                eventActivityChoiceTags!.map((x) => x.toJson())),
      };
}

class Rating {
  int? id;
  String? ratingText;
  int? sourceId;
  int? ratedBy;
  int? venueId;
  int? rateNum;
  String? type;
  String? createdAt;
  String? updatedAt;
  User? user;

  Rating({
    this.id,
    this.ratingText,
    this.sourceId,
    this.ratedBy,
    this.venueId,
    this.rateNum,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
        id: json["id"],
        ratingText: json["rating_text"],
        rateNum: json["rate_num"],
        sourceId: json["source_id"],
        createdAt: json["created_at"],
        ratedBy: json["rated_by"],
        type: json["type"],
        updatedAt: json["updated_at"],
        venueId: json["venue_id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]));
  }
}

class EventActivityChoiceTag {
  int? id;
  int? userId;
  int? eventId;
  int? eventTagId;
  int? eventTagItemId;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  ChoiceItems? activityChoiceItems;

  EventActivityChoiceTag({
    this.id,
    this.userId,
    this.eventId,
    this.eventTagId,
    this.eventTagItemId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.activityChoiceItems,
  });

  factory EventActivityChoiceTag.fromJson(Map<String, dynamic> json) =>
      EventActivityChoiceTag(
        id: json["id"],
        userId: json["user_id"],
        eventId: json["event_id"],
        eventTagId: json["event_tag_id"],
        eventTagItemId: json["event_tag_item_id"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        activityChoiceItems: json["activity_choice_items"] == null
            ? null
            : ChoiceItems.fromJson(json["activity_choice_items"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "event_id": eventId,
        "event_tag_id": eventTagId,
        "event_tag_item_id": eventTagItemId,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "activity_choice_items": activityChoiceItems?.toJson(),
      };
}

class ChoiceItems {
  int? id;
  int? eventTagId;
  String? name;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  ChoiceItems({
    this.id,
    this.eventTagId,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory ChoiceItems.fromJson(Map<String, dynamic> json) => ChoiceItems(
        id: json["id"],
        eventTagId: json["event_tag_id"],
        name: json["name"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_tag_id": eventTagId,
        "name": name,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class EventMusicChoiceTag {
  int? id;
  int? userId;
  int? eventId;
  int? eventTagId;
  int? eventTagItemId;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  ChoiceItems? musicChoiceItems;

  EventMusicChoiceTag({
    this.id,
    this.userId,
    this.eventId,
    this.eventTagId,
    this.eventTagItemId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.musicChoiceItems,
  });

  factory EventMusicChoiceTag.fromJson(Map<String, dynamic> json) =>
      EventMusicChoiceTag(
        id: json["id"],
        userId: json["user_id"],
        eventId: json["event_id"],
        eventTagId: json["event_tag_id"],
        eventTagItemId: json["event_tag_item_id"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        musicChoiceItems: json["music_choice_items"] == null
            ? null
            : ChoiceItems.fromJson(json["music_choice_items"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "event_id": eventId,
        "event_tag_id": eventTagId,
        "event_tag_item_id": eventTagItemId,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "music_choice_items": musicChoiceItems?.toJson(),
      };
}

class HardwareProvide {
  int? id;
  int? userId;
  int? eventId;
  int? eventItemId;
  int? eventSubItemId;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  HardwareItems? hardwareItems;

  HardwareProvide({
    this.id,
    this.userId,
    this.eventId,
    this.eventItemId,
    this.eventSubItemId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.hardwareItems,
  });

  factory HardwareProvide.fromJson(Map<String, dynamic> json) =>
      HardwareProvide(
        id: json["id"],
        userId: json["user_id"],
        eventId: json["event_id"],
        eventItemId: json["event_item_id"],
        eventSubItemId: json["event_sub_item_id"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        hardwareItems: json["hardware_items"] == null
            ? null
            : HardwareItems.fromJson(json["hardware_items"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "event_id": eventId,
        "event_item_id": eventItemId,
        "event_sub_item_id": eventSubItemId,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "hardware_items": hardwareItems?.toJson(),
      };
}

class HardwareItems {
  int? id;
  int? eventId;
  String? name;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  HardwareItems({
    this.id,
    this.eventId,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory HardwareItems.fromJson(Map<String, dynamic> json) => HardwareItems(
        id: json["id"],
        eventId: json["event_id"],
        name: json["name"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "name": name,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class MusicGenre {
  int? id;
  int? userId;
  int? eventId;
  int? categoryId;
  int? itemId;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  MusicGenreItems? musicGenreItems;

  MusicGenre({
    this.id,
    this.userId,
    this.eventId,
    this.categoryId,
    this.itemId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.musicGenreItems,
  });

  factory MusicGenre.fromJson(Map<String, dynamic> json) => MusicGenre(
        id: json["id"],
        userId: json["user_id"],
        eventId: json["event_id"],
        categoryId: json["category_id"],
        itemId: json["item_id"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        musicGenreItems: json["music_genre_items"] == null
            ? null
            : MusicGenreItems.fromJson(json["music_genre_items"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "event_id": eventId,
        "category_id": categoryId,
        "item_id": itemId,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "music_genre_items": musicGenreItems?.toJson(),
      };
}

class MusicGenreItems {
  int? id;
  int? categoryId;
  String? name;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  MusicGenreItems({
    this.id,
    this.categoryId,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory MusicGenreItems.fromJson(Map<String, dynamic> json) =>
      MusicGenreItems(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Service {
  int? id;
  int? userId;
  int? eventId;
  int? eventItemId;
  dynamic eventSubItemId;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  EventItem? eventItem;

  Service({
    this.id,
    this.userId,
    this.eventId,
    this.eventItemId,
    this.eventSubItemId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.eventItem,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        userId: json["user_id"],
        eventId: json["event_id"],
        eventItemId: json["event_item_id"],
        eventSubItemId: json["event_sub_item_id"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        eventItem: json["event_item"] == null
            ? null
            : EventItem.fromJson(json["event_item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "event_id": eventId,
        "event_item_id": eventItemId,
        "event_sub_item_id": eventSubItemId,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "event_item": eventItem?.toJson(),
      };
}

class EventItem {
  int? id;
  String? name;
  String? image;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? categoryItems;

  EventItem({
    this.id,
    this.name,
    this.image,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.categoryItems,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) => EventItem(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        categoryItems: json["category_items"] == null
            ? []
            : List<dynamic>.from(json["category_items"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "category_items": categoryItems == null
            ? []
            : List<dynamic>.from(categoryItems!.map((x) => x)),
      };
}
