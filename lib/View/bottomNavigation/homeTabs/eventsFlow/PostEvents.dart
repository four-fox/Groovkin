// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/cancelEventWidget.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';

import '../organizerHomeModel/alleventsModel.dart';

class PendingScreen extends StatelessWidget {
  PendingScreen({Key? key}) : super(key: key);

  EventController _eventController = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<EventController>(initState: (v) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _eventController.getAllSendingRequest();
      });
    }, builder: (controller) {
      return controller.getAllSendingRequestLoader.value == false
          ? SizedBox.shrink()
          : controller.allEvents!.data!.data!.isEmpty
              ? Center(
                  child: Text(
                    "No Data",
                    style: poppinsMediumStyle(
                      fontSize: 16,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (scroll) {
                    if (scroll.metrics.pixels ==
                        scroll.metrics.maxScrollExtent) {
                      if (controller.requestEventWaiting == false) {
                        controller.requestEventWaiting = true;
                        if (controller.allEvents!.data!.nextPageUrl != null) {
                          controller.getAllSendingRequest(
                              nextUrl: controller.allEvents!.data!.nextPageUrl);
                          return true;
                        } else {
                          print("next Url Null");
                        }
                      }
                      return false;
                    }
                    return false;
                  },
                  child: ListView.builder(
                      itemCount: controller.allEvents!.data!.data!.length,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, index) {
                        EventData eventData =
                            controller.allEvents!.data!.data![index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                  color: DynamicColor.grayClr.withOpacity(0.6)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(6),
                                      child: ImageIcon(
                                        AssetImage("assets/pin.png"),
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 8),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          color: DynamicColor.lightBlackClr
                                          // image: DecorationImage(
                                          //     image: AssetImage("assets/topbtnGradent.png"),
                                          //     fit: BoxFit.fill
                                          // )
                                          ),
                                      child: Center(
                                        child: Text(
                                          "Pending",
                                          style: poppinsRegularStyle(
                                            fontSize: 11,
                                            context: context,
                                            color: theme.primaryColor,
                                          ),
                                        ),
                                      ),
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
                                            eventData.bannerImage == null
                                                ? eventData.profilePicture![0]
                                                    .mediaPath!
                                                : eventData
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
                                              controller.allEvents!.data!
                                                  .data![index].eventTitle!,
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
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: CustomButton(
                                    borderClr: Colors.transparent,
                                    heights: 35,
                                    fontSized: 13,
                                    onTap: () {
                                      Get.toNamed(Routes.pendingEventDetails,
                                              arguments: {
                                            "notInterestedBtn": 1,
                                            "title": "About Event",
                                            "eventId": eventData.id,
                                            "type": "event",
                                          })!
                                          .then(
                                        (value) => _eventController
                                            .getAllSendingRequest(),
                                      );
                                    },
                                    text: "View Detail",
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: CustomButton(
                                    backgroundClr: false,
                                    borderClr: Colors.transparent,
                                    heights: 35,
                                    fontSized: 13,
                                    onTap: () {
                                      cancelEventWidget(
                                          context: context,
                                          theme: theme,
                                          onTap: () {
                                            Get.back();
                                            Get.toNamed(Routes.cancelReason,
                                                arguments: {
                                                  "eventId": eventData.id,
                                                  "doubleBack": false,
                                                });
                                          });
                                    },
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
                        );
                      }),
                );
    });
  }
}
