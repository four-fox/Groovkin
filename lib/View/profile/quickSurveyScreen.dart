import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';

class QuickSurveyScreen extends StatefulWidget {
  QuickSurveyScreen({super.key});

  @override
  State<QuickSurveyScreen> createState() => _QuickSurveyScreenState();
}

class _QuickSurveyScreenState extends State<QuickSurveyScreen> {
  int addMoreSurvey = Get.arguments['addMoreService'];

  String appBarTitle = Get.arguments['title'] ?? "Lifestyle Survey";
  bool isFromEvent = Get.arguments["isFromEvent"] ?? false;
  bool isFromGroovkin = Get.arguments?["isFromGroovkin"] ?? false;

  bool createEvent = false;

  final AuthController _controller = Get.find();
  late EventController _eventController;

  late HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _controller.myGroockingMusicListing = Get.arguments?["isMusic"] ?? [];

    if (Get.arguments['addMoreService'] == 1) {
      createEvent = Get.arguments['createEvent'];
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
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
          onTap: () {
            Get.back();
          },
          theme: theme,
          text: appBarTitle,
          style: poppinsMediumStyle(
            fontSize: 17,
            context: context,
            color: theme.primaryColor,
            // color: DynamicColor.lightYellowClr,
          ),
          actions: [
            ((_eventController.eventDetail == null) &&
                    (_eventController.draftCondition.value == true))
                ? GestureDetector(
                    onTap: () {
                      _eventController.postEventFunction(context, theme,
                          draft: true);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.drafts),
                    ),
                  )
                : SizedBox.shrink()
          ]),
      body: GetBuilder<AuthController>(initState: (v) {
        // if((addMoreSurvey == 1) && sp.read("role")=="eventOrganizer"){
        //   _controller.getAllService(type: "lifestyle_preference");
        // }else{
        _controller.getLifeStyle(
            surveyType: "music_genre",
            mygrookinHit:
                _controller.myGroockingMusicListing.isNotEmpty ? true : false);
        // }
      }, builder: (controller) {
        return ((controller.getLifeStyleLoader.value == false) ||
                (controller.getAllServiceLoader.value == false))
            ? SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: isFromEvent
                          ? Text(
                              "Indicate the type of music\nyou are proposing for this event.",
                              textAlign: TextAlign.center,
                              style: poppinsRegularStyle(
                                fontSize: 16,
                                context: context,
                                color: theme.primaryColor,
                              ),
                            )
                          : Text(
                              ((addMoreSurvey == 1) &&
                                      (sp.read("role") == "eventOrganizer"))
                                  ? "Let us know more about\nyour lifestyle preference"
                                  : 'Music Genre',
                              textAlign: TextAlign.center,
                              style: poppinsRegularStyle(
                                fontSize: 16,
                                context: context,
                                color: theme.primaryColor,
                              ),
                            ),
                    ),
                    Text(
                      'Please select from given option.',
                      style: poppinsRegularStyle(
                        fontSize: 12,
                        context: context,
                        color: DynamicColor.lightRedClr,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: Get.height / 1.41,
                        child: ListView.builder(
                            itemCount: controller.surveyData!.data!.length,
                            itemBuilder: (BuildContext context, index) {
                              return Column(
                                children: [
                                  musicGenreWidget(
                                    text: controller
                                        .surveyData!.data![index].name
                                        .toString(),
                                    onTap: () {
                                      controller.surveyData!.data![index]
                                              .showItems!.value =
                                          !controller.surveyData!.data![index]
                                              .showItems!.value;
                                      controller.update();
                                    },
                                    theme: theme,
                                    context: context,
                                    icon: controller.surveyData!.data![index]
                                            .showItems!.value
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 4.0),
                                    child: Visibility(
                                      visible: controller.surveyData!
                                          .data![index].showItems!.value,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        decoration: BoxDecoration(
                                          color: DynamicColor.dropDownClr,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: ListView.builder(
                                            itemCount: controller
                                                .surveyData!
                                                .data![index]
                                                .categoryItems!
                                                .length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                indexxx) {
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        controller
                                                            .surveyData!
                                                            .data![index]
                                                            .categoryItems![
                                                                indexxx]
                                                            .name
                                                            .toString(),
                                                        style:
                                                            poppinsRegularStyle(
                                                                fontSize: 12,
                                                                color: theme
                                                                    .primaryColor,
                                                                context:
                                                                    context),
                                                      ),
                                                      Spacer(),
                                                      Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          unselectedWidgetColor:
                                                              Colors.white,
                                                        ),
                                                        child: Checkbox(
                                                            activeColor:
                                                                DynamicColor
                                                                    .yellowClr,
                                                            value: controller
                                                                .surveyData!
                                                                .data![index]
                                                                .categoryItems![
                                                                    indexxx]
                                                                .selectedItem!
                                                                .value,
                                                            onChanged: (v) {
                                                              // if((addMoreSurvey == 1) && sp.read("role")=="eventOrganizer"){
                                                              //   controller.lifeStyleFunction(serviceObj: controller.surveyData!.data![index].categoryItems![indexxx],value: v);
                                                              // }else{

                                                              if (isFromGroovkin ==
                                                                  true) {
                                                                controller.myGroovkingMusicGenerFunction(
                                                                    surveyObj: controller
                                                                            .surveyData!
                                                                            .data![
                                                                        index],
                                                                    value: v,
                                                                    items: controller
                                                                        .surveyData!
                                                                        .data![
                                                                            index]
                                                                        .categoryItems![indexxx]);
                                                              } else {
                                                                controller.surveyAddFtn(
                                                                    surveyObj: controller
                                                                            .surveyData!
                                                                            .data![
                                                                        index],
                                                                    value: v,
                                                                    items: controller
                                                                        .surveyData!
                                                                        .data![
                                                                            index]
                                                                        .categoryItems![indexxx]);
                                                              }

                                                              // }
                                                            }),
                                                      )
                                                    ],
                                                  ),
                                                  Divider(
                                                    height: 1,
                                                  )
                                                ],
                                              );
                                            }),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              );
      }),
      bottomNavigationBar: SafeArea(
        bottom: Platform.isIOS ? true : false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () async {
              if (isFromGroovkin == true) {
                _controller.myGroovkinMusicGenreUpdate().then((_) {
                  _homeController.getMyGroovkinData().then((_) {
                    bottomToast(text: "Music Genre Updated Successfully");
                    Get.back();
                  });
                });
              } else {
                if (sp.read("role") == "User") {
                  if (addMoreSurvey == 2) {
                    Get.back();
                  } else {
                    if (_controller.itemsList.isNotEmpty) {
                      _controller.makeMethodHit(navigation: "music");
                    } else {
                      bottomToast(text: "Please add life style for survey");
                    }
                  }
                } else {
                  if (addMoreSurvey == 2) {
                    Get.back();
                    Get.back();
                  } else {
                    if (createEvent == true) {
                      if (/*_controller.lifeStyleItemsList.isNotEmpty ||*/ _controller
                          .itemsList.isNotEmpty) {
                        if (_eventController.eventDetail != null) {
                          await _eventController.getMusicTag(
                              type: "music_choice");
                        }
                        Get.toNamed(Routes.musicChoiceScreen);
                      } else {
                        bottomToast(text: "Please add life style for survey");
                      }
                    } else {
                      if (_controller.itemsList.isNotEmpty) {
                        _controller.createEvent();
                      } else {
                        bottomToast(text: "Please add life style for survey");
                      }
                    }
                  }
                }
              }
            },
            text: ((sp.read("role") == "User") &&
                    (appBarTitle == 'Edit Music Genre'))
                ? "Save"
                : ((addMoreSurvey == 2 && (sp.read("role") != "User")))
                    ? "Update"
                    : "Next",
          ),
        ),
      ),
    );
  }

  Widget musicGenreWidget(
      {context, theme, text, GestureTapCallback? onTap, IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage("assets/buttonBg.png"),
          //     fit: BoxFit.fill
          // ),
          color: DynamicColor.secondaryClr,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Text(
            text ?? 'Hip Hop',
            style: poppinsMediumStyle(
              fontSize: 16,
              context: context,
              color: theme.primaryColor,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Icon(
              icon,
              size: 30,
              color: theme.primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
