

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/settingView/followingScren.dart';

class AllUserScreen extends StatelessWidget {
  AllUserScreen({super.key});

  final AuthController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight*1.5),
        child: Container(
          height: kToolbarHeight*1.5,
          padding: EdgeInsets.only(top: 30,left: 10),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/grayClor.png"),
                  fit: BoxFit.fill
              )
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Center(
                child: Text("Follow New Users",style: poppinsMediumStyle(
                  fontSize: 17,
                  color: theme.primaryColor,
                ),),
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: ImageIcon(AssetImage("assets/backArrow.png"),
                  color: theme.primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
      body: GetBuilder<AuthController>(
        initState: (v){
          _controller.getAllUnfollowing();
        },
        builder: (controller) {
          return controller.getAllUnfollowingLoader.value == false?
            SizedBox.shrink():
          NotificationListener<ScrollNotification>(
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
                child: AllUsers(userValue: "",heights: Get.height,));
        }
      ),
    );
  }
}
