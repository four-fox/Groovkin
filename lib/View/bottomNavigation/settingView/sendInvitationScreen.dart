// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class SendInvitationScreen extends StatelessWidget {
  const SendInvitationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 60,
              ),
              const Image(
                image: AssetImage("assets/sendInvitation.png"),
              ),
              const SizedBox(
                height: 30,
              ),
              CircleAvatar(
                radius: 40,
                backgroundColor: DynamicColor.greenClr.withValues(alpha:0.3),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: DynamicColor.greenClr,
                  child: Icon(
                    Icons.check,
                    color: theme.primaryColor,
                    size: 35,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Text(
                ' The invitation for the GROOVKIN has been sent successfully.',
                textAlign: TextAlign.center,
                style: poppinsRegularStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          child: CustomButton(
            borderClr: Colors.transparent,
            color1: DynamicColor.blackClr,
            color2: DynamicColor.blackClr,
            onTap: () {
              if (sp.read("role") == "User") {
                Get.offAllNamed(Routes.userBottomNavigationNav);
              } else {
                Get.offAllNamed(Routes.bottomNavigationView,
                    arguments: {"indexValue": 1});
              }
            },
            text: "Ok",
          ),
        ),
      ),
    );
  }
}
