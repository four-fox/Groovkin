// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/cancelEventWidget.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/showCustomMap.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class ChatCenterScreen extends StatelessWidget {
  ChatCenterScreen({super.key});

  RxBool showMessageField = false.obs;
  String onGoingVal = Get.arguments['onGoing'];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Message Center"),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                onGoingVal == "ongoing"
                    ? SizedBox.shrink()
                    : eventOrganizer(
                        theme: theme,
                        context: context,
                        name: "Michael Logan",
                        location: "Herkimer County Fairgrounds",
                        iconClr: DynamicColor.lightWhite,
                        iconShow: true,
                        onTap: () {
                          print(sp.read('role'));
                          // Get.toNamed(Routes.eventOrganizerScreen,
                          //     arguments: {
                          //       'eventOrganizerValue': 2
                          //     }
                          // );
                        }),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                          color: DynamicColor.grayClr.withOpacity(0.6)),
                    ),
                    child: Column(
                      children: [
                        eventStatusWidget(
                            theme: theme, context: context, text: "ongoing"),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          child: Row(
                            children: [
                              Image(
                                image: AssetImage("assets/profileImg.png"),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Herkimer County Fairgrounds',
                                      style: poppinsRegularStyle(
                                          fontSize: 12,
                                          context: context,
                                          color: theme.primaryColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Want to book for an event.',
                                      style: poppinsRegularStyle(
                                          fontSize: 12,
                                          context: context,
                                          color: DynamicColor.lightRedClr,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CustomButton(
                            borderClr: Colors.transparent,
                            heights: 38,
                            style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.primaryColor,
                            ),
                            backgroundClr: false,
                            onTap: () {
                              Get.toNamed(Routes.upcomingScreen, arguments: {
                                "reportedEventView": 1,
                                "notInterestedBtn": 3,
                                "appBarTitle": "Event Preview"
                              });
                            },
                            text: "View Detail",
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        onGoingVal == "ongoing"
                            ? SizedBox.shrink()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CustomButton(
                                  heights: 38,
                                  style: poppinsRegularStyle(
                                    fontSize: 14,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                  onTap: () {
                                    cancelEventWidget(
                                        context: context, theme: theme);
                                  },
                                  backgroundClr: false,
                                  borderClr: Colors.transparent,
                                  color2: DynamicColor.redClr,
                                  color1: DynamicColor.redClr,
                                  text: "Cancel",
                                ),
                              ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                onGoingVal == "ongoing"
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: CustomButton(
                          heights: 38,
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                          onTap: () {
                            showMessageField.value = !showMessageField.value;
                          },
                          backgroundClr: false,
                          textClr: DynamicColor.blackClr,
                          borderClr: Colors.transparent,
                          color2: DynamicColor.lightYellowClr,
                          color1: DynamicColor.lightYellowClr,
                          text: "Counter",
                        ),
                      ),
                SizedBox(
                  height: 100,
                ),
                Divider(
                  thickness: 1,
                  color: DynamicColor.grayClr,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Counter  by Michael.",
                        style: poppinsRegularStyle(
                          context: context,
                          fontSize: 12,
                          color: theme.primaryColor,
                        ),
                      ),
                      Text(
                        "10:34am",
                        style: poppinsRegularStyle(
                            context: context,
                            fontSize: 12,
                            color: DynamicColor.lightRedClr),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                    style: poppinsRegularStyle(
                      context: context,
                      fontSize: 12,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: DynamicColor.grayClr,
                ),
                SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
          Obx(
            () => Visibility(
              visible: showMessageField.value,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: DynamicColor.grayClr)),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Write here  to Townsquare",
                            hintStyle: poppinsRegularStyle(
                              fontSize: 10,
                              context: context,
                              color: DynamicColor.grayClr,
                            ),
                            prefixIcon: Icon(
                              Icons.attach_file_outlined,
                              color: DynamicColor.grayClr,
                            ),
                            suffixIcon: ImageIcon(
                              AssetImage("assets/sendIcon.png"),
                              color: DynamicColor.grayClr,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: onGoingVal != "ongoing"
          ? SizedBox.shrink()
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: CustomButton(
                heights: 38,
                style: poppinsRegularStyle(
                  fontSize: 14,
                  context: context,
                  color: theme.primaryColor,
                ),
                onTap: () {
                  Get.back();
                },
                backgroundClr: false,
                // textClr: theme.scaffoldBackgroundColor,
                borderClr: Colors.transparent,
                color2: DynamicColor.greenClr,
                color1: DynamicColor.greenClr,
                text: "Complete",
              ),
            ),
    );
  }
}
