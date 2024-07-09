// ignore_for_file: depend_on_referenced_packages

import 'package:dio/dio.dart' as form;
import 'package:http_parser/http_parser.dart';

multiPartingImage(image) {
  return form.MultipartFile.fromFileSync(image,
      filename: "Image.${image!.split(".").last}",
      contentType: MediaType("image", image!.split(".").last));
}

multiPartingImageNoObx(image) {
  return form.MultipartFile.fromFileSync(image!.path,
      filename: "Image.${image.path.split(".").last}",
      contentType: MediaType("image", image.path.split(".").last));
}

multiPartingVideo(video) {
  return form.MultipartFile.fromFileSync(video!.path,
      filename: "Video.${video!.path.split(".").last}",
      contentType: MediaType("video", video!.path.split(".").last));
}
