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
import 'package:groovkin/View/paymentMethod/showSelectedBottomSheetCard.dart';
import 'package:groovkin/main.dart';
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
    print(sp.read('role'));
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
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
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
                                              message:
                                                  eventReasonController.text)
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
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: theme.primaryColor,
                    ))
                : const SizedBox()
            : const SizedBox.shrink()
      ]),
      body: GetBuilder<EventController>(initState: (v) {
        _eventController.eventDetails(eventId: eventId);
      }, builder: (controller) {
        return controller.eventDetailsLoader.value == false
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0.0, right: 0.0, top: 10.0),
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
                                      if (controller.eventDetail!.data!.user!
                                              .isDelete !=
                                          null)
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
                                            "Pending",
                                            style: poppinsRegularStyle(
                                              fontSize: 11,
                                              context: context,
                                              color:
                                                  theme.scaffoldBackgroundColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: controller.eventDetail!.data!.user!
                                            .isDelete ==
                                        null
                                    ? () {
                                        Get.toNamed(Routes.eventOrganizerScreen,
                                            arguments: {
                                              "eventOrganizerValue": 2,
                                              'profileImg':
                                                  "assets/eventOrganizer.png",
                                              "manager": "Event Manager"
                                            });
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
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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
                              const SizedBox(
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
                                                .withValues(alpha: 0.8),
                                            color1: DynamicColor.redClr
                                                .withValues(alpha: 0.8),
                                            widths: Get.width / 2.4,
                                            backgroundClr: false,
                                            fontSized: 12,
                                            text: "Not interested/decline",
                                            onTap: controller.eventDetail!.data!
                                                        .user!.isDelete ==
                                                    null
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
                                            onTap:
                                                controller.eventDetail!.data!
                                                            .user!.isDelete ==
                                                        null
                                                    ? () {
                                                        showDialog(
                                                            barrierColor: Colors
                                                                .transparent,
                                                            context: context,
                                                            barrierDismissible:
                                                                true,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertWidget(
                                                                height:
                                                                    Get.height,
                                                                container:
                                                                    SizedBox(
                                                                  width:
                                                                      Get.width,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            12.0,
                                                                        horizontal:
                                                                            4),
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "Disclaimer",
                                                                            style:
                                                                                poppinsMediumStyle(
                                                                              fontSize: 20,
                                                                              context: context,
                                                                              color: theme.primaryColor,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          Text(
                                                                            "“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” “Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”",
                                                                            maxLines:
                                                                                8,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                poppinsMediumStyle(
                                                                              fontSize: 13,
                                                                              context: context,
                                                                              color: theme.primaryColor,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” “Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”",
                                                                            maxLines:
                                                                                8,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                poppinsMediumStyle(
                                                                              fontSize: 13,
                                                                              context: context,
                                                                              color: theme.primaryColor,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” “Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”",
                                                                            maxLines:
                                                                                8,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                poppinsMediumStyle(
                                                                              fontSize: 13,
                                                                              context: context,
                                                                              color: theme.primaryColor,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Obx(
                                                                                () => Theme(
                                                                                  data: Theme.of(context).copyWith(
                                                                                    unselectedWidgetColor: Colors.white,
                                                                                  ),
                                                                                  child: SizedBox(
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
                                                                                padding: const EdgeInsets.only(left: 2.0),
                                                                                child: Text(
                                                                                  'i have read and agree to the terms and\nconditions',
                                                                                  style: poppinsRegularStyle(
                                                                                    fontSize: 13,
                                                                                    context: context,
                                                                                    color: theme.primaryColor,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          CustomButton(
                                                                            heights:
                                                                                35,
                                                                            text:
                                                                                "Accept",
                                                                            fontSized:
                                                                                12,
                                                                            onTap:
                                                                                () {
                                                                              Get.back();
                                                                            },
                                                                            color2:
                                                                                DynamicColor.greenClr.withValues(alpha: 0.8),
                                                                            color1:
                                                                                DynamicColor.greenClr.withValues(alpha: 0.8),
                                                                            widths:
                                                                                Get.width / 1.4,
                                                                            backgroundClr:
                                                                                false,
                                                                            borderClr:
                                                                                Colors.transparent,
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
                                        onTap: controller.eventDetail!.data!
                                                    .user!.isDelete ==
                                                null
                                            ? () {
                                                cancelEventWidget(
                                                    context: context,
                                                    theme: theme,
                                                    onTap: () {
                                                      Get.back();
                                                      Get.toNamed(
                                                          Routes.cancelReason,
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
                                        text: API().sp.read("role") ==
                                                "eventOrganizer"
                                            ? "Cancel"
                                            : "Decline",
                                      ),
                                    ),
                              const SizedBox(
                                height: 8,
                              ),
                              (API().sp.read("role") == "eventOrganizer" &&
                                      controller.eventDetail!.data!
                                              .isCounterActive!.value ==
                                          0)
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          CustomButton(
                                            heights: 39,
                                            onTap: controller.eventDetail!.data!
                                                        .user!.isDelete ==
                                                    null
                                                ? () {
                                                    int? userId;
                                                    if (controller.eventDetail!
                                                            .data!.userId ==
                                                        API()
                                                            .sp
                                                            .read("userId")) {
                                                      userId = controller
                                                          .eventDetail!
                                                          .data!
                                                          .venue!
                                                          .userId;
                                                    } else {
                                                      userId = controller
                                                          .eventDetail!
                                                          .data!
                                                          .userId!;
                                                    }
                                                    Get.toNamed(
                                                        Routes.counterScreen,
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
                                                color: theme
                                                    .scaffoldBackgroundColor),
                                            backgroundClr: false,
                                            color2: DynamicColor.lightYellowClr,
                                            color1: DynamicColor.lightYellowClr,
                                            borderClr: Colors.transparent,
                                            text: "Counters",
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          if (sp.read("role") == "eventManager")
                                            CustomButton(
                                              heights: 39,
                                              text: "Accept",
                                              fontSized: 12,
                                              onTap:
                                                  controller.eventDetail!.data!
                                                              .user!.isDelete ==
                                                          null
                                                      ? () {
                                                          _controller
                                                              .checkBoxValue
                                                              .value = false;
                                                          showDialog(
                                                              barrierColor: Colors
                                                                  .transparent,
                                                              context: context,
                                                              barrierDismissible:
                                                                  true,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertWidget(
                                                                  height:
                                                                      Get.height *
                                                                          .45,
                                                                  container:
                                                                      SizedBox(
                                                                    width: Get
                                                                        .width,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              12.0,
                                                                          horizontal:
                                                                              4),
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "Disclaimer",
                                                                              style: poppinsMediumStyle(
                                                                                fontSize: 20,
                                                                                context: context,
                                                                                color: theme.primaryColor,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Text(
                                                                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
                                                                              maxLines: 8,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: poppinsMediumStyle(
                                                                                fontSize: 13,
                                                                                context: context,
                                                                                color: theme.primaryColor,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Obx(
                                                                                  () => Theme(
                                                                                    data: Theme.of(context).copyWith(
                                                                                      unselectedWidgetColor: Colors.white,
                                                                                    ),
                                                                                    child: SizedBox(
                                                                                      width: 30,
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
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 2.0),
                                                                                    child: Text(
                                                                                      'i have read and agree to the terms and conditions',
                                                                                      style: poppinsRegularStyle(
                                                                                        fontSize: 13,
                                                                                        context: context,
                                                                                        color: theme.primaryColor,
                                                                                      ),
                                                                                      maxLines: 2,
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            CustomButton(
                                                                              heights: 35,
                                                                              text: "Accept",
                                                                              fontSized: 12,
                                                                              onTap: () async {
                                                                                if (_controller.checkBoxValue.value) {
                                                                                  await _homeController.getAllCards().then((_) async {
                                                                                    _controller.selectedCardId = null;
                                                                                    _controller.update();
                                                                                    if (_homeController.transactionData.isEmpty) {
                                                                                      bottomToast(text: "Please Add At Least One Card To Accept Event");
                                                                                    } else {
                                                                                      final isCardSelected = await showBottomSelectedCardSheet(context);
                                                                                      if (isCardSelected == true) {
                                                                                        _controller.eventAcceptDeclineFtn(
                                                                                          id: controller.eventDetail!.data!.id,
                                                                                          status: "accepted",
                                                                                        );
                                                                                      } else {
                                                                                        bottomToast(text: "You didn't select any card");
                                                                                      }
                                                                                    }
                                                                                  });
                                                                                } else {
                                                                                  bottomToast(text: "Please agree with the disclaimer to accept the event request");
                                                                                }
                                                                              },
                                                                              color2: DynamicColor.greenClr.withValues(alpha: 0.8),
                                                                              color1: DynamicColor.greenClr.withValues(alpha: 0.8),
                                                                              widths: Get.width / 1.4,
                                                                              backgroundClr: false,
                                                                              borderClr: Colors.transparent,
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
                                              color2: controller
                                                          .eventDetail!
                                                          .data!
                                                          .user!
                                                          .isDelete ==
                                                      null
                                                  ? DynamicColor.greenClr
                                                      .withValues(alpha: 0.8)
                                                  : DynamicColor.disabledColor,
                                              color1: controller
                                                          .eventDetail!
                                                          .data!
                                                          .user!
                                                          .isDelete ==
                                                      null
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                      const SizedBox(
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
                      customWidget(context, theme,
                          title: "Price",
                          value: controller.eventDetail!.data!.balanceDue
                              .toString()),
                      customWidget(context, theme,
                          title: "Rating",
                          value: controller.eventDetail!.data!.rate.toString()),
                      const SizedBox(
                        height: 5,
                      ),
                      sp.read('role') == "eventManager"
                          ? const SizedBox.shrink()
                          : Obx(
                              () => _authController.followingLoader.value ==
                                      false
                                  ? const SizedBox.shrink()
                                  : controller.eventDetail!.data!.venue != null
                                      ? aboutEventCreator(
                                          isDelete: controller.eventDetail!.data!.venue!.user!.isDelete == null
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
                                          horizontalPadding: 0,
                                          theme: theme,
                                          context: context,
                                          image: controller.eventDetail!.data!.venue!.user!.profilePicture != null
                                              ? controller
                                                  .eventDetail!
                                                  .data!
                                                  .venue!
                                                  .user!
                                                  .profilePicture!
                                                  .mediaPath
                                                  .toString()
                                              : groupPlaceholder,
                                          organizerName: controller.eventDetail!
                                              .data!.venue!.venueName
                                              .toString(),
                                          icons: controller.eventDetail!.data!.venue!.user!.following == null
                                              ? Icons.check
                                              : Icons.add,
                                          followBg:
                                              controller.eventDetail!.data!.venue!.user!.following != null
                                                  ? DynamicColor.avatarBgClr
                                                  : DynamicColor.grayClr,
                                          textClr: controller.eventDetail!.data!.venue!.user!.following == null
                                              ? theme.scaffoldBackgroundColor
                                              : theme.primaryColor,
                                          text: controller.eventDetail!.data!.venue!.user!.profile!.about.toString(),
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
                                          })
                                      : const SizedBox(),
                            ),

                      sp.read('role') == "eventOrganizer"
                          ? const SizedBox.shrink()
                          : Obx(
                              () => _authController.followingLoader.value ==
                                      false
                                  ? const SizedBox.shrink()
                                  : ourGuestWidget(
                                      isDelete:
                                          controller.eventDetail!.data!.user!.isDelete == null
                                              ? false
                                              : true,
                                      onTap: () {
                                        Get.toNamed(Routes.viewProfileScreen,
                                            arguments: {
                                              "eventDetails":
                                                  controller.eventDetail!.data!,
                                              "eventId": controller
                                                  .eventDetail!.data!.userId
                                            });
                                      },
                                      networkImg:
                                          controller.eventDetail!.data!.user!.profilePicture == null
                                              ? groupPlaceholder
                                              : controller
                                                  .eventDetail!
                                                  .data!
                                                  .user!
                                                  .profilePicture!
                                                  .mediaPath
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
                      if (controller.eventDetail!.data!.location != null) ...[
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
                      ],
                      const SizedBox(
                        height: 15,
                      ),
                      if (controller.eventDetail!.data!.services!.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
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
                                      itemCount: controller
                                          .eventDetail!.data!.services!.length,
                                      itemBuilder:
                                          (BuildContext context, indx) {
                                        return customList(
                                            context: context,
                                            theme: theme,
                                            name: controller.eventDetail!.data!
                                                .services![indx].eventItem!.name
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
                                    itemCount: controller.eventDetail!.data!
                                        .hardwareProvide!.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, index) {
                                      final filterItem = controller
                                          .eventDetail!
                                          .data!
                                          .hardwareProvide![index]
                                          .hardwareItems!
                                          .where(
                                              (data) => data.selected == true)
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
                                                    .hardwareProvide![index]
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
                              if (controller.eventDetail!.data!.musicGenre!.any(
                                  (genre) =>
                                      genre.musicGenreItems?.any(
                                          (item) => item.selected == true) ??
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller
                                        .eventDetail!.data!.musicGenre!.length,
                                    itemBuilder: (BuildContext context, index) {
                                      final filterItem = controller
                                          .eventDetail!
                                          .data!
                                          .musicGenre![index]
                                          .musicGenreItems!
                                          .where(
                                              (data) => data.selected == true)
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
                                                controller.eventDetail!.data!
                                                    .musicGenre![index].name
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, index) {
                                      final filterItem = controller
                                          .eventDetail!
                                          .data!
                                          .eventMusicChoiceTags![index]
                                          .musicChoiceItems!
                                          .categoryItems!
                                          .where((data) =>
                                              data.userSelection == true)
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
                                                    .eventMusicChoiceTags![
                                                        index]
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
                                    itemCount: controller.eventDetail!.data!
                                        .eventActivityChoiceTags!.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, index) {
                                      final filterItem = controller
                                          .eventDetail!
                                          .data!
                                          .eventActivityChoiceTags![index]
                                          .activityChoiceItems!
                                          .categoryItems!
                                          .where((data) =>
                                              data.userSelection == true)
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
                                                    .eventActivityChoiceTags![
                                                        index]
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
                        ),
                      const SizedBox(
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
                      const SizedBox(
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
}
