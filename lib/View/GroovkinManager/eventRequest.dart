import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/main.dart';
import 'package:groovkin/utils/backend_contract.dart';
import 'package:intl/intl.dart';

import '../../Routes/app_pages.dart';

class EventRequests extends StatefulWidget {
  const EventRequests({super.key});

  @override
  State<EventRequests> createState() => _EventRequestsState();
}

class _EventRequestsState extends State<EventRequests>
    with WidgetsBindingObserver {
  late AuthController _authController;
  late ManagerController _managerController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }
    _managerController = Get.isRegistered<ManagerController>()
        ? Get.find<ManagerController>()
        : Get.put(ManagerController());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _managerController.getScheduledEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "My Events", backArrow: false),
      body: GetBuilder<ManagerController>(initState: (controller) {
        _managerController.getScheduledEvents();
      }, builder: (controller) {
        if (controller.scheduledLoader.value == false) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.scheduledError != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.scheduledError!,
                    textAlign: TextAlign.center,
                    style: poppinsMediumStyle(
                      fontSize: 14,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: controller.getScheduledEvents,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        final events = retainServerEventBucket(
          controller.scheduledEvents?.data?.data ?? [],
        );
        if (events.isEmpty) {
          return noData(theme: theme);
        }
        return RefreshIndicator(
          onRefresh: () async => controller.getScheduledEvents(),
          child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                        itemCount: events.length,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, index) {
                          final data = events[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                // Get.toNamed(Routes.pendingEventDetails,
                                //     arguments: {
                                //       "notInterestedBtn": 2,
                                //       "title": "About Event"
                                //     }
                                // );
                                Get.toNamed(Routes.upcomingScreen, arguments: {
                                  "notInterestedBtn": 2,
                                  "appBarTitle": "About Event",
                                  "eventId": data.id ?? 1,
                                  // "isFromEventRequestPage": true,
                                  // "reportedEventView": 1
                                });
                              },
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
                                          color: isDark(context)
                                              ? theme.primaryColor
                                              : DynamicColor.whiteClr,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        venueMyEventStatusLabel(
                                          status: data.status,
                                          start: data.startDateTime,
                                          end: data.endDateTime,
                                        ),
                                        style: poppinsMediumStyle(
                                          fontSize: 12,
                                          context: context,
                                          color: DynamicColor.lightYellowClr,
                                        ),
                                      ),
                                    ),
                                    if (data.startDateTime != null &&
                                        data.endDateTime != null)
                                      eventDateTime(
                                        text:
                                            "${DateFormat('HH:mm').format(data.startDateTime!)} to ${DateFormat('HH:mm').format(data.endDateTime!)}",
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
                                        widths: Get.width / 1.4,
                                      ),
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
                                      widths: Get.width / 1.4,
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: DynamicColor.avatarBgClr,
                                    ),
                                    if (data.user == null)
                                      const SizedBox.shrink()
                                    else
                                    GetBuilder<AuthController>(
                                        builder: (contr) {
                                      return ourGuestWidget(
                                        isDelete: data.user!.isDelete == null
                                            ? false
                                            : true,
                                        horizontalPadding: 12,
                                        networkImg:
                                            data.user!.profilePicture == null
                                                ? groupPlaceholder
                                                : data.user!.profilePicture!
                                                    .mediaPath,
                                        venueOwner: data.user?.name ?? "",
                                        context: context,
                                        theme: theme,
                                        bgClr: Colors.transparent,
                                        rowPadding: 0.0,
                                        avatarPadding: 6,
                                        rowVerticalPadding: 0.0,
                                        followBgClr:
                                            data.user!.following != null
                                                ? theme.primaryColor
                                                : DynamicColor.avatarBgClr,
                                        followText: data.user!.following == null
                                            ? "Follow"
                                            : "Unfollow",
                                        textClr: data.user!.following == null
                                            ? isDark(context)
                                                ? theme.primaryColor
                                                : DynamicColor.whiteClr
                                            : theme.scaffoldBackgroundColor,
                                        followOnTap: () {
                                          if (data.user!.following == null) {
                                            _authController.followUser(
                                              userData: data.user,
                                              fromAllUser: false,
                                              fromRequestEvent: true,
                                              eventListModel:
                                                  controller.scheduledEvents,
                                            );
                                          } else {
                                            _authController.unfollow(
                                              userData: data.user,
                                              fromAllUser: false,
                                              fromRequestEvent: true,
                                              eventListModel:
                                                  controller.scheduledEvents,
                                            );

                                            // _eventController.getAllEvents();
                                          }
                                          _authController.update();
                                          controller.update();
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                ),
        );
      }),
    );
  }
}
