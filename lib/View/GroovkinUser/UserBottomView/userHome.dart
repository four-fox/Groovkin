// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_final_fields, prefer_null_aware_operators

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/customEventWidget.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:groovkin/Components/searchRadiusSelector.dart';
import 'package:groovkin/Components/zipCodeShortcut.dart';
import 'package:groovkin/discovery/discovery_config.dart';
import 'package:groovkin/discovery/discovery_contract.dart';
import 'package:groovkin/discovery/discovery_widgets.dart';
import 'package:groovkin/utils/search_radius.dart';
import 'package:intl/intl.dart';

import '../../bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  RxBool recommendedVal = false.obs;

  RxBool topRatedVal = false.obs;

  RxBool ongoingVal = false.obs;

  late HomeController _controller;
  late EventController _eventController;
  late AuthController _authController;
  late ManagerController _managerController;

  @override
  void initState() {
    if (Get.isRegistered<HomeController>()) {
      _controller = Get.find<HomeController>();
      _controller.nearbyVal.value = false;
      _controller.update();
    } else {
      _controller = Get.put(HomeController());
    }

    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }

    if (Get.isRegistered<ManagerController>()) {
      _managerController = Get.find<ManagerController>();
    } else {
      _managerController = Get.put(ManagerController());
    }

    if (Get.isRegistered<EventController>()) {
      _eventController = Get.find<EventController>();
    } else {
      _eventController = Get.put(EventController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.toNamed(Routes.viewAllEventListScreen);
        },
        child: Container(
          height: 35,
          width: 90,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              // color: Colors.amberAccent
              border: Border.all(
                color: theme.primaryColor,
              ),
              color: DynamicColor.darkGrayClr,
              borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text(
              "View All",
              style: poppinsMediumStyle(
                fontSize: 14,
                context: context,
                color: theme.primaryColor,
              ),
            ),
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight * 2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 38,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Welcome to Groovkin",
                    style: poppinsMediumStyle(
                      fontSize: 16,
                      context: context,
                      color: DynamicColor.lightYellowClr,
                    ),
                  ),
                ),
                const ZipCodeShortcut(compact: true),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.notificationScreen);
                  },
                  child: Icon(
                    Icons.notification_important,
                    color: theme.primaryColor,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Get.width / 1.3,
                  child: SearchTextFields(
                    controller: TextEditingController(),
                    readOnly: true,
                    onTap: () {
                      Get.toNamed(Routes.viewAllEventListScreen,
                          arguments: {"searchFieldShow": true});
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.searchFilterScreen);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: DynamicColor.grayClr.withValues(alpha: 0.6)),
                        borderRadius: BorderRadius.circular(8)),
                    child: ImageIcon(
                      const AssetImage("assets/filterIcon.png"),
                      color: DynamicColor.grayClr,
                    ),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
      body: GetBuilder<HomeController>(builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            await controller.invalidateRecommendations();
            await controller.getEventNearByMe();
            await controller.getTopRatedEvent();
            await controller.getOngoingEventUser();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GestureDetector(
                //   onTap: () {
                //     Get.toNamed(Routes.userMyGroovkinScreen);
                //   },
                //   child: Container(
                //     height: kToolbarHeight * 2,
                //     width: double.infinity,
                //     decoration: const BoxDecoration(
                //         image: DecorationImage(
                //       image: AssetImage("assets/myGroovkin.png"),
                //       fit: BoxFit.fill,
                //     )),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Text(
                //           "My Groovkin",
                //           style: poppinsMediumStyle(
                //             fontSize: 17,
                //             fontWeight: FontWeight.w700,
                //             context: context,
                //             latterSpacing: 1.1,
                //             color: theme.primaryColor,
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.only(top: 12.0),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               CircleAvatar(
                //                 backgroundColor:
                //                     DynamicColor.yellowClr.withValues(alpha: 0.7),
                //                 child: ImageIcon(
                //                   const AssetImage("assets/groupIcons.png"),
                //                   color: theme.primaryColor,
                //                 ),
                //               ),
                //               Padding(
                //                 padding:
                //                     const EdgeInsets.symmetric(horizontal: 30.0),
                //                 child: CircleAvatar(
                //                   backgroundColor: DynamicColor.yellowClr
                //                       .withValues(alpha: 0.7),
                //                   child: ImageIcon(
                //                     const AssetImage("assets/musicIcons.png"),
                //                     color: theme.primaryColor,
                //                   ),
                //                 ),
                //               ),
                //               CircleAvatar(
                //                 backgroundColor:
                //                     DynamicColor.yellowClr.withValues(alpha: 0.7),
                //                 child: ImageIcon(
                //                   const AssetImage("assets/supportIcon.png"),
                //                   color: theme.primaryColor,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),

                const SizedBox(
                  height: 10,
                ),
// Recommended Event
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: DynamicColor.darkGrayClr),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recommended for you",
                              style: poppinsMediumStyle(
                                fontSize: 14,
                                context: context,
                                color: theme.primaryColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (recommendedVal.value == false) {
                                  controller.getRecommended();
                                  recommendedVal.value = true;
                                } else {
                                  recommendedVal.value = false;
                                  controller.update();
                                }
                              },
                              child: Icon(
                                recommendedVal.value == false
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up_outlined,
                                size: 35,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        if (recommendedVal.value)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SearchRadiusSelector(
                                  selected: controller.recommendedRadius,
                                  options: controller.allowedSearchRadii,
                                  onSelected: controller.setRecommendationRadius,
                                ),
                                if (DiscoveryConfig.compileTime.enabled &&
                                    controller.radiusPendingSave)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      'Showing this radius for now. It was not saved to your profile.',
                                      style: poppinsRegularStyle(
                                        fontSize: 12,
                                        context: context,
                                        color: DynamicColor.grayClr,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        controller.getRecommendedLoader.value == false
                            ? DiscoveryConfig.compileTime.enabled
                                ? const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : const SizedBox.shrink()
                            : Visibility(
                                visible: recommendedVal.value,
                                child: controller.recommendedEventData ==
                                            null ||
                                        controller.recommendedEventData!.data!
                                            .data!.isEmpty
                                    ? DiscoveryConfig.compileTime.enabled
                                        ? DiscoveryFeedNotice(
                                            message: controller
                                                    .discoveryRecommendationNotice ??
                                                recommendationEmptyMessage(
                                                  locationStatus: controller
                                                      .recommendationLocationStatus,
                                                  locationDenied: false,
                                                ),
                                            actionLabel: controller
                                                    .discoveryRecommendationCanRetry
                                                ? 'Try again'
                                                : controller
                                                        .discoveryRecommendationNeedsLocation
                                                    ? 'Use my location'
                                                    : null,
                                            onAction: controller
                                                        .discoveryRecommendationCanRetry ||
                                                    controller
                                                        .discoveryRecommendationNeedsLocation
                                                ? controller
                                                    .onDiscoveryRecommendationAction
                                                : null,
                                          )
                                        : noData(theme: theme, context: context)
                                    : Column(
                                        children: [
                                          ListView.builder(
                                              itemCount: controller
                                                          .recommendedEventData!
                                                          .data!
                                                          .data!
                                                          .length >
                                                      4
                                                  ? 4
                                                  : controller
                                                      .recommendedEventData!
                                                      .data!
                                                      .data!
                                                      .length,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                EventData singleEventData =
                                                    controller
                                                        .recommendedEventData!
                                                        .data!
                                                        .data![index];
                                                final cardCopy =
                                                    DiscoveryCardCopy.fromEvent(
                                                        singleEventData);
                                                final start = singleEventData
                                                    .startDateTime;
                                                return userCustomEvent(
                                                    isDelete: singleEventData
                                                                .user?.isDelete ==
                                                            null
                                                        ? false
                                                        : true,
                                                    dayy: start == null
                                                        ? ''
                                                        : DateFormat.MMM()
                                                            .format(start),
                                                    datee: start == null
                                                        ? ''
                                                        : "${start.day}\n",
                                                    networkImg: singleEventData
                                                                .bannerImage ==
                                                            null
                                                        ? false
                                                        : true,
                                                    img: singleEventData
                                                                .bannerImage ==
                                                            null
                                                        ? null
                                                        : singleEventData
                                                            .bannerImage!
                                                            .mediaPath
                                                            .toString(),
                                                    title:
                                                        singleEventData.eventTitle
                                                            .toString(),
                                                    location: singleEventData
                                                        .location,
                                                    subtitle: singleEventData
                                                            .venue?.venueName ??
                                                        '',
                                                    recommendationText: cardCopy
                                                            .reasons ??
                                                        singleEventData
                                                            .recommendation
                                                            ?.displayReason,
                                                    badgeText: cardCopy.badge,
                                                    distanceText:
                                                        cardCopy.distance,
                                                    onTap: () {
                                                      Get.toNamed(
                                                          Routes
                                                              .userEventDetailsScreen,
                                                          arguments: {
                                                            "notify": true,
                                                            "notifyBackBtn":
                                                                true,
                                                            'appBarTitle':
                                                                "Event Preview",
                                                            "statusText":
                                                                singleEventData
                                                                    .id
                                                                    .toString()
                                                          });
                                                    },
                                                    context: context,
                                                    theme: theme);
                                              }),
                                          CustomButton(
                                            onTap: () {
                                              Get.toNamed(
                                                  Routes
                                                      .viewAllRecommendedScreen,
                                                  arguments: {
                                                    "urlText":
                                                        "recommended-for-you-events",
                                                    "appBarText":
                                                        "All Recommended Event"
                                                  });
                                            },
                                            borderClr: Colors.transparent,
                                            text: "View All ",
                                          ),
                                        ],
                                      ),
                              ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ), // Happening Now Event
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: DynamicColor.darkGrayClr),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // "Ongoing Events",
                              "Happening Now",
                              style: poppinsMediumStyle(
                                fontSize: 14,
                                context: context,
                                color: theme.primaryColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (ongoingVal.value == false) {
                                  controller.getOngoingEventUser();
                                  ongoingVal.value = true;
                                } else {
                                  ongoingVal.value = false;
                                  controller.update();
                                }
                              },
                              child: Icon(
                                ongoingVal.value == false
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up_outlined,
                                size: 35,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        controller.userOngoingLoader.value == false
                            ? const SizedBox.shrink()
                            : Visibility(
                                visible: ongoingVal.value,
                                child: controller.userOngoing == null ||
                                        controller
                                            .userOngoing!.data!.data!.isEmpty
                                    ? noData(theme: theme, context: context)
                                    : Column(
                                        children: [
                                          ListView.builder(
                                              itemCount: controller.userOngoing!
                                                          .data!.data!.length >
                                                      4
                                                  ? 4
                                                  : controller.userOngoing!
                                                      .data!.data!.length,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                EventData singleEvent =
                                                    controller.userOngoing!
                                                        .data!.data![index];
                                                return userCustomEvent(
                                                    isDelete: singleEvent.user
                                                                ?.isDelete ==
                                                            null
                                                        ? false
                                                        : true,
                                                    dayy: DateFormat.MMM()
                                                        .format(
                                                            singleEvent
                                                                .startDateTime!),
                                                    datee:
                                                        "${singleEvent.startDateTime!.day}\n",
                                                    networkImg: singleEvent
                                                                .bannerImage ==
                                                            null
                                                        ? false
                                                        : true,
                                                    img: singleEvent
                                                                .bannerImage ==
                                                            null
                                                        ? null
                                                        : singleEvent
                                                            .bannerImage!.mediaPath
                                                            .toString(),
                                                    title: singleEvent
                                                        .eventTitle
                                                        .toString(),
                                                    location:
                                                        singleEvent.location,
                                                    subtitle: singleEvent
                                                        .venue!.venueName
                                                        .toString(),
                                                    onTap: () {
                                                      Get.toNamed(
                                                          Routes
                                                              .userEventDetailsScreen,
                                                          arguments: {
                                                            "notify": true,
                                                            "notifyBackBtn":
                                                                true,
                                                            'appBarTitle':
                                                                "Event Preview",
                                                            "statusText":
                                                                singleEvent.id
                                                                    .toString()
                                                          });
                                                    },
                                                    context: context,
                                                    theme: theme);
                                              }),
                                          CustomButton(
                                            onTap: () {
                                              Get.toNamed(
                                                  Routes
                                                      .viewAllRecommendedScreen,
                                                  arguments: {
                                                    "urlText":
                                                        "user-interested-on-going-list",
                                                    "appBarText":
                                                        "OnGoing Events"
                                                  });
                                            },
                                            borderClr: Colors.transparent,
                                            text: "View All ",
                                          ),
                                        ],
                                      ),
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Nearby Event
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: DynamicColor.darkGrayClr),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              kNearbyThisWeekLabel,
                              style: poppinsMediumStyle(
                                fontSize: 14,
                                context: context,
                                color: theme.primaryColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (controller.nearbyVal.value == false) {
                                  controller.getEventNearByMe();
                                  controller.nearbyVal.value = true;
                                } else {
                                  controller.nearbyVal.value = false;
                                  controller.update();
                                }
                              },
                              child: Icon(
                                controller.nearbyVal.value == false
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up_outlined,
                                size: 35,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        controller.getEventNearByMeLoader.value == false
                            ? const SizedBox.shrink()
                            : Visibility(
                                visible: controller.nearbyVal.value,
                                child: controller.eventNearByMe == null ||
                                        controller
                                            .eventNearByMe!.data!.data!.isEmpty
                                    ? noData(theme: theme, context: context)
                                    : Column(
                                        children: [
                                          ListView.builder(
                                              itemCount: controller
                                                          .eventNearByMe!
                                                          .data!
                                                          .data!
                                                          .length >
                                                      4
                                                  ? 4
                                                  : controller.eventNearByMe!
                                                      .data!.data!.length,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                EventData singleEvent =
                                                    controller.eventNearByMe!
                                                        .data!.data![index];
                                                return userCustomEvent(
                                                    isDelete: singleEvent.user
                                                                ?.isDelete ==
                                                            null
                                                        ? false
                                                        : true,
                                                    dayy: DateFormat.MMM()
                                                        .format(
                                                            singleEvent
                                                                .startDateTime!),
                                                    datee:
                                                        "${singleEvent.startDateTime!.day}\n",
                                                    networkImg: singleEvent
                                                                .bannerImage ==
                                                            null
                                                        ? false
                                                        : true,
                                                    img: singleEvent
                                                                .bannerImage ==
                                                            null
                                                        ? null
                                                        : singleEvent
                                                            .bannerImage!.mediaPath
                                                            .toString(),
                                                    title: singleEvent
                                                        .eventTitle
                                                        .toString(),
                                                    location:
                                                        singleEvent.location,
                                                    subtitle: singleEvent
                                                        .venue!.venueName
                                                        .toString(),
                                                    onTap: () {
                                                      Get.toNamed(
                                                          Routes
                                                              .userEventDetailsScreen,
                                                          arguments: {
                                                            "notify": true,
                                                            "notifyBackBtn":
                                                                true,
                                                            'appBarTitle':
                                                                "Event Preview",
                                                            "statusText":
                                                                singleEvent.id
                                                                    .toString()
                                                          });
                                                    },
                                                    context: context,
                                                    theme: theme);
                                              }),
                                          CustomButton(
                                            onTap: () {
                                              Get.toNamed(
                                                  Routes
                                                      .viewAllRecommendedScreen,
                                                  arguments: {
                                                    "urlText": "near-by-events",
                                                    "appBarText":
                                                        kNearbyThisWeekLabel
                                                  });
                                            },
                                            borderClr: Colors.transparent,
                                            text: "View All ",
                                          ),
                                        ],
                                      ),
                              ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                // Top Rated Event
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: DynamicColor.darkGrayClr),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Top rated",
                              style: poppinsMediumStyle(
                                fontSize: 14,
                                context: context,
                                color: theme.primaryColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (topRatedVal.value == false) {
                                  controller.getTopRatedEvent();
                                  topRatedVal.value = true;
                                } else {
                                  topRatedVal.value = false;
                                  controller.update();
                                }
                              },
                              child: Icon(
                                topRatedVal.value == false
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up_outlined,
                                size: 35,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        controller.getTopRatedEventLoader.value == false
                            ? const SizedBox.shrink()
                            : Visibility(
                                visible: topRatedVal.value,
                                child: controller.topRatingData == null ||
                                        controller
                                            .topRatingData!.data!.data!.isEmpty
                                    ? noData(theme: theme, context: context)
                                    : Column(
                                        children: [
                                          ListView.builder(
                                              itemCount: controller
                                                          .topRatingData!
                                                          .data!
                                                          .data!
                                                          .length >
                                                      4
                                                  ? 4
                                                  : controller.topRatingData!
                                                      .data!.data!.length,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                EventData singleEvent =
                                                    controller.topRatingData!
                                                        .data!.data![index];
                                                return userCustomEvent(
                                                    isDelete: singleEvent.user
                                                                ?.isDelete ==
                                                            null
                                                        ? false
                                                        : true,
                                                    dayy: DateFormat.MMM()
                                                        .format(
                                                            singleEvent
                                                                .startDateTime!),
                                                    datee:
                                                        "${singleEvent.startDateTime!.day}\n",
                                                    networkImg: singleEvent
                                                                .bannerImage ==
                                                            null
                                                        ? false
                                                        : true,
                                                    img: singleEvent
                                                                .bannerImage ==
                                                            null
                                                        ? null
                                                        : singleEvent
                                                            .bannerImage!.mediaPath
                                                            .toString(),
                                                    title: singleEvent
                                                        .eventTitle
                                                        .toString(),
                                                    location:
                                                        singleEvent.location,
                                                    subtitle: singleEvent
                                                        .venue!.venueName
                                                        .toString(),
                                                    onTap: () {
                                                      Get.toNamed(
                                                          Routes
                                                              .userEventDetailsScreen,
                                                          arguments: {
                                                            "notify": true,
                                                            "notifyBackBtn":
                                                                true,
                                                            'appBarTitle':
                                                                "Event Preview",
                                                            "statusText":
                                                                singleEvent.id
                                                                    .toString()
                                                          });
                                                    },
                                                    context: context,
                                                    theme: theme);
                                              }),
                                          CustomButton(
                                            onTap: () {
                                              Get.toNamed(
                                                  Routes
                                                      .viewAllRecommendedScreen,
                                                  arguments: {
                                                    "urlText":
                                                        "top-rated-events",
                                                    "appBarText":
                                                        "All Top Rated Event"
                                                  });
                                            },
                                            borderClr: Colors.transparent,
                                            text: "View All ",
                                          ),
                                        ],
                                      ),
                              ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                const SizedBox(
                  height: kToolbarHeight * 1.3,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  List list = [
    "assets/eventPreview.png",
    "assets/venueImg.png",
    "assets/eventPreview.png",
    "assets/venueImg.png",
    "assets/eventPreview.png",
    "assets/venueImg.png",
    "assets/eventPreview.png",
    "assets/venueImg.png",
  ];
}

class ViewAllEventListScreen extends StatefulWidget {
  const ViewAllEventListScreen({super.key});

  @override
  State<ViewAllEventListScreen> createState() => _ViewAllEventListScreenState();
}

class _ViewAllEventListScreenState extends State<ViewAllEventListScreen> {
  // EventController _eventController = Get.find<EventController>();

  late HomeController _controller;
  late EventController _eventController;
  late AuthController _authController;
  late ManagerController _managerController;
  bool searchingShow = false;

  @override
  void initState() {
    if (Get.isRegistered<HomeController>()) {
      _controller = Get.find<HomeController>();
    } else {
      _controller = Get.put(HomeController());
    }

    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }

    if (Get.isRegistered<ManagerController>()) {
      _managerController = Get.find<ManagerController>();
    } else {
      _managerController = Get.put(ManagerController());
    }

    if (Get.isRegistered<EventController>()) {
      _eventController = Get.find<EventController>();
    } else {
      _eventController = Get.put(EventController());
    }
    if (Get.arguments != null) {
      searchingShow = Get.arguments['searchFieldShow'];
    }
    super.initState();
  }

  DateTime pre_backpress = DateTime.now();

  Timer? onStoppedTyping;

  _onChangeHandler() {
    onStoppedTyping?.cancel();
    const duration = Duration(milliseconds: 800);
    onStoppedTyping = Timer(duration, () => stopTyping());
  }

  stopTyping() {
    _eventController.searchingEvent();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (_eventController.allEvents != null) {
            _eventController.allEvents!.data!.data.clear();
            _eventController.update();
          }
        } else {
          if (_eventController.allEvents != null) {
            _eventController.allEvents!.data!.data.clear();
            _eventController.update();
          }
        }
      },
      child: Scaffold(
        appBar: customAppBar(theme: theme, text: "All Events"),
        body: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            searchingShow == true
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SearchTextFields(
                      controller: _eventController.searchingController,
                      onChanged: (v) {
                        if (DiscoveryConfig.compileTime.enabled &&
                            searchingShow == true) {
                          _eventController.scheduleDiscoverySearch();
                          return;
                        }
                        if (v != "") {
                          _onChangeHandler();
                        } else {
                          _eventController.searchingController.clear();
                        }
                      },
                    ),
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: GetBuilder<EventController>(initState: (v) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (DiscoveryConfig.compileTime.enabled &&
                      searchingShow == true) {
                    _eventController.prepareDiscoverySearch();
                    return;
                  }
                  _eventController.searchingController.clear();
                  if (searchingShow == true) {
                    _eventController.searchingEvent();
                  } else {
                    _eventController.getAllEvents();
                  }
                });
              }, builder: (controller) {
                return NotificationListener<ScrollNotification>(
                  onNotification: (scroll) {
                    if (scroll.metrics.pixels ==
                        scroll.metrics.maxScrollExtent) {
                      if (controller.getAllEventWaiting == false) {
                        if (DiscoveryConfig.compileTime.enabled &&
                            searchingShow == true) {
                          if (controller.discoverySearchNextPage != null) {
                            controller.loadNextDiscoverySearch();
                            return true;
                          }
                          return false;
                        }
                        controller.getAllEventWaiting = true;
                        if (controller.allEvents!.data!.nextPageUrl != null) {
                          if (searchingShow == true) {
                            _eventController.searchingEvent(
                                nextUrl:
                                    controller.allEvents!.data!.nextPageUrl);
                          } else {
                            controller.getAllEvents(
                                nextUrl:
                                    controller.allEvents!.data!.nextPageUrl);
                          }

                          return true;
                        } else {
                          print("next Url Null");
                        }
                      }
                      return false;
                    }
                    return false;
                  },
                  child: Column(
                    children: [
                      if (DiscoveryConfig.compileTime.enabled &&
                          searchingShow == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DiscoverySearchPanel(
                            draft: controller.discoverySearch,
                            activities: controller.discoveryActivities,
                            music: controller.discoveryMusic,
                            radiusOptions: _controller.allowedSearchRadii,
                            coordinatesAvailable:
                                controller.discoveryCoordinatesAvailable,
                            postalController:
                                controller.discoveryPostalController,
                            activityController:
                                controller.discoveryActivityController,
                            musicController: controller.discoveryMusicController,
                            postalError: controller.discoveryPostalError,
                            activeSummary: discoveryActiveFilterLabels(
                              draft: controller.discoverySearch,
                              activities: controller.discoveryActivities,
                              music: controller.discoveryMusic,
                            ),
                            onSort: controller.setDiscoverySort,
                            onPostal: controller.onDiscoveryPostalChanged,
                            onToggleRadius: controller.setDiscoveryRadiusEnabled,
                            onRadius: controller.setDiscoveryRadius,
                            onToggleActivity: controller.toggleDiscoveryActivity,
                            onMusic: controller.setDiscoveryMusic,
                            onActivityText: controller.onDiscoveryActivityText,
                            onMusicText: controller.onDiscoveryMusicText,
                            onClear: controller.clearDiscoveryFilters,
                          ),
                        ),
                      if (DiscoveryConfig.compileTime.enabled &&
                          searchingShow == true &&
                          isCompleteUsZip(controller.discoverySearch.postalCode) &&
                          !controller.discoverySearch.applyRadius)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Exact ZIP match. No distance radius was applied.',
                          ),
                        ),
                      Expanded(
                        child: controller.getAllEventsLoader.value == false
                      ? DiscoveryConfig.compileTime.enabled &&
                              searchingShow == true
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink()
                      : controller.allEvents == null ||
                              controller.allEvents!.data!.data.isEmpty
                          ? DiscoveryConfig.compileTime.enabled &&
                                  searchingShow == true
                              ? DiscoveryFeedNotice(
                                  message: controller.discoverySearchError ??
                                      controller.discoveryPostalError ??
                                      (!controller.discoverySearch
                                              .hasMeaningfulFilter
                                          ? 'Search events by name, #hashtag, ZIP, activity, or music.'
                                          : searchEmptyMessage()),
                                  actionLabel:
                                      controller.discoverySearchError != null
                                          ? 'Try again'
                                          : null,
                                  onAction: controller.discoverySearchError !=
                                          null
                                      ? controller.retryDiscoverySearch
                                      : null,
                                )
                              : noData(context: context, theme: theme)
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: DynamicColor.darkGrayClr),
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    if (DiscoveryConfig.compileTime.enabled &&
                                        searchingShow == true) {
                                      await controller.retryDiscoverySearch();
                                      return;
                                    }
                                    if (searchingShow == true) {
                                      await controller.searchingEvent();
                                      return;
                                    }
                                    await controller.getAllEvents();
                                  },
                                  child: ListView.builder(
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior.onDrag,
                                    itemCount:
                                        controller.allEvents!.data!.data.length,
                                    shrinkWrap: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, index) {
                                      EventData singleEventDat = controller
                                          .allEvents!.data!.data[index];
                                      final cardCopy =
                                          DiscoveryCardCopy.fromEvent(
                                              singleEventDat);
                                      final start = singleEventDat.startDateTime;
                                      return userCustomEvent(
                                          isDelete: singleEventDat
                                                      .user?.isDelete ==
                                                  null
                                              ? false
                                              : true,
                                          dayy: start == null
                                              ? ''
                                              : DateFormat.MMM().format(start),
                                          datee: start == null
                                              ? ''
                                              : "${start.day}\n",
                                          recommendationText: cardCopy.reasons,
                                          badgeText: cardCopy.badge,
                                          distanceText: cardCopy.distance,
                                          networkImg:
                                              singleEventDat.bannerImage == null
                                                  ? false
                                                  : true,
                                          img: singleEventDat
                                                      .bannerImage ==
                                                  null
                                              ? null
                                              : singleEventDat
                                                  .bannerImage!.mediaPath
                                                  .toString(),
                                          title: singleEventDat.eventTitle
                                              .toString(),
                                          location: singleEventDat.location,
                                          subtitle: singleEventDat.venue == null
                                              ? ""
                                              : singleEventDat.venue!.venueName
                                                  .toString(),
                                          onTap: () {
                                            Get.toNamed(
                                                Routes.userEventDetailsScreen,
                                                arguments: {
                                                  "notify": true,
                                                  "notifyBackBtn": true,
                                                  'appBarTitle':
                                                      "Event Preview",
                                                  "statusText": singleEventDat
                                                      .id
                                                      .toString()
                                                });
                                          },
                                          context: context,
                                          theme: theme);
                                    }),
                                  ),
                              ),
                            ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
