import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/firebase/notification_services.dart';
import 'package:groovkin/firebase_options.dart';
import 'package:groovkin/purchased/revenue_cat.dart';
import 'package:groovkin/utils/constant.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> configureSDK() async {
  await Purchases.setLogLevel(LogLevel.debug);
  PurchasesConfiguration configuration =
      PurchasesConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = API().sp.read("userId").toString()
        ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
  await Purchases.configure(configuration);
  checkUserSubscriptionIsActive();
}

checkUserSubscriptionIsActive() async {
  CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  if (kDebugMode) {
    print(
        "Revnuecat Subscrion if Active?   ${customerInfo.entitlements.all[entitlementID]?.isActive ?? false}");
  }
  appData.entitlementIsActive =
      customerInfo.entitlements.all[entitlementID]?.isActive ?? false;
}

void main() async {
  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(apiKey: appleApiKey, store: Store.appStore);
  } else {
    StoreConfig(apiKey: googleApiKey, store: Store.playStore);
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Todo Received BackGround Message
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();

    if (API().sp.read("userId") != null) {
      configureSDK();
    }
    //Todo Firebase Notification Start

    notificationService.requestNotificationPermission();
    notificationService.setUpInteractMessage(context);
    notificationService.firebaseInit(context);
    notificationService.getDeviceToken();

    // Todo Firebase Notification End

    // Todo Start the socket server

    // SocketClass.singleton.connectSocket();

    // initStateNotification();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Groovkin',
      theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: DynamicColor.yellowClr,
            selectionColor: DynamicColor.yellowClr,
            selectionHandleColor: DynamicColor.yellowClr,
          ),
          brightness: Brightness.light,
          primaryColor: const Color(0xff040305),
          // backgroundColor: Color(0xff040305),
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
            labelLarge:
                TextStyle(color: Colors.white, fontFamily: 'poppinsMedium'),
          )),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xffFFFFFF),
          // backgroundColor: Color(0xffFFFFFF),
          scaffoldBackgroundColor: Colors.black,
          textTheme: const TextTheme(
            labelLarge:
                TextStyle(color: Colors.white, fontFamily: 'poppinsMedium'),
          )),
      navigatorObservers: [BotToastNavigatorObserver()],
      builder: (context, child) {
        child = ScrollConfiguration(
          behavior: MyBehavior(),
          child: EasyLoading.init(builder: BotToastInit())(context, child),
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
