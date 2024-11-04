// ignore_for_file: prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';
import 'package:groovkin/utils/utils.dart';

class PostEvents extends StatelessWidget {
  final HomeController _controller = Get.find();

  PostEvents({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<HomeController>(initState: (v) {
      _controller.completedEvent();
    }, builder: (controller) {
      return controller.completedEventLoader.value == false
          ? SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.all(8.0),
              child: controller.eventHistory!.data!.data!.isEmpty
                  ? noData(theme: theme, context: context)
                  : ListView.builder(
                      // itemCount: 2,
                      itemCount: controller.eventHistory!.data!.data!.length,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, index) {
                        EventData singleEvent =
                            controller.eventHistory!.data!.data![index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 14.0),
                          child: Container(
                            // padding: EdgeInsets.all(6),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                  color: DynamicColor.grayClr.withOpacity(0.6)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(6),
                                      child: ImageIcon(
                                        AssetImage("assets/pin.png"),
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        if (singleEvent.user!.deleteAt != null)
                                          Utils.accountDelete(context),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                              image: controller.selectedFilter
                                                          .value !=
                                                      4
                                                  ? DecorationImage(
                                                      image: AssetImage(
                                                          "assets/topbtnGradent.png"),
                                                      fit: BoxFit.fill,
                                                    )
                                                  : null,
                                              color: controller.selectedFilter
                                                          .value ==
                                                      4
                                                  ? DynamicColor.redClr
                                                  : Colors.transparent),
                                          child: Center(
                                            child: Text(
                                              "Completed",
                                              style: poppinsRegularStyle(
                                                fontSize: 11,
                                                context: context,
                                                color: controller.selectedFilter
                                                            .value ==
                                                        4
                                                    ? theme.primaryColor
                                                    : theme
                                                        .scaffoldBackgroundColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundImage: NetworkImage(
                                            singleEvent.bannerImage == null
                                                ? singleEvent.profilePicture![0]
                                                    .mediaPath!
                                                : singleEvent
                                                    .bannerImage!.mediaPath
                                                    .toString()),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              singleEvent.eventTitle!,
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
                                                  color:
                                                      DynamicColor.lightRedClr,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // venueBookingUser(
                                // ,theme: theme,context: context),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 6),
                                  child: CustomButtonWithIcon(
                                    height: 35,
                                    bgColor: DynamicColor.avatarBgClr,
                                    iconValue: false,
                                    style: poppinsRegularStyle(
                                      fontSize: 13,
                                      context: context,
                                      color: theme.primaryColor,
                                    ),
                                    onTap: singleEvent.user!.deleteAt == null
                                        ? () {
                                            Get.toNamed(Routes.upcomingScreen,
                                                    arguments: {
                                                  "eventId": singleEvent.id,
                                                  "reportedEventView": 1,
                                                  "notInterestedBtn": 1,
                                                  "appBarTitle": "Completed"
                                                  // "${singleEvent.status.toString().capitalize} Event"
                                                })!
                                                .then(
                                              (value) =>
                                                  _controller.completedEvent(),
                                            );
                                            // Get.toNamed(Routes.pendingEventDetails,
                                            //     arguments: {
                                            //       "eventId": singleEvent.id,
                                            //       "notInterestedBtn": 0,
                                            //       "title": "Event Completed"
                                            //     }
                                            // );

                                            ///asdasd
                                            //    Get.toNamed(Routes.aboutEventScreen,
                                            //    arguments: {
                                            //      "imageShow": true,
                                            //      "upcomingOrganizer": controller.eventStatus!.value,
                                            //    }
                                            //    );
                                          }
                                        : () {
                                            Utils.showToast();
                                          },
                                    text: "View Details",
                                  ),
                                ),
                                controller.selectedFilter.value == 4
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 3),
                                        child: CustomButton(
                                          heights: 35,
                                          backgroundClr: false,
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
                        );
                      }),
            );
    });
  }

  Widget reviewWidget({theme, context}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            "How was your experience with\nMark Anderson",
            textAlign: TextAlign.center,
            style: poppinsMediumStyle(
                fontSize: 18,
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
                context: context),
          ),
          RatingBarIndicator(
            rating: 2.75,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            unratedColor: DynamicColor.grayClr,
            itemCount: 5,
            itemSize: 25.0,
            direction: Axis.horizontal,
          ),
          CustomTextFieldsHintText(
              maxLine: 4,
              controller: TextEditingController(),
              hintText: "Additional Comments",
              borderClr: DynamicColor.lightWhite),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                heights: 35,
                widths: Get.width / 3,
                backgroundClr: false,
                borderClr: DynamicColor.lightWhite,
                color2: Colors.transparent,
                color1: Colors.transparent,
                text: "Not now",
                onTap: () {
                  Get.back();
                },
              ),
              CustomButton(
                heights: 35,
                widths: Get.width / 3,
                borderClr: Colors.transparent,
                text: "Submit",
                onTap: () {
                  Get.back();
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
                                border: Border.all(
                                  color: theme.primaryColor,
                                )),
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
                                      "Thank you For Review",
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
              ),
            ],
          )
        ],
      ),
    );
  }
}
