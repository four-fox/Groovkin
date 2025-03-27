import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:groovkin/Components/colors.dart';
import 'API.dart';

dynamic returnResponse(Response? responseData) {
  if (responseData == null) {
    BotToast.closeAllLoading();
    BotToast.showText(text: 'Internet Error');
  } else {
    BotToast.closeAllLoading();
    switch (responseData.statusCode) {
      case 200:
        var responseJson = json.decode(responseData.data.toString());
        //print(responseJson);
        return responseJson;
      case 400:
        bottomToast(text: responseData.data["message"].toString());
        // BotToast.showText(text: responseData.data["message"].toString());
        break;
      case 401:
        if (responseData.data["message"] == "Unauthenticated.") {
          BotToast.showText(
              text: "Session has been expired!! Please Sign in again"
                  "",
              duration: const Duration(seconds: 2));
          API().sp.erase();
          // getx.Get.offAllNamed(Routes.signUpScreen);
        } else {
          bottomToast(text: responseData.data["message"].toString());
          // BotToast.showText(text: responseData.data["message"].toString());
        }
        break;
      case 404:
        bottomToast(text: responseData.data["message"].toString());
        // BotToast.showText(text: responseData.data["message"].toString());
        break;
      case 410:
        bottomToast(text: responseData.data["message"].toString());
        // BotToast.showText(text: responseData.data["message"].toString());
        getx.Get.back();
        break;
      case 403:
        bottomToast(text: responseData.data["message"].toString());
        // BotToast.showText(text: responseData.data["message"].toString());
        break;
      case 422:
        if (responseData.data["data"] == null) {
          return null;
        } else {
          bottomToast(text: responseData.data["data"].toString());
          // BotToast.showText(text: responseData.data["data"].toString());
        }
        break;
      case 500:
      default:
        if (responseData.data["data"] != null) {
          BotToast.showText(text: responseData.data["data"]);
        } else {
          throw bottomToast(
              text:
                  ('Error occurred while Communication with Server with StatusCode : ${responseData.statusCode}'));
        }

      // throw BotToast.showText(
      //     text:
      //         ('Error occurred while Communication with Server with StatusCode : ${responseData.statusCode}'));
    }
  }
}
