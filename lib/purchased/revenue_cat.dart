// import 'dart:developer';
// import 'dart:io';
// import 'package:bot_toast/bot_toast.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:groovkin/Components/Network/API.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../utils/constant.dart';


class StoreConfig {
  final String apiKey;
  final Store store;
  StoreConfig._interval(this.apiKey, this.store);

  static StoreConfig? _instance;

  factory StoreConfig({required String apiKey, required Store store}) {
    _instance ??= StoreConfig._interval(apiKey, store);
    return _instance!;
  }

  static StoreConfig get instance => _instance!;

  bool get isFromApple => instance.store == Store.appStore;

  bool get isFromGoogle => instance.store == Store.playStore;
}



// final appData = AppData();

// class RevenueCatSubscription extends GetxController {
//   @override
//   void onInit() {
//     super.onInit();
//     initPlatFormState();
//     fetchOffers();
//   }

//   List<SubscriptionModel> subscriptionList = [
//     SubscriptionModel(
//       price: '\$2.99',
//       plan: 'Monthly Plan',
//       trial: '7 Days Free Trial',
//       isSelected: true.obs,
//     ),
//     SubscriptionModel(
//       price: '\$29.99',
//       plan: 'Annual Plan',
//       trial: '7 Days Free Trial',
//       isSelected: false.obs,
//     ),
//   ];

//   Offerings? offering;

//   void configureSdk() async {
//     final purchaseConfiguration =
//         PurchasesConfiguration(StoreConfig.instance.apiKey)
//           ..appUserID = API().sp.read("userId")
//           ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();

//     await Purchases.configure(purchaseConfiguration);
//   }

//   void initPlatFormState() async {
//     Purchases.addCustomerInfoUpdateListener(
//       (customerInfo) async {
//         CustomerInfo customerInfo = await Purchases.getCustomerInfo();

//         EntitlementInfo? entitlement =
//             customerInfo.entitlements.all[entitlementID];

//         log("Updated Purchased");
//         appData.entitlementIsActive = entitlement?.isActive ?? false;
//         log("Updated Purchased");

//         update();
//       },
//     );
//   }

//   void fetchOffers() async {
//     try {
//       offering = await Purchases.getOfferings();
//     } catch (e) {
//       rethrow;
//     }
//     update();
//   }

//   void purchasePackage() async {
//     if (Platform.isIOS) {
//       final customerInfo = await Purchases.purchasePackage(
//           offering!.current!.availablePackages[0]);
//       final isPro = customerInfo.entitlements.active.containsKey(entitlementID);
//       if (isPro) {
//         // Then Hit Api Call
//       }
//     } else {
//       final customerInfo = await Purchases.purchaseSubscriptionOption(offering!
//           .current!.availablePackages[0].storeProduct.subscriptionOptions![0]);
//       final isPro = customerInfo.entitlements.active.containsKey(entitlementID);
//       if (isPro) {
//         // Then Hit Api Call
//       }
//     }
//   }

//   void restoreSubscription() async {
//     await Purchases.logIn(API().sp.read("userId"));
//     CustomerInfo restoredInfo = await Purchases.restorePurchases();
//     if (restoredInfo.entitlements.all[entitlementID] != null) {
//       if (restoredInfo.entitlements.all[entitlementID]!.isActive == true) {
//         final time = DateTime.parse(
//                 restoredInfo.entitlements.all[entitlementID]!.expirationDate!)
//             .toLocal()
//             .difference(DateTime.now().toLocal())
//             .inMinutes;
//         if (time >= 0) {
//         } else {
//           checkSub("Subscription Expired");
//         }
//       } else {
//         checkSub("No Active Subscription");
//       }
//     } else {
//       checkSub("No Active Subscription");
//     }
//   }

//   void cancelSubscription() async {
//     if (Platform.isAndroid) {
//       launchUrl(
//           Uri.parse(
//               'https://play.google.com/store/account/subscriptions?sku=asdas&package=com.gologonow.groovkinn'),
//           mode: LaunchMode.externalApplication);
//     } else {
//       showCupertinoDialog(
//           context: Get.context!,
//           builder: (context) {
//             return CupertinoAlertDialog(
//               title: const Text("Cancel Subscription"),
//               // content: Text(
//               //     'To ${productId!.value.isEmpty ? 'Cancel' : (productId!.value == "Monthly" && controller.selected.value == 0) ? 'Cancel' : (productId!.value == "Yearly" && controller.selected.value == 1) ? 'Cancel' : 'Upgrade Or Downgrade'} Your Subscription\nGo To Settings > Your Account > Subscription'),
//               actions: <Widget>[
//                 CupertinoDialogAction(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text('OK'),
//                 ),
//               ],
//             );
//           });
//     }
//   }

//   checkSub(String text) {
//     BotToast.closeAllLoading();
//     BotToast.showText(
//       text: text,
//     );
//   }
// }

// class SubscriptionModel {
//   String price;
//   String plan;
//   String trial;
//   RxBool isSelected;

//   SubscriptionModel({
//     required this.price,
//     required this.plan,
//     required this.trial,
//     required this.isSelected,
//   });
// }
