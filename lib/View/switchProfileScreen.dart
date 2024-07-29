// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class SwitchProfileScreen extends StatelessWidget {
  const SwitchProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 35,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ImageIcon(AssetImage("assets/backArrow.png"),
                  color: theme.primaryColor,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text("Welcome to User Profile",
                style: poppinsMediumStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Text("Lorem Ipsum is simply dummy text of\nthe printing and typesetting industry. ",
                textAlign: TextAlign.center,
                style: poppinsRegularStyle(
                  fontSize: 14,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),

              SizedBox(
                height: 40,
              ),

              SizedBox(
                width: Get.width/1.3,
                  height: Get.height/2.9,
                  child: Image(image: AssetImage("assets/switchImg.png"))),

              SizedBox(
                height: 40,
              ),

              Text("Complete your Profile",
                textAlign: TextAlign.center,
                style: poppinsMediumStyle(
                  fontSize: 17,
                    fontWeight: FontWeight.w600,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),

              Text("Lorem Ipsum is simply dummy text of\nthe printing and typesetting industry. ",
                textAlign: TextAlign.center,
                style: poppinsRegularStyle(
                    fontSize: 14,
                    context: context,
                    color: theme.primaryColor,
                ),
              ),

              Spacer(),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                child: CustomButton(
                  borderClr: Colors.transparent,
                  onTap: (){
                    Get.offAllNamed(Routes.userQuickSurveyScreen);
                  },
                  text: "Start",
                ),
              ),

              SizedBox(
                height: 30,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
