// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class LoginSelection extends StatefulWidget {
  const LoginSelection({super.key});

  @override
  State<LoginSelection> createState() => _LoginSelectionState();
}

class _LoginSelectionState extends State<LoginSelection> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            customAlertt(
              context: context,
              title: "Exit Application",
              text: "Are You Sure?",              btnSuccess: "Yes",
              onTap: () {
                SystemNavigator.pop();
              },
            );
          }
        },
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/loginSelection2.png'),
                    fit: BoxFit.fill)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: kToolbarHeight,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    'Who are you?',
                    style: poppinsMediumStyle(
                        color: theme.primaryColor,
                        fontSize: 23,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    'What type of account do you want\nto sign up for?',
                    style: poppinsRegularStyle(
                      color: theme.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(30),
                  color: DynamicColor.whiteClr.withValues(alpha: 0.8),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    child: Container(
                      // height: 100,
                      width: Get.width,
                      color: theme.scaffoldBackgroundColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "User",
                            style: poppinsMediumStyle(
                              color: theme.primaryColor,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomButton(
                            borderClr: Colors.transparent,
                            text: "Register as Groovkin User",
                            heights: 45,
                            onTap: () {
                              sp.write("currentRole", "User");
                              sp.write('role', 'User');
                              Get.toNamed(Routes.loginWithScreen);
                              // Get.toNamed(Routes.welComeScreen);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(30),
                  color: DynamicColor.whiteClr.withValues(alpha: 0.8),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    child: Container(
                      // height: 100,
                      width: Get.width,
                      color: theme.scaffoldBackgroundColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Business Users",
                            style: poppinsMediumStyle(
                              color: theme.primaryColor,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomButton(
                            heights: 45,
                            borderClr: Colors.transparent,
                            onTap: () {
                              sp.write("currentRole", "eventOrganizer");
                              sp.write('role', 'eventOrganizer');
                              Get.toNamed(Routes.loginWithScreen);
                              // Get.toNamed(Routes.welComeScreen);
                            },
                            text: "Register as Event Organizer",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                            heights: 45,
                            borderClr: Colors.transparent,
                            text: "Register as Venue Manager",
                            onTap: () {
                              sp.write("currentRole", "eventManager");
                              sp.write('role', 'eventManager');
                              Get.toNamed(Routes.loginWithScreen);
                              // Get.toNamed(Routes.welComeScreen);
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
