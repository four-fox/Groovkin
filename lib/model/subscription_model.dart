class SubscriptionModel {
  bool? status;
  List<Data>? data;
  String? message;

  SubscriptionModel({this.status, this.data, this.message});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? subcriptionName;
  int? subcriptionPrice;
  String? subcriptionDescription;
  int? subcriptionSubValue;
  String? subcriptionSubType;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.subcriptionName,
      this.subcriptionPrice,
      this.subcriptionDescription,
      this.subcriptionSubValue,
      this.subcriptionSubType,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subcriptionName = json['subcription_name'];
    subcriptionPrice = json['subcription_price'];
    subcriptionDescription = json['subcription_description'];
    subcriptionSubValue = json['subcription_sub_value'];
    subcriptionSubType = json['subcription_sub_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subcription_name'] = subcriptionName;
    data['subcription_price'] = subcriptionPrice;
    data['subcription_description'] = subcriptionDescription;
    data['subcription_sub_value'] = subcriptionSubValue;
    data['subcription_sub_type'] = subcriptionSubType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
