// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/social_sign_in.dart';

class LoginWithScreen extends StatelessWidget {
  const LoginWithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/loginSelection1.png"),
                fit: BoxFit.fill)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: kToolbarHeight / 1.5,
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: ImageIcon(
                const AssetImage('assets/backArrow.png'),
                size: 32,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Let’s get Started',
              style: poppinsMediumStyle(
                fontSize: 28,
                context: context,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Signup or login to your Event\nOrganizer account.',
              style: poppinsRegularStyle(
                fontSize: 14,
                context: context,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(
              height: kToolbarHeight * 1.4,
            ),
            CustomButton(
              onTap: () {
                // if(sp.read("role") == "eventManager"){
                //   Get.offAllNamed(Routes.welComeScreen);
                // } else{
                Get.toNamed(Routes.loginOrSignUpScreen);
                // }
              },
              color2: DynamicColor.grayClr.withValues(alpha:0.4),
              color1: DynamicColor.grayClr.withValues(alpha:0.1),
              backgroundClr: false,
              borderClr: Colors.transparent,
              text: "Signup with email address",
              style: poppinsMediumStyle(
                  fontSize: 16, color: DynamicColor.lightRedClr),
            ),
            const SizedBox(
              height: 20,
            ),
            if (API().sp.read("role") == "User")
              const SocialSignIn(
                showSpotify: true,
              ),
          ],
        ),
      ),
    );
  }
}
