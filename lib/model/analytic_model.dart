class AnalyticsModel {
  bool? _status;
  List<Data>? _data;
  String? _message;

  AnalyticsModel({bool? status, List<Data>? data, String? message}) {
    if (status != null) {
      _status = status;
    }
    if (data != null) {
      _data = data;
    }
    if (message != null) {
      _message = message;
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
        _data!.add(Data.fromJson(v));
      });
    }
    _message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    if (_data != null) {
      data['data'] = _data!.map((v) => v.toJson()).toList();
    }
    data['message'] = _message;
    return data;
  }
}

class Data {
  String? _genre;
  int? _count;

  Data({String? genre, int? count}) {
    if (genre != null) {
      _genre = genre;
    }
    if (count != null) {
      _count = count;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['genre'] = _genre;
    data['count'] = _count;
    return data;
  }
}
