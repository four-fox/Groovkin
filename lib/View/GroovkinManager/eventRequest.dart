import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:intl/intl.dart';

import '../../Routes/app_pages.dart';

class EventRequests extends StatefulWidget {
  const EventRequests({super.key});

  @override
  State<EventRequests> createState() => _EventRequestsState();
}

class _EventRequestsState extends State<EventRequests> {
  late EventController _eventController;
  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<EventController>()) {
      _eventController = Get.find<EventController>();
    } else {
      _eventController = Get.put(EventController());
    }
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Request", backArrow: false),
      body: GetBuilder<EventController>(initState: (controller) {
        _eventController.getAllEvents();
      }, builder: (controller) {
        return _eventController.getAllEventsLoader.value == false
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                    itemCount: controller.allEvents!.data!.data.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, index) {
                      final data = controller.allEvents!.data!.data[index];

                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.upcomingScreen, arguments: {
                            "notInterestedBtn": 2,
                            "appBarTitle": "About Event",
                            "eventId": data.id ?? 1,
                            // "reportedEventView": 1
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage("assets/grayClor.png"),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    data.eventTitle ?? "",
                                    style: poppinsMediumStyle(
                                      fontSize: 16,
                                      context: context,
                                      color: theme.cardColor,
                                    ),
                                  ),
                                ),
                                if (data.startDateTime != null ||
                                    data.endDateTime != null)
                                  eventDateTime(
                                    text:
                                        "${DateFormat.jm().format(data.startDateTime!)} to ${DateFormat.jm().format(data.endDateTime!)}",
                                    context: context,
                                    iconBgClr: DynamicColor.darkGrayClr,
                                    theme: theme,
                                    iconClr: DynamicColor.darkYellowClr,
                                    iconSize: 17,
                                    textClr: DynamicColor.lightRedClr,
                                    widths: Get.width / 1.4,
                                  ),
                                const SizedBox(
                                  height: 4,
                                ),
                                if (data.startDateTime != null)
                                  eventDateTime(
                                      context: context,
                                      iconBgClr: DynamicColor.darkGrayClr,
                                      theme: theme,
                                      iconClr: DynamicColor.darkYellowClr,
                                      img: "assets/calender.png",
                                      iconSize: 17,
                                      text: DateFormat.yMMMMEEEEd()
                                          .format(data.startDateTime!),
                                      textClr: DynamicColor.lightRedClr,
                                      widths: Get.width / 1.4),
                                const SizedBox(
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
                                    text: data.location ?? "",
                                    textClr: DynamicColor.lightRedClr,
                                    widths: Get.width / 1.4),
                                Divider(
                                  thickness: 2,
                                  color: DynamicColor.avatarBgClr,
                                ),
                                // ourGuestWidget(
                                //   isDelete: data.user!.deleteAt == null
                                //       ? false
                                //       : true,
                                //   horizontalPadding: 12,
                                //   networkImg: groupPlaceholder,
                                //   venueOwner: data.user?.name ?? "",
                                //   context: context,
                                //   theme: theme,
                                //   bgClr: Colors.transparent,
                                //   rowPadding: 0.0,
                                //   avatarPadding: 6,
                                //   rowVerticalPadding: 0.0,
                                //   followText: controller.eventDetail!.data!
                                //               .user!.following ==
                                //           null
                                //       ? "Follow"
                                //       : "Unfollow",
                                //   followBgClr: controller.eventDetail!.data!
                                //               .user!.following !=
                                //           null
                                //       ? theme.primaryColor
                                //       : DynamicColor.avatarBgClr,
                                //   textClr: controller.eventDetail!.data!.user!
                                //               .following ==
                                //           null
                                //       ? theme.primaryColor
                                //       : theme.scaffoldBackgroundColor,
                                //   followOnTap: () {
                                //     if (controller.eventDetail!.data!.user!
                                //             .following ==
                                //         null) {
                                //       _authController.followUser(
                                //           userData: controller
                                //               .eventDetail!.data!.user,
                                //           fromAllUser: false);
                                //     } else {
                                //       _authController.unfollow(
                                //           userData: controller
                                //               .eventDetail!.data!.user,
                                //           fromAllUser: false);
                                //     }
                                //   },
                                // ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }));
      }),
    );
  }
}
