import 'dart:convert';

class MyGroovkinModel {
  bool status;
  Data data;
  String message;

  MyGroovkinModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory MyGroovkinModel.fromRawJson(String str) => MyGroovkinModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyGroovkinModel.fromJson(Map<String, dynamic> json) => MyGroovkinModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  List<HardwareProvide> services;
  List<HardwareProvide> hardwareProvides;
  List<MusicGenre> musicGenre;
  int isInsurance;

  Data({
    required this.services,
    required this.hardwareProvides,
    required this.musicGenre,
    required this.isInsurance,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        services: List<HardwareProvide>.from(
            json["services"].map((x) => HardwareProvide.fromJson(x))),
        hardwareProvides: List<HardwareProvide>.from(
            json["hardware_provides"].map((x) => HardwareProvide.fromJson(x))),
        musicGenre: List<MusicGenre>.from(
            json["music_genre"].map((x) => MusicGenre.fromJson(x))),
        isInsurance: json["is_insurance"],
      );

  Map<String, dynamic> toJson() => {
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
        "hardware_provides":
            List<dynamic>.from(hardwareProvides.map((x) => x.toJson())),
        "music_genre": List<dynamic>.from(musicGenre.map((x) => x.toJson())),
        "is_insurance": isInsurance,
      };
}

class HardwareProvide {
  int id;
  int userId;
  int? eventId;
  int eventItemId;
  int? eventSubItemId;
  String type;
  String userType;
  DateTime createdAt;
  DateTime updatedAt;
  Item eventItem;

  HardwareProvide({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.eventItemId,
    required this.eventSubItemId,
    required this.type,
    required this.userType,
    required this.createdAt,
    required this.updatedAt,
    required this.eventItem,
  });

  factory HardwareProvide.fromRawJson(String str) =>
      HardwareProvide.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HardwareProvide.fromJson(Map<String, dynamic> json) =>
      HardwareProvide(
        id: json["id"],
        userId: json["user_id"],
        eventId: json["event_id"],
        eventItemId: json["event_item_id"],
        eventSubItemId: json["event_sub_item_id"],
        type: json["type"],
        userType: json["user_type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        eventItem: Item.fromJson(json["event_item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "event_id": eventId,
        "event_item_id": eventItemId,
        "event_sub_item_id": eventSubItemId,
        "type": type,
        "user_type": userType,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "event_item": eventItem.toJson(),
      };
}

class Item {
  int id;
  String name;
  String? image;
  Type type;
  DateTime createdAt;
  DateTime updatedAt;
  List<Item>? categoryItems;
  int? categoryId;

  Item({
    required this.id,
    required this.name,
    this.image,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.categoryItems,
    this.categoryId,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: typeValues.map[json["type"]]!,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        categoryItems: json["category_items"] == null
            ? []
            : List<Item>.from(
                json["category_items"]!.map((x) => Item.fromJson(x))),
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": typeValues.reverse[type],
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "category_items": categoryItems == null
            ? []
            : List<dynamic>.from(categoryItems!.map((x) => x.toJson())),
        "category_id": categoryId,
      };
}

enum Type { MUSIC_GENRE, SERVICES }

final typeValues =
    EnumValues({"music_genre": Type.MUSIC_GENRE, "services": Type.SERVICES});

class MusicGenre {
  int id;
  int userId;
  int eventId;
  int categoryId;
  int itemId;
  Type type;
  String userType;
  DateTime createdAt;
  DateTime updatedAt;
  Item eventItem;

  MusicGenre({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.categoryId,
    required this.itemId,
    required this.type,
    required this.userType,
    required this.createdAt,
    required this.updatedAt,
    required this.eventItem,
  });

  factory MusicGenre.fromRawJson(String str) =>
      MusicGenre.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MusicGenre.fromJson(Map<String, dynamic> json) => MusicGenre(
        id: json["id"],
        userId: json["user_id"],
        eventId: json["event_id"],
        categoryId: json["category_id"],
        itemId: json["item_id"],
        type: typeValues.map[json["type"]]!,
        userType: json["user_type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        eventItem: Item.fromJson(json["event_item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "event_id": eventId,
        "category_id": categoryId,
        "item_id": itemId,
        "type": typeValues.reverse[type],
        "user_type": userType,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "event_item": eventItem.toJson(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
