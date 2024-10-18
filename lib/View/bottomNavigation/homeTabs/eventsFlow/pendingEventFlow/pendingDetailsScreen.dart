// ignore_for_file: prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/cancelEventWidget.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/showCustomMap.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:intl/intl.dart';

class PendingEventDetails extends StatefulWidget {
  PendingEventDetails({Key? key}) : super(key: key);

  @override
  State<PendingEventDetails> createState() => _PendingEventDetailsState();
}

class _PendingEventDetailsState extends State<PendingEventDetails> {
  int flowBtn = Get.arguments['notInterestedBtn'];

  String titleText = Get.arguments['title'];

  int eventId = Get.arguments['eventId'];

  String type = Get.arguments["type"];

  RxBool organizerFollowVal = false.obs;

  RxBool organizerGuestVal = false.obs;

  ManagerController _controller = Get.find();

  EventController _eventController = Get.find();

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
    print(eventId);
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: titleText, actions: [
        flowBtn == 1
            ? type == "event" && API().sp.read("role") == "eventManager"
                ? IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: EdgeInsets.all(12.0),
                              margin: EdgeInsets.all(10.0),
                              child: CustomButton(
                                borderClr: Colors.transparent,
                                heights: 35,
                                fontSized: 13,
                                onTap: () async {
                                  Get.back();
                                  await _authController.reportAccount(
                                      type, eventId);
                                },
                                text: "Report",
                              ),
                            );
                          });
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: theme.primaryColor,
                    ))
                : SizedBox()
            : SizedBox.shrink()
      ]),
      body: GetBuilder<EventController>(initState: (v) {
        _eventController.eventDetails(eventId: eventId);
      }, builder: (controller) {
        return controller.eventDetailsLoader.value == false
            ? SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
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
                                        vertical: 6, horizontal: 13),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/topbtnGradent.png"),
                                            fit: BoxFit.fill)),
                                    child: Center(
                                      child: Text(
                                        "Pending",
                                        style: poppinsRegularStyle(
                                          fontSize: 11,
                                          context: context,
                                          color: theme.scaffoldBackgroundColor,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.eventOrganizerScreen,
                                      arguments: {
                                        "eventOrganizerValue": 2,
                                        'profileImg':
                                            "assets/eventOrganizer.png",
                                        "manager": "Event Manager"
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: controller.eventDetail!
                                                    .data!.bannerImage ==
                                                null
                                            ? null
                                            : NetworkImage(controller
                                                .eventDetail!
                                                .data!
                                                .bannerImage!
                                                .mediaPath!),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.eventDetail!.data!
                                                  .eventTitle!,
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
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              flowBtn != 1
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomButton(
                                            heights: 35,
                                            color2: DynamicColor.redClr
                                                .withOpacity(0.8),
                                            color1: DynamicColor.redClr
                                                .withOpacity(0.8),
                                            widths: Get.width / 2.4,
                                            backgroundClr: false,
                                            fontSized: 12,
                                            text: "Not interested/decline",
                                            onTap: () {
                                              cancelEventWidget(
                                                  context: context,
                                                  theme: theme,
                                                  onTap: () {
                                                    Get.back();
                                                  });
                                            },
                                            borderClr: Colors.transparent,
                                          ),
                                          CustomButton(
                                            heights: 35,
                                            text: "Accept",
                                            fontSized: 12,
                                            onTap: () {
                                              showDialog(
                                                  barrierColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertWidget(
                                                      height: Get.height,
                                                      container: SizedBox(
                                                        width: Get.width,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      12.0,
                                                                  horizontal:
                                                                      4),
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "Disclaimer",
                                                                  style:
                                                                      poppinsMediumStyle(
                                                                    fontSize:
                                                                        20,
                                                                    context:
                                                                        context,
                                                                    color: theme
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Text(
                                                                  "“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” “Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”",
                                                                  maxLines: 8,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      poppinsMediumStyle(
                                                                    fontSize:
                                                                        13,
                                                                    context:
                                                                        context,
                                                                    color: theme
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” “Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”",
                                                                  maxLines: 8,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      poppinsMediumStyle(
                                                                    fontSize:
                                                                        13,
                                                                    context:
                                                                        context,
                                                                    color: theme
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” “Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”",
                                                                  maxLines: 8,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      poppinsMediumStyle(
                                                                    fontSize:
                                                                        13,
                                                                    context:
                                                                        context,
                                                                    color: theme
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Obx(
                                                                      () =>
                                                                          Theme(
                                                                        data: Theme.of(context)
                                                                            .copyWith(
                                                                          unselectedWidgetColor:
                                                                              Colors.white,
                                                                        ),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              30,
                                                                          child: Checkbox(
                                                                              activeColor: DynamicColor.yellowClr,
                                                                              value: true,
                                                                              onChanged: (v) {
                                                                                // checkBoxValue.value = v!;
                                                                              }),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              2.0),
                                                                      child:
                                                                          Text(
                                                                        'i have read and agree to the terms and\nconditions',
                                                                        style:
                                                                            poppinsRegularStyle(
                                                                          fontSize:
                                                                              13,
                                                                          context:
                                                                              context,
                                                                          color:
                                                                              theme.primaryColor,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                CustomButton(
                                                                  heights: 35,
                                                                  text:
                                                                      "Accept",
                                                                  fontSized: 12,
                                                                  onTap: () {
                                                                    Get.back();
                                                                  },
                                                                  color2: DynamicColor
                                                                      .greenClr
                                                                      .withOpacity(
                                                                          0.8),
                                                                  color1: DynamicColor
                                                                      .greenClr
                                                                      .withOpacity(
                                                                          0.8),
                                                                  widths:
                                                                      Get.width /
                                                                          1.4,
                                                                  backgroundClr:
                                                                      false,
                                                                  borderClr: Colors
                                                                      .transparent,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            color2: DynamicColor.greenClr
                                                .withOpacity(0.8),
                                            color1: DynamicColor.greenClr
                                                .withOpacity(0.8),
                                            widths: Get.width / 2.4,
                                            backgroundClr: false,
                                            borderClr: Colors.transparent,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: CustomButton(
                                        heights: 39,
                                        widths: /*flowBtn==1? Get.width/1.5:*/
                                            Get.width / 1.135,
                                        style: poppinsMediumStyle(
                                          fontSize: 13,
                                          context: context,
                                          color: theme.primaryColor,
                                        ),
                                        onTap: () {
                                          cancelEventWidget(
                                              context: context,
                                              theme: theme,
                                              onTap: () {
                                                Get.back();
                                                Get.toNamed(Routes.cancelReason,
                                                    arguments: {
                                                      "eventId": eventId,
                                                      "doubleBack": true,
                                                    });
                                              });
                                        },
                                        backgroundClr: false,
                                        borderClr: Colors.transparent,
                                        color2: DynamicColor.redClr,
                                        color1: DynamicColor.redClr,
                                        text: "Cancel",
                                      ),
                                    ),
                              SizedBox(
                                height: 8,
                              ),
                              (API().sp.read("role") == "eventOrganizer" &&
                                      controller.eventDetail!.data!
                                              .isCounterActive!.value ==
                                          0)
                                  ? SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: CustomButton(
                                        heights: 39,
                                        onTap: () {
                                          int? userId;
                                          if (controller
                                                  .eventDetail!.data!.userId ==
                                              API().sp.read("userId")) {
                                            userId = controller.eventDetail!
                                                .data!.venue!.userId;
                                          } else {
                                            userId = controller
                                                .eventDetail!.data!.userId!;
                                          }
                                          Get.toNamed(Routes.counterScreen,
                                              arguments: {
                                                "textField": true,
                                                "acceptVal": true,
                                                "userId": userId,
                                                "eventId": eventId,
                                              });
                                        },
                                        style: poppinsMediumStyle(
                                            fontSize: 13,
                                            context: context,
                                            color:
                                                theme.scaffoldBackgroundColor),
                                        backgroundClr: false,
                                        color2: DynamicColor.lightYellowClr,
                                        color1: DynamicColor.lightYellowClr,
                                        borderClr: Colors.transparent,
                                        text: "Counters",
                                      ),
                                    ),
                              SizedBox(
                                height: 8,
                              ),
                              flowBtn == 1
                                  ? SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: CustomButton(
                                        heights: 39,
                                        style: poppinsMediumStyle(
                                          fontSize: 13,
                                          context: context,
                                          color: theme.primaryColor,
                                        ),
                                        onTap: () {
                                          Get.toNamed(Routes.editEventScreen);
                                        },
                                        backgroundClr: false,
                                        borderClr: Colors.transparent,
                                        color2: DynamicColor.greenClr,
                                        color1: DynamicColor.greenClr,
                                        text: "Changes",
                                      ),
                                    ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      flowBtn == 1
                          ? SizedBox.shrink()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CustomButton(
                                heights: 33,
                                color1: DynamicColor.lightYellowClr,
                                color2: DynamicColor.lightYellowClr,
                                backgroundClr: false,
                                borderClr: Colors.transparent,
                                onTap: () {
                                  Get.toNamed(Routes.counterScreen, arguments: {
                                    "textField": true,
                                    "acceptVal": false,
                                  });
                                  // Get.toNamed(Routes.upcomingScreen,
                                  //     arguments: {
                                  //       "reportedEventView": flowBtn==2?3: 1
                                  //     }
                                  // );
                                },
                                textClr: theme.scaffoldBackgroundColor,
                                text: "Counter",
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          controller.eventDetail!.data!.eventTitle!,
                          style: poppinsMediumStyle(
                            fontSize: 19,
                            context: context,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      venueService(
                        theme: theme,
                        context: context,
                        horizontalPadding: 0.0,
                        bgColor: DynamicColor.darkBlueClr,
                        iconPadding: 4,
                        radius: 18,
                        image: "assets/lockIcon.png",
                        text:
                            "${DateFormat.jm().format(controller.eventDetail!.data!.startDateTime!)} to ${DateFormat.jm().format(controller.eventDetail!.data!.endDateTime!)}",
                        icon: true,
                      ),
                      venueService(
                        theme: theme,
                        context: context,
                        horizontalPadding: 0.0,
                        bgColor: DynamicColor.darkBlueClr,
                        iconPadding: 4,
                        radius: 18,
                        image: "assets/calender.png",
                        text: DateFormat.yMMMMEEEEd().format(
                            controller.eventDetail!.data!.startDateTime!),
                        icon: true,
                      ),
                      venueService(
                          theme: theme,
                          context: context,
                          horizontalPadding: 0.0,
                          bgColor: DynamicColor.darkBlueClr,
                          iconPadding: 4,
                          radius: 18,
                          image: "assets/location.png",
                          text: controller.eventDetail!.data!.location,
                          icon: false,
                          iconClr: DynamicColor.yellowClr),
                      SizedBox(
                        height: 10,
                      ),
                      customWidget(context, theme,
                          title: "Event Comments",
                          value:
                              controller.eventDetail!.data!.comment.toString()),
                      customWidget(context, theme,
                          title: "Event About",
                          value:
                              controller.eventDetail!.data!.about.toString()),
                      customWidget(context, theme,
                          title: "Event theme",
                          value: controller.eventDetail!.data!.themeOfEvent
                              .toString()),
                      customWidget(context, theme,
                          title: "Featuring",
                          value: controller.eventDetail!.data!.featuring
                              .toString()),
                      sp.read('role') == "eventManager"
                          ? SizedBox.shrink()
                          : Obx(
                              () => _authController.followingLoader.value ==
                                      false
                                  ? SizedBox.shrink()
                                  : aboutEventCreator(
                                      // text: controller.eventDetail!.data!.venue!.streetAddress.toString(),
                                      horizontalPadding: 0,
                                      theme: theme,
                                      context: context,
                                      image: controller.eventDetail!.data!.venue!.user!.profilePicture != null
                                          ? controller.eventDetail!.data!.venue!
                                              .user!.profilePicture!.mediaPath
                                              .toString()
                                          : groupPlaceholder,
                                      organizerName: controller
                                          .eventDetail!.data!.venue!.venueName
                                          .toString(),
                                      icons: controller.eventDetail!.data!.venue!.user!.following == null
                                          ? Icons.check
                                          : Icons.add,
                                      followBg: controller.eventDetail!.data!.venue!.user!.following != null
                                          ? DynamicColor.avatarBgClr
                                          : DynamicColor.grayClr,
                                      textClr: controller.eventDetail!.data!.venue!.user!.following == null
                                          ? theme.scaffoldBackgroundColor
                                          : theme.primaryColor,
                                      text: controller.eventDetail!.data!.venue!
                                          .user!.profile!.about
                                          .toString(),
                                      followText: controller.eventDetail!.data!.venue!.user!.following == null ? "Follow" : "Unfollow",
                                      onTap: () {
                                        if (controller.eventDetail!.data!.venue!
                                                .user!.following ==
                                            null) {
                                          _authController.followUser(
                                              userData: controller.eventDetail!
                                                  .data!.venue!.user,
                                              fromAllUser: false);
                                        } else {
                                          _authController.unfollow(
                                              userData: controller.eventDetail!
                                                  .data!.venue!.user,
                                              fromAllUser: false);
                                        }
                                      }),
                            ),
                      sp.read('role') == "eventOrganizer"
                          ? SizedBox.shrink()
                          : Obx(
                              () => _authController.followingLoader.value ==
                                      false
                                  ? SizedBox.shrink()
                                  : ourGuestWidget(
                                      networkImg: controller.eventDetail!.data!
                                                  .user!.profilePicture ==
                                              null
                                          ? groupPlaceholder
                                          : controller.eventDetail!.data!.user!
                                              .profilePicture!.mediaPath
                                              .toString(),
                                      venueOwner: controller
                                          .eventDetail!.data!.user!.name
                                          .toString(),
                                      theme: theme,
                                      context: context,
                                      horizontalPadding: 0.0,
                                      rowPadding: 0.0,
                                      avatarPadding: 6,
                                      rowVerticalPadding: 0.0,
                                      followBgClr: controller.eventDetail!.data!
                                                  .user!.following !=
                                              null
                                          ? DynamicColor.grayClr
                                          : DynamicColor.avatarBgClr,
                                      textClr: controller.eventDetail!.data!.user!.following == null
                                          ? theme.primaryColor
                                          : theme.scaffoldBackgroundColor,
                                      followText: controller.eventDetail!.data!.user!.following == null
                                          ? "Follow"
                                          : "Unfollow",
                                      followOnTap: () {
                                        if (controller.eventDetail!.data!.user!
                                                .following ==
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
                                      }),
                            ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Location",
                            style: poppinsMediumStyle(
                                fontSize: 18,
                                context: context,
                                color: DynamicColor.lightRedClr,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2, bottom: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            controller.eventDetail!.data!.location!,
                            style: poppinsMediumStyle(
                              fontSize: 13,
                              context: context,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      ShowCustomMap(
                        horizontalPadding: 2,
                        lat: double.parse(
                            controller.eventDetail!.data!.latitude!),
                        lng: double.parse(
                            controller.eventDetail!.data!.longitude!),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: DynamicColor.darkGrayClr),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Service",
                                style: poppinsRegularStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  context: context,
                                  underline: true,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: kToolbarHeight,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller
                                        .eventDetail!.data!.services!.length,
                                    itemBuilder: (BuildContext context, indx) {
                                      return customList(
                                          context: context,
                                          theme: theme,
                                          name: controller.eventDetail!.data!
                                              .services![indx].eventItem!.name
                                              .toString());
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Hardware Provided",
                                style: poppinsRegularStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  context: context,
                                  underline: true,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: kToolbarHeight,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: ListView.builder(
                                    itemCount: controller.eventDetail!.data!
                                        .hardwareProvide!.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, index) {
                                      return controller
                                                  .eventDetail!
                                                  .data!
                                                  .hardwareProvide![index]
                                                  .hardwareItems!
                                                  .name ==
                                              null
                                          ? SizedBox.shrink()
                                          : customList(
                                              context: context,
                                              theme: theme,
                                              name: controller
                                                  .eventDetail!
                                                  .data!
                                                  .hardwareProvide![index]
                                                  .hardwareItems!
                                                  .name
                                                  .toString());
                                      // return ListView.builder(
                                      //     shrinkWrap: true,
                                      //     scrollDirection: Axis.horizontal,
                                      //     physics: NeverScrollableScrollPhysics(),
                                      //     itemCount: controller.eventDetail!.data!.hardwareProvide![index].hardwareItems!.categoryItems!.length,
                                      //     itemBuilder: (BuildContext context,indx){
                                      //       return controller.eventDetail!.data!.hardwareProvide![index].eventItem!.categoryItems![indx].userEventSubItems ==null?SizedBox.shrink(): customList(context: context, theme: theme,name: controller.eventDetail!.data!.hardwareProvide![index].eventItem!.categoryItems![indx].name.toString());
                                      //     });
                                    }),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Music Genre",
                                style: poppinsRegularStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  context: context,
                                  underline: true,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: kToolbarHeight,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller
                                        .eventDetail!.data!.musicGenre!.length,
                                    itemBuilder: (BuildContext context, indx) {
                                      return controller
                                                  .eventDetail!
                                                  .data!
                                                  .musicGenre![indx]
                                                  .musicGenreItems!
                                                  .name ==
                                              null
                                          ? SizedBox.shrink()
                                          : customList(
                                              context: context,
                                              theme: theme,
                                              name: controller
                                                  .eventDetail!
                                                  .data!
                                                  .musicGenre![indx]
                                                  .musicGenreItems!
                                                  .name
                                                  .toString());
                                      // return ListView.builder(
                                      //     shrinkWrap: true,
                                      //     scrollDirection: Axis.horizontal,
                                      //     physics: NeverScrollableScrollPhysics(),
                                      //     itemCount: controller.eventDetail!.data!.musicGenre![indx].eventItem!.categoryItems!.length,
                                      //     itemBuilder: (BuildContext context,indxess){
                                      //       return controller.eventDetail!.data!.musicGenre![indx].eventItem!.categoryItems![indxess].userCategoryItems ==null?SizedBox.shrink(): customList(context: context, theme: theme,name: controller.eventDetail!.data!.musicGenre![indx].eventItem!.categoryItems![indxess].name.toString());
                                      //     });
                                    }),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Music Choice",
                                style: poppinsRegularStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  context: context,
                                  underline: true,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: kToolbarHeight,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: ListView.builder(
                                    itemCount: controller.eventDetail!.data!
                                        .eventMusicChoiceTags!.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, index) {
                                      return controller
                                                  .eventDetail!
                                                  .data!
                                                  .eventMusicChoiceTags![index]
                                                  .musicChoiceItems!
                                                  .name ==
                                              null
                                          ? SizedBox.shrink()
                                          : customList(
                                              context: context,
                                              theme: theme,
                                              name: controller
                                                  .eventDetail!
                                                  .data!
                                                  .eventMusicChoiceTags![index]
                                                  .musicChoiceItems!
                                                  .name
                                                  .toString());
                                    }),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Activity Choice",
                                style: poppinsRegularStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  context: context,
                                  underline: true,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: kToolbarHeight,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: ListView.builder(
                                    itemCount: controller.eventDetail!.data!
                                        .eventActivityChoiceTags!.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, index) {
                                      return controller
                                                  .eventDetail!
                                                  .data!
                                                  .eventActivityChoiceTags![
                                                      index]
                                                  .activityChoiceItems!
                                                  .name ==
                                              null
                                          ? SizedBox.shrink()
                                          : customList(
                                              context: context,
                                              theme: theme,
                                              name: controller
                                                  .eventDetail!
                                                  .data!
                                                  .eventActivityChoiceTags![
                                                      index]
                                                  .activityChoiceItems!
                                                  .name
                                                  .toString());
                                      // return ListView.builder(
                                      //     shrinkWrap: true,
                                      //     scrollDirection: Axis.horizontal,
                                      //     physics: NeverScrollableScrollPhysics(),
                                      //     itemCount: controller.eventDetail!.data!.eventActivityChoiceTags![index].eventTagItem!.categoryItems!.length,
                                      //     itemBuilder: (BuildContext context,indx){
                                      //       return
                                      //         controller.eventDetail!.data!.eventActivityChoiceTags![index].eventTagItem!.categoryItems![indx].userEventTagItems == null?SizedBox.shrink():
                                      //         customList(context: context, theme: theme,name: controller.eventDetail!.data!.eventActivityChoiceTags![index].eventTagItem!.categoryItems![indx].name.toString());
                                      //     });
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // flowBtn==2?SizedBox.shrink():
                      // Container(
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       color: DynamicColor.darkGrayClr
                      //   ),
                      //   child: ListView.builder(
                      //       itemCount: 8,
                      //       shrinkWrap: true,
                      //       physics: NeverScrollableScrollPhysics(),
                      //       itemBuilder: (BuildContext context,index){
                      //     return Container(
                      //       width: double.infinity,
                      //       decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10),
                      //           color: DynamicColor.darkGrayClr
                      //       ),
                      //       child: customWidget(theme: theme),
                      //     );
                      //
                      //   }),
                      // ),
                      // Padding(padding: EdgeInsets.only(left: 2,bottom: 8),
                      //   child: Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: Text("Verbiage to come",
                      //       style: poppinsMediumStyle(
                      //           fontSize: 16,
                      //           context: context,
                      //           color: theme.primaryColor,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // ListView.builder(
                      //     itemCount: list.length,
                      //     shrinkWrap: true,
                      //     padding: EdgeInsets.zero,
                      //     physics: NeverScrollableScrollPhysics(),
                      //     itemBuilder: (BuildContext context,index){
                      //   return Obx(
                      //     ()=> GestureDetector(
                      //       onTap: (){
                      //         list[index].value = !list[index].value;
                      //       },
                      //       child: Padding(
                      //         padding: EdgeInsets.symmetric(vertical: 5.0),
                      //         child: Container(
                      //           padding: EdgeInsets.symmetric(vertical: 6,horizontal:list[index]==false? 0:8),
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10),
                      //             color:list[index]==false?Colors.transparent: DynamicColor.avatarBgClr,
                      //           ),
                      //           child: Row(
                      //             // ignore: prefer_const_literals_to_create_immutables
                      //             children: [
                      //               CircleAvatar(
                      //                 radius: 15,
                      //                 backgroundColor:list[index]==false?DynamicColor.darkBlueClr: DynamicColor.grayClr,
                      //                 child: ImageIcon(AssetImage("assets/avEquipment.png"),
                      //                 color: list[index]==false?DynamicColor.yellowClr: DynamicColor.blackClr,
                      //                 ),
                      //               ),
                      //               Padding(
                      //                 padding: EdgeInsets.only(left: 6.0),
                      //                 child: Text("AV Equipment",
                      //                 style: poppinsRegularStyle(
                      //                   fontSize: 14,
                      //                   context: context,
                      //                   color:theme.primaryColor,
                      //                 ),
                      //                 ),
                      //               ),
                      //               Spacer(),
                      //              list[index]==false?SizedBox.shrink(): Icon(Icons.check)
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   );
                      // }),
                      // Padding(padding: EdgeInsets.only(left: 2,bottom: 8),
                      //   child: Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: Text("All Hardware",
                      //       style: poppinsMediumStyle(
                      //           fontSize: 16,
                      //           context: context,
                      //           color: theme.primaryColor,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // ListView.builder(
                      //     itemCount: 7,
                      //     shrinkWrap: true,
                      //     padding: EdgeInsets.zero,
                      //     physics: NeverScrollableScrollPhysics(),
                      //     itemBuilder: (BuildContext context,index){
                      //       return Padding(
                      //         padding: EdgeInsets.symmetric(vertical: 5.0),
                      //         child: Container(
                      //           padding: EdgeInsets.symmetric(vertical: 6),
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           child: Row(
                      //             // ignore: prefer_const_literals_to_create_immutables
                      //             children: [
                      //               Image(
                      //                 image: AssetImage("assets/headingIcons.png"),
                      //               ),
                      //               Padding(
                      //                 padding: EdgeInsets.only(left: 6.0),
                      //                 child: Text("Vinyl Turntables",
                      //                   style: poppinsRegularStyle(
                      //                       fontSize: 14,
                      //                       context: context,
                      //                       color:theme.primaryColor,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       );
                      //     }),
                      //
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 12.0),
                      //   child: Align(
                      //     alignment: Alignment.topLeft,
                      //     child: Text("Tags",
                      //       style: poppinsMediumStyle(
                      //         fontSize: 13,
                      //         context: context,
                      //         color: theme.primaryColor,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // SizedBox(
                      //   height: kToolbarHeight/2,
                      //   child: ListView.builder(
                      //       itemCount: 12,
                      //       shrinkWrap: true,
                      //       physics: AlwaysScrollableScrollPhysics(),
                      //       scrollDirection: Axis.horizontal,
                      //       itemBuilder: (BuildContext context,index){
                      //         return Padding(
                      //           padding: EdgeInsets.only(left: 10.0),
                      //           child: Container(
                      //             padding: EdgeInsets.symmetric(horizontal: 10),
                      //             decoration: BoxDecoration(
                      //                 color: DynamicColor.lightRedClr,
                      //                 borderRadius: BorderRadius.circular(12)
                      //             ),
                      //             child: Center(
                      //               child: Text("#Nirvana",
                      //                 style: poppinsRegularStyle(
                      //                   fontSize: 12,
                      //                   context: context,
                      //                   color: theme.scaffoldBackgroundColor,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         );
                      //       }),
                      // ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  List list = [
    false.obs,
    false.obs,
    false.obs,
  ];

  Widget customWidget(context, theme, {title, value}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
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
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: poppinsRegularStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  context: context,
                  underline: true,
                  color: DynamicColor.whiteClr.withOpacity(0.6)),
            ),
          ),
        ),
      ],
    );
  }

  customList({String? name, context, theme}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Chip(
        backgroundColor: DynamicColor.lightBlackClr,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        label: Text(
          name!,
          style: poppinsRegularStyle(
            fontSize: 14,
            context: context,
            color: theme.primaryColor,
          ),
        ),
      ),
    );
  }
}
