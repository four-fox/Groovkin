import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';

class NotificationService {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ! Check notification permissions
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
        print("iOS Notification Permission Active");
      }
    } else {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  // ! Get device token
  Future<String> getDeviceToken() async {
    String? token = await firebaseMessaging.getToken();
    print(token);
    return token!;
  }

  // ! Refresh token listener
  void isRefreshToken() {
    firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  // ! Initialize local notifications
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

  // ! Listen to incoming notifications
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
          saveNotificationData(message); // Save notification data
        }
      }
    });
  }

  // ! Show notification
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

  // ! Handle notifications when app is background or terminated
  Future<void> setUpInteractMessage(BuildContext context) async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      if (context.mounted) {
        print("<Terminated>");
        EasyLoading.show(status: 'Loading...');
        Future.delayed(Duration(seconds: 5), () {
          if (context.mounted) {
            handleMessage(context, message);
            EasyLoading.dismiss();
          }
        });
      }
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (context.mounted) {
        print("<Background>");
        handleMessage(context, event);
        clearNotificationData(); // Clear saved notification data
      }
    });

    // Check for saved notification data if app is reopened
    checkSavedNotificationData(context);
  }

  // ! Handle foreground notification settings for iOS
  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // ! Handle when user taps on notification
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
          .then((value) => homeController.completedEvent());
    }
    // Add remaining scenarios...
  }

  // ! Save notification data to local storage
  void saveNotificationData(RemoteMessage message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('last_notification', jsonEncode(message.data));
  }

  // ! Clear saved notification data
  void clearNotificationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('last_notification');
  }

  // ! Check saved notification data on app launch
  Future<void> checkSavedNotificationData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('last_notification');

    if (savedData != null) {
      var messageData = jsonDecode(savedData);
      handleMessage(context, RemoteMessage(data: messageData));
      clearNotificationData(); // Clear data after handling
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  TouchCallbacks touchCallbacks = TouchCallbacks();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(touchCallbacks.taps.length.toString()),
      ),
      body: Stack(
        children: [
          Positioned(
            left: touchCallbacks.taps.length == 3
                ? touchCallbacks.taps.first.offset.dx
                : 200,
            top: touchCallbacks.taps.length == 3
                ? touchCallbacks.taps.first.offset.dy
                : 200,
            child: Container(
              height: 100,
              width: 100,
              color: Colors.red,
            ),
          ),
          RawGestureDetector(
            gestures: <Type, GestureRecognizerFactory>{
              ImmediateMultiDragGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<
                          ImmediateMultiDragGestureRecognizer>(
                      () => ImmediateMultiDragGestureRecognizer(),
                      (ImmediateMultiDragGestureRecognizer instance) {
                instance.onStart = (Offset offset) {
                  setState(() {
                    _counter++;
                    touchCallbacks.touchBegan(TouchData(_counter, offset));
                  });
                  return ItemDrag((details, tId) {
                    setState(() {
                      touchCallbacks
                          .touchMoved(TouchData(tId, details.globalPosition));
                    });
                  }, (details, tId) {
                    touchCallbacks
                        .touchEnded(TouchData(tId, const Offset(0, 0)));
                  }, (tId) {
                    touchCallbacks
                        .touchCanceled(TouchData(tId, const Offset(0, 0)));
                  }, _counter);
                };
              }),
            },
          ),
        ],
      ),
    );
  }
}

/// Just saving the taps information here
class TouchCallbacks {
  List<TouchData> taps = []; //list that holds ongoing taps or drags
  void touchBegan(TouchData touch) {
    taps.add(touch);
    //touch began code here
  }

  void touchMoved(TouchData touch) {
    for (int i = 0; i < taps.length; i++) {
      if (taps[i].touchId == touch.touchId) {
        taps[i] = touch;
        break;
      }
    }
    //touch moved code here
  }

  void touchCanceled(TouchData touch) {
    //touch canceled code here
    taps.removeWhere((element) => element.touchId == touch.touchId);
  }

  void touchEnded(TouchData touch) {
    //touch ended code here
    taps.removeWhere((element) => element.touchId == touch.touchId);
  }
}

/// Every touch point must have the touch id, here touch id will be every offset on the screen
/// until finger has not left i.e., until drag doesn't end.

class TouchData {
  final int touchId;
  final Offset offset;

  TouchData(this.touchId, this.offset);
}

class ItemDrag extends Drag {
  final Function onUpdate;
  final Function onEnd;
  final Function onCancel;
  final int touchId;

  ItemDrag(this.onUpdate, this.onEnd, this.onCancel, this.touchId);

  @override
  void update(DragUpdateDetails details) {
    super.update(details);
    onUpdate(details, touchId);
  }

  @override
  void end(DragEndDetails details) {
    super.end(details);
    onEnd(details, touchId);
  }

  @override
  void cancel() {
    super.cancel();
    onCancel(touchId);
  }
}




