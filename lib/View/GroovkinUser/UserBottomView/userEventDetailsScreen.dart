import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/showCustomMap.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:intl/intl.dart';

class UserEventDetailsScreen extends StatefulWidget {
  const UserEventDetailsScreen({super.key});

  @override
  State<UserEventDetailsScreen> createState() => _UserEventDetailsScreenState();
}

class _UserEventDetailsScreenState extends State<UserEventDetailsScreen> {
  bool notifyBtnShow = Get.arguments['notify'];

  bool notifyBackBtn = Get.arguments['notifyBackBtn'] ?? false;

  String? appBarTitle = Get.arguments['appBarTitle'];

  bool? isCancel = Get.arguments["isCancel"] ?? false;

  RxBool followBgClr = false.obs;

  String statusVal = Get.arguments['statusText'];

  EventController _controller = Get.find();

  late AuthController _authController;

  @override
  void initState() {
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: customAppBar(text: appBarTitle, theme: theme),
        body: GetBuilder<EventController>(initState: (v) {
          _controller.eventDetails(eventId: statusVal);
        }, builder: (controller) {
          return controller.eventDetailsLoader.value == false
              ? const SizedBox.shrink()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          controller.eventDetail!.data!.profilePicture!.isEmpty
                              ? const SizedBox.shrink()
                              : SizedBox(
                                  height: kToolbarHeight * 3,
                                  width: Get.width,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: controller.eventDetail!.data!
                                          .profilePicture!.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Container(
                                            width: controller
                                                        .eventDetail!
                                                        .data!
                                                        .profilePicture!
                                                        .length ==
                                                    1
                                                ? Get.width
                                                : Get.width / 1.5,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: theme.primaryColor,
                                                ),
                                                image: DecorationImage(
                                                  image: controller
                                                              .eventDetail!
                                                              .data!
                                                              .profilePicture![
                                                                  index]
                                                              .mediaPath
                                                              .toString()
                                                              .split(".")
                                                              .last !=
                                                          "mp4"
                                                      ? NetworkImage(controller
                                                                  .eventDetail!
                                                                  .data !=
                                                              null
                                                          ? controller
                                                              .eventDetail!
                                                              .data!
                                                              .profilePicture![
                                                                  index]
                                                              .mediaPath
                                                              .toString()
                                                          : 'assets/eventPreview.png')
                                                      : NetworkImage(controller
                                                          .eventDetail!
                                                          .data!
                                                          .profilePicture![
                                                              index]
                                                          .mediaPath
                                                          .toString()),
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                        );
                                      }),
                                ),
                          // notifyBtnShow == true
                          //     ? Padding(
                          //         padding: const EdgeInsets.only(
                          //             right: 8, left: 8, bottom: 8),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.end,
                          //           children: [
                          //             controller.eventDetail!.data!.status ==
                          //                     "completed"
                          //                 ? const SizedBox.shrink()
                          //                 : Align(
                          //                     alignment: Alignment.bottomRight,
                          //                     child: CustomButton(
                          //                       text: "Notify",
                          //                       heights: 30,
                          //                       borderRadius: 4,
                          //                       borderClr: Colors.transparent,
                          //                       widths: 80,
                          //                       onTap: () {
                          //                         if (sp.read("role") == 'User') {
                          //                           if (notifyBackBtn == true) {
                          //                             Get.toNamed(
                          //                                 Routes.notifyScreen);
                          //                             // selectUserIndexxx.value = 2;
                          //                             // Get.back();
                          //                           } else {
                          //                             Get.back();
                          //                             Get.back();
                          //                             // Get.toNamed(Routes.groupScreen);
                          //                           }
                          //                         } else {
                          //                           Get.offAllNamed(Routes
                          //                               .userBottomNavigationNav);
                          //                         }
                          //                       },
                          //                     ),
                          //                   ),
                          //             const SizedBox(
                          //               width: 10,
                          //             ),
                          //             CustomButtonWithIcon(
                          //               width: 130,
                          //               height: 30,
                          //               borderRadius: 6,
                          //               iconss: Icons.share,
                          //               iconsClr: DynamicColor.whiteClr,
                          //               iconValue: false,
                          //               iconRightSide: true,
                          //               bgColor: DynamicColor.secondaryClr,
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          //     : Padding(
                          //         padding: const EdgeInsets.only(
                          //             right: 8, left: 8, bottom: 8),
                          //         child: Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             CustomButton(
                          //               text: statusVal,
                          //               heights: 25,
                          //               borderRadius: 4,
                          //               backgroundClr: false,
                          //               borderClr: Colors.transparent,
                          //               color2: DynamicColor.finishedTextClr,
                          //               color1: DynamicColor.finishedTextClr,
                          //               style: poppinsRegularStyle(
                          //                 fontSize: 12,
                          //                 context: context,
                          //                 color: theme.primaryColor,
                          //               ),
                          //               widths: 80,
                          //               onTap: () {},
                          //             ),
                          //             CustomButtonWithIcon(
                          //               width: 130,
                          //               height: 25,
                          //               borderRadius: 6,
                          //               iconss: Icons.share,
                          //               iconsClr: DynamicColor.whiteClr,
                          //               iconValue: false,
                          //               iconRightSide: true,
                          //               bgColor: DynamicColor.secondaryClr,
                          //               iconSize: 15,
                          //               style: poppinsRegularStyle(
                          //                 fontSize: 12,
                          //                 context: context,
                          //                 color: theme.primaryColor,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10, left: 12),
                          child: Text(
                            controller.eventDetail!.data!.eventTitle.toString(),
                            style: poppinsMediumStyle(
                              fontSize: 21,
                              color: theme.primaryColor,
                              context: context,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      eventDateTime(
                          text:
                              "${DateFormat.jm().format(controller.eventDetail!.data!.startDateTime!)} to ${DateFormat.jm().format(controller.eventDetail!.data!.endDateTime!)}",
                          theme: theme,
                          context: context,
                          iconClr: DynamicColor.yellowClr),
                      const SizedBox(
                        height: 10,
                      ),
                      eventDateTime(
                          theme: theme,
                          context: context,
                          img: "assets/calender.png",
                          text:
                              "${DateFormat.yMMMMEEEEd().format(controller.eventDetail!.data!.startDateTime!)}",
                          iconClr: DynamicColor.yellowClr),
                      const SizedBox(
                        height: 10,
                      ),

                      eventDateTime(
                          theme: theme,
                          context: context,
                          icon: true,
                          text:
                              "${controller.eventDetail!.data!.location ?? "N/N"}",
                          iconClr: DynamicColor.yellowClr),
                      customWidget(context, theme,
                          title: "Event Comments",
                          value:
                              controller.eventDetail!.data!.comment.toString()),
                      customWidget(context, theme,
                          title: "Event About",
                          value:
                              controller.eventDetail!.data!.about.toString()),
                      if (controller.eventDetail!.data!.themeOfEvent
                              .toString()
                              .toLowerCase() !=
                          "null")
                        customWidget(context, theme,
                            title: "Event theme",
                            value: controller.eventDetail!.data!.themeOfEvent
                                .toString()),
                      customWidget(context, theme,
                          title: "Featuring",
                          value: controller.eventDetail!.data!.featuring
                              .toString()),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 12.0, vertical: 10),
                      //   child: Container(
                      //     width: double.infinity,
                      //     padding: const EdgeInsets.symmetric(
                      //         vertical: 10, horizontal: 10),
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         color: DynamicColor.darkGrayClr),
                      //     child: Column(
                      //       children: [
                      //         Align(
                      //           alignment: Alignment.topLeft,
                      //           child: Text(
                      //             "Service",
                      //             style: poppinsRegularStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w600,
                      //               context: context,
                      //               color: theme.primaryColor,
                      //             ),
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           height: kToolbarHeight,
                      //           child: Align(
                      //             alignment: Alignment.topLeft,
                      //             child: ListView.builder(
                      //                 shrinkWrap: true,
                      //                 scrollDirection: Axis.horizontal,
                      //                 // physics: NeverScrollableScrollPhysics(),
                      //                 itemCount: controller
                      //                     .eventDetail!.data!.services!.length,
                      //                 itemBuilder:
                      //                     (BuildContext context, indx) {
                      //                   return Padding(
                      //                     padding: const EdgeInsets.symmetric(
                      //                         horizontal: 6),
                      //                     child: Chip(
                      //                       backgroundColor:
                      //                           DynamicColor.lightBlackClr,
                      //                       shape: RoundedRectangleBorder(
                      //                         borderRadius:
                      //                             BorderRadius.circular(8),
                      //                       ),
                      //                       label: Text(
                      //                         controller
                      //                             .eventDetail!
                      //                             .data!
                      //                             .services![indx]
                      //                             .eventItem!
                      //                             .name
                      //                             .toString(),
                      //                         style: poppinsRegularStyle(
                      //                           fontSize: 14,
                      //                           context: context,
                      //                           color: theme.primaryColor,
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   );
                      //                 }),
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 10,
                      //         ),
                      //         Align(
                      //           alignment: Alignment.topLeft,
                      //           child: Text(
                      //             "Hardware Provided",
                      //             style: poppinsRegularStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w600,
                      //               context: context,
                      //               color: theme.primaryColor,
                      //             ),
                      //           ),
                      //         ),
                      //         Align(
                      //           alignment: Alignment.topLeft,
                      //           child: ListView.builder(
                      //               shrinkWrap: true,
                      //               itemCount: controller.eventDetail!.data!
                      //                   .hardwareProvide!.length,
                      //               padding: EdgeInsets.zero,
                      //               physics:
                      //                   const NeverScrollableScrollPhysics(),
                      //               itemBuilder: (BuildContext context, index) {
                      //                 final filterdItem = controller
                      //                     .eventDetail!
                      //                     .data!
                      //                     .hardwareProvide![index]
                      //                     .hardwareItems!
                      //                     .where(
                      //                         (data) => data.selected == true)
                      //                     .toList();
                      //                 if (filterdItem.isEmpty)
                      //                   return SizedBox();
                      //                 return Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Row(
                      //                       children: [
                      //                         Text("${"• "}",
                      //                             style:
                      //                                 TextStyle(fontSize: 20)),
                      //                         Text(
                      //                           controller
                      //                               .eventDetail!
                      //                               .data!
                      //                               .hardwareProvide![index]
                      //                               .name
                      //                               .toString(),
                      //                           style: poppinsRegularStyle(
                      //                             fontSize: 13,
                      //                             fontWeight: FontWeight.w600,
                      //                             context: context,
                      //                             underline: true,
                      //                             color: theme.primaryColor,
                      //                           ),
                      //                         )
                      //                       ],
                      //                     ),
                      //                     SizedBox(
                      //                       height: kToolbarHeight,
                      //                       child: ListView.builder(
                      //                         shrinkWrap: true,
                      //                         scrollDirection: Axis.horizontal,
                      //                         itemBuilder: (context, index1) {
                      //                           return Padding(
                      //                             padding: const EdgeInsets
                      //                                 .symmetric(horizontal: 6),
                      //                             child: Chip(
                      //                               backgroundColor:
                      //                                   DynamicColor
                      //                                       .lightBlackClr,
                      //                               shape:
                      //                                   RoundedRectangleBorder(
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(
                      //                                         8),
                      //                               ),
                      //                               label: Text(
                      //                                 filterdItem[index1]
                      //                                     .name
                      //                                     .toString(),
                      //                                 style:
                      //                                     poppinsRegularStyle(
                      //                                   fontSize: 14,
                      //                                   context: context,
                      //                                   color:
                      //                                       theme.primaryColor,
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           );
                      //                         },
                      //                         itemCount: filterdItem.length,
                      //                       ),
                      //                     )
                      //                   ],
                      //                 );
                      //               }),
                      //         ),
                      //         Align(
                      //           alignment: Alignment.topLeft,
                      //           child: Text(
                      //             "Music Genre",
                      //             style: poppinsRegularStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w600,
                      //               context: context,
                      //               color: theme.primaryColor,
                      //             ),
                      //           ),
                      //         ),
                      //         Align(
                      //           alignment: Alignment.topLeft,
                      //           child: ListView.builder(
                      //               padding: EdgeInsets.zero,
                      //               shrinkWrap: true,
                      //               physics: NeverScrollableScrollPhysics(),
                      //               itemCount: controller
                      //                   .eventDetail!.data!.musicGenre!.length,
                      //               itemBuilder: (BuildContext context, index) {
                      //                 final filterdItem = controller
                      //                     .eventDetail!
                      //                     .data!
                      //                     .musicGenre![index]
                      //                     .musicGenreItems!
                      //                     .where(
                      //                         (data) => data.selected == true)
                      //                     .toList();
                      //                 if (filterdItem.isEmpty)
                      //                   return SizedBox();
                      //                 return Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Row(
                      //                       children: [
                      //                         Text("${"• "}",
                      //                             style:
                      //                                 TextStyle(fontSize: 20)),
                      //                         Text(
                      //                           controller.eventDetail!.data!
                      //                               .musicGenre![index].name!
                      //                               .toString(),
                      //                           style: poppinsRegularStyle(
                      //                             fontSize: 13,
                      //                             fontWeight: FontWeight.w600,
                      //                             context: context,
                      //                             underline: true,
                      //                             color: theme.primaryColor,
                      //                           ),
                      //                         )
                      //                       ],
                      //                     ),
                      //                     SizedBox(
                      //                       height: kToolbarHeight,
                      //                       child: ListView.builder(
                      //                         shrinkWrap: true,
                      //                         scrollDirection: Axis.horizontal,
                      //                         itemBuilder: (context, index1) {
                      //                           return Padding(
                      //                             padding: const EdgeInsets
                      //                                 .symmetric(horizontal: 6),
                      //                             child: Chip(
                      //                               backgroundColor:
                      //                                   DynamicColor
                      //                                       .lightBlackClr,
                      //                               shape:
                      //                                   RoundedRectangleBorder(
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(
                      //                                         8),
                      //                               ),
                      //                               label: Text(
                      //                                 filterdItem[index1]
                      //                                     .name
                      //                                     .toString(),
                      //                                 style:
                      //                                     poppinsRegularStyle(
                      //                                   fontSize: 14,
                      //                                   context: context,
                      //                                   color:
                      //                                       theme.primaryColor,
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           );
                      //                         },
                      //                         itemCount: filterdItem.length,
                      //                       ),
                      //                     )
                      //                   ],
                      //                 );
                      //               }),
                      //         ),

                      //         Align(
                      //           alignment: Alignment.topLeft,
                      //           child: Text(
                      //             "Music Choice",
                      //             style: poppinsRegularStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w600,
                      //               context: context,
                      //               color: theme.primaryColor,
                      //             ),
                      //           ),
                      //         ),
                      //         Align(
                      //           alignment: Alignment.topLeft,
                      //           child: ListView.builder(
                      //               padding: EdgeInsets.zero,
                      //               itemCount: controller.eventDetail!.data!
                      //                   .eventMusicChoiceTags!.length,
                      //               shrinkWrap: true,
                      //               physics:
                      //                   const NeverScrollableScrollPhysics(),
                      //               itemBuilder: (BuildContext context, index) {
                      //                 final filterdItem = controller
                      //                     .eventDetail!
                      //                     .data!
                      //                     .eventMusicChoiceTags![index]
                      //                     .musicChoiceItems!
                      //                     .categoryItems!
                      //                     .where((data) =>
                      //                         data.userSelection == true)
                      //                     .toList();
                      //                 if (filterdItem.isEmpty)
                      //                   return SizedBox();
                      //                 return Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Row(
                      //                       children: [
                      //                         Text("${"• "}",
                      //                             style:
                      //                                 TextStyle(fontSize: 20)),
                      //                         Text(
                      //                           controller
                      //                               .eventDetail!
                      //                               .data!
                      //                               .eventMusicChoiceTags![
                      //                                   index]
                      //                               .musicChoiceItems!
                      //                               .name
                      //                               .toString(),
                      //                           style: poppinsRegularStyle(
                      //                             fontSize: 13,
                      //                             fontWeight: FontWeight.w600,
                      //                             context: context,
                      //                             underline: true,
                      //                             color: theme.primaryColor,
                      //                           ),
                      //                         )
                      //                       ],
                      //                     ),
                      //                     SizedBox(
                      //                       height: kToolbarHeight,
                      //                       child: ListView.builder(
                      //                         shrinkWrap: true,
                      //                         scrollDirection: Axis.horizontal,
                      //                         itemBuilder: (context, index1) {
                      //                           return Padding(
                      //                             padding: const EdgeInsets
                      //                                 .symmetric(horizontal: 6),
                      //                             child: Chip(
                      //                               backgroundColor:
                      //                                   DynamicColor
                      //                                       .lightBlackClr,
                      //                               shape:
                      //                                   RoundedRectangleBorder(
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(
                      //                                         8),
                      //                               ),
                      //                               label: Text(
                      //                                 filterdItem[index1]
                      //                                     .name
                      //                                     .toString(),
                      //                                 style:
                      //                                     poppinsRegularStyle(
                      //                                   fontSize: 14,
                      //                                   context: context,
                      //                                   color:
                      //                                       theme.primaryColor,
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           );
                      //                         },
                      //                         itemCount: filterdItem.length,
                      //                       ),
                      //                     )
                      //                   ],
                      //                 );
                      //               }),
                      //         ),

                      //         // Todo Activity Choice
                      //         Align(
                      //           alignment: Alignment.topLeft,
                      //           child: Text(
                      //             "Activity Choice",
                      //             style: poppinsRegularStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w600,
                      //               context: context,
                      //               color: theme.primaryColor,
                      //             ),
                      //           ),
                      //         ),
                      //         Align(
                      //           alignment: Alignment.topLeft,
                      //           child: ListView.builder(
                      //               padding: EdgeInsets.zero,
                      //               itemCount: controller.eventDetail!.data!
                      //                   .eventActivityChoiceTags!.length,
                      //               shrinkWrap: true,
                      //               physics:
                      //                   const NeverScrollableScrollPhysics(),
                      //               itemBuilder: (BuildContext context, index) {
                      //                 final filterdItem = controller
                      //                     .eventDetail!
                      //                     .data!
                      //                     .eventActivityChoiceTags![index]
                      //                     .activityChoiceItems!
                      //                     .categoryItems!
                      //                     .where((data) =>
                      //                         data.userSelection == true)
                      //                     .toList();
                      //                 if (filterdItem.isEmpty)
                      //                   return SizedBox();
                      //                 return Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Row(
                      //                       children: [
                      //                         Text("${"• "}",
                      //                             style:
                      //                                 TextStyle(fontSize: 20)),
                      //                         Text(
                      //                           controller
                      //                               .eventDetail!
                      //                               .data!
                      //                               .eventActivityChoiceTags![
                      //                                   index]
                      //                               .activityChoiceItems!
                      //                               .name
                      //                               .toString(),
                      //                           style: poppinsRegularStyle(
                      //                             fontSize: 13,
                      //                             fontWeight: FontWeight.w600,
                      //                             context: context,
                      //                             underline: true,
                      //                             color: theme.primaryColor,
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                     SizedBox(
                      //                       height: kToolbarHeight,
                      //                       child: ListView.builder(
                      //                         padding: EdgeInsets.zero,
                      //                         scrollDirection: Axis.horizontal,
                      //                         itemBuilder: (context, index1) {
                      //                           return Padding(
                      //                             padding: const EdgeInsets
                      //                                 .symmetric(horizontal: 6),
                      //                             child: Chip(
                      //                               backgroundColor:
                      //                                   DynamicColor
                      //                                       .lightBlackClr,
                      //                               shape:
                      //                                   RoundedRectangleBorder(
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(
                      //                                         8),
                      //                               ),
                      //                               label: Text(
                      //                                 filterdItem[index1]
                      //                                     .name
                      //                                     .toString(),
                      //                                 style:
                      //                                     poppinsRegularStyle(
                      //                                   fontSize: 14,
                      //                                   context: context,
                      //                                   color:
                      //                                       theme.primaryColor,
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           );
                      //                         },
                      //                         itemCount: filterdItem.length,
                      //                       ),
                      //                     )
                      //                   ],
                      //                 );
                      //               }),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      if (controller.eventDetail!.data!.location != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            "Live Location",
                            style: poppinsMediumStyle(
                                fontWeight: FontWeight.w700,
                                color: DynamicColor.lightRedClr,
                                context: context,
                                fontSize: 17),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            controller.eventDetail!.data!.location.toString(),
                            style: poppinsMediumStyle(
                                color: theme.primaryColor,
                                context: context,
                                fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                      ],

                      if (controller.eventDetail!.data!.latitude != null &&
                          controller.eventDetail!.data!.longitude != null) ...[
                        ShowCustomMap(
                          lat: double.parse(
                              controller.eventDetail!.data!.latitude!),
                          lng: double.parse(
                              controller.eventDetail!.data!.longitude!),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],

                      // Todo Event & Venu Ended

                      sp.read('role') == "eventManager"
                          ? const SizedBox.shrink()
                          : Obx(
                              () => _authController.followingLoader.value ==
                                      false
                                  ? const SizedBox.shrink()
                                  : controller.eventDetail!.data!.venue == null
                                      ? SizedBox()
                                      : aboutEventCreator(
                                          isDelete:
                                              controller.eventDetail!.data!.venue!.user!.isDelete == null
                                                  ? false
                                                  : true,
                                          rowOnTap: () {
                                            Get.toNamed(
                                                Routes.viewProfileScreen,
                                                arguments: {
                                                  "venueDetails": controller
                                                      .eventDetail!.data!,
                                                  "venueId": controller
                                                      .eventDetail!
                                                      .data!
                                                      .venue!
                                                      .userId,
                                                });
                                          },
                                          // text: controller.eventDetail!.data!.venue!.streetAddress.toString(),
                                          horizontalPadding: 12,
                                          theme: theme,
                                          context: context,
                                          image: controller.eventDetail!.data!.venue!.user!.profilePicture == null
                                              ? groupPlaceholder
                                              : controller
                                                  .eventDetail!
                                                  .data!
                                                  .venue!
                                                  .user!
                                                  .profilePicture!
                                                  .mediaPath,
                                          organizerName: controller.eventDetail!
                                              .data!.venue!.venueName
                                              .toString(),
                                          icons: controller.eventDetail!.data!.venue!.user!.following == null
                                              ? Icons.check
                                              : Icons.add,
                                          followBg:
                                              controller.eventDetail!.data!.venue!.user!.following == null
                                                  ? DynamicColor.avatarBgClr
                                                  : DynamicColor.grayClr,
                                          textClr: controller.eventDetail!.data!.venue!.user!.following != null
                                              ? theme.scaffoldBackgroundColor
                                              : theme.primaryColor,
                                          followText: controller.eventDetail!.data!.venue!.user!.following == null ? "Follow" : "Unfollow",
                                          onTap: () {
                                            if (controller.eventDetail!.data!
                                                    .venue!.user!.following ==
                                                null) {
                                              _authController.followUser(
                                                  userData: controller
                                                      .eventDetail!
                                                      .data!
                                                      .venue!
                                                      .user,
                                                  fromAllUser: false);
                                            } else {
                                              _authController.unfollow(
                                                  userData: controller
                                                      .eventDetail!
                                                      .data!
                                                      .venue!
                                                      .user,
                                                  fromAllUser: false);
                                            }
                                          }),
                            ),
                      sp.read('role') == "eventOrganizer"
                          ? const SizedBox.shrink()
                          : Obx(
                              () => _authController.followingLoader.value ==
                                      false
                                  ? const SizedBox.shrink()
                                  : controller.eventDetail!.data!.user == null
                                      ? SizedBox()
                                      : ourGuestWidget(
                                          isDelete: controller.eventDetail!.data!.user!.isDelete == null
                                              ? false
                                              : true,
                                          onTap: () {
                                            Get.toNamed(
                                                Routes.viewProfileScreen,
                                                arguments: {
                                                  "eventDetails": controller
                                                      .eventDetail!.data!,
                                                  "eventId": controller
                                                      .eventDetail!.data!.id,
                                                });
                                          },
                                          horizontalPadding: 12,
                                          networkImg:
                                              controller.eventDetail!.data!.user!.profilePicture == null
                                                  ? groupPlaceholder
                                                  : controller
                                                      .eventDetail!
                                                      .data!
                                                      .user!
                                                      .profilePicture!
                                                      .mediaPath,
                                          venueOwner: controller
                                              .eventDetail!.data!.user!.name
                                              .toString(),
                                          theme: theme,
                                          context: context,
                                          rowPadding: 0.0,
                                          avatarPadding: 6,
                                          rowVerticalPadding: 0.0,
                                          followBgClr:
                                              controller.eventDetail!.data!.user!.following != null
                                                  ? DynamicColor.grayClr
                                                  : DynamicColor.avatarBgClr,
                                          textClr: controller.eventDetail!.data!.user!.following == null
                                              ? theme.primaryColor
                                              : theme.scaffoldBackgroundColor,
                                          followText:
                                              controller.eventDetail!.data!.user!.following == null
                                                  ? "Follow"
                                                  : "Unfollow",
                                          followOnTap: () {
                                            if (controller.eventDetail!.data!
                                                    .user!.following ==
                                                null) {
                                              _authController.followUser(
                                                  userData: controller
                                                      .eventDetail!.data!.user,
                                                  fromAllUser: false);
                                            } else {
                                              _authController.unfollow(
                                                  userData: controller
                                                      .eventDetail!.data!.user,
                                                  fromAllUser: false);
                                            }
                                          }
                                          // onTap: (){
                                          //   followBgClr.value = !followBgClr.value;
                                          // }
                                          ),
                            ),

                      // Todo Event & Venu Ended

                      notifyBtnShow == false
                          ? SizedBox(
                              height: kToolbarHeight,
                              child: ListView.builder(
                                itemCount: 12,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: DynamicColor.lightRedClr,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "#Nirvana",
                                          style: poppinsRegularStyle(
                                              fontSize: 13,
                                              context: context,
                                              color: DynamicColor.blackClr),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                      SizedBox(
                        height: notifyBtnShow == false ? 0 : 10,
                      ),

                      API().sp.read("role") != "User"
                          ? const SizedBox.shrink()
                          : controller.eventDetail!.data!
                                      .eventGoingOrInterested!.value ==
                                  1
                              ? controller.eventDetail!.data!.status ==
                                      "completed"
                                  ? const SizedBox.shrink()
                                  : isCancel == true
                                      ? const SizedBox.shrink()
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomButton(
                                            borderClr: Colors.transparent,
                                            widths: Get.width,
                                            heights: 45,
                                            onTap: () {
                                              controller.userCancelEvents(
                                                eventId: controller
                                                    .eventDetail!.data!.id,
                                              );
                                            },
                                            text: "Cancel",
                                            // appBarTitle == "Past Event"?
                                            // "Complete": appBarTitle=="Cancelled Event"?"Cancelled": "Check in",
                                            textClr: theme.primaryColor,
                                          ),
                                        )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomButton(
                                        widths: Get.width / 2.4,
                                        heights: 40,
                                        backgroundClr: false,
                                        color2: Colors.transparent,
                                        color1: Colors.transparent,
                                        text: "Going",
                                        onTap: () {
                                          controller.userInterested(
                                            eventId: controller
                                                .eventDetail!.data!.id,
                                            statusValue: "going",
                                          );
                                        },
                                        textClr: DynamicColor.yellowClr,
                                      ),
                                      CustomButton(
                                        onTap: () {
                                          controller.userInterested(
                                            eventId: controller
                                                .eventDetail!.data!.id,
                                            statusValue: "interested",
                                          );
                                        },
                                        borderClr: Colors.transparent,
                                        widths: Get.width / 2.4,
                                        heights: 40,
                                        text: "Interested",
                                        textClr: theme.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                      SizedBox(
                        height:
                            Platform.isIOS ? kBottomNavigationBarHeight : 10,
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }

  customWidget(context, theme, {title, value}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title ?? "Event Comments",
              style: poppinsRegularStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                context: context,
                underline: true,
                color: theme.primaryColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: poppinsRegularStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  context: context,
                  underline: true,
                  color: DynamicColor.whiteClr.withValues(alpha: 0.6)),
            ),
          ),
        ),
      ],
    );
  }
}
