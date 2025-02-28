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
      print(API().sp.read("token"));
      // if (response.data["message"] == "Unauthenticated") {
      if (API().sp.read("token") != null) {
        getx.Get.offAllNamed(Routes.loginScreen);
      } else {
        bottomToast(text: response.data["message"].toString());
      }
      // }
    }
    if (response.statusCode! > 400) {
      BotToast.closeAllLoading();
      BotToast.showText(text: response.data["data"]);
    }

    log(response.data.toString());
    handler.next(response);
  }
}
