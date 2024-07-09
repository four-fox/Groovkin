

import 'package:groovkin/Components/Network/Url.dart';

class MediaClass {
  MediaClass({
    this.id,
    this.filename,
    this.fileType,
    this.thumbnail,
  });

  String? id;
  String? filename;
  String? fileType;
  String? thumbnail;

  factory MediaClass.fromJson(Map<String, dynamic> json) {
    return MediaClass(
      id: json["file_id"],
      filename: json["filename"] == null
          ? null
          : json["file_id"] == null
          ? json["filename"]
          : json["filename"].toString().contains(Url().baseUrl)
          ? json["filename"]
          : Url().baseUrl + json["filename"],
      fileType: json["file_type"],
      thumbnail: json["thumbnail"] == null
          ? null
          : json["file_id"] == null
          ? json["thumbnail"]
          : json["thumbnail"].toString().contains(Url().baseUrl)
          ? json["thumbnail"]
          : Url().baseUrl + json["thumbnail"],
    );
  }

  Map<String, dynamic> toJson() => {
    "filename": filename,
    "file_type": fileType,
    "thumbnail": thumbnail,
  };
}
