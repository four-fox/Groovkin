

// To parse this JSON data, do
//
//     final addVenueModel = addVenueModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

AddVenueModel addVenueModelFromJson(String str) => AddVenueModel.fromJson(json.decode(str));

String addVenueModelToJson(AddVenueModel data) => json.encode(data.toJson());

class AddVenueModel {
  bool? status;
  List<AmenitiesItem>? data;
  String? message;

  AddVenueModel({
    this.status,
    this.data,
    this.message,
  });

  factory AddVenueModel.fromJson(Map<String, dynamic> json) => AddVenueModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<AmenitiesItem>.from(json["data"]!.map((x) => AmenitiesItem.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class AmenitiesItem {
  int? id;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;
  RxBool? selected = false.obs;
  RxBool? permit = false.obs;
  dynamic userVenueItems;

  AmenitiesItem({
    this.id,
    this.name,
    this.type,
    this.selected,
    this.permit,
    this.createdAt,
    this.updatedAt,
    this.userVenueItems,
  });

  factory AmenitiesItem.fromJson(Map<String, dynamic> json) => AmenitiesItem(
    id: json["id"],
    name: json["name"],
    selected: json["selected"]??false.obs,
    permit: json["permit"]??false.obs,
    type: json["type"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    userVenueItems: json["user_venue_items"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user_venue_items": userVenueItems,
  };
}
