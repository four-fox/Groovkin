class AnalyticsModel {
  bool? _status;
  List<Data>? _data;
  String? _message;

  AnalyticsModel({bool? status, List<Data>? data, String? message}) {
    if (status != null) {
      this._status = status;
    }
    if (data != null) {
      this._data = data;
    }
    if (message != null) {
      this._message = message;
    }
  }

  bool? get status => _status;
  set status(bool? status) => _status = status;
  List<Data>? get data => _data;
  set data(List<Data>? data) => _data = data;
  String? get message => _message;
  set message(String? message) => _message = message;

  AnalyticsModel.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if (json['data'] != null) {
      _data = <Data>[];
      json['data'].forEach((v) {
        _data!.add(new Data.fromJson(v));
      });
    }
    _message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    if (this._data != null) {
      data['data'] = this._data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this._message;
    return data;
  }
}

class Data {
  String? _genre;
  int? _count;

  Data({String? genre, int? count}) {
    if (genre != null) {
      this._genre = genre;
    }
    if (count != null) {
      this._count = count;
    }
  }

  String? get genre => _genre;
  set genre(String? genre) => _genre = genre;
  int? get count => _count;
  set count(int? count) => _count = count;

  Data.fromJson(Map<String, dynamic> json) {
    _genre = json['genre'];
    _count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['genre'] = this._genre;
    data['count'] = this._count;
    return data;
  }
}
