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
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  Genre? genre;
  int? count;

  Data({this.genre, this.count});

  Data.fromJson(Map<String, dynamic> json) {
    genre = json['genre'] != null ? new Genre.fromJson(json['genre']) : null;
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.genre != null) {
      data['genre'] = this.genre!.toJson();
    }
    data['count'] = this.count;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
