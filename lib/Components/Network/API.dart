// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:core';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:groovkin/Components/Network/interceptors_service.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'ErrorMethod.dart';
import 'Url.dart';

String dummyProfile =
    "https://www.itdp.org/wp-content/uploads/2021/06/avatar-man-icon-profile-placeholder-260nw-1229859850-e1623694994111.jpg";

class API {
  /// SingleTon
  static final API _singleton = API._internal();
  var sp = GetStorage();
  late Dio dio;

  factory API() {
    return _singleton;
  }

  API._internal() : dio = Dio() {
    dio = Dio(BaseOptions(
      validateStatus: (statusCode) => statusCode! < 500,
      connectTimeout: const Duration(seconds: 180),
      receiveTimeout: const Duration(seconds: 180),
    ));
    dio.interceptors.add(InterceptorsServices());
    dio.interceptors.add(PrettyDioLogger(
      compact: true,
      maxWidth: 90,
      responseBody: true,
      request: true,
      requestHeader: true,
    ));
  }

  ///Get
  Future<dynamic> getApi({
    url,
    fullUrl,
    Map<String, dynamic>? queryParameters,
    bool isLoader = true,
    bool isFromSpotify = false,
  }) async {
    dio.options.headers['Authorization'] = isFromSpotify
        ? "Bearer ${sp.read('accessToken')}"
        : "Bearer ${sp.read('token')}";
    dio.options.headers['Accept'] = "application/json";
    if (url != "") {
      try {
        if (isLoader == true) {
          showLoading();
        }

        final response = await dio.get(fullUrl ?? Url().baseUrl + url,
            queryParameters: queryParameters);

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

      dynamic response = await dio.post(
        fullUrl ?? Url().baseUrl + url,
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
        onSendProgress: (int progress, int total) {},
      );

      BotToast.closeAllLoading();

      return response;
    } on DioException catch (e) {
      BotToast.closeAllLoading();
      print(e.toString());
      return returnResponse(e.response);
    } catch (e) {
      print(e.toString());
      BotToast.showText(text: e.toString());
    }
  }

  Future<Response> jsonPostApi(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    bool auth = true,
    bool showProgress = false,
  }) async {
    try {
      if (auth == true) {
        dio.options.headers['Authorization'] = "Bearer ${sp.read('token')}";
      }
      final requestHeaders = <String, dynamic>{
        Headers.acceptHeader: "application/json",
        Headers.contentTypeHeader: "application/json",
        ...?headers,
      };
      if (showProgress) showLoading();
      final response = await dio.post(
        Url().baseUrl + url,
        data: body ?? <String, dynamic>{},
        options: Options(headers: requestHeaders),
      );
      if (showProgress) BotToast.closeAllLoading();
      return response;
    } on DioException catch (e) {
      if (showProgress) BotToast.closeAllLoading();
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 0,
            data: {
              "status": false,
              "message": "Network error",
              "data": e.message,
            },
          );
    }
  }

  Future<Response> jsonDeleteApi(
    String url, {
    Map<String, dynamic>? headers,
    bool auth = true,
    bool showProgress = false,
  }) async {
    try {
      if (auth == true) {
        dio.options.headers['Authorization'] = "Bearer ${sp.read('token')}";
      }
      final requestHeaders = <String, dynamic>{
        Headers.acceptHeader: "application/json",
        Headers.contentTypeHeader: "application/json",
        ...?headers,
      };
      if (showProgress) showLoading();
      final response = await dio.delete(
        Url().baseUrl + url,
        options: Options(headers: requestHeaders),
      );
      if (showProgress) BotToast.closeAllLoading();
      return response;
    } on DioException catch (e) {
      if (showProgress) BotToast.closeAllLoading();
      return e.response ??
          Response(
            requestOptions: e.requestOptions,
            statusCode: 0,
            data: {
              "status": false,
              "message": "Network error",
              "data": e.message,
            },
          );
    }
  }

  ///Post
  Future<dynamic> imagePostApi(formData, url) async {
    try {
      dio.options.headers['Authorization'] = "Bearer ${sp.read('token')}";
      dio.options.headers['accept'] = "application/json";

      showLoading();

      final response = await Dio().post(Url().baseUrl + url,
          data: formData,
          options: Options(
            headers: {
              Headers.acceptHeader: "application/json",
              'Authorization': "Bearer ${sp.read('token')}"
            },
            contentType: 'multipart/form-data',
          ));

      BotToast.closeAllLoading();

      return response;
    } on DioException catch (e) {
      BotToast.closeAllLoading();
      BotToast.showText(
          text:
              "${e.response!.data["message"]}\n${e.response!.data["errors"]["banner_image"]}",
          duration: Duration(seconds: 4),
          contentPadding: EdgeInsets.symmetric(horizontal: 10));
      return e.response;
    }
  }

  /// Delete
  Future<dynamic> delete(
    formData,
    url, {
    fullUrl,
    auth = true,
    multiPart = false,
    showProgress = true,
    context,
    /*required RoundedLoadingButtonController postButton*/
  }) async {
    try {
      if (auth == true) {
        dio.options.headers['Authorization'] = "Bearer ${sp.read('token')}";
        // dio.options.headers['Accept'] = "application/json";
      }

      if (showProgress) {
        showLoading();
      }

      dynamic response = await dio.delete(fullUrl ?? Url().baseUrl + url,
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
                ));

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
  Timer(const Duration(seconds: 3), () {
    postButton.reset();
  });
}

class LoaderClass extends StatelessWidget {
  const LoaderClass({super.key, this.colorOne, this.colorTwo});

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
            colorTwo: DynamicColor.yellowClr.withValues(alpha: 0.6),
          )),
      animationDuration: const Duration(milliseconds: 300));
}
