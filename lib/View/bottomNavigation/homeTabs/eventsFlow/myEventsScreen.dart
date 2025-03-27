import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';
import 'package:groovkin/utils/utils.dart';

class MyEventsScreen extends StatelessWidget {
  MyEventsScreen({super.key});

  final HomeController _controller = Get.find();

  String pageCondition = Get.arguments['pageTitle'];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "My Events"),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels ==
              scrollNotification.metrics.maxScrollExtent) {
            if (_controller.recommendedEventData!.data!.nextPageUrl != null) {
              if (_controller.newsFeedWait == false) {
                _controller.newsFeedWait = true;
                Future.delayed(const Duration(seconds: 2), () {
                  _controller.newsFeedWait = false;
                });
                _controller.getMyAllEvent(
                  fullUrl: _controller.recommendedEventData!.data!.nextPageUrl,
                  title: pageCondition,
                );
                return true;
              }
            }
            return false;
          }
          return false;
        },
        child: GetBuilder<HomeController>(initState: (v) {
          _controller.getMyAllEvent(title: pageCondition);
        }, builder: (controller) {
          return controller.getRecommendedLoader.value == false
              ? const SizedBox.shrink()
              : controller.recommendedEventData?.data?.data?.isEmpty ?? true
                  ? noData(context: context, theme: theme)
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ListView.builder(
                          itemCount: controller
                                  .recommendedEventData?.data?.data?.length ??
                              0,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, index) {
                            log(controller
                                .recommendedEventData!.data!.data!.length
                                .toString());
                            EventData singleEventData = controller
                                .recommendedEventData!.data!.data![index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14.0),
                              child: Container(
                                // padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(
                                      color: DynamicColor.grayClr
                                          .withOpacity(0.6)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: ImageIcon(
                                            const AssetImage("assets/pin.png"),
                                            color: theme.primaryColor,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            if (singleEventData
                                                    .user!.deleteAt !=
                                                null)
                                              Utils.accountDelete(context),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/topbtnGradent.png"),
                                                    fit: BoxFit.fill),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  pageCondition == "drafts"
                                                      ? "Drafts"
                                                      : singleEventData.status
                                                          .toString(),
                                                  style: poppinsRegularStyle(
                                                    fontSize: 11,
                                                    context: context,
                                                    color: theme
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
                                                singleEventData.bannerImage ==
                                                        null
                                                    ? singleEventData
                                                            .profilePicture!
                                                            .isNotEmpty
                                                        ? singleEventData
                                                            .profilePicture![0]
                                                            .mediaPath!
                                                        : groupPlaceholder
                                                    : singleEventData
                                                        .bannerImage!.mediaPath
                                                        .toString()),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  singleEventData.eventTitle!,
                                                  style: poppinsRegularStyle(
                                                      fontSize: 12,
                                                      context: context,
                                                      color: theme.primaryColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  'Want to book for an event.',
                                                  style: poppinsRegularStyle(
                                                      fontSize: 12,
                                                      context: context,
                                                      color: DynamicColor
                                                          .lightRedClr,
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 6),
                                      child: CustomButtonWithIcon(
                                        height: 35,
                                        bgColor: DynamicColor.avatarBgClr,
                                        color2: DynamicColor.avatarBgClr
                                            .withOpacity(0.8),
                                        color1: DynamicColor.avatarBgClr
                                            .withOpacity(0.8),
                                        iconValue: false,
                                        style: poppinsRegularStyle(
                                          fontSize: 13,
                                          context: context,
                                          color: theme.primaryColor,
                                        ),
                                        onTap: singleEventData.user!.deleteAt ==
                                                null
                                            ? () {
                                                Get.toNamed(
                                                    Routes.upcomingScreen,
                                                    arguments: {
                                                      "eventId":
                                                          singleEventData.id,
                                                      "reportedEventView": 1,
                                                      "notInterestedBtn": 1,
                                                      "appBarTitle":
                                                          pageCondition ==
                                                                  "drafts"
                                                              ? "Drafts"
                                                              : singleEventData
                                                                  .status
                                                                  .toString()
                                                                  .capitalize
                                                    });
                                              }
                                            : () {
                                                Utils.showToast();
                                              },
                                        text: "View Details",
                                      ),
                                    ),
                                    controller.selectedFilter.value == 4
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
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
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
        }),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            onTap: () {
              EventController eventController = Get.find();
              eventController.eventDetail = null;
              eventController.clearFields();
              Get.toNamed(Routes.upGradeEvents);
            },
            borderClr: Colors.transparent,
            text: "Create new event",
          ),
        ),
      ),
    );
  }
}
