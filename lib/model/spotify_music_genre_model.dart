import 'package:get/get.dart';

class SpotifyMusicGenre {
  int? resultCount;
  List<Results>? results;

  SpotifyMusicGenre({this.resultCount, this.results});

  SpotifyMusicGenre.fromJson(Map<String, dynamic> json) {
    resultCount = json['resultCount'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resultCount'] = resultCount;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? collectionId;
  String? primaryGenreName;
  RxBool? selectedItem = false.obs;

  Results({
    this.collectionId,
    this.primaryGenreName,
    this.selectedItem,
  });

  Results.fromJson(Map<String, dynamic> json) {
    collectionId = json['collectionId'];
    primaryGenreName = json['primaryGenreName'];
    selectedItem = json["selectedItem"] ?? false.obs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['collectionId'] = collectionId;
    data['primaryGenreName'] = primaryGenreName;
    return data;
  }
}
