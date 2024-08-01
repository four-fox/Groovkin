import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:groovkin/Routes/app_pages.dart';

import 'notification.dart';

void main() async{
  await GetStorage.init();
  // await Firebase.initializeApp(
  //   name: "Groovkin",
  //   options: ConfigFirebaseConfig.platformOptions,
  // );
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // if (!kIsWeb) {
  //   channel = const AndroidNotificationChannel(
  //       'high_importance_channel', // id
  //       'High Importance Notifications', // title
  //       description:
  //       'This channel is used for important notifications.', // description
  //       importance: Importance.max,
  //       enableVibration: true);
  //
  //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //   /// Create an Android Notification Channel.
  //   ///
  //   /// We use this channel in the `AndroidManifest.xml` file to override the
  //   /// default FCM channel to enable heads up notifications.
  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //       AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(channel);
  //
  //   //d/ Update the iOS foreground notification presentation options to allow
  //   /// heads up notifications.
  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  //   await FirebaseMessaging.instance.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  // }
  // if (Platform.isMacOS) {
  //   // Disable Metal rendering on macOS
  //   debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  // }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initStateNotification();
  }

  initStateNotification() {
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
        onDidReceiveNotificationResponse: onSelectNotification);

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      print('after kill app get notification 1');
      print(message);
      if (message != null) {
        Future.delayed(Duration(seconds: 9),(){

        });
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(message);
      print('after kill app get notification 2');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? ios = message.notification?.apple;
      if (Platform.isAndroid) {
        String action = message.data.toString();
        print(action);
        noti(
          notification,
          message.data,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print('after kill app get notification 3');
      if(message != null){
      }
      // noti(
      //   notification,
      //   message.data,
      // );
      // if (notification != null && android != null && !kIsWeb) {
      //   String action = message.data.toString();
      //  print(action);
      //   noti(
      //     notification,
      //     message.data,
      //   );
      // }
    });}

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Groovkin',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xff040305),
        // backgroundColor: Color(0xff040305),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          labelLarge: TextStyle(
            color: Colors.white,
            fontFamily: 'poppinsMedium'
          ),
        )
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
          primaryColor: Color(0xffFFFFFF),
        // backgroundColor: Color(0xffFFFFFF),
        scaffoldBackgroundColor: Colors.black,
          textTheme: TextTheme(
            labelLarge: TextStyle(
                color: Colors.white,
                fontFamily: 'poppinsMedium'
            ),
          )
      ),
      navigatorObservers: [BotToastNavigatorObserver()],
      builder: (context, child) {
        child = ScrollConfiguration(
          behavior: MyBehavior(),
          child:
          EasyLoading.init(builder: BotToastInit())(context, child),
        );
        // child = SafeArea(top: false, child: child);
        return child;
      },
      themeMode: ThemeMode.dark,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}


class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
