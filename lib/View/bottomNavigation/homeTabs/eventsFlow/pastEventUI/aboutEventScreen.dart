// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/showCustomMap.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Components/userCustomWidget.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';

class AboutEventScreen extends StatelessWidget {
  AboutEventScreen({super.key});

  bool imageShow = Get.arguments['imageShow'];
  String titleText = Get.arguments['upcomingOrganizer'] ?? "About Event";

  RxBool organizerFollowVal = false.obs;
  RxBool organizerFollowValue = false.obs;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: titleText),
      body: GetBuilder<HomeController>(builder: (controller) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  // padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                        color: DynamicColor.grayClr.withOpacity(0.6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      eventStatusWidget(theme: theme, context: context),
                      venueBookingUser(theme: theme, context: context),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                        child: CustomButton(
                          heights: 33,
                          color2: DynamicColor.secondaryClr,
                          color1: DynamicColor.secondaryClr,
                          backgroundClr: false,
                          onTap: () {
                            Get.toNamed(Routes.counterScreen, arguments: {
                              "textField": false,
                              "acceptVal": false,
                            });
                          },
                          borderClr: Colors.transparent,
                          text: "See Counter",
                        ),
                      ),
                      controller.selectedFilter.value == 4
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 3),
                              child: CustomButton(
                                heights: 35,
                                backgroundClr: false,
                                onTap: () {
                                  Get.toNamed(Routes.cancellationReason);
                                },
                                borderClr: Colors.transparent,
                                color2: DynamicColor.redClr,
                                color1: DynamicColor.redClr,
                                style: poppinsRegularStyle(
                                  fontSize: 13,
                                  context: context,
                                  color: theme.primaryColor,
                                ),
                                text: "Cancellation Reason",
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                Container(
                    height: kToolbarHeight * 3,
                    // padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      image: DecorationImage(
                          image: AssetImage("assets/event1.png"),
                          fit: BoxFit.fill),
                    )),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 25,
                    width: 150,
                    // padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                    decoration: BoxDecoration(
                      color: DynamicColor.lightBlackClr.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "Attended by 500 people",
                        style: poppinsRegularStyle(
                            fontSize: 10,
                            color: theme.primaryColor,
                            context: context),
                      ),
                    ),
                  ),
                ),
                // titleText !="UpcomingOrganizer"?  eventOrganizer(theme: theme,context: context,onTap: (){
                //   Get.toNamed(Routes.eventOrganizerScreen,
                //       arguments: {
                //         'eventOrganizerValue': 2
                //       }
                //   );
                // }):SizedBox.shrink(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "90’s Grunge and Bowling",
                      style: poppinsMediumStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                venueService(
                    theme: theme,
                    context: context,
                    bgColor: DynamicColor.darkBlueClr,
                    text: "10:30 Pm to 5:00 Am (GMT-04:00)",
                    image: "assets/lockIcon.png",
                    horizontalPadding: 0.0,
                    radius: 18,
                    icon: true,
                    fontSize: 12),
                venueService(
                    theme: theme,
                    context: context,
                    bgColor: DynamicColor.darkBlueClr,
                    text: "Saturday, June 17th of 2023",
                    image: "assets/calender.png",
                    horizontalPadding: 0.0,
                    radius: 18,
                    icon: true,
                    fontSize: 12),
                venueService(
                    theme: theme,
                    context: context,
                    bgColor: DynamicColor.darkBlueClr,
                    text: "Herkimer County Fairgrounds",
                    image: "assets/location.png",
                    horizontalPadding: 0.0,
                    radius: 18,
                    iconClr: DynamicColor.secondaryClr,
                    fontSize: 12
                    // icon: true,
                    ),
                SizedBox(
                  height: 10,
                ),
                sp.read('role') == "eventManager"
                    ? SizedBox.shrink()
                    : Obx(
                        () => aboutEventCreator(
                          isDelete: null,
                            theme: theme,
                            context: context,
                            followBg: organizerFollowVal.value == true
                                ? DynamicColor.lightWhite
                                : DynamicColor.avatarBgClr,
                            textClr: organizerFollowVal.value == true
                                ? theme.scaffoldBackgroundColor
                                : theme.primaryColor,
                            icons: organizerFollowVal.value == true
                                ? Icons.check
                                : Icons.add,
                            onTap: () {
                              organizerFollowVal.value =
                                  !organizerFollowVal.value;
                            }),
                      ),
                sp.read('role') == "eventOrganizer"
                    ? SizedBox.shrink()
                    : Obx(
                        () => ourGuestWidget(
                          isDelete: null,
                          theme: theme,
                          context: context,
                          horizontalPadding: 0.0,
                          rowPadding: 0.0,
                          rowVerticalPadding: 0.0,
                          avatarPadding: 6,
                          followBgClr: organizerFollowValue.value == true
                              ? DynamicColor.grayClr
                              : DynamicColor.avatarBgClr,
                          icon: organizerFollowValue.value == true
                              ? Icons.check
                              : Icons.add,
                          textClr: organizerFollowValue.value != true
                              ? theme.primaryColor
                              : theme.scaffoldBackgroundColor,
                          followOnTap: () {
                            organizerFollowValue.value =
                                !organizerFollowValue.value;
                          },
                          onTap: () {
                            // Get.toNamed(Routes.eventOrganizerScreen,
                            //     arguments: {
                            //       'eventOrganizerValue': 2
                            //     }
                            // );
                          },
                        ),
                      ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Location",
                      style: poppinsMediumStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        context: context,
                        color: DynamicColor.lightRedClr,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Herkimer County Fairgrounds",
                      style: poppinsRegularStyle(
                        fontSize: 15,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ShowCustomMap(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
                    child: Text(
                      'verbiage to come',
                      style: poppinsMediumStyle(
                        fontSize: 18,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: DynamicColor.avatarBgClr,
                        child: Image(
                          image: AssetImage("assets/djing.png"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "DJing",
                          style: poppinsMediumStyle(
                              fontSize: 16,
                              color: theme.primaryColor,
                              context: context),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: DynamicColor.avatarBgClr,
                        child: Image(
                          image: AssetImage("assets/lighting.png"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Lighting",
                          style: poppinsMediumStyle(
                              fontSize: 16,
                              color: theme.primaryColor,
                              context: context),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: DynamicColor.avatarBgClr,
                        child: Image(
                          image: AssetImage("assets/photobooth.png"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Photobooth",
                          style: poppinsMediumStyle(
                              fontSize: 16,
                              color: theme.primaryColor,
                              context: context),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: DynamicColor.avatarBgClr,
                        child: Image(
                          image: AssetImage("assets/master.png"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Master of Ceremony",
                          style: poppinsMediumStyle(
                              fontSize: 16,
                              color: theme.primaryColor,
                              context: context),
                        ),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: DynamicColor.avatarBgClr,
                        child: Image(
                          image: AssetImage("assets/avEquipment.png"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "AV Equipment",
                          style: poppinsMediumStyle(
                              fontSize: 16,
                              color: theme.primaryColor,
                              context: context),
                        ),
                      )
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
                    child: Text(
                      'All Hardware',
                      style: poppinsMediumStyle(
                        fontSize: 18,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: Image(
                                image: AssetImage("assets/headingIcons.png"),
                              ),
                            ),
                            SizedBox(
                              width: Get.width / 1.35,
                              child: Text(
                                "Vinyl Turntables",
                                style: poppinsRegularStyle(
                                  fontSize: 12,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Tags",
                      style: poppinsMediumStyle(
                        fontSize: 13,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: kToolbarHeight / 2,
                  child: ListView.builder(
                      itemCount: 12,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: DynamicColor.lightRedClr,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Text(
                                "#Nirvana",
                                style: poppinsRegularStyle(
                                  fontSize: 12,
                                  context: context,
                                  color: theme.scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class GenerateTicket extends StatelessWidget {
  const GenerateTicket({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        appBar: customAppBar(theme: theme, text: "Generate Ticket"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: 60,
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: DynamicColor.avatarBgClr),
                child: Center(
                  child: Text(
                    "Report",
                    style: poppinsRegularStyle(
                      fontSize: 13,
                      color: theme.primaryColor,
                      context: context,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Name",
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.grayClr.withOpacity(0.8)),
                  ),
                  Text(
                    "John",
                    style: poppinsRegularStyle(
                      fontSize: 14,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                  Text(
                    "Date",
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.grayClr.withOpacity(0.8)),
                  ),
                  Text(
                    "01-Sep-23",
                    style: poppinsRegularStyle(
                      fontSize: 14,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
                color: DynamicColor.grayClr.withOpacity(0.6),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Title',
                style: poppinsRegularStyle(
                  fontSize: 14,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              CustomTextFieldsHintText(
                hintText: "Type here",
                controller: TextEditingController(),
                borderClr: DynamicColor.grayClr.withOpacity(0.6),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Describe here',
                style: poppinsRegularStyle(
                  fontSize: 14,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              CustomTextFieldsHintText(
                hintText: "Type here",
                maxLine: 5,
                controller: TextEditingController(),
                borderClr: DynamicColor.grayClr.withOpacity(0.6),
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                color1: DynamicColor.redClr,
                color2: DynamicColor.redClr,
                backgroundClr: false,
                borderClr: Colors.transparent,
                heights: 40,
                fontSized: 14,
                onTap: () {
                  showDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertWidget(
                          height: kToolbarHeight * 4,
                          container: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              // border: Border.all(color: theme.primaryColor,)
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        DynamicColor.greenClr.withOpacity(0.3),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: DynamicColor.greenClr,
                                      child: Icon(
                                        Icons.check,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 18.0),
                                    child: Text(
                                      "Thank you For reporting",
                                      style: poppinsMediumStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        context: context,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width / 1.8,
                                    child: CustomButton(
                                      onTap: () {
                                        Get.back();
                                        Get.back();
                                        // Get.toNamed(Routes.upcomingScreen,
                                        // arguments: {
                                        //   "reportedEventView":2
                                        // }
                                        // );
                                      },
                                      heights: 30,
                                      text: "Back",
                                      borderClr: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                text: "Send Report",
              ),
            ],
          ),
        ));
  }
}

class CancellationReason extends StatelessWidget {
  const CancellationReason({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Cancelled"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Reason of cancellation',
                style: poppinsMediumStyle(
                  fontSize: 17,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: DynamicColor.avatarBgClr.withOpacity(0.5)),
              child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to",
                style: poppinsRegularStyle(
                    fontSize: 13, color: theme.primaryColor, context: context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
