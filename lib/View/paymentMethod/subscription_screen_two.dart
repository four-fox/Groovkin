import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/utils/constant.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../model/single_ton_data.dart';

class SubscriptionScreenTwo extends StatefulWidget {
  const SubscriptionScreenTwo({super.key});

  @override
  State<SubscriptionScreenTwo> createState() => _SubscriptionScreenTwoState();
}

class _SubscriptionScreenTwoState extends State<SubscriptionScreenTwo> {
  bool isActive = false;
  CustomerInfo? _customerInfo;
  bool loader = true;
  late AuthController controller;

  Future<void> initPlatformState() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      _customerInfo = customerInfo;
      EntitlementInfo? entitlement =
          customerInfo.entitlements.all[entitlementID];
      appData.entitlementIsActive = entitlement?.isActive ?? false;
      bool isAutoRenewOff = entitlement?.willRenew == false;
      String expirationTime = entitlement?.expirationDate ?? "";
      if (kDebugMode) {
        print("Is AUTO RENEW $isAutoRenewOff");
        print("Expiration Time $expirationTime");
      }
      controller.update();
      Future.delayed(const Duration(seconds: 3), () {
        controller.update();
      });
    } catch (e) {
      loader = false;
    }
    controller.update();
  }

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AuthController>()) {
      controller = Get.find<AuthController>();
    } else {
      controller = Get.put(AuthController());
    }

    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller) {
      return SubscriptionClass(
        customerInfo: _customerInfo,
      );
    });
  }
}

class SubscriptionClass extends StatefulWidget {
  final CustomerInfo? customerInfo;
  const SubscriptionClass({super.key, this.customerInfo});

  @override
  State<SubscriptionClass> createState() => _SubscriptionClassState();
}

class _SubscriptionClassState extends State<SubscriptionClass> {
  late AuthController controller;
  late HomeController homeController;
  Offerings? _offerings;
  List<Package> availablePackages = [];

  List<SubscriptionModel> subscriptionList = [
    SubscriptionModel(
        price: '\$2.99',
        plan: 'Monthly Plan',
        trial: '7 Days Free Trial',
        isSelected: true.obs),
    SubscriptionModel(
        price: '\$29.99',
        plan: 'Annual Plan',
        trial: '7 Days Free Trial',
        isSelected: false.obs),
  ];

  void fetchData() async {
    Offerings? offerings;
    try {
      offerings = await Purchases.getOfferings();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } on SocketException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (!mounted) return;

    setState(() {
      if (offerings != null) {
        _offerings = offerings;
        availablePackages.addAll(_offerings!.current!.availablePackages);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AuthController>()) {
      controller = Get.find<AuthController>();
    } else {
      controller = Get.put(AuthController());
    }
    if (Get.isRegistered<HomeController>()) {
      homeController = Get.find<HomeController>();
    } else {
      homeController = Get.put(HomeController());
    }
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                    onTap: () {
                      for (var i = 0; i < subscriptionList.length; i++) {
                        subscriptionList[i].isSelected.value = false;
                      }
                      subscriptionList[index].isSelected.value = true;
                      controller.selected.value = index;
                    },
                    child: Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              DynamicColor.darkGrayClr.withOpacity(0.7),
                              DynamicColor.darkGrayClr,
                              DynamicColor.darkGrayClr.withOpacity(0.2),
                              DynamicColor.darkGrayClr.withOpacity(0.5),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topCenter,
                          ),
                          // color: Colors.grey[200],
                          // color: DynamicColor.darkGrayClr.withOpacity(0.7),
                          border: Border.all(
                            color:
                                subscriptionList[index].isSelected.value == true
                                    ? DynamicColor.yellowClr
                                    : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "${subscriptionList[index].price} / ${subscriptionList[index].plan}",
                                style: poppinsRegularStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                subscriptionList[index].trial,
                                style: poppinsRegularStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
              );
            },
            itemCount: subscriptionList.length,
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: CustomButton(
                  borderClr: Colors.transparent,
                  color1: DynamicColor.blackClr,
                  color2: DynamicColor.blackClr,
                  onTap: () async {
                    final entitlement =
                        widget.customerInfo?.entitlements.all[entitlementID];
                    if (entitlement?.isActive == true) {
                      return;
                    }
                    if (Platform.isAndroid) {
                      final customerInfo =
                          await Purchases.purchaseSubscriptionOption(_offerings!
                              .current!
                              .availablePackages[controller.selected.value]
                              .storeProduct
                              .subscriptionOptions![0]);
                      final isPro = customerInfo.entitlements.active
                          .containsKey(entitlementID);
                      if (isPro) {
                        appData.entitlementIsActive = customerInfo
                                .entitlements.all[entitlementID]?.isActive ??
                            false;
                        homeController.update();
                        controller.completePurchase(customerInfo);
                        controller.update();
                      }
                    } else {
                      BotToast.showLoading();
                      final customerInfo = await Purchases.purchasePackage(
                              _offerings!.current!
                                  .availablePackages[controller.selected.value])
                          .then((value) {
                        BotToast.closeAllLoading();
                        return value;
                      }).onError((error, _) {
                        BotToast.closeAllLoading();
                        throw Exception(error.toString());
                      });

                      final isPro = customerInfo.entitlements.active
                          .containsKey(entitlementID);
                      if (isPro) {
                        appData.entitlementIsActive = customerInfo
                                .entitlements.all[entitlementID]?.isActive ??
                            false;
                        homeController.update();
                        BotToast.closeAllLoading();
                        controller.completePurchase(customerInfo);
                      }
                    }
                  },
                  style: poppinsMediumStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                  text: getSubscriptionText(widget.customerInfo),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: CustomButton(
                  borderClr: Colors.transparent,
                  color1: DynamicColor.blackClr,
                  color2: DynamicColor.blackClr,
                  onTap: () {
                    controller.restore();
                  },
                  style: poppinsMediumStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                  text: "Restore Subscription",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String getSubscriptionText(CustomerInfo? info) {
    final entitlement = info?.entitlements.all[entitlementID];

    if (entitlement != null && entitlement.isActive == true) {
      return "Already Subscribed";
    } else if (entitlement != null &&
        entitlement.periodType == PeriodType.trial) {
      return "Start Trial";
    } else if (info != null && info.entitlements.all.isEmpty) {
      return "Start Trial";
    } else {
      return "Subscribe";
    }
  }
}

class SubscriptionModel {
  String price;
  String plan;
  String trial;
  RxBool isSelected;

  SubscriptionModel({
    required this.price,
    required this.plan,
    required this.trial,
    required this.isSelected,
  });
}
