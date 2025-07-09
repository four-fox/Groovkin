import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/showCustomMap.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class ManagerApprovedEventScreen extends StatelessWidget {
  const ManagerApprovedEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(text: "About Event", theme: theme),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.eventOrganizerScreen, arguments: {
                  'eventOrganizerValue': 1,
                  "profileImg": "assets/eventOrganizer.png",
                  "manager": "Event Organizer",
                });
              },
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: DynamicColor.blackClr,
                      shape: BoxShape.circle,
                      border: Border.all(color: DynamicColor.lightYellowClr),
                    ),
                    child: const Image(
                      image: AssetImage("assets/profileImg.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: SizedBox(
                      width: Get.width / 2.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Townsquare',
                            style: poppinsMediumStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: theme.primaryColor,
                            ),
                          ),
                          Text(
                            "Event Organizer",
                            style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: DynamicColor.grayClr,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: DynamicColor.grayClr.withValues(alpha:0.6)),
              ),
              child: Column(
                children: [
                  eventStatusWidget(
                    theme: theme,
                    context: context,
                    text: "Waiting for approved",
                    color: DynamicColor.greenClr,
                    textClr: theme.primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Row(
                      children: [
                        const Image(
                          image: AssetImage("assets/profileImg.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
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
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          heights: 35,
                          widths: Get.width / 3.2,
                          onTap: () {
                            Get.toNamed(Routes.editEventScreen);
                          },
                          backgroundClr: false,
                          borderClr: Colors.transparent,
                          color2: DynamicColor.lightBlackClr.withValues(alpha:0.7),
                          color1: DynamicColor.lightBlackClr.withValues(alpha:0.7),
                          text: "Change",
                          textClr: theme.primaryColor,
                        ),
                        CustomButton(
                          heights: 35,
                          widths: Get.width / 3.2,
                          onTap: () {
                            Get.toNamed(Routes.editEventScreen);
                          },
                          backgroundClr: false,
                          borderClr: Colors.transparent,
                          color2: DynamicColor.lightBlackClr.withValues(alpha:0.7),
                          color1: DynamicColor.lightBlackClr.withValues(alpha:0.7),
                          textClr: theme.primaryColor,
                          text: "Cancel",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomButton(
                      heights: 35,
                      color1: DynamicColor.secondaryClr,
                      color2: DynamicColor.secondaryClr,
                      widths: Get.width,
                      onTap: () {
                        Get.toNamed(Routes.upcomingScreen, arguments: {
                          "reportedEventView": 3,
                          "notInterestedBtn": 3,
                          "appBarTitle": "View Event"
                        });
                      },
                      backgroundClr: false,
                      textClr: theme.primaryColor,
                      borderClr: Colors.transparent,
                      text: "View",
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomButton(
                      heights: 35,
                      onTap: () {
                        showDialog(
                            barrierColor: Colors.transparent,
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertWidget(
                                height: kToolbarHeight * 4,
                                container: SizedBox(
                                  width: Get.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 4),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: DynamicColor.greenClr
                                              .withValues(alpha:0.3),
                                          radius: 35,
                                          child: CircleAvatar(
                                            backgroundColor: DynamicColor
                                                .greenClr
                                                .withValues(alpha:0.3),
                                            radius: 23,
                                            child: Icon(
                                              Icons.check,
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "successfully Approved",
                                          style: poppinsMediumStyle(
                                              fontSize: 16,
                                              color: theme.primaryColor,
                                              context: context),
                                        ),
                                        CustomButton(
                                          widths: Get.width / 2,
                                          heights: 30,
                                          text: "Back",
                                          borderClr: Colors.transparent,
                                          onTap: () {
                                            Get.back();
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      backgroundClr: false,
                      borderClr: Colors.transparent,
                      color2: DynamicColor.greenClr,
                      color1: DynamicColor.greenClr,
                      text: "Approved",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 6),
                    child: CustomButton(
                      heights: 35,
                      color1: DynamicColor.redClr,
                      color2: DynamicColor.redClr,
                      widths: Get.width,
                      onTap: () {
                        showDialog(
                            barrierColor: Colors.transparent,
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertWidget(
                                height: kToolbarHeight * 6,
                                container: SizedBox(
                                  width: Get.width,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 4),
                                      child: reportWidget(
                                          theme: theme, context: context)),
                                ),
                              );
                            });
                      },
                      backgroundClr: false,
                      textClr: theme.primaryColor,
                      borderClr: Colors.transparent,
                      text: "Report",
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: kToolbarHeight,
            ),
            Divider(
              thickness: 1,
              color: DynamicColor.grayClr,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
          ],
        ),
      ),
    );
  }

  Widget reportWidget({theme, context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: DynamicColor.lightWhite,
                child: Icon(
                  Icons.clear,
                  size: 10,
                  color: DynamicColor.blackClr,
                ),
              ),
            ),
          ),
          Text(
            "\nWe at Groovkin are here to assist you at any time, but we also recommend that the affected parties attempt to resolve the issue on their own end first and try to find a middle\n\n ground.However, if you are unable to reach a conclusion, please generate a ticket, and Groovkin will assist you.",
            textAlign: TextAlign.center,
            style: poppinsRegularStyle(
                fontSize: 12, color: theme.primaryColor, context: context),
          ),
          Text(
            "Thank You",
            style: poppinsMediumStyle(
                fontSize: 16, color: theme.primaryColor, context: context),
          ),
          CustomButton(
            widths: Get.width / 2,
            heights: 30,
            text: "Generate a tickets",
            borderClr: Colors.transparent,
            onTap: () {
              Get.back();
              Get.toNamed(Routes.generateTicket);
            },
          )
        ],
      ),
    );
  }
}
