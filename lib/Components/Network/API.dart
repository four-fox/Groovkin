// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:core';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:groovkin/Components/colors.dart';
import 'ErrorMethod.dart';
import 'Url.dart';

String dummyProfile =
    "https://www.itdp.org/wp-content/uploads/2021/06/avatar-man-icon-profile-placeholder-260nw-1229859850-e1623694994111.jpg";

class API {
  ///SingleTon
  static final API _singleton = API._internal();
  var sp = GetStorage();
  factory API() {
    return _singleton;
  }
  Dio dio = Dio(BaseOptions(
    connectTimeout: Duration(seconds: 180),
    receiveTimeout: Duration(seconds: 180),
  ));

  API._internal();
  Dio addInterceptors() {
    return dio
      ..interceptors.add(InterceptorsWrapper(
          onError: (dioError, interceptorErrorCallback) async {
        returnResponse(dioError.response!);
      }));
  }

  ///Get
  Future<dynamic> getApi(
      {url,
      fullUrl,
      Map<String, dynamic>? queryParameters,
      bool isLoader = true}) async {
    print(sp.read('token'));
    dio.options.headers['Authorization'] = "Bearer ${sp.read('token')}";
    dio.options.headers['Accept'] = "application/json";

    if (url != "") {
      try {
        print(url);
        if (isLoader == true) {
          showLoading();
        }
        final response = await dio.get(
          fullUrl ?? Url().baseUrl + url,
          queryParameters: queryParameters,
        );
        BotToast.closeAllLoading();
        return response;
      } on DioException catch (e) {
        BotToast.closeAllLoading();
        return returnResponse(e.response!);
      }
    }
  }

  ///Post
  Future<dynamic> postApi(
    formData,
    url, {
    fullUrl,
    auth = true,
    multiPart = false,
    showProgress = true,
    context,
    /*required RoundedLoadingButtonController postButton*/
  }) async {
    print(Url().baseUrl + url);
    print(sp.read('token'));
    try {
      if (auth == true) {
        dio.options.headers['Authorization'] = "Bearer ${sp.read('token')}";
        // dio.options.headers['Accept'] = "application/json";
      }
      if (showProgress) {
        showLoading();
      }
      dynamic response = await dio.post(fullUrl ?? Url().baseUrl + url,
          data: formData,
          options: multiPart == true
              ? Options(
                  headers: {
                    Headers.acceptHeader: "application/json",
                  },
                  contentType: 'multipart/form-data',
                )
              : Options(
                  headers: {
                    Headers.acceptHeader: "application/json",
                  },
                ),
          onSendProgress: (int progress, int total) {});
      BotToast.closeAllLoading();
      return response;
    } on DioException catch (e) {
      BotToast.closeAllLoading();
      return returnResponse(e.response);
    }
  }

  Future<void> deleteAllKeysExceptOne(
      String keyToKeep, String themeMode) async {
    GetStorage storage = GetStorage();
    List<String> allKeys = storage.getKeys().toList();

    for (String key in allKeys) {
      if (key != keyToKeep && key != themeMode) {
        await storage.remove(key);
      }
    }
  }
}

errorIcon(postButton) async {
  postButton.error();
  Timer(Duration(seconds: 3), () {
    postButton.reset();
  });
}
//

class LoaderClass extends StatelessWidget {
  LoaderClass({this.colorOne, this.colorTwo});

  final Color? colorOne;
  final Color? colorTwo;

  @override
  Widget build(BuildContext context) {
    return SpinKitFoldingCube(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven
                ? colorOne ?? DynamicColor.whiteClr
                : colorTwo ?? DynamicColor.whiteClr,
          ),
        );
      },
    );
  }
}

showLoading() {
  return BotToast.showCustomLoading(
      toastBuilder: (_) => Center(
              child: LoaderClass(
            colorOne: DynamicColor.yellowClr,
            colorTwo: DynamicColor.yellowClr.withOpacity(0.6),
          )),
      animationDuration: Duration(milliseconds: 300));
}
