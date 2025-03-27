class AnalyticsListModel {
  bool? status;
  List<Data>? data;
  String? message;

  AnalyticsListModel({this.status, this.data, this.message});

  AnalyticsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  Genre? genre;
  int? count;

  Data({this.genre, this.count});

  Data.fromJson(Map<String, dynamic> json) {
    genre = json['genre'] != null ? Genre.fromJson(json['genre']) : null;
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (genre != null) {
      data['genre'] = genre!.toJson();
    }
    data['count'] = count;
    return data;
  }
}

class Genre {
  int? id;
  int? categoryId;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;

  Genre(
      {this.id,
      this.categoryId,
      this.name,
      this.type,
      this.createdAt,
      this.updatedAt});

  Genre.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['name'] = name;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
