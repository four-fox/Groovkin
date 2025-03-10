import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
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
  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<EventController>()) {
      _eventController = Get.find<EventController>();
    } else {
      _eventController = Get.put(EventController());
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
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                    itemCount: controller.allEvents!.data!.data!.length,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, index) {
                      final data = controller.allEvents!.data!.data![index];

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
                            "appBarTitle": "About Event",
                            "eventId": data.id ?? 1,
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
                                    data.eventTitle ?? "",
                                    style: poppinsMediumStyle(
                                      fontSize: 16,
                                      context: context,
                                      color: theme.primaryColor,
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
                                SizedBox(
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
                                    text: data.location ?? "",
                                    textClr: DynamicColor.lightRedClr,
                                    widths: Get.width / 1.4),
                                Divider(
                                  thickness: 2,
                                  color: DynamicColor.avatarBgClr,
                                ),
                                ourGuestWidget(
                                    isDelete: false,
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
                    }));
      }),
    );
  }
}
