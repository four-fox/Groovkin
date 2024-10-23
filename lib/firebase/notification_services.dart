import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:groovkin/Routes/app_pages.dart';

class NotificationService {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ! check the permissions of the notification service
  void requestNotificationPermission() async {
    final NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(
      sound: true,
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
    );

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("Android Notification Permission Active");
      }
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("IOS Notification Permission Active");
      }
    } else {
      // Todo Send User to setting to open the notification
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  // ! get devices token
  Future<String> getDeviceToken() async {
    String? token = await firebaseMessaging.getToken();
    print(token);
    return token!;
  }

  // ! refresh token
  void isRefreshToken() {
    firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  // ! initialize the android and ios settings and icon
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = const DarwinInitializationSettings();
    final initializations = InitializationSettings(android: android, iOS: ios);
    await localNotificationsPlugin.initialize(
      initializations,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  // ! listen the notification
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
      if (Platform.isIOS) {
        forgroundMessage();
      }
      if (Platform.isAndroid) {
        if (context.mounted) {
          initLocalNotifications(context, message);
          showNotification(message);
        }
      }
    });
  }

  //! showNotification

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      importance: Importance.high,
      priority: Priority.high,
      ticker: "ticker",
      playSound: true,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      localNotificationsPlugin.show(
        message.hashCode, // Unique ID for the notification
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  // ! when app is background and terminated
  Future<void> setUpInteractMessage(BuildContext context) async {
    //! when app is terminated
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      if (context.mounted) {
        print("<Terminated>");

        handleMessage(context, message);
      }
    }

    //! when app is background

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (context.mounted) {
        print("<Background>");
        handleMessage(context, event);
      }
    });
  }

  // ! when user tap on the notification
  void handleMessage(BuildContext context, RemoteMessage message) {
    print(message.data.keys);
    print(message.data.values);
    if (message.data["type"] == "chats") {
      print("done");
      Get.offAllNamed(Routes.loginScreen);
    }
  }

  // ! Todo ios notification message
  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
