import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';

class SettingNotificationController extends GetxController {
  RxBool chatNotification = false.obs;
  RxBool counterNotification = false.obs;

  set setChatNotification(bool value) {
    chatNotification.value = value;
    update();
  }

  set setCounterNotification(bool value) {
    counterNotification.value = value;
    update();
  }
}

class SettingNotificationScreen extends StatefulWidget {
  const SettingNotificationScreen({super.key});

  @override
  State<SettingNotificationScreen> createState() =>
      _SettingNotificationScreenState();
}

class _SettingNotificationScreenState extends State<SettingNotificationScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(SettingNotificationController());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              // color:imagee==true?Colors.transparent: DynamicColor.yellowClr,
              image: DecorationImage(
                  image: AssetImage("assets/grayClor.png"), fit: BoxFit.fill),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
        ),
        title: Text(
          "Notifications Settings",
          style: poppinsMediumStyle(
            fontSize: 17,
            color: theme.primaryColor,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: ImageIcon(
              const AssetImage("assets/backArrow.png"),
              color: theme.primaryColor,
            )),
      ),
      body: GetBuilder<SettingNotificationController>(builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chat Notification",
                      style: poppinsMediumStyle(
                        fontSize: 14,
                        color: theme.primaryColor,
                      ),
                    ),
                    Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                            activeTrackColor: DynamicColor.yellowClr,
                            value: controller.chatNotification.value,
                            onChanged: (value) {
                              controller.setChatNotification = value;
                            }))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Counter Notification",
                      style: poppinsMediumStyle(
                        fontSize: 14,
                        color: theme.primaryColor,
                      ),
                    ),
                    Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                            activeTrackColor: DynamicColor.yellowClr,
                            value: controller.counterNotification.value,
                            onChanged: (value) {
                              controller.setCounterNotification = value;
                            }))
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
