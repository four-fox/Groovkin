import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Routes/app_pages.dart';

import '../colors.dart';

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
      if (response.data["message"] == "Unauthenticated.") {
        API().sp.erase();
        API().sp.write("intro", true);
        getx.Get.offAllNamed(Routes.loginScreen);
        bottomToast(text: "Token Expired!!");
      }
    }
    if (response.statusCode! > 400) {
      BotToast.closeAllLoading();
      BotToast.showText(text: response.data["data"]);
    }

    log(response.data.toString());
    handler.next(response);
  }
}
