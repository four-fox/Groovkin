import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/settingView/followingScren.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({super.key});

  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  final AuthController _controller = Get.find();

  Timer? onStoppedTyping;

  _onChangeHandler() {
    const duration = Duration(
      milliseconds: 800,
    );
    if (onStoppedTyping != null) {
      onStoppedTyping!.cancel();
    }
    onStoppedTyping = Timer(duration, () => stopTyping());
  }

  stopTyping() {
    _controller.getAllUnfollowing();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/grayClor.png"), fit: BoxFit.fill)),
        ),
        title: Text(
          "Follow New Users",
          style: poppinsMediumStyle(
            fontSize: 17,
            color: theme.primaryColor,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: ImageIcon(
            const AssetImage("assets/backArrow.png"),
            color: theme.primaryColor,
          ),
        ),
      ),
      body: GetBuilder<AuthController>(initState: (v) {
        _controller.getAllUnfollowing();
      }, builder: (controller) {
        return controller.getAllUnfollowingLoader.value == false
            ? const SizedBox.shrink()
            : NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent) {
                    if (controller.getAllUnfollowingWait == false) {
                      controller.getAllUnfollowingWait = true;
                      if (controller.allUnFollower!.data!.nextPageUrl != null) {
                        String link =
                            controller.allUnFollower!.data!.nextPageUrl!;
                        controller.getAllUnfollowing(nextUrl: link);
                        return true;
                      }
                    }
                    return false;
                  }
                  return false;
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: DynamicColor.blackClr,
                      child: SearchTextFields(
                        borderRadius: 12,
                        controller: controller.allFollowUserController,
                        bgColor: DynamicColor.blackClr,
                        onChanged: (v) {
                          if (v != "") {
                            _onChangeHandler();
                          } else {
                            controller.allFollowUserController.clear();
                            _onChangeHandler();
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: AllUsers(
                        userValue: "",
                        heights: Get.height,
                      ),
                    ),
                  ],
                ));
      }),
    );
  }
}
