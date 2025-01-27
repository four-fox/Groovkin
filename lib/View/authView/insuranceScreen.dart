// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';

class InsuranceScreen extends StatefulWidget {
  InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  late HomeController _homeController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.isRegistered<HomeController>()) {
      _homeController = Get.find<HomeController>();
    } else {
      _homeController = Get.put(HomeController());
    }
  }

  int insuranceNavigation = Get.arguments['insuranceNavigation'];

  bool isFromGroovkin = Get.arguments?["isFromGroovkin"] ?? false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Insurance"),
      body: GetBuilder<AuthController>(builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              'Can you provide insurance if\nrequired?',
              textAlign: TextAlign.center,
              style: poppinsRegularStyle(
                  fontSize: 15,
                  context: context,
                  color: DynamicColor.lightRedClr),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    widths: Get.width / 2.3,
                    heights: 45,
                    borderClr: controller.insuranceVal.value == 1
                        ? Colors.transparent
                        : DynamicColor.yellowClr,
                    backgroundClr:
                        controller.insuranceVal.value == 1 ? true : false,
                    color1: Colors.transparent,
                    color2: Colors.transparent,
                    onTap: () {
                      controller.insuranceVal.value = 1;
                      if (isFromGroovkin) {
                        controller.update();
                        controller.updateInsurance().then((_) {
                          _homeController.getMyGroovkinData().then((_) {
                            Get.back();
                          });
                        });
                        return;
                      }

                      if (insuranceNavigation == 2) {
                        Get.back();
                      } else {
                        Get.toNamed(Routes.hardwareScreen, arguments: {
                          "createEvent": false,
                        });
                      }
                      controller.update();
                    },
                    textClr: controller.insuranceVal.value == 1
                        ? theme.primaryColor
                        : DynamicColor.yellowClr,
                    text: "Yes",
                  ),
                  CustomButton(
                    widths: Get.width / 2.3,
                    heights: 45,
                    onTap: () {
                      controller.insuranceVal.value = 0;
                      if (isFromGroovkin) {
                        controller.update();
                        controller.updateInsurance().then((_) {
                          _homeController.getMyGroovkinData().then((_) {
                            Get.back();
                          });
                        });
                        return;
                      }

                      if (insuranceNavigation == 2) {
                        Get.back();
                      } else {
                        Get.toNamed(Routes.hardwareScreen, arguments: {
                          "createEvent": false,
                        });
                      }
                      controller.update();
                    },
                    borderClr: controller.insuranceVal.value == 0
                        ? Colors.transparent
                        : DynamicColor.yellowClr,
                    backgroundClr:
                        controller.insuranceVal.value == 0 ? true : false,
                    color1: Colors.transparent,
                    color2: Colors.transparent,
                    textClr: controller.insuranceVal.value == 0
                        ? theme.primaryColor
                        : DynamicColor.yellowClr,
                    text: "No",
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
