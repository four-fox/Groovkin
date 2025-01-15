import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:groovkin/Routes/app_pages.dart';

class InterceptorsServices extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 401) {
      // if (response.data["message"] == "Unauthenticated") {
      getx.Get.offAllNamed(Routes.loginScreen);
      // }
    }
    log(response.data.toString());
    handler.next(response);
  }
}
