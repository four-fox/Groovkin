class MyGroovkinModel {
  final bool status;
  final Data data;

  MyGroovkinModel({required this.status, required this.data});

  factory MyGroovkinModel.fromJson(Map<String, dynamic> json) {
    return MyGroovkinModel(
      status: json['status'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final int isInsurance;
  final List<Service> services;
  final List<HardwareProvided> hardwareProvides;
  final List<MusicGenre> musicGenre;

  Data({
    required this.services,
    required this.hardwareProvides,
    required this.musicGenre,
    required this.isInsurance
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        isInsurance:json["is_insurance"]??0,
      services: (json['services'] as List)
          .map((item) => Service.fromJson(item))
          .toList(),
      hardwareProvides: (json['hardware_provides'] as List)
          .map((item) => HardwareProvided.fromJson(item))
          .toList(),
      musicGenre: (json['music_genre'] as List)
          .map((item) => MusicGenre.fromJson(item))
          .toList(),
    );
  }
}

class Service {
  final int id;
  final int userId;
  final int? eventId;
  final int eventItemId;
  final int? eventSubItemId;
  final String type;
  final String userType;
  final String? createdAt;
  final String? updatedAt;
  final EventItem eventItem;

  Service({
    required this.id,
    required this.userId,
    this.eventId,
    required this.eventItemId,
    this.eventSubItemId,
    required this.type,
    required this.userType,
    required this.createdAt,
    required this.updatedAt,
    required this.eventItem,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      userId: json['user_id'],
      eventId: json['event_id'],
      eventItemId: json['event_item_id'],
      eventSubItemId: json['event_sub_item_id'],
      type: json['type'],
      userType: json['user_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      eventItem: EventItem.fromJson(json['event_item']),
    );
  }
}

class EventItem {
  final int id;
  final String name;
  final String? image;
  final String type;
  final String createdAt;
  final String updatedAt;
  final List<CategoryItem> categoryItems;

  EventItem({
    required this.id,
    required this.name,
    this.image,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryItems,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    return EventItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      type: json['type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categoryItems: (json['category_items'] as List)
          .map((item) => CategoryItem.fromJson(item))
          .toList(),
    );
  }
}

class CategoryItem {
  final int id;
  final int? eventId;
  final int? categoryId;
  final String name;
  final String type;
  final String createdAt;
  final String updatedAt;

  CategoryItem({
    required this.id,
    this.eventId,
    this.categoryId,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'],
      eventId: json['event_id'],
      categoryId: json['category_id'],
      name: json['name'],
      type: json['type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class HardwareProvided {
  final int id;
  final int userId;
  final int eventId;
  final int eventItemId;
  final int eventSubItemId;
  final String type;
  final String userType;
  final String createdAt;
  final String updatedAt;
  final EventItem eventItem;

  HardwareProvided({
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

  factory HardwareProvided.fromJson(Map<String, dynamic> json) {
    return HardwareProvided(
      id: json['id'],
      userId: json['user_id'],
      eventId: json['event_id'],
      eventItemId: json['event_item_id'],
      eventSubItemId: json['event_sub_item_id'],
      type: json['type'],
      userType: json['user_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      eventItem: EventItem.fromJson(json['event_item']),
    );
  }
}

class MusicGenre {
  final int id;
  final int userId;
  final int eventId;
  final int categoryId;
  final int itemId;
  final String type;
  final String userType;
  final String createdAt;
  final String updatedAt;
  final EventItem eventItem;

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

  factory MusicGenre.fromJson(Map<String, dynamic> json) {
    return MusicGenre(
      id: json['id'],
      userId: json['user_id'],
      eventId: json['event_id'],
      categoryId: json['category_id'],
      itemId: json['item_id'],
      type: json['type'],
      userType: json['user_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      eventItem: EventItem.fromJson(json['event_item']),
    );
  }
}
