// ignore_for_file: prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';

class NewPasswordScreen extends StatelessWidget {
  NewPasswordScreen({super.key});

  late AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Change password"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Reset Password",
              style: poppinsMediumStyle(
                fontSize: 17,
                context: context,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
              style: poppinsRegularStyle(
                  fontSize: 14,
                  context: context,
                  color: DynamicColor.grayClr.withOpacity(0.8)),
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextFields(
              labelText: "Old Password",
              controller: _authController.oldPasswordController,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextFields(
              labelText: "New Password",
              controller: _authController.newPasswordController,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextFields(
              labelText: "Confirm Password",
              controller: _authController.newConfirmPasswordController,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          child: CustomButton(
            borderClr: Colors.transparent,
            color1: DynamicColor.blackClr,
            color2: DynamicColor.blackClr,
            onTap: () {
              _authController.changePassword(context, theme);
              // Get.toNamed(Routes.newPasswordScreen);
            },
            text: "Continue",
          ),
        ),
      ),
    );
  }
}
