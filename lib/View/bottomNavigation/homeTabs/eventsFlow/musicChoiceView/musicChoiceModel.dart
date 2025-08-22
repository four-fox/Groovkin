// To parse this JSON data, do
//
//     final musicTagModel = musicTagModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

MusicTagModel musicTagModelFromJson(String str) =>
    MusicTagModel.fromJson(json.decode(str));

String musicTagModelToJson(MusicTagModel data) => json.encode(data.toJson());

class MusicTagModel {
  bool? status;
  List<TagObject>? data;
  String? message;

  MusicTagModel({
    this.status,
    this.data,
    this.message,
  });

  factory MusicTagModel.fromJson(Map<String, dynamic> json) => MusicTagModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<TagObject>.from(
                json["data"]!.map((x) => TagObject.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class TagObject {
  int? id;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;
  List<CategoryItem>? categoryItems;
  RxBool? showSubCat = false.obs;

  TagObject({
    this.id,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.categoryItems,
    this.showSubCat,
  });

  factory TagObject.fromJson(Map<String, dynamic> json) => TagObject(
        id: json["id"],
        name: json["name"],
        showSubCat: json["showSubCat"] ?? false.obs,
        type: json["type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        categoryItems: json["category_items"] == null
            ? []
            : List<CategoryItem>.from(
                json["category_items"]!.map((x) => CategoryItem.fromJson(x))),
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

class CategoryItem {
  int? id;
  int? eventTagId;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;
  dynamic userEventTagItems;
  RxBool? selected = false.obs;

  CategoryItem({
    this.id,
    this.eventTagId,
    this.name,
    this.selected,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.userEventTagItems,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
        id: json["id"],
        eventTagId: json["event_tag_id"],
        name: json["name"],
        selected: json["selected"] ?? false.obs,
        type: json["type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        userEventTagItems: json["user_event_tag_items"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_tag_id": eventTagId,
        "name": name,
        "type": type,
        "selected": false.obs,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_event_tag_items": userEventTagItems,
      };
}
