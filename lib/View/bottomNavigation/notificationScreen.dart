// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:intl/intl.dart';

import '../../model/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late AuthController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AuthController>()) {
      controller = Get.find<AuthController>();
    } else {
      controller = Get.put(AuthController());
    }
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat.jm().format(dateTime); // "1:00 PM"
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        appBar: customAppBar(theme: theme, text: "Notification"),
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              if (controller.notificationModel!.data!.nextPageUrl != null) {
                if (controller.notificationWait == false) {
                  controller.notificationWait = true;
                  Future.delayed(Duration(seconds: 2), () {
                    controller.notificationWait = false;
                  });
                  controller.getAllNotification(
                      fullUrl: controller.notificationModel!.data!.nextPageUrl);
                  return true;
                }
              }
              return false;
            }
            return false;
          },
          child: GetBuilder<AuthController>(initState: (state) {
            controller.getAllNotification();
          }, builder: (controller) {
            return controller.isNotificationLoading.value
                ? SizedBox()
                : ListView.builder(
                    itemBuilder: (BuildContext context, index) {
                      final Datas data =
                          controller.notificationModel!.data!.datas![index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: notificationWidget(
                            onTap: () {
                              if (data.type == "event_following") {
                                Get.toNamed(Routes.viewProfileScreen,
                                    arguments: {
                                      "id": data.sourceId, // Pass only the ID
                                      "fromNotification": true, // Add this flag
                                    });
                              } else if (data.type == "event_accept") {
                                Get.toNamed(Routes.pendingEventDetails,
                                    arguments: {
                                      "notInterestedBtn": 1,
                                      "title": "About Event",
                                      "eventId": data.sourceId!,
                                      "type": "event",
                                    });
                              } else if (data.type == "event_created") {
                                Get.toNamed(Routes.pendingEventDetails,
                                    arguments: {
                                      "notInterestedBtn": 1,
                                      "title": "About Event",
                                      "eventId": data.sourceId!,
                                      "type": "event",
                                    });
                              }
                            },
                            theme: theme,
                            context: context,
                            text: data.notificationReceiver!.receiver!.name,
                            subtitle: data.text,
                            imageUrl: data.notificationReceiver!.receiver!
                                .profilePicture?.mediaPath,
                            time: formatDate(data
                                .notificationReceiver!.receiver!.createdAt!)),
                      );
                    },
                    itemCount:
                        controller.notificationModel!.data!.datas!.length,
                  );
          }),
        ));
  }

  Widget notificationWidget(
      {bool profileImg = true,
      context,
      theme,
      text,
      subtitle,
      time,
      String? imageUrl,
      onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage("assets/grayClor.png"), fit: BoxFit.fill),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(imageUrl ?? groupPlaceholder),
            // child: Image(
            //   image: NetworkImage(groupPlaceholder),
            // ),
          ),
          title: Text(
            text ?? 'Michael Logan',
            style: poppinsMediumStyle(
              fontSize: 14,
              context: context,
              color: theme.primaryColor,
            ),
          ),
          subtitle: Text(
            subtitle ?? 'Title here This Event hold by Venue',
            style: poppinsRegularStyle(
              fontSize: 14,
              context: context,
              color: DynamicColor.grayClr.withOpacity(0.8),
            ),
          ),
          trailing: Text(
            time ?? "1:00 PM",
            style: poppinsRegularStyle(
                fontSize: 12,
                context: context,
                color: DynamicColor.lightRedClr),
          ),
        ),
      ),
    );
  }
}
