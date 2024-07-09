

// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Change password"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text("Reset Password",
              style: poppinsMediumStyle(
                  fontSize: 17,
                  context: context,
                  color: theme.primaryColor,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
              style: poppinsRegularStyle(
                  fontSize: 14,
                  context: context,
                  color: DynamicColor.grayClr.withOpacity(0.8)
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextFields(
              labelText: "Old Password",
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextFields(
              labelText: "New Password",
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextFields(
              labelText: "Confirm Password",
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),
        child: CustomButton(
          borderClr: Colors.transparent,
          color1: DynamicColor.blackClr,
          color2: DynamicColor.blackClr,
          onTap: (){
            showDialog(
                barrierColor: Colors.transparent,
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertWidget(
                    height: kToolbarHeight*5,
                    bgColor: true,
                    container: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image(image: AssetImage("assets/sucses.png")),
                        Text("Successfully change\nPassword",
                        textAlign: TextAlign.center,
                          style: poppinsMediumStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: theme.scaffoldBackgroundColor,
                            context: context
                          ),
                        ),
                        CustomButton(
                          borderClr: Colors.transparent,
                          color1: DynamicColor.blackClr,
                          color2: DynamicColor.blackClr,
                          widths: 120,
                          heights: 35,
                          onTap: (){
                            Get.back();
                            Get.back();
                            Get.back();
                          },
                          text: "Done",
                        ),
                      ],
                    )
                  );
                });
            // Get.toNamed(Routes.newPasswordScreen);
          },
          text: "Continue",
        ),
      ),
    );
  }
}
