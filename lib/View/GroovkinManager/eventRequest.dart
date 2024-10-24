import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class EventRequests extends StatelessWidget {
  const EventRequests({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Request", backArrow: false),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: ListView.builder(
              itemCount: 15,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, index) {
                return GestureDetector(
                  onTap: () {
                    // Get.toNamed(Routes.pendingEventDetails,
                    //     arguments: {
                    //       "notInterestedBtn": 2,
                    //       "title": "About Event"
                    //     }
                    // );
                    Get.toNamed(Routes.upcomingScreen, arguments: {
                      "notInterestedBtn": 2,
                      "appBarTitle": "About Event"
                      // "reportedEventView": 1
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/grayClor.png"),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "90’s Grunge and Bowling",
                              style: poppinsMediumStyle(
                                fontSize: 16,
                                context: context,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          eventDateTime(
                              context: context,
                              iconBgClr: DynamicColor.darkGrayClr,
                              theme: theme,
                              iconClr: DynamicColor.darkYellowClr,
                              iconSize: 17,
                              textClr: DynamicColor.lightRedClr,
                              widths: Get.width / 1.4),
                          SizedBox(
                            height: 4,
                          ),
                          eventDateTime(
                              context: context,
                              iconBgClr: DynamicColor.darkGrayClr,
                              theme: theme,
                              iconClr: DynamicColor.darkYellowClr,
                              img: "assets/calender.png",
                              iconSize: 17,
                              text: "Saturday, June 17th of 2023",
                              textClr: DynamicColor.lightRedClr,
                              widths: Get.width / 1.4),
                          SizedBox(
                            height: 4,
                          ),
                          eventDateTime(

                              context: context,
                              iconBgClr: DynamicColor.darkGrayClr,
                              theme: theme,
                              iconClr: DynamicColor.darkYellowClr,
                              img: "assets/calender.png",
                              icon: true,
                              iconSize: 17,
                              text: "Herkimer County Fairgrounds",
                              textClr: DynamicColor.lightRedClr,
                              widths: Get.width / 1.4),
                          Divider(
                            thickness: 2,
                            color: DynamicColor.avatarBgClr,
                          ),
                          ourGuestWidget(
                            isDelete: null,
                              context: context,
                              theme: theme,
                              bgClr: Colors.transparent,
                              horizontalPadding: 0,
                              iconShow: true,
                              verticalPadding: 0,
                              followPadding: 6),
                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
