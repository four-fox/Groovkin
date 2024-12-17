class CardModel {
  bool? status;
  List<Data>? data;
  String? message;

  CardModel({this.status, this.data, this.message});

  CardModel.fromJson(Map<String, dynamic> json) {
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
  String? cardholderName;
  String? customerId;
  String? brand;
  String? last4digit;
  String? first4digit;
  String? cardType;
  String? cardDetails;
  int? defaultCard;
  String? status;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.cardholderName,
      this.customerId,
      this.brand,
      this.last4digit,
      this.first4digit,
      this.cardType,
      this.cardDetails,
      this.defaultCard,
      this.status,
      this.userId,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardholderName = json['cardholder_name'];
    customerId = json['customer_id'];
    brand = json['brand'];
    last4digit = json['last4digit'];
    first4digit = json['first4digit'];
    cardType = json['card_type'];
    cardDetails = json['card_details'];
    defaultCard = json['default_card'];
    status = json['status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cardholder_name'] = cardholderName;
    data['customer_id'] = customerId;
    data['brand'] = brand;
    data['last4digit'] = last4digit;
    data['first4digit'] = first4digit;
    data['card_type'] = cardType;
    data['card_details'] = cardDetails;
    data['default_card'] = defaultCard;
    data['status'] = status;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
