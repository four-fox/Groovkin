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
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:groovkin/main.dart';
import 'package:groovkin/payment/journey/payment_journey_widgets.dart';
import 'package:groovkin/utils/utils.dart';
import 'package:intl/intl.dart';

class PendingEventDetails extends StatefulWidget {
  const PendingEventDetails({super.key});

  @override
  State<PendingEventDetails> createState() => _PendingEventDetailsState();
}

class _PendingEventDetailsState extends State<PendingEventDetails> {
  int flowBtn = Get.arguments['notInterestedBtn'];
  final TextEditingController eventReasonController = TextEditingController();
  String titleText = Get.arguments['title'];

  int eventId = Get.arguments['eventId'];

  String type = Get.arguments["type"];

  RxBool organizerFollowVal = false.obs;

  RxBool organizerGuestVal = false.obs;

  late ManagerController _controller;
  late EventController _eventController;

  late AuthController _authController;
  late HomeController _homeController;

  @override
  void initState() {
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }
    if (Get.isRegistered<ManagerController>()) {
      _controller = Get.find<ManagerController>();
    } else {
      _controller = Get.put(ManagerController());
    }
    if (Get.isRegistered<EventController>()) {
      _eventController = Get.find<EventController>();
    } else {
      _eventController = Get.put(EventController());
    }

    if (Get.isRegistered<HomeController>()) {
      _homeController = Get.find<HomeController>();
    } else {
      _homeController = Get.put(HomeController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<EventController>(initState: (v) {
      _eventController.eventDetails(eventId: eventId);
    }, builder: (controller) {
      if (controller.eventDetailsLoader.value == false) {
        return const SizedBox.shrink();
      }
      final event = controller.eventDetail!.data!;
      return Scaffold(
          appBar: customAppBar(theme: theme, text: titleText, actions: [
            flowBtn == 1
                ? type == "event" &&
                        (API().sp.read("role") == "eventManager" &&
                            event.status != "cancelled")
                    ? IconButton(
                        onPressed: () => _showReportSheet(context),
                        icon: Icon(
                          Icons.more_vert,
                          color: theme.primaryColor,
                        ))
                    : const SizedBox()
                : const SizedBox.shrink()
          ]),
          body: pendingDetailsWidget(theme, controller, context, flowBtn,
              eventId, _controller, _authController, _homeController));
    });
  }

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: eventReasonController,
                  decoration: const InputDecoration(
                    hintText: "Reason",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  borderClr: Colors.transparent,
                  heights: 35,
                  fontSized: 13,
                  onTap: () async {
                    Get.back();
                    await _authController
                        .reportAccount(
                            type: type,
                            sourceId: eventId,
                            message: eventReasonController.text)
                        .then((value) {
                      eventReasonController.clear();
                    });
                  },
                  text: "Report",
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    eventReasonController.dispose();
    super.dispose();
  }

  List list = [
    false.obs,
    false.obs,
    false.obs,
  ];
}

Widget customWidget(context, theme, {title, value}) {
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

customList({String? name, context, theme}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
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

Widget pendingDetailsWidget(
    ThemeData theme,
    EventController controller,
    BuildContext context,
    int flowBtn,
    int eventId,
    ManagerController _controller,
    AuthController _authController,
    HomeController _homeController) {
  final event = controller.eventDetail!.data!;
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                      color: DynamicColor.grayClr.withValues(alpha: 0.6)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            if (event.user!.isDelete != null)
                              Utils.accountDelete(context),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 13),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/topbtnGradent.png"),
                                      fit: BoxFit.fill)),
                              child: Center(
                                child: Text(
                                  // "Pending",
                                  event.status.toString(),
                                  style: poppinsRegularStyle(
                                    fontSize: 11,
                                    context: context,
                                    color: theme.scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: event.user!.isDelete == null
                          ? () {
                              // Get.toNamed(Routes.eventOrganizerScreen,
                              //     arguments: {
                              //       "eventOrganizerValue": 2,
                              //       'profileImg':
                              //           "assets/eventOrganizer.png",
                              //       "manager": "Event Manager"
                              //     });
                            }
                          : () {
                              Utils.showToast();
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: event.bannerImage == null
                                  ? null
                                  : NetworkImage(event.bannerImage!.mediaPath!),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.eventTitle!,
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
                                        color: DynamicColor.lightRedClr,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    flowBtn != 1
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  heights: 35,
                                  color2: DynamicColor.redClr
                                      .withValues(alpha: 0.8),
                                  color1: DynamicColor.redClr
                                      .withValues(alpha: 0.8),
                                  widths: Get.width / 2.4,
                                  backgroundClr: false,
                                  fontSized: 12,
                                  text: "Not interested/decline",
                                  onTap: event.user!.isDelete == null
                                      ? () {
                                          cancelEventWidget(
                                              context: context,
                                              theme: theme,
                                              onTap: () {
                                                Get.back();
                                              });
                                        }
                                      : () {
                                          Utils.showToast();
                                        },
                                  borderClr: Colors.transparent,
                                ),
                                CustomButton(
                                  heights: 35,
                                  text: "Accept",
                                  fontSized: 12,
                                  onTap: event.user!.isDelete == null
                                      ? () {
                                          showDialog(
                                              barrierColor: Colors.transparent,
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (BuildContext context) {
                                                return AlertWidget(
                                                  height: Get.height,
                                                  container: SizedBox(
                                                    width: Get.width,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12.0,
                                                          horizontal: 4),
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
                                                                fontSize: 20,
                                                                context:
                                                                    context,
                                                                color: theme
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            const SizedBox(
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
                                                                fontSize: 13,
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
                                                                fontSize: 13,
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
                                                                fontSize: 13,
                                                                context:
                                                                    context,
                                                                color: theme
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Obx(
                                                                  () => Theme(
                                                                    data: Theme.of(
                                                                            context)
                                                                        .copyWith(
                                                                      unselectedWidgetColor:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                    child:
                                                                        SizedBox(
                                                                      width: 30,
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
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              2.0),
                                                                  child: Text(
                                                                    'i have read and agree to the terms and\nconditions',
                                                                    style:
                                                                        poppinsRegularStyle(
                                                                      fontSize:
                                                                          13,
                                                                      context:
                                                                          context,
                                                                      color: theme
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            CustomButton(
                                                              heights: 35,
                                                              text: "Accept",
                                                              fontSized: 12,
                                                              onTap: () {
                                                                Get.back();
                                                              },
                                                              color2: DynamicColor
                                                                  .greenClr
                                                                  .withValues(
                                                                      alpha:
                                                                          0.8),
                                                              color1: DynamicColor
                                                                  .greenClr
                                                                  .withValues(
                                                                      alpha:
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
                                        }
                                      : () {
                                          Utils.showToast();
                                        },
                                  color2: DynamicColor.greenClr
                                      .withValues(alpha: 0.8),
                                  color1: DynamicColor.greenClr
                                      .withValues(alpha: 0.8),
                                  widths: Get.width / 2.4,
                                  backgroundClr: false,
                                  borderClr: Colors.transparent,
                                ),
                              ],
                            ),
                          )
                        : (event.status == "cancelled" ||
                                event.status == "completed" ||
                                event.status == "acknowledged")
                            ? SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CustomButton(
                                  heights: 39,
                                  widths: /*flowBtn==1? Get.width/1.5:*/
                                      Get.width / 1.135,
                                  style: poppinsMediumStyle(
                                    fontSize: 13,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                  onTap: event.user!.isDelete == null
                                      ? () {
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
                                        }
                                      : () {
                                          Utils.showToast();
                                        },
                                  backgroundClr: false,
                                  borderClr: Colors.transparent,
                                  color2: DynamicColor.redClr,
                                  color1: DynamicColor.redClr,
                                  text:
                                      API().sp.read("role") == "eventOrganizer"
                                          ? "Cancel"
                                          : "Decline",
                                ),
                              ),
                    const SizedBox(
                      height: 8,
                    ),
                    (API().sp.read("role") == "eventOrganizer" &&
                            event.isCounterActive!.value == 0)
                        ? const SizedBox.shrink()
                        : (event.status == "cancelled" ||
                                event.status == "completed" ||
                                event.status == "acknowledged")
                            ? SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    CustomButton(
                                      heights: 39,
                                      onTap: event.user!.isDelete == null
                                          ? () {
                                              int? userId;
                                              if (event.userId ==
                                                  API().sp.read("userId")) {
                                                userId = event.venue!.userId;
                                              } else {
                                                userId = event.userId!;
                                              }
                                              Get.toNamed(Routes.counterScreen,
                                                  arguments: {
                                                    "textField": true,
                                                    "acceptVal": true,
                                                    "userId": userId,
                                                    "eventId": eventId,
                                                  });
                                            }
                                          : () {
                                              Utils.showToast();
                                            },
                                      style: poppinsMediumStyle(
                                          fontSize: 13,
                                          context: context,
                                          color: theme.scaffoldBackgroundColor),
                                      backgroundClr: false,
                                      color2: DynamicColor.lightYellowClr,
                                      color1: DynamicColor.lightYellowClr,
                                      borderClr: Colors.transparent,
                                      text: "Counters",
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    if (sp.read("role") == "eventManager" &&
                                        event.status == "pending")
                                      CustomButton(
                                        heights: 39,
                                        text: "Accept",
                                        fontSized: 12,
                                        onTap: event.user!.isDelete == null
                                            ? () {
                                                _controller.checkBoxValue
                                                    .value = false;
                                                showDialog(
                                                    barrierColor:
                                                        Colors.transparent,
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertWidget(
                                                        height:
                                                            Get.height * .45,
                                                        container: SizedBox(
                                                          width: Get.width,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        12.0,
                                                                    horizontal:
                                                                        4),
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
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
                                                                  const SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  Text(
                                                                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
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
                                                                  const SizedBox(
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
                                                                          data:
                                                                              Theme.of(context).copyWith(
                                                                            unselectedWidgetColor:
                                                                                Colors.white,
                                                                          ),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                30,
                                                                            child: Checkbox(
                                                                                activeColor: DynamicColor.yellowClr,
                                                                                value: _controller.checkBoxValue.value,
                                                                                onChanged: (v) {
                                                                                  _controller.checkBoxValue.value = v!;
                                                                                  controller.update();
                                                                                }),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 2.0),
                                                                          child:
                                                                              Text(
                                                                            'i have read and agree to the terms and conditions',
                                                                            style:
                                                                                poppinsRegularStyle(
                                                                              fontSize: 13,
                                                                              context: context,
                                                                              color: theme.primaryColor,
                                                                            ),
                                                                            maxLines:
                                                                                2,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  CustomButton(
                                                                    heights: 35,
                                                                    text:
                                                                        "Accept",
                                                                    fontSized:
                                                                        12,
                                                                    onTap:
                                                                        () async {
                                                                      if (_controller
                                                                          .checkBoxValue
                                                                          .value) {
                                                                        await _controller
                                                                            .beginPaidEventAcceptance(
                                                                          event
                                                                              .id!,
                                                                        );
                                                                      } else {
                                                                        bottomToast(
                                                                            text:
                                                                                "Please agree with the disclaimer to accept the event request");
                                                                      }
                                                                    },
                                                                    color2: DynamicColor
                                                                        .greenClr
                                                                        .withValues(
                                                                            alpha:
                                                                                0.8),
                                                                    color1: DynamicColor
                                                                        .greenClr
                                                                        .withValues(
                                                                            alpha:
                                                                                0.8),
                                                                    widths:
                                                                        Get.width /
                                                                            1.4,
                                                                    backgroundClr:
                                                                        false,
                                                                    borderClr:
                                                                        Colors
                                                                            .transparent,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                            : () {
                                                Utils.showToast();
                                              },
                                        color2: event.user!.isDelete == null
                                            ? DynamicColor.greenClr
                                                .withValues(alpha: 0.8)
                                            : DynamicColor.disabledColor,
                                        color1: event.user!.isDelete == null
                                            ? DynamicColor.greenClr
                                                .withValues(alpha: 0.8)
                                            : DynamicColor.disabledColor,
                                        // widths: Get.width / 2.4,
                                        backgroundClr: false,
                                        borderClr: Colors.transparent,
                                      ),
                                  ],
                                ),
                              ),
                    const SizedBox(
                      height: 8,
                    ),
                    flowBtn == 1
                        ? const SizedBox.shrink()
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            flowBtn == 1
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      },
                      textClr: theme.scaffoldBackgroundColor,
                      text: "Counter",
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                event.eventTitle!,
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
                  "${DateFormat.jm().format(event.startDateTime!)} to ${DateFormat.jm().format(event.endDateTime!)}",
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
              text: DateFormat.yMMMMEEEEd().format(event.startDateTime!),
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
                text: event.location,
                icon: false,
                iconClr: DynamicColor.yellowClr),
            const SizedBox(
              height: 10,
            ),
            customWidget(context, theme,
                title: "Event Comments", value: event.comment.toString()),
            customWidget(context, theme,
                title: "Event About", value: event.about.toString()),
            customWidget(context, theme,
                title: "Event theme", value: event.themeOfEvent.toString()),
            customWidget(context, theme,
                title: "Featuring", value: event.featuring.toString()),
            customWidget(context, theme,
                title: "Price", value: event.balanceDue.toString()),
            if (API().sp.read('role') == 'eventOrganizer' ||
                API().sp.read('role') == 'eventManager')
              EventPaymentJourneySection(eventId: eventId),
            customWidget(context, theme,
                title: "Rating", value: event.rate.toString()),
            const SizedBox(
              height: 5,
            ),
            sp.read('role') == "eventManager"
                ? const SizedBox.shrink()
                : Obx(
                    () => _authController.followingLoader.value == false
                        ? const SizedBox.shrink()
                        : event.venue != null
                            ? aboutEventCreator(
                                isDelete: event.venue!.user!.isDelete == null
                                    ? false
                                    : true,
                                rowOnTap: () {
                                  Get.toNamed(Routes.viewProfileScreen,
                                      arguments: {
                                        "venueDetails": event,
                                        "venueId": controller
                                            .eventDetail!.data!.venue!.userId,
                                      });
                                },
                                // text: event.venue!.streetAddress.toString(),
                                horizontalPadding: 0,
                                theme: theme,
                                context: context,
                                image: event.venue!.user!.profilePicture != null
                                    ? event
                                        .venue!.user!.profilePicture!.mediaPath
                                        .toString()
                                    : groupPlaceholder,
                                organizerName: controller
                                    .eventDetail!.data!.venue!.venueName
                                    .toString(),
                                icons: event.venue!.user!.following == null
                                    ? Icons.check
                                    : Icons.add,
                                followBg: event.venue!.user!.following != null
                                    ? DynamicColor.avatarBgClr
                                    : DynamicColor.grayClr,
                                textClr: event.venue!.user!.following == null
                                    ? theme.scaffoldBackgroundColor
                                    : theme.primaryColor,
                                text: event.venue!.user!.profile!.about
                                    .toString(),
                                followText: event.venue!.user!.following == null
                                    ? "Follow"
                                    : "Unfollow",
                                onTap: () {
                                  if (event.venue!.user!.following == null) {
                                    _authController.followUser(
                                        userData: controller
                                            .eventDetail!.data!.venue!.user,
                                        fromAllUser: false);
                                  } else {
                                    _authController.unfollow(
                                        userData: controller
                                            .eventDetail!.data!.venue!.user,
                                        fromAllUser: false);
                                  }
                                })
                            : const SizedBox(),
                  ),
            sp.read('role') == "eventOrganizer"
                ? const SizedBox.shrink()
                : Obx(
                    () => _authController.followingLoader.value == false
                        ? const SizedBox.shrink()
                        : ourGuestWidget(
                            isDelete:
                                event.user!.isDelete == null ? false : true,
                            onTap: () {
                              Get.toNamed(Routes.viewProfileScreen, arguments: {
                                "eventDetails": event,
                                "eventId": event.userId
                              });
                            },
                            networkImg: event.user!.profilePicture == null
                                ? groupPlaceholder
                                : event.user!.profilePicture!.mediaPath
                                    .toString(),
                            venueOwner: event.user!.name.toString(),
                            theme: theme,
                            context: context,
                            horizontalPadding: 0.0,
                            rowPadding: 0.0,
                            avatarPadding: 6,
                            rowVerticalPadding: 0.0,
                            followBgClr: event.user!.following != null
                                ? DynamicColor.grayClr
                                : DynamicColor.avatarBgClr,
                            textClr: event.user!.following == null
                                ? theme.primaryColor
                                : theme.scaffoldBackgroundColor,
                            followText: event.user!.following == null
                                ? "Follow"
                                : "Unfollow",
                            followOnTap: () {
                              if (controller
                                      .eventDetail!.data!.user!.following ==
                                  null) {
                                _authController.followUser(
                                    userData: event.user, fromAllUser: false);
                              } else {
                                _authController.unfollow(
                                    userData: event.user, fromAllUser: false);
                              }
                            }),
                  ),
            if (event.location != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
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
                padding: const EdgeInsets.only(left: 2, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    event.location!,
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
                lat: double.parse(event.latitude!),
                lng: double.parse(event.longitude!),
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            if (event.services!.isNotEmpty)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: event.services!.length,
                            itemBuilder: (BuildContext context, indx) {
                              return customList(
                                  context: context,
                                  theme: theme,
                                  name: event.services![indx].eventItem!.name
                                      .toString());
                            }),
                      ),
                    ),
                    const SizedBox(
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
                    Align(
                      alignment: Alignment.topLeft,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: controller
                              .eventDetail!.data!.hardwareProvide!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, index) {
                            final filterItem = event
                                .hardwareProvide![index].hardwareItems!
                                .where((data) => data.selected == true)
                                .toList();
                            if (filterItem.isEmpty) return SizedBox();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("${"• "}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: isDark(context)
                                              ? theme.primaryColor
                                              : DynamicColor.whiteClr,
                                        )),
                                    Text(
                                      event.hardwareProvide![index].name
                                          .toString(),
                                      style: poppinsRegularStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        context: context,
                                        underline: true,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: kToolbarHeight,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index1) {
                                      return customList(
                                          context: context,
                                          theme: theme,
                                          name: filterItem[index1]
                                              .name
                                              .toString());
                                    },
                                    itemCount: filterItem.length,
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                    if (event.musicGenre!.any((genre) =>
                        genre.musicGenreItems
                            ?.any((item) => item.selected == true) ??
                        false))
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
                    Align(
                      alignment: Alignment.topLeft,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: event.musicGenre!.length,
                          itemBuilder: (BuildContext context, index) {
                            final filterItem = event
                                .musicGenre![index].musicGenreItems!
                                .where((data) => data.selected == true)
                                .toList();
                            if (filterItem.isEmpty) return SizedBox();
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text("${"• "}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: isDark(context)
                                              ? theme.primaryColor
                                              : DynamicColor.whiteClr,
                                        )),
                                    Text(
                                      event.musicGenre![index].name.toString(),
                                      style: poppinsRegularStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        context: context,
                                        underline: true,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: kToolbarHeight,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index1) {
                                      return customList(
                                          context: context,
                                          theme: theme,
                                          name: filterItem[index1]
                                              .name
                                              .toString());
                                    },
                                    itemCount: filterItem.length,
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                    if (controller
                        .eventDetail!.data!.eventMusicChoiceTags!.isNotEmpty)
                      Column(
                        children: [
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
                          Align(
                            alignment: Alignment.topLeft,
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: controller.eventDetail!.data!
                                    .eventMusicChoiceTags!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, index) {
                                  final filterItem = controller
                                      .eventDetail!
                                      .data!
                                      .eventMusicChoiceTags![index]
                                      .musicChoiceItems!
                                      .categoryItems!
                                      .where(
                                          (data) => data.userSelection == true)
                                      .toList();
                                  if (filterItem.isEmpty) return SizedBox();
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text("${"• "}",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: isDark(context)
                                                    ? theme.primaryColor
                                                    : DynamicColor.whiteClr,
                                              )),
                                          Text(
                                            controller
                                                .eventDetail!
                                                .data!
                                                .eventMusicChoiceTags![index]
                                                .musicChoiceItems!
                                                .name
                                                .toString(),
                                            style: poppinsRegularStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              context: context,
                                              underline: true,
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: kToolbarHeight,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index1) {
                                            return customList(
                                                context: context,
                                                theme: theme,
                                                name: filterItem[index1]
                                                    .name
                                                    .toString());
                                          },
                                          itemCount: filterItem.length,
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    if (controller
                        .eventDetail!.data!.eventActivityChoiceTags!.isNotEmpty)
                      Column(
                        children: [
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
                          Align(
                            alignment: Alignment.topLeft,
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount:
                                    event.eventActivityChoiceTags!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, index) {
                                  final filterItem = controller
                                      .eventDetail!
                                      .data!
                                      .eventActivityChoiceTags![index]
                                      .activityChoiceItems!
                                      .categoryItems!
                                      .where(
                                          (data) => data.userSelection == true)
                                      .toList();
                                  if (filterItem.isEmpty) return SizedBox();
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("${"• "}",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: isDark(context)
                                                    ? theme.primaryColor
                                                    : DynamicColor.whiteClr,
                                              )),
                                          Text(
                                            controller
                                                .eventDetail!
                                                .data!
                                                .eventActivityChoiceTags![index]
                                                .activityChoiceItems!
                                                .name
                                                .toString(),
                                            style: poppinsRegularStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              context: context,
                                              underline: true,
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: kToolbarHeight,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index1) {
                                            return customList(
                                                context: context,
                                                theme: theme,
                                                name: filterItem[index1]
                                                    .name
                                                    .toString());
                                          },
                                          itemCount: filterItem.length,
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    if (controller.eventDetail!.data!.hashtags!.isNotEmpty)
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Organizer Private Hashtags",
                              style: poppinsRegularStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                context: context,
                                underline: true,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                height: kToolbarHeight,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final hashtags = controller
                                        .eventDetail!.data!.hashtags![index];
                                    return customList(
                                        context: context,
                                        theme: theme,
                                        name: hashtags.name.toString());
                                  },
                                  itemCount: controller
                                      .eventDetail!.data!.hashtags!.length,
                                ),
                              )),
                        ],
                      ),
                  ],
                ),
              ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    ),
  );
}
