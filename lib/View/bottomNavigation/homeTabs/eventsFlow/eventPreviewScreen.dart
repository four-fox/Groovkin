// ignore_for_file: prefer_final_fields


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/showCustomMap.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/commentsAndAttechment.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';

class EventPreview extends StatelessWidget {
  EventPreview({super.key});

  int upComingDetail = Get.arguments['viewDetails'] ?? 1;

  RxBool organizerFollowerVal = false.obs;
  RxBool eventVal = false.obs;

  EventController _controller = Get.find();
  ManagerController _managerController = Get.find();
  AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Event Preview", actions: [
        ((_controller.eventDetail == null) &&
                (_controller.draftCondition.value == true))
            ? GestureDetector(
                onTap: () {
                  _controller.postEventFunction(context, theme, draft: true);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.drafts),
                ),
              )
            : const SizedBox.shrink()
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _managerController.mediaClass.isNotEmpty &&
                    _controller.draftCondition.value == false
                ? SizedBox(
                    height: kToolbarHeight * 3,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: _managerController.mediaClass.isNotEmpty
                            ? _managerController.mediaClass.length
                            : _controller.imageListtt.length,
                        itemBuilder: (BuildContext context, index) {
                          print(_controller.draftCondition.value);
                          return assetImage(
                            eventController: _controller,
                            closedIcon: false,
                            controller: _controller,
                            mediaItem: _managerController.mediaClass.isNotEmpty
                                ? _managerController.mediaClass[index]
                                : _controller.imageListtt[index],
                          );
                        }),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                ((_controller.eventDetail != null) &&
                        (_controller.eventDetail!.data!.venue != null))
                    ? _controller.eventDetail!.data!.venue!.venueName!
                    : _controller.venuesDetails!.venueName.toString(),
                textAlign: TextAlign.center,
                style: poppinsMediumStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
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
                text:
                    "${_controller.proposedTimeWindowsController.text} to ${_controller.endTimeController.text}"),
            const SizedBox(
              height: 4,
            ),
            eventDateTime(
              context: context,
              iconBgClr: DynamicColor.darkGrayClr,
              theme: theme,
              iconClr: DynamicColor.darkYellowClr,
              img: "assets/calender.png",
              iconSize: 17,
              text:
                  "${_controller.eventDateController.text == _controller.eventEndDateController.text ? "" : _controller.eventDateController.text} ${_controller.eventEndDateController.text}",
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
              text: ((_controller.eventDetail != null) &&
                      (_controller.eventDetail!.data!.venue != null))
                  ? _controller.eventDetail!.data!.venue!.location!
                  : _managerController.venueDetails!.data!.location.toString(),
            ),

            /// event organizer details
            // SizedBox(
            //   height: 10,
            // ),
            // Obx(() => aboutEventCreator(theme: theme,context: context,
            //     icons:organizerFollowerVal.value?Icons.check: Icons.add,
            //     followBg: organizerFollowerVal.value? DynamicColor.grayClr:DynamicColor.avatarBgClr,
            //     textClr: organizerFollowerVal.value?theme.scaffoldBackgroundColor:theme.primaryColor,
            //     onTap: (){
            //       organizerFollowerVal.value = !organizerFollowerVal.value;
            //     }
            // ),),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Location",
                  style: poppinsMediumStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    context: context,
                    color: DynamicColor.lightRedClr,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _managerController.addressController.text,
                  style: poppinsRegularStyle(
                    fontSize: 15,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ShowCustomMap(
              lat: double.parse(((_controller.eventDetail != null) &&
                      (_controller.eventDetail!.data!.venue != null))
                  ? _controller.eventDetail!.data!.venue!.latitude!
                  : _managerController.lat),
              lng: double.parse(((_controller.eventDetail != null) &&
                      (_controller.eventDetail!.data!.venue != null))
                  ? _controller.eventDetail!.data!.venue!.longitude!
                  : _managerController.lng),
            ),
            
            // Obx(() =>    ourGuestWidget(theme: theme,context: context,rowPadding: 0.0,
            //     avatarPadding: 8,
            //     rowVerticalPadding: 0.0,
            //     icon: eventVal.value?Icons.check:Icons.add,
            //     textClr: eventVal.value?theme.scaffoldBackgroundColor:theme.primaryColor,
            //     followBgClr: eventVal.value?DynamicColor.grayClr:DynamicColor.avatarBgClr,
            //     onTap: (){
            //       eventVal.value = !eventVal.value;
            //     }
            // ),),

            customContainer(context, theme),
            customContainer(context, theme,
                title: "Featuring", text: _controller.featuringController.text),
            customContainer(context, theme,
                title: "About", text: _controller.aboutController.text),
            // customContainer(context, theme,
            //     title: "Theme of Event",
            //     text: _controller.themeOfEventController.text),
            customContainer(context, theme,
                title: "Event start time",
                text: _controller.proposedTimeWindowsController.text),
            customContainer(context, theme,
                title: "Event end time",
                text: _controller.endTimeController.text),
            customContainer(context, theme,
                title: "Hourly Rate",
                text: _controller.hourlyRateController.text),
            customContainer(context, theme,
                title: "Start Date",
                text: _controller.eventDateController.text),
            customContainer(context, theme,
                title: "End Date",
                text: _controller.eventEndDateController.text),
            // customContainer(context, theme,text: _controller.eventHoursController.text),
            // customContainer(context, theme,title: "Max capacity",text: _controller.maxCapacityController.text),
            customContainer(context, theme,
                title: "Comments", text: _controller.commentsController.text),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Services",
                  style: poppinsMediumStyle(
                    fontSize: 13,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: kToolbarHeight / 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                    itemCount: _authController.serviceList.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: DynamicColor.lightRedClr,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              _authController.serviceList[index].name
                                  .toString(),
                              style: poppinsRegularStyle(
                                fontSize: 12,
                                context: context,
                                color: theme.scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Hardware",
                  style: poppinsMediumStyle(
                    fontSize: 13,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: kToolbarHeight / 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                    itemCount: _authController.eventItemsList.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: DynamicColor.lightRedClr,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              _authController.eventItemsList[index].name
                                  .toString(),
                              style: poppinsRegularStyle(
                                fontSize: 12,
                                context: context,
                                color: theme.scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Music Genre",
                  style: poppinsMediumStyle(
                    fontSize: 13,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: kToolbarHeight / 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                    itemCount: _authController.itemsList.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: DynamicColor.lightRedClr,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              _authController.itemsList[index].name.toString(),
                              style: poppinsRegularStyle(
                                fontSize: 12,
                                context: context,
                                color: theme.scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Music Choice",
                  style: poppinsMediumStyle(
                    fontSize: 13,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: kToolbarHeight / 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                    itemCount: _controller.tagListPost.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: DynamicColor.lightRedClr,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              _controller.tagListPost[index].name.toString(),
                              style: poppinsRegularStyle(
                                fontSize: 12,
                                context: context,
                                color: theme.scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Activity Choice",
                  style: poppinsMediumStyle(
                    fontSize: 13,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: kToolbarHeight / 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                    itemCount: _controller.activityListPost.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: DynamicColor.lightRedClr,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              _controller.activityListPost[index].name
                                  .toString(),
                              style: poppinsRegularStyle(
                                fontSize: 12,
                                context: context,
                                color: theme.scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: upComingDetail == 1
          ? SafeArea(
              bottom:  true,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: CustomButton(
                  borderClr: Colors.transparent,
                  onTap: () {
                    Get.toNamed(Routes.confirmationEventScreen);
                    // Get.toNamed(Routes.commentsAndAttachment);
                  },
                  text: "Continue",
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  customContainer(context, theme, {text, title}) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
                color: DynamicColor.lightRedClr.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "Event Title",
                  style: poppinsRegularStyle(
                    fontSize: 10,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
                Text(
                  text ?? _controller.eventTitleController.text,
                  style: poppinsRegularStyle(
                    fontSize: 13,
                    context: context,
                    color: theme.scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
