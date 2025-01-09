import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';

class MusicChoiceScreen extends StatelessWidget {
  MusicChoiceScreen({super.key});

  EventController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Create Event", actions: [
        ((_controller.eventDetail == null) &&
                (_controller.draftCondition.value == true))
            ? GestureDetector(
                onTap: () {
                  _controller.postEventFunction(context, theme, draft: true);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.drafts),
                ),
              )
            : SizedBox.shrink()
      ]),
      body: GetBuilder<EventController>(initState: (v) {
        if (_controller.eventDetail != null) {
          _controller.musicChoiceBinding();
        } else {
          _controller.getMusicTag(type: "music_choice");
        }
      }, builder: (controller) {
        return controller.getMusicTagLoader.value == false
            ? SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Add Hashtags',
                          textAlign: TextAlign.center,
                          style: poppinsRegularStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            context: context,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      Text(
                        'Adding Tags to your proposal will give the Groovkin community a better understanding of your event!',
                        textAlign: TextAlign.center,
                        style: poppinsRegularStyle(
                          fontSize: 12,
                          context: context,
                          color: DynamicColor.lightRedClr,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SearchTextFields(
                        controller: TextEditingController(),
                        searchIcon: false,
                        hintText: "add tags",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "90’s Hip Hop Party",
                            style: poppinsRegularStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              context: context,
                              color: theme.primaryColor,
                            ),
                          ),
                          CustomButtonWithIcon(
                            // bgColor: null,
                            bgColor: DynamicColor.secondaryClr,
                            width: 90,
                            height: 30,
                            borderRadius: 5,
                            iconValue: false,
                            iconss: Icons.bookmark,
                            iconsClr: theme.primaryColor,
                            text: "Save",
                            onTap: () {
                              Get.toNamed(Routes.saveHashTagScreen, arguments: {
                                "musicHashTag": true,
                              });
                            },
                          ),
                        ],
                      ),
                      controller.tagListPost.isEmpty
                          ? SizedBox.shrink()
                          : SizedBox(
                              height: kToolbarHeight,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: ListView.builder(
                                    itemCount: controller.tagListPost.length,
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Chip(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            backgroundColor:
                                                DynamicColor.whiteClr,
                                            label: Text(
                                              controller.tagListPost[index].name
                                                  .toString(),
                                              style: poppinsRegularStyle(
                                                fontSize: 12,
                                                context: context,
                                                color: theme
                                                    .scaffoldBackgroundColor,
                                              ),
                                            )),
                                      );
                                    }),
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "My Tags Collection",
                          style: poppinsRegularStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            context: context,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 8),
                          child: ListView.builder(
                              itemCount: controller.tagList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller.tagList[index].showSubCat!
                                                  .value =
                                              !controller.tagList[index]
                                                  .showSubCat!.value;
                                          controller.update();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: DynamicColor.darkGrayClr,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                controller.tagList[index].name
                                                    .toString(),
                                                style: poppinsRegularStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  context: context,
                                                  color: theme.primaryColor,
                                                ),
                                              ),
                                              Icon(
                                                controller.tagList[index]
                                                        .showSubCat!.value
                                                    ? Icons
                                                        .keyboard_arrow_up_outlined
                                                    : Icons
                                                        .keyboard_arrow_down_sharp,
                                                color: DynamicColor.whiteClr,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                          visible: controller
                                              .tagList[index].showSubCat!.value,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: DynamicColor.darkGrayClr,
                                              ),
                                              child: ListView.builder(
                                                  itemCount: controller
                                                      .tagList[index]
                                                      .categoryItems!
                                                      .length,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          indexess) {
                                                    return Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: DynamicColor
                                                                .darkGrayClr,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                controller
                                                                    .tagList[
                                                                        index]
                                                                    .categoryItems![
                                                                        indexess]
                                                                    .name
                                                                    .toString(),
                                                                style:
                                                                    poppinsRegularStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  context:
                                                                      context,
                                                                  color: theme
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                              Theme(
                                                                data: Theme.of(
                                                                        context)
                                                                    .copyWith(
                                                                  unselectedWidgetColor:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                                child: Checkbox(
                                                                    activeColor:
                                                                        DynamicColor
                                                                            .yellowClr,
                                                                    value: controller
                                                                        .tagList[
                                                                            index]
                                                                        .categoryItems![
                                                                            indexess]
                                                                        .selected!
                                                                        .value,
                                                                    onChanged:
                                                                        (v) {
                                                                      controller.tagAddFtn(
                                                                          items: controller.tagList[index].categoryItems![
                                                                              indexess],
                                                                          value:
                                                                              v);
                                                                    }),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: DynamicColor
                                                              .whiteClr,
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                          ))
                                    ],
                                  ),
                                );
                              }))
                    ],
                  ),
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
              if (_controller.tagListPost.isNotEmpty) {
                if (_controller.eventDetail != null) {
                  await _controller.getMusicTag(type: "activity_choice");
                }
                Get.toNamed(Routes.activityChoiceScreen);
              } else {
                bottomToast(text: "Please add music event");
              }
              // Get.toNamed(Routes.eventPreview,
              // arguments: {
              //   "viewDetails": 1
              // }
              // );
            },
            text: "Continue",
          ),
        ),
      ),
    );
  }
}

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Activity Choice

class ActivityChoiceScreen extends StatelessWidget {
  ActivityChoiceScreen({super.key});

  EventController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Create Event", actions: [
        ((_controller.eventDetail == null) &&
                (_controller.draftCondition.value == true))
            ? GestureDetector(
                onTap: () {
                  _controller.postEventFunction(context, theme, draft: true);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.drafts),
                ),
              )
            : SizedBox.shrink()
      ]),
      body: GetBuilder<EventController>(initState: (v) {
        if (_controller.eventDetail != null) {
          _controller.activityChoice();
        } else {
          _controller.getMusicTag(type: "activity_choice");
        }
      }, builder: (controller) {
        return controller.getMusicTagLoader.value == false
            ? SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Activity Choice!',
                            textAlign: TextAlign.center,
                            style: poppinsRegularStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              context: context,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Adding Tags to your proposal will give the Groovkin community a better understanding of your event!',
                        textAlign: TextAlign.center,
                        style: poppinsRegularStyle(
                          fontSize: 12,
                          context: context,
                          color: DynamicColor.lightRedClr,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SearchTextFields(
                        controller: TextEditingController(),
                        searchIcon: false,
                        hintText: "add tags",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Foodie Pool Hall",
                            style: poppinsRegularStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              context: context,
                              color: theme.primaryColor,
                            ),
                          ),
                          CustomButtonWithIcon(
                            // bgColor: null,
                            bgColor: DynamicColor.secondaryClr,
                            width: 90,
                            height: 30,
                            onTap: () {
                              Get.toNamed(Routes.saveHashTagScreen, arguments: {
                                "musicHashTag": true,
                              });
                            },
                            borderRadius: 5,
                            iconValue: false,
                            iconss: Icons.bookmark,
                            iconsClr: theme.primaryColor,
                            text: "Save",
                          ),
                        ],
                      ),
                      controller.activityListPost.isEmpty
                          ? SizedBox.shrink()
                          : SizedBox(
                              height: kToolbarHeight,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: ListView.builder(
                                    itemCount:
                                        controller.activityListPost.length,
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Chip(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            backgroundColor:
                                                DynamicColor.whiteClr,
                                            label: Text(
                                              controller
                                                  .activityListPost[index].name
                                                  .toString(),
                                              style: poppinsRegularStyle(
                                                fontSize: 12,
                                                context: context,
                                                color: theme
                                                    .scaffoldBackgroundColor,
                                              ),
                                            )),
                                      );
                                    }),
                              ),
                            ),
                      Container(
                          padding: EdgeInsets.only(top: 8),
                          child: ListView.builder(
                              itemCount: controller.activityList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller.activityList[index]
                                                  .showSubCat!.value =
                                              !controller.activityList[index]
                                                  .showSubCat!.value;
                                          controller.update();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: DynamicColor.darkGrayClr,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                controller
                                                    .activityList[index].name
                                                    .toString(),
                                                style: poppinsRegularStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  context: context,
                                                  color: theme.primaryColor,
                                                ),
                                              ),
                                              Icon(
                                                controller.activityList[index]
                                                        .showSubCat!.value
                                                    ? Icons
                                                        .keyboard_arrow_up_outlined
                                                    : Icons
                                                        .keyboard_arrow_down_sharp,
                                                color: DynamicColor.whiteClr,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                          visible: controller
                                              .activityList[index]
                                              .showSubCat!
                                              .value,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: DynamicColor.darkGrayClr,
                                              ),
                                              child: ListView.builder(
                                                  itemCount: controller
                                                      .activityList[index]
                                                      .categoryItems!
                                                      .length,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          indexess) {
                                                    return Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      8),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: DynamicColor
                                                                .darkGrayClr,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                controller
                                                                    .activityList[
                                                                        index]
                                                                    .categoryItems![
                                                                        indexess]
                                                                    .name
                                                                    .toString(),
                                                                style:
                                                                    poppinsRegularStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  context:
                                                                      context,
                                                                  color: theme
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                              Theme(
                                                                data: Theme.of(
                                                                        context)
                                                                    .copyWith(
                                                                  unselectedWidgetColor:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                                child: Checkbox(
                                                                    activeColor:
                                                                        DynamicColor
                                                                            .yellowClr,
                                                                    value: controller
                                                                        .activityList[
                                                                            index]
                                                                        .categoryItems![
                                                                            indexess]
                                                                        .selected!
                                                                        .value,
                                                                    onChanged:
                                                                        (v) {
                                                                      controller.activityAddFtn(
                                                                          items: controller.activityList[index].categoryItems![
                                                                              indexess],
                                                                          value:
                                                                              v);
                                                                    }),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: DynamicColor
                                                              .whiteClr,
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                          ))
                                    ],
                                  ),
                                );
                              }))
                    ],
                  ),
                ),
              );
      }),
      bottomNavigationBar: SafeArea(
        bottom: Platform.isIOS ? true : false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () {
              if (_controller.activityListPost.isNotEmpty) {
                if (_controller.eventDetail != null) {
                  _controller.imageListtt.clear();
                  _controller.removeImageList.clear();
                  for (var ele
                      in _controller.eventDetail!.data!.profilePicture!) {
                    _controller.imageListtt.add(ele);
                  }
                } else {
                  _controller.imageListtt.clear();
                }
                Get.toNamed(Routes.commentsAndAttachment);
              } else {
                bottomToast(text: "Please select activity choice");
              }
            },
            text: "Continue",
          ),
        ),
      ),
    );
  }

  List<ListClass> listA = [
    ListClass(text: "90’s Hip Hop Party", condition: false.obs),
    ListClass(text: "for  night party ", condition: false.obs),
    ListClass(text: "for birthday", condition: false.obs),
    ListClass(text: "for  night party ", condition: false.obs),
    ListClass(text: "90’s Hip Hop Party", condition: false.obs),
    ListClass(text: "for  night party ", condition: false.obs),
    ListClass(text: "for birthday", condition: false.obs),
    ListClass(text: "for  night party ", condition: false.obs),
  ];
}

class SaveHashTagScreen extends StatelessWidget {
  SaveHashTagScreen({super.key});
  EventController _controller = Get.find();
  bool hashTag = Get.arguments['musicHashTag'];
  List selectedHashList = [];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
        theme: theme,
        text: "Save Hashtag",
      ),
      body: GetBuilder<EventController>(builder: (controller) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Wrap(
                children: <Widget>[
                  Chip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: DynamicColor.whiteClr,
                      label: Text(
                        "#Pooltable",
                        style: poppinsRegularStyle(
                          fontSize: 12,
                          context: context,
                          color: theme.scaffoldBackgroundColor,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Chip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: DynamicColor.whiteClr,
                        label: Text(
                          "#Billiards",
                          style: poppinsRegularStyle(
                            fontSize: 12,
                            context: context,
                            color: theme.scaffoldBackgroundColor,
                          ),
                        )),
                  ),
                  Chip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: DynamicColor.whiteClr,
                      label: Text(
                        "#Tequla",
                        style: poppinsRegularStyle(
                          fontSize: 12,
                          context: context,
                          color: theme.scaffoldBackgroundColor,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Chip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: DynamicColor.whiteClr,
                        label: Text(
                          "#8Ball",
                          style: poppinsRegularStyle(
                            fontSize: 12,
                            context: context,
                            color: theme.scaffoldBackgroundColor,
                          ),
                        )),
                  ),
                  Chip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: DynamicColor.whiteClr,
                      label: Text(
                        "#TacoTuesday",
                        style: poppinsRegularStyle(
                          fontSize: 12,
                          context: context,
                          color: theme.scaffoldBackgroundColor,
                        ),
                      )),
                ],
              ),
              Expanded(
                child: SizedBox(
                  height: Get.height / 3.15,
                  child: ListView.builder(
                      itemCount: listA.length,
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            height: 45,
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: DynamicColor.darkGrayClr,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  listA[index].text.toString(),
                                  style: poppinsRegularStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.white,
                                  ),
                                  child: Checkbox(
                                      activeColor: DynamicColor.yellowClr,
                                      value: listA[index].condition!.value,
                                      onChanged: (v) {
                                        selectedHashList
                                                .contains(listA[index].text)
                                            ? selectedHashList
                                                .remove(listA[index].text)
                                            : selectedHashList
                                                .add(listA[index].text);
                                        listA[index].condition!.value = v!;
                                        print(selectedHashList.length);
                                        controller.update();
                                      }),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Visibility(
                visible: selectedHashList.isNotEmpty ? true : false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4),
                  child: CustomButton(
                    heights: 30,
                    widths: Get.width / 2.1,
                    borderClr: Colors.transparent,
                    bgImage: "assets/grayClor.png",
                    backgroundClr: true,
                    onTap: () {
                      // Get.offAllNamed(Routes.userQuickSurveyScreen);
                    },
                    text: "Save",
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: () {
            Get.toNamed(Routes.createNewHashTagScreen);
          },
          text: "Create new Collection",
        ),
      ),
    );
  }

  List<ListClass> listA = [
    ListClass(text: "90’s Hip Hop Party", condition: false.obs),
    ListClass(text: "for  night party ", condition: false.obs),
    ListClass(text: "for birthday", condition: false.obs),
    ListClass(text: "for  night party ", condition: false.obs),
    ListClass(text: "90’s Hip Hop Party", condition: false.obs),
    ListClass(text: "for  night party ", condition: false.obs),
    ListClass(text: "for birthday", condition: false.obs),
    ListClass(text: "for  night party ", condition: false.obs),
  ];
}

class CreateNewHashTagScreen extends StatelessWidget {
  CreateNewHashTagScreen({super.key});
  List<String> _myListCustom = [];
  final hashController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
        theme: theme,
        text: "New Hashtag",
      ),
      body: GetBuilder<EventController>(builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  padding: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: DynamicColor.avatarBgClr),
                  child: TextFormField(
                    controller: hashController,
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        color: theme.primaryColor,
                        context: context),
                    decoration: InputDecoration(
                        hintText: "here", border: InputBorder.none),
                    onChanged: (v) {
                      if (v != "") {
                        if (v.contains(" ")) {
                          _myListCustom.add(v);
                          v = "";
                          hashController.clear();
                          controller.update();
                        }
                      }
                    },
                  ),
                ),
              ),
              Wrap(
                children: <Widget>[
                  for (var i in _myListCustom)
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Chip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: DynamicColor.whiteClr,
                          label: Text(
                            i,
                            style: poppinsRegularStyle(
                              fontSize: 12,
                              context: context,
                              color: theme.scaffoldBackgroundColor,
                            ),
                          )),
                    ),
                ],
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: () {
            Get.back();
          },
          text: "Save",
        ),
      ),
    );
  }
}
