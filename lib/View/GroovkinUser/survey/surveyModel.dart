// To parse this JSON data, do
//
//     final surveyModel = surveyModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

SurveyModel surveyModelFromJson(String str) =>
    SurveyModel.fromJson(json.decode(str));

String surveyModelToJson(SurveyModel data) => json.encode(data.toJson());

class SurveyModel {
  bool? status;
  List<SurveyObject>? data;
  String? message;

  SurveyModel({
    this.status,
    this.data,
    this.message,
  });

  factory SurveyModel.fromJson(Map<String, dynamic> json) => SurveyModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<SurveyObject>.from(
                json["data"]!.map((x) => SurveyObject.fromJson(x))),
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

class SurveyObject {
  int? id;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;
  List<CategoryItem>? categoryItems;
  List<EventItem>? eventItems;
  RxBool? showItems = false.obs;

  SurveyObject({
    this.id,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.categoryItems,
    this.showItems,
    this.eventItems,
  });

  factory SurveyObject.fromJson(Map<String, dynamic> json) => SurveyObject(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        showItems: json["showItems"] ?? false.obs,
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        eventItems: json["event_items"] == null
            ? []
            : List<EventItem>.from(
                json["event_items"]!.map((x) => EventItem.fromJson(x))),
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
        "event_items": eventItems == null
            ? []
            : List<dynamic>.from(eventItems!.map((x) => x.toJson())),
        "category_items": categoryItems == null
            ? []
            : List<dynamic>.from(categoryItems!.map((x) => x.toJson())),
      };
}

class EventItem {
  int? id;
  int? eventId;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;
  dynamic userEventSubItems;
  RxBool? selectedValue = false.obs;

  EventItem({
    this.id,
    this.eventId,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.userEventSubItems,
    this.selectedValue,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) => EventItem(
        id: json["id"],
        eventId: json["event_id"],
        name: json["name"],
        type: json["type"],
        selectedValue: json["selectedValue"] ?? false.obs,
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        userEventSubItems: json["user_event_sub_items"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "name": name,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_event_sub_items": userEventSubItems,
      };
}

class CategoryItem {
  int? id;
  int? categoryId;
  int? eventId;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;
  dynamic userCategoryItems;
  RxBool? selectedItem = false.obs;

  CategoryItem({
    this.id,
    this.categoryId,
    this.eventId,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.userCategoryItems,
    this.selectedItem,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        type: json["type"],
        eventId: json["event_id"],
        selectedItem: json["selectedItem"] ?? false.obs,
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        userCategoryItems: json["user_category_items"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "type": type,
        "event_id": eventId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_category_items": userCategoryItems,
      };
}
