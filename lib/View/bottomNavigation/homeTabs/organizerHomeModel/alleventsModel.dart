// To parse this JSON data, do
//
//     final eventsListModel = eventsListModelFromJson(jsonString);

import 'dart:convert';
import '../../../../Components/Network/API.dart';
import '../../../../Components/Network/Url.dart';
import '../../../../links.dart';
import '../../../GroovkinManager/venueDetailsModel.dart';

EventsListModel eventsListModelFromJson(String str) =>
    EventsListModel.fromJson(json.decode(str));

String eventsListModelToJson(EventsListModel data) =>
    json.encode(data.toJson());

class EventsListModel {
  bool? status;
  Data? data;
  String? message;

  EventsListModel({
    this.status,
    this.data,
    this.message,
  });

  factory EventsListModel.fromJson(Map<String, dynamic> json) =>
      EventsListModel(
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
  List<EventData> data;
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
    this.data = const [],
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
            : List<EventData>.from(
                json["data"]!.map((x) => EventData.fromJson(x))),
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
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
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

class EventData {
  int? id;
  String? eventTitle;
  String? featuring;
  String? about;
  String? themeOfEvent;
  DateTime? date;
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
  String? description;
  int? userId;
  int? venueId;
  int? acceptedBy;
  int? saveDraft;
  String? status;
  String? createdAt;
  String? updatedAt;
  Venue? venue;
  List<ProfilePicture>? profilePicture;
  BannerImage? bannerImage;
  // DatumUser? user;
  User? user;
  List<Service>? services;
  List<HardwareProvide>? hardwareProvide;
  List<MusicGenre>? musicGenre;
  List<EventMusicChoiceTag>? eventMusicChoiceTags;
  List<EventMusicChoiceTag>? eventActivityChoiceTags;
  List<EventHashtag>? hashtags;
  Recommendation? recommendation;
  double? distance;

  EventData({
    this.id,
    this.eventTitle,
    this.featuring,
    this.about,
    this.themeOfEvent,
    this.startDateTime,
    this.endDateTime,
    this.maxCapacity,
    this.rate,
    this.description,
    this.downPayment,
    this.balanceDue,
    this.totalAmount,
    this.rateType,
    this.paymentSchedule,
    this.comment,
    this.location,
    this.latitude,
    this.longitude,
    this.userId,
    this.venueId,
    this.acceptedBy,
    this.saveDraft,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.venue,
    this.profilePicture,
    this.bannerImage,
    this.user,
    this.services,
    this.hardwareProvide,
    this.musicGenre,
    this.eventMusicChoiceTags,
    this.eventActivityChoiceTags,
    this.hashtags,
    this.recommendation,
    this.distance,
  });

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
        id: json["id"],
        eventTitle: json["event_title"],
        featuring: json["featuring"],
        about: json["about"],
        themeOfEvent: json["theme_of_event"],
        description: json["description"],
        startDateTime: json["start_date_time"] == null
            ? null
            : DateTime.parse(json["start_date_time"]),
        endDateTime: json["end_date_time"] == null
            ? null
            : DateTime.parse(json["end_date_time"]),
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
        userId: json["user_id"],
        venueId: json["venue_id"],
        acceptedBy: json["accepted_by"],
        saveDraft: json["save_draft"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        venue: json["venue"] == null ? null : Venue.fromJson(json["venue"]),
        profilePicture: json["profile_picture"] == null
            ? []
            : List<ProfilePicture>.from(json["profile_picture"]!
                .map((x) => ProfilePicture.fromJson(x))),
        bannerImage: json["banner_image"] == null
            ? null
            : BannerImage.fromJson(json["banner_image"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
        hardwareProvide: json["hardwares"] == null
            ? []
            : List<HardwareProvide>.from(
                json["hardwares"]!.map((x) => HardwareProvide.fromJson(x))),
        musicGenre: json["genre"] == null
            ? []
            : List<MusicGenre>.from(
                json["genre"]!.map((x) => MusicGenre.fromJson(x))),
        eventMusicChoiceTags: json["eventMusicChoiceTags"] == null
            ? []
            : List<EventMusicChoiceTag>.from(json["eventMusicChoiceTags"]!
                .map((x) => EventMusicChoiceTag.fromJson(x))),
        eventActivityChoiceTags: json["eventActivityChoiceTags"] == null
            ? []
            : List<EventMusicChoiceTag>.from(json["eventActivityChoiceTags"]!
                .map((x) => EventMusicChoiceTag.fromJson(x))),
        hashtags: json["hashtags"] == null
            ? []
            : List<EventHashtag>.from(
                json["hashtags"]!.map((x) => EventHashtag.fromJson(x))),
        recommendation: json["recommendation"] is Map
            ? Recommendation.fromJson(
                Map<String, dynamic>.from(json["recommendation"]))
            : null,
        distance: json["distance"] is num
            ? (json["distance"] as num).toDouble()
            : double.tryParse(json["distance"]?.toString() ?? ""),
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
        "user_id": userId,
        "venue_id": venueId,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
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
            : List<dynamic>.from(musicGenre!.map((x) => x)),
        "event_music_choice_tags": eventMusicChoiceTags == null
            ? []
            : List<dynamic>.from(eventMusicChoiceTags!.map((x) => x.toJson())),
        "event_activity_choice_tags": eventActivityChoiceTags == null
            ? []
            : List<dynamic>.from(eventActivityChoiceTags!.map((x) => x)),
        "hashtags": hashtags == null
            ? []
            : List<dynamic>.from(hashtags!.map((x) => x.toJson())),
        "recommendation": recommendation?.toJson(),
        "distance": distance,
      };
}

class Recommendation {
  static const knownReasons = <String>{
    'followed_organizer',
    'followed_venue',
    'music_match',
    'activity_match',
    'hashtag_match',
    'nearby',
  };

  const Recommendation({
    this.reasons = const [],
    this.matchedMusic = const [],
    this.matchedActivities = const [],
    this.matchedHashtags = const [],
  });

  final List<String> reasons;
  final List<MatchedPreference> matchedMusic;
  final List<MatchedPreference> matchedActivities;
  final List<MatchedHashtag> matchedHashtags;

  factory Recommendation.fromJson(Map<String, dynamic> json) => Recommendation(
        reasons: _stringList(json['reasons'])
            .where(knownReasons.contains)
            .toList(growable: false),
        matchedMusic: _modelList(
          json['matched_music'],
          MatchedPreference.fromJson,
        ),
        matchedActivities: _modelList(
          json['matched_activities'],
          MatchedPreference.fromJson,
        ),
        matchedHashtags: _modelList(
          json['matched_hashtags'],
          MatchedHashtag.fromJson,
        ),
      );

  Map<String, dynamic> toJson() => {
        'reasons': reasons,
        'matched_music': matchedMusic.map((item) => item.toJson()).toList(),
        'matched_activities':
            matchedActivities.map((item) => item.toJson()).toList(),
        'matched_hashtags':
            matchedHashtags.map((item) => item.toJson()).toList(),
      };

  String? get displayReason {
    if (reasons.contains('music_match') && matchedMusic.isNotEmpty) {
      return 'Because you like ${matchedMusic.first.name}';
    }
    if (reasons.contains('activity_match') && matchedActivities.isNotEmpty) {
      return 'Matches your ${matchedActivities.first.name} interests';
    }
    if (reasons.contains('hashtag_match') && matchedHashtags.isNotEmpty) {
      return 'Matches ${matchedHashtags.first.displayName}';
    }
    if (reasons.contains('followed_organizer')) {
      return 'From an organizer you follow';
    }
    if (reasons.contains('followed_venue')) {
      return 'From a venue you follow';
    }
    if (reasons.contains('nearby')) return 'In your selected area';
    return null;
  }
}

class MatchedPreference {
  const MatchedPreference({this.id, required this.name});

  final int? id;
  final String name;

  factory MatchedPreference.fromJson(Map<String, dynamic> json) =>
      MatchedPreference(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id']?.toString() ?? ''),
        name: json['name']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class MatchedHashtag {
  const MatchedHashtag({required this.name, required this.displayName});

  final String name;
  final String displayName;

  factory MatchedHashtag.fromJson(Map<String, dynamic> json) {
    final name = json['name']?.toString() ?? '';
    return MatchedHashtag(
      name: name,
      displayName:
          json['display_name']?.toString() ?? (name.isEmpty ? '' : '#$name'),
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'display_name': displayName};
}

List<String> _stringList(dynamic value) =>
    value is List ? value.map((item) => item.toString()).toList() : const [];

List<T> _modelList<T>(
  dynamic value,
  T Function(Map<String, dynamic>) fromJson,
) =>
    value is List
        ? value
            .whereType<Map>()
            .map((item) => fromJson(Map<String, dynamic>.from(item)))
            .toList()
        : const [];

class EventHashtag {
  int? id;
  String? name;
  String? displayName;

  EventHashtag({
    this.id,
    this.name,
    this.displayName,
  });

  factory EventHashtag.fromJson(Map<String, dynamic> json) => EventHashtag(
        id: json["id"],
        name: json["name"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "display_name": displayName,
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
  String? createdAt;
  String? updatedAt;

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
        mediaPath: json["media_path"] == null
            ? dummyProfile
            : Url().imageUrl + json["media_path"],
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

class MusicGenre {
  int? id;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;
  List<MusicGenreEventItem>? eventItem;

  MusicGenre({
    this.id,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.eventItem,
  });

  factory MusicGenre.fromJson(Map<String, dynamic> json) => MusicGenre(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      eventItem: json["category_items"] == null
          ? []
          : List<MusicGenreEventItem>.from(json["category_items"].map(
              (x) => MusicGenreEventItem.fromJson(x),
            )));

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class MusicGenreEventItem {
  int? id;
  int? categoryId;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;
  bool? selected;

  MusicGenreEventItem({
    this.id,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.selected,
    this.categoryId,
  });

  factory MusicGenreEventItem.fromJson(Map<String, dynamic> json) =>
      MusicGenreEventItem(
          id: json["id"],
          name: json["name"],
          categoryId: json["category_id"],
          type: json["type"],
          createdAt: json["created_at"],
          updatedAt: json["updated_at"],
          selected: json["selected"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

// class FluffyCategoryItem {
//   int? id;
//   int? categoryId;
//   String? name;
//   String? type;
//   String? createdAt;
//   String? updatedAt;

//   FluffyCategoryItem({
//     this.id,
//     this.categoryId,
//     this.name,
//     this.type,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory FluffyCategoryItem.fromJson(Map<String, dynamic> json) =>
//       FluffyCategoryItem(
//         id: json["id"],
//         categoryId: json["category_id"],
//         name: json["name"],
//         type: json["type"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "category_id": categoryId,
//         "name": name,
//         "type": type,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//       };
// }

class EventMusicChoiceTag {
  int? id;
  int? userId;
  int? eventId;
  int? eventTagId;
  int? eventTagItemId;
  String? type;
  String? createdAt;
  String? updatedAt;
  EventTagItem? eventTagItem;

  EventMusicChoiceTag({
    this.id,
    this.userId,
    this.eventId,
    this.eventTagId,
    this.eventTagItemId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.eventTagItem,
  });

  factory EventMusicChoiceTag.fromJson(Map<String, dynamic> json) =>
      EventMusicChoiceTag(
        id: json["id"],
        userId: json["user_id"],
        eventId: json["event_id"],
        eventTagId: json["event_tag_id"],
        eventTagItemId: json["event_tag_item_id"],
        type: json["type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        eventTagItem: json["event_tag_item"] == null
            ? null
            : EventTagItem.fromJson(json["event_tag_item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "event_id": eventId,
        "event_tag_id": eventTagId,
        "event_tag_item_id": eventTagItemId,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "event_tag_item": eventTagItem?.toJson(),
      };
}

class EventTagItem {
  int? id;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;
  List<EventTagItemCategoryItem>? categoryItems;

  EventTagItem({
    this.id,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.categoryItems,
  });

  factory EventTagItem.fromJson(Map<String, dynamic> json) => EventTagItem(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        categoryItems: json["category_items"] == null
            ? []
            : List<EventTagItemCategoryItem>.from(json["category_items"]!
                .map((x) => EventTagItemCategoryItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "category_items": categoryItems == null
            ? []
            : List<dynamic>.from(categoryItems!.map((x) => x.toJson())),
      };
}

class EventTagItemCategoryItem {
  int? id;
  int? eventTagId;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;
  bool? userSelection;

  EventTagItemCategoryItem({
    this.id,
    this.eventTagId,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.userSelection,
  });

  factory EventTagItemCategoryItem.fromJson(Map<String, dynamic> json) =>
      EventTagItemCategoryItem(
          id: json["id"],
          eventTagId: json["event_tag_id"],
          name: json["name"],
          type: json["type"],
          createdAt: json["created_at"],
          updatedAt: json["updated_at"],
          userSelection: json["user_selections"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_tag_id": eventTagId,
        "name": name,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class HardwareProvide {
  int? id;
  String? name;
  String? image;
  String? type;
  String? createdAt;
  String? updatedAt;
  List<HardwareProvideEventItem>? eventItem;

  HardwareProvide({
    this.id,
    this.name,
    this.image,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.eventItem,
  });

  factory HardwareProvide.fromJson(Map<String, dynamic> json) =>
      HardwareProvide(
          id: json["id"],
          name: json["name"],
          type: json["type"],
          image: json["image"],
          createdAt: json["created_at"],
          updatedAt: json["updated_at"],
          eventItem: json["category_items"] == null
              ? []
              : List<HardwareProvideEventItem>.from(json["category_items"]
                  .map((x) => HardwareProvideEventItem.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class HardwareProvideEventItem {
  int? id;
  String? name;
  int? eventId;
  String? type;
  String? createdAt;
  String? updatedAt;
  bool? selected;

  HardwareProvideEventItem({
    this.id,
    this.name,
    this.eventId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.selected,
  });

  factory HardwareProvideEventItem.fromJson(Map<String, dynamic> json) =>
      HardwareProvideEventItem(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        eventId: json["event_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        selected: json["selected"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

// class EventItemCategoryItem {
//   int? id;
//   int? eventId;
//   String? name;
//   String? type;
//   String? createdAt;
//   String? updatedAt;

//   EventItemCategoryItem({
//     this.id,
//     this.eventId,
//     this.name,
//     this.type,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory EventItemCategoryItem.fromJson(Map<String, dynamic> json) =>
//       EventItemCategoryItem(
//         id: json["id"],
//         eventId: json["event_id"],
//         name: json["name"],
//         type: json["type"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "event_id": eventId,
//         "name": name,
//         "type": type,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//       };
// }

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
        mediaPath: json["media_path"] == null
            ? null
            : Url().imageUrl + json["media_path"],
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

class Service {
  int? id;
  int? userId;
  int? eventId;
  int? eventItemId;
  String? type;
  String? createdAt;
  String? updatedAt;
  ServiceEventItem? eventItem;

  Service({
    this.id,
    this.userId,
    this.eventId,
    this.eventItemId,
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
        type: json["type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        eventItem: json["event_item"] == null
            ? null
            : ServiceEventItem.fromJson(json["event_item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "event_id": eventId,
        "event_item_id": eventItemId,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "event_item": eventItem?.toJson(),
      };
}

class ServiceEventItem {
  int? id;
  String? name;
  String? image;
  String? type;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? categoryItems;

  ServiceEventItem({
    this.id,
    this.name,
    this.image,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.categoryItems,
  });

  factory ServiceEventItem.fromJson(Map<String, dynamic> json) =>
      ServiceEventItem(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        categoryItems: json["category_items"] == null
            ? []
            : List<dynamic>.from(json["category_items"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "category_items": categoryItems == null
            ? []
            : List<dynamic>.from(categoryItems!.map((x) => x)),
      };
}

class DatumUser {
  int? id;
  String? name;
  String? email;
  String? deviceToken;
  dynamic emailVerifiedAt;
  dynamic otp;
  String? createdAt;
  String? updatedAt;
  String? deleteAt;
  PurpleProfile? profile;
  Following? following;
  Following? followers;
  ProfilePicture? profilePicture;
  DatumUser({
    this.id,
    this.name,
    this.email,
    this.deviceToken,
    this.emailVerifiedAt,
    this.otp,
    this.createdAt,
    this.updatedAt,
    this.profile,
    this.deleteAt,
    this.following,
    this.followers,
    this.profilePicture,
  });

  factory DatumUser.fromJson(Map<String, dynamic> json) => DatumUser(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        deviceToken: json["device_token"],
        emailVerifiedAt: json["email_verified_at"],
        otp: json["otp"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deleteAt: json["deleted_at"],
        following: json["following"] == null
            ? null
            : Following.fromJson(json["following"]),
        followers: json["follower"] == null
            ? null
            : Following.fromJson(json["follower"]),
        profilePicture: json["profile_picture"] == null
            ? null
            : ProfilePicture.fromJson(json["profile_picture"]),
        profile: json["profile"] == null
            ? null
            : PurpleProfile.fromJson(json["profile"]),
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

class PurpleProfile {
  int? id;
  String? firstName;
  String? lastName;
  dynamic birthYear;
  String? phoneNumber;
  dynamic companyName;
  String? selectState;
  dynamic location;
  dynamic latitude;
  dynamic longitude;
  int? isInsurance;
  int? userId;
  String? createdAt;
  String? updatedAt;

  PurpleProfile({
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

  factory PurpleProfile.fromJson(Map<String, dynamic> json) => PurpleProfile(
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

class Venue {
  int? id;
  String? location;
  String? venueName;
  String? streetAddress;
  String? state;
  String? city;
  String? zipCode;
  String? phoneNumber;
  String? latitude;
  String? longitude;
  String? website;
  int? userId;
  String? createdAt;
  String? updatedAt;
  User? user;
  Following? following;
  Following? follower;
  List<BannerImage>? profilePicture;

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
    this.following,
    this.follower,
    this.website,
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
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        website: json["website"],
        following: json["following"] == null
            ? null
            : Following.fromJson(json["following"]),
        follower: json["follower"] == null
            ? null
            : Following.fromJson(json["follower"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        profilePicture: json["profile_picture"] == null
            ? []
            : List<BannerImage>.from(
                json["profile_picture"]!.map((x) => BannerImage.fromJson(x))),
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
        "user": user?.toJson(),
        "profile_picture": profilePicture == null
            ? []
            : List<dynamic>.from(profilePicture!.map((x) => x.toJson())),
      };
}
