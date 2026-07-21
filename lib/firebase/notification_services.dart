import 'dart:convert';
import 'dart:developer';
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
import 'package:groovkin/payment/payment_deep_links.dart';
import 'package:groovkin/payment/stripe_connect_controller.dart';
import '../chatView/chatRoomModel.dart';

class NotificationService {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    final NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(
      sound: true,
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
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

  Future<String> getDeviceToken() async {
    String? token = await firebaseMessaging.getToken();
    log("Device Token $token");
    if (kDebugMode) {
      print("Device Token $token");
    }
    return token!;
  }

  void isRefreshToken() async {
    firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  void initLocalNotifications(
    BuildContext context,
    RemoteMessage message,
  ) async {
    var android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = const DarwinInitializationSettings();
    final initializations = InitializationSettings(android: android, iOS: ios);
    await localNotificationsPlugin.initialize(
      settings: initializations,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title);
        print(message.notification!.body);
      }

      if (Platform.isIOS) {
        if (context.mounted) {
          // initLocalNotifications(context, message);
          // showNotification(message);
          forgroundMessage();
        }
      }

      if (Platform.isAndroid) {
        if (context.mounted) {
          initLocalNotifications(context, message);
          showNotification(message);
        }
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    // Check if message.notification is null (important for silent notifications)
    if (message.notification == null) return;
    // Define a default notification channel ID (for Android)
    String channelId = "default_channel";
    String channelName = "General Notifications";

    if (Platform.isAndroid && message.notification!.android != null) {
      channelId = message.notification!.android!.channelId ?? "default_channel";
      channelName =
          message.notification!.android!.channelId ?? "General Notifications";
    }

    // Android Notification Channel (Avoid null errors)
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    // Android Notification Details
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id, // Use the non-null channel ID
      channel.name,
      importance: Importance.high,
      priority: Priority.high,
      ticker: "ticker",
      playSound: true,
    );

    // iOS Notification Details
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Combine Android & IOS Notification Details
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      localNotificationsPlugin.show(
        id: message.hashCode,
        title: message.notification!.title ?? "New Notification",
        body: message.notification!.body ?? "Tap to open",
        notificationDetails: notificationDetails,
      );
    });
  }

  Future<void> setUpInteractMessage(BuildContext context) async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      if (context.mounted) {
        // Show EasyLoading spinner
        // Todo I Use this for the loading not show in splash screen for 3 seconds
        await Future.delayed(const Duration(seconds: 3));
        EasyLoading.show(status: 'Loading...');
        Future.delayed(const Duration(seconds: 5), () {
          if (context.mounted) {
            handleMessage(context, message);
            EasyLoading.dismiss();
          }
        });
      }
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (context.mounted) {
        if (kDebugMode) {
          print("<Background>");
        }
        handleMessage(context, event);
      }
    });
  }

  // ! Todo ios notification message

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

  // ! when user tap on the notification
  void handleMessage(BuildContext context, RemoteMessage message) {
    if (kDebugMode) {
      print(message.data);
    }

    var data;
    if (message.data["type"] == "send_message") {
      data = jsonDecode(message.data["data"]);
    } else {
      data = message.data;
    }

    final deepLink = data["deep_link"]?.toString() ?? data["link"]?.toString();
    if (deepLink != null) {
      final parsed = PaymentDeepLink.parse(deepLink);
      if (parsed != null) {
        parsed.navigate();
        return;
      }
    }

    if (data["type"] == "connect_onboarding_incomplete" ||
        data["type"] == "stripe_connect_status") {
      Get.toNamed(
        Routes.connectOnboardingScreen,
        arguments: {'refreshAfterReturn': true},
      );
      if (Get.isRegistered<StripeConnectController>()) {
        Get.find<StripeConnectController>().handleDeepLinkReturn();
      }
      return;
    }

    if (data["payment_id"] != null) {
      Get.toNamed(
        Routes.paymentStatusScreen,
        arguments: {"paymentId": int.tryParse(data["payment_id"].toString())},
      );
      return;
    }
    if (data["cancellation_id"] != null) {
      Get.toNamed(
        Routes.cancellationWorkflowScreen,
        arguments: {
          "cancellationId": int.tryParse(data["cancellation_id"].toString()),
        },
      );
      return;
    }
    if (data["type"] == "completion_requested" ||
        data["type"] == "counter_created" ||
        data["type"] == "counter_revised" ||
        data["type"] == "counter_accepted" ||
        data["type"] == "counter_rejected") {
      Get.toNamed(
        Routes.completionWorkflowScreen,
        arguments: {"eventId": int.tryParse(data["source_id"].toString())},
      );
      return;
    }

    // Payment lifecycle notification types. Text is not authoritative —
    // always open the relevant screen and refresh backend state.
    const paymentLifecycleTypes = {
      'down_payment_succeeded',
      'down_payment_failed',
      'down_payment_requires_action',
      'final_payment_requires_action',
      'final_payment_failed',
      'final_payment_succeeded',
      'eo_transfer',
      'refund',
      'dispute',
      'payout',
      'manual_review',
      'payment_journey_updated',
    };
    if (paymentLifecycleTypes.contains(data["type"]?.toString())) {
      final eventId = int.tryParse(
        data["event_id"]?.toString() ?? data["source_id"]?.toString() ?? '',
      );
      final transactionId = data["transaction_id"]?.toString();
      if (transactionId != null && transactionId.isNotEmpty) {
        Get.toNamed(
          Routes.walletTransactionDetailScreen,
          arguments: {'transactionId': transactionId},
        );
        return;
      }
      if (eventId != null) {
        Get.toNamed(
          Routes.pendingEventDetails,
          arguments: {
            'eventId': eventId,
            'notInterestedBtn': 0,
            'title': 'Event Details',
            'type': 'payment',
          },
        );
        return;
      }
      Get.toNamed(Routes.walletHomeScreen);
      return;
    }

    EventController controller = Get.find();
    ManagerController managerController = Get.find();
    HomeController homeController = Get.find();
    if (message.data["type"] == "send_message") {
      controller.eventDetails(eventId: data["source_id"]);
      managerController.getAllMessages(
          userId: data["sender_id"], sourceId: data["source_id"]);
      Get.toNamed(Routes.counterScreen, arguments: {
        "userId": data["sender_id"],
        "eventId": data["source_id"],
        "acceptVal": true,
      });
    } else if (data["type"] == "single_message") {
      User? user = User.fromJson(jsonDecode(data['data'])['user']);
      Get.toNamed(Routes.chatInnerScreen, arguments: {"userData": user});
    } else if (data["type"] == "event_created") {
      Get.toNamed(Routes.upcomingScreen, arguments: {
        "eventId": int.parse(data["source_id"]),
        "reportedEventView": 1,
        "notInterestedBtn": 1,
        "appBarTitle": "Event Created",
        "isComingFromNotification": true,
        // "appBarTitle": "Completed",
        // "${singleEvent.status.toString().capitalize} Event"
      });
    } else if (data["type"] == "event_complete") {
      Get.toNamed(Routes.upcomingScreen, arguments: {
        "eventId": int.parse(data["source_id"]),
        "reportedEventView": 1,
        "notInterestedBtn": 1,
        "appBarTitle": "About Event",
        "isComingFromNotification": true,
      })!
          .then(
        (value) => homeController.completedEvent(),
      );
    } else if (data["type"] == "event_accept") {
      Get.toNamed(Routes.upcomingScreen, arguments: {
        "eventId": int.parse(data["source_id"]),
        "reportedEventView": 1,
        "notInterestedBtn": 1,
        "appBarTitle": "About Event",
        "isComingFromNotification": true,
        // "appBarTitle": "Completed",
        // "${singleEvent.status.toString().capitalize} Event"
      });
    } else if (data["type"] == "event_following") {
      Get.toNamed(Routes.viewProfileScreen, arguments: {
        "id": int.parse(data["source_id"]), // Pass only the ID
        "fromNotification": true, // Add this flag
      });
    } else if (data["type"] == "event_rate") {
      Get.toNamed(Routes.upcomingScreen, arguments: {
        "eventId": int.parse(data["source_id"]),
        "reportedEventView": 1,
        "notInterestedBtn": 1,
        "appBarTitle": "Event Rate",
        "isComingFromNotification": true,
        // "appBarTitle": "Completed",
        // "${singleEvent.status.toString().capitalize} Event"
      });
    } else if (data["type"] == "event_price_update") {
      Get.toNamed(Routes.upcomingScreen, arguments: {
        "eventId": int.parse(data["source_id"]),
        "reportedEventView": 1,
        "notInterestedBtn": 1,
        "appBarTitle": "Event Price Update",
        "isComingFromNotification": true,
        // "appBarTitle": "Completed",
        // "${singleEvent.status.toString().capitalize} Event"
      });
    } else if (data["type"] == "event_cancelled") {
      Get.toNamed(Routes.upcomingScreen, arguments: {
        "eventId": int.parse(data["source_id"]),
        "reportedEventView": 1,
        "notInterestedBtn": 1,
        // "appBarTitle": "Cancelled",
        "isComingFromNotification": true,
        "appBarTitle": "About Event",
      });
    } else if (data["type"] == "event_declined") {
      Get.toNamed(Routes.upcomingScreen, arguments: {
        "eventId": int.parse(data["source_id"]),
        "reportedEventView": 1,
        "notInterestedBtn": 1,
        "appBarTitle": "About Event",
        "isComingFromNotification": true,
      });
    } else if (data["type"] == "event_acknowledged") {
      Get.toNamed(Routes.upcomingScreen, arguments: {
        "eventId": int.parse(data["source_id"]),
        "reportedEventView": 1,
        "notInterestedBtn": 1,
        // "appBarTitle": "Completed",
        "isComingFromNotification": true,
        "appBarTitle": "About Event",
      });
    } else if (data.type == "event_reschedule") {
      Get.toNamed(Routes.upcomingScreen, arguments: {
        "eventId": int.parse(data["source_id"]),
        "reportedEventView": 1,
        "notInterestedBtn": 1,
        "appBarTitle": "Reschedule Event",
        "isComingFromNotification": true,
        // "appBarTitle": "Completed",
        // "${singleEvent.status.toString().capitalize} Event"
      });
    } else if (data.type == "event_rate") {
      Get.toNamed(Routes.upcomingScreen, arguments: {
        "eventId": int.parse(data["source_id"]),
        "reportedEventView": 1,
        "notInterestedBtn": 1,
        "appBarTitle": "Event Rate",
        "isComingFromNotification": true,
        // "appBarTitle": "Completed",
        // "${singleEvent.status.toString().capitalize} Event"
      });
    }
  }
}
