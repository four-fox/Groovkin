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
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/authView/theme_controller.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/firebase/notification_services.dart';
import 'package:groovkin/firebase_options.dart';
import 'package:groovkin/model/single_ton_data.dart';
import 'package:groovkin/utils/constant.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class StoreConfig {
  final Store store;
  final String apiKey;

  StoreConfig._interval({required this.store, required this.apiKey});
  static StoreConfig? instances;

  factory StoreConfig({required Store store, required String apiKey}) {
    return instances ??= StoreConfig._interval(store: store, apiKey: apiKey);
  }
  static StoreConfig get instance => StoreConfig.instances!;
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FlutterAppBadge.count(1);
}

Future<void> configureSDK() async {
  await Purchases.setLogLevel(LogLevel.debug);
  PurchasesConfiguration configuration =
      PurchasesConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = API().sp.read("userId").toString()
        ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
  await Purchases.configure(configuration);
}

checkUserSubscriptionIsActive() async {
  final HomeController homeController;
  final AuthController authController;

  if (Get.isRegistered<HomeController>()) {
    homeController = Get.find<HomeController>();
  } else {
    homeController = Get.put(HomeController());
  }

  if (Get.isRegistered<AuthController>()) {
    authController = Get.find<AuthController>();
  } else {
    authController = Get.put(AuthController());
  }

  CustomerInfo customerInfo = await Purchases.getCustomerInfo();

  if (kDebugMode) {
    print(customerInfo.toString());
    print(
        "Revnuecat Subscrion if Active?  ${customerInfo.entitlements.all[entitlementID]?.isActive ?? false}");
  }

  appData.entitlementIsActive =
      customerInfo.entitlements.all[entitlementID]?.isActive ?? false;

  authController.update();
  homeController.update();
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
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NotificationService notificationService = NotificationService();
  late AuthController authController;
  ThemeController themeController = Get.find<ThemeController>();

  Future<void> fetchSubscription() async {
    await configureSDK();
    checkUserSubscriptionIsActive();
    authController.restore();
  }

  @override
  void initState() {
    super.initState();

    themeController.setTheme(API().sp.read("apptheme") == ThemeMode.light.name
        ? ThemeMode.light
        : ThemeMode.dark);

    if (Get.isRegistered<AuthController>()) {
      authController = Get.find<AuthController>();
    } else {
      authController = Get.put(AuthController());
    }

    if (API().sp.read("userId") != null) {
      fetchSubscription();
    }

    // Todo Firebase Notification Start

    notificationService.requestNotificationPermission();
    notificationService.setUpInteractMessage(context);
    notificationService.firebaseInit(context);

    // notificationService.getDeviceToken();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NotificationService().localNotificationsPlugin.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
          cardColor: Colors.white,

          // primaryColor: Colors.grey,

          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
            labelLarge:
                TextStyle(color: Colors.white, fontFamily: 'poppinsMedium'),
          ),
        ),
        darkTheme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: DynamicColor.yellowClr,
            selectionColor: DynamicColor.yellowClr,
            selectionHandleColor: DynamicColor.yellowClr,
          ),
          brightness: Brightness.dark,
          primaryColor: const Color(0xffFFFFFF),
          cardColor: Colors.white,
          scaffoldBackgroundColor: Colors.black,
          textTheme: const TextTheme(
            labelLarge:
                TextStyle(color: Colors.white, fontFamily: 'poppinsMedium'),
          ),
        ),
        navigatorObservers: [BotToastNavigatorObserver()],
        builder: (context, child) {
          child = ScrollConfiguration(
            behavior: MyBehavior(),
            child: EasyLoading.init(builder: BotToastInit())(context, child),
          );
          // child = SafeArea(top: false, child: child);
          return child;
        },
        // themeMode: ThemeMode.light,

        // themeMode: API().sp.read("apptheme") == ThemeMode.light.name
        //     ? ThemeMode.light
        //     : ThemeMode.dark,
        themeMode: themeController.themeMode.value,

        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      );
    });
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
