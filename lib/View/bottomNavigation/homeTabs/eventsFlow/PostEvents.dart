// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/cancelEventWidget.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:groovkin/utils/utils.dart';

import '../organizerHomeModel/alleventsModel.dart';

class PendingScreen extends StatelessWidget {
  PendingScreen({super.key});

  final EventController _eventController = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<EventController>(initState: (v) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _eventController.getAllSendingRequest();
      });
    }, builder: (controller) {
      return controller.getAllSendingRequestLoader.value == false
          ? const SizedBox.shrink()
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
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, index) {
                        EventData eventData =
                            controller.allEvents!.data!.data![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                  color: DynamicColor.grayClr
                                      .withValues(alpha: 0.6)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        if (eventData.user!.deleteAt != null)
                                          Utils.accountDelete(context),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6, horizontal: 8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10)),
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
                                            eventData.bannerImage == null
                                                ? eventData.profilePicture!
                                                        .isNotEmpty
                                                    ? eventData
                                                        .profilePicture![0]
                                                        .mediaPath!
                                                    : groupPlaceholder
                                                : eventData
                                                    .bannerImage!.mediaPath
                                                    .toString()),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: CustomButton(
                                    borderClr: Colors.transparent,
                                    heights: 35,
                                    fontSized: 13,
                                    onTap: eventData.user!.deleteAt == null
                                        ? () {
                                            Get.toNamed(
                                                    Routes.pendingEventDetails,
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
                                          }
                                        : () {
                                            Utils.showToast();
                                          },
                                    text: "View Detail",
                                  ),
                                ),
                                const SizedBox(
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
                                    onTap: eventData.user!.deleteAt == null
                                        ? () {
                                            cancelEventWidget(
                                                context: context,
                                                theme: theme,
                                                onTap: () {
                                                  Get.back();
                                                  Get.toNamed(
                                                      Routes.cancelReason,
                                                      arguments: {
                                                        "eventId": eventData.id,
                                                        "doubleBack": false,
                                                      });
                                                });
                                          }
                                        : () {
                                            Utils.showToast();
                                          },
                                    color2: eventData.user!.deleteAt == null
                                        ? DynamicColor.redClr
                                        : DynamicColor.disabledColor,
                                    color1: eventData.user!.deleteAt == null
                                        ? DynamicColor.redClr
                                        : DynamicColor.disabledColor,
                                    text: "Cancel",
                                  ),
                                ),
                                const SizedBox(
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
