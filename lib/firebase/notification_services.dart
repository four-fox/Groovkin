import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ! Todo check the permissions of the notification service
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

  // ! Todo get devices token
  Future<String> getDeviceToken() async {
    String? token = await firebaseMessaging.getToken();
    print(token);
    return token!;
  }

  // ! Todo refresh token
  void isRefreshToken() {
    firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  // ! Todo initialize the android and ios settings and icon
  void initLocalNotifications(
    BuildContext context,
    RemoteMessage message,
  ) async {
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

  // ! Todo listen the notification
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
          print("ONGOING");
          initLocalNotifications(context, message);
          showNotification(message);
        }
      }
    });
  }

  //! Todo showNotification
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

  // !Todo when app is background and terminated
  Future<void> setUpInteractMessage(BuildContext context) async {
    //! when app is terminated
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      if (context.mounted) {
        print("<Terminated>");
        // Show EasyLoading spinner
        // Todo I Use this for the loading not show in splash screen for 3 seconds
        await Future.delayed(Duration(seconds: 3));
        EasyLoading.show(status: 'Loading...');

        Future.delayed(Duration(seconds: 5), () {
          if (context.mounted) {
            handleMessage(context, message);

            // Hide EasyLoading spinner once handleMessage completes
            EasyLoading.dismiss();
          }
        });
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

  // ! Todo ios notification message
  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // ! when user tap on the notification
  void handleMessage(BuildContext context, RemoteMessage message) {
    var data;
    if (message.data["type"] == "send_message") {
      data = jsonDecode(message.data["data"]);
    } else {
      data = message.data;
    }

    EventController controller = Get.find();
    ManagerController managerController = Get.find();
    HomeController homeController = Get.find();

    if (message.data["type"] == "send_message") {
      print(data["source_id"].runtimeType);
      controller.eventDetails(eventId: data["source_id"]);
      managerController.getAllMessages(
          userId: data["sender_id"], sourceId: data["source_id"]);
      Get.toNamed(Routes.counterScreen, arguments: {
        "userId": data["sender_id"],
        "eventId": data["source_id"],
        "acceptVal": true,
      });
    } else if (data["type"] == "event_created") {
      Get.toNamed(Routes.pendingEventDetails, arguments: {
        "notInterestedBtn": 1,
        "title": "About Event",
        "eventId": int.parse(data["source_id"]),
        "type": "event",
      });
    } else if (data["type"] == "event_complete") {
      Get.toNamed(Routes.upcomingScreen, arguments: {
        "eventId": int.parse(data["source_id"]),
        "reportedEventView": 1,
        "notInterestedBtn": 1,
        "appBarTitle": "Completed Event",
        "isComingFromNotification": true,
      })!
          .then(
        (value) => homeController.completedEvent(),
      );
    } else if (data["type"] == "event_accept") {
      Get.toNamed(Routes.pendingEventDetails, arguments: {
        "notInterestedBtn": 1,
        "title": "About Event",
        "eventId": int.parse(data["source_id"]),
        "type": "event",
      });
    } else if (data["type"] == "event_following") {
      Get.toNamed(Routes.viewProfileScreen, arguments: {
        "id": int.parse(data["source_id"]), // Pass only the ID
        "fromNotification": true, // Add this flag
      });
    } else if (data["type"] == "event_rate") {
      Get.toNamed(Routes.pendingEventDetails, arguments: {
        "eventId": int.parse(data["source_id"]),
        "notInterestedBtn": 1,
        "title": "About Event",
        "type": "event",
      })!
          .then(
        (value) => managerController.getAllPendingEvents(),
      );
    } else if (data["type"] == "event_price_update") {
      Get.toNamed(Routes.pendingEventDetails, arguments: {
        "eventId": int.parse(data["source_id"]),
        "notInterestedBtn": 1,
        "title": "About Event",
        "type": "event",
      })!
          .then(
        (value) => managerController.getAllPendingEvents(),
      );
    } else if (data["type"] == "event_cancelled") {
      Get.toNamed(Routes.upcomingScreen, arguments: {
        "eventId": int.parse(data["source_id"]),
        "reportedEventView": 1,
        "notInterestedBtn": 1,
        "appBarTitle": "Cancelled",
        "isComingFromNotification": true,
      });
    } else if (data["type"] == "event_declined") {
      Get.toNamed(Routes.upcomingScreen, arguments: {
        "eventId": int.parse(data["source_id"]),
        "reportedEventView": 1,
        "notInterestedBtn": 1,
        "appBarTitle": "Declined",
        "isComingFromNotification": true,
      });
    } else if (data["type"] == "event_acknowledged") {
      Get.toNamed(Routes.upcomingScreen, arguments: {
        "eventId": int.parse(data["source_id"]),
        "reportedEventView": 1,
        "notInterestedBtn": 1,
        "appBarTitle": "Completed",
        "isComingFromNotification": true,
      });
    }
  }
}
