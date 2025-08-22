// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';

import '../homeTabs/eventsFlow/musicChoiceView/musicChoiceModel.dart';

class MyTagCollection extends StatefulWidget {
  const MyTagCollection({super.key});

  @override
  State<MyTagCollection> createState() => _MyTagCollectionState();
}

class _MyTagCollectionState extends State<MyTagCollection> {
  final EventController _eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<EventController>(initState: (state) {
      _eventController.getEventTagCollection(type: "music_choice");
    }, builder: (controller) {
      return controller.getMyTagCollectionLoader == false
          ? SizedBox()
          : Scaffold(
              appBar: customAppBar(theme: theme, text: "My Tag Collection"),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Collection",
                        style: poppinsMediumStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      (controller.tagCollectionList == null ||
                              controller.tagCollectionList!.data == null ||
                              controller.tagCollectionList!.data!.isEmpty)
                          ? SizedBox(
                              child: Center(
                                child: noData(context: context, theme: theme),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                              itemBuilder: (context, index) {
                                final data =
                                    controller.tagCollectionList!.data![index];
                                return customWidget(
                                  theme: theme,
                                  context: context,
                                  text: data.name ?? "",
                                  onTap: () {
                                    Get.toNamed(
                                        Routes.myCollectionDetailsScreen,
                                        arguments: {"id": data.id});
                                  },
                                );
                              },
                              itemCount:
                                  controller.tagCollectionList?.data?.length ??
                                      0,
                            )
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: SafeArea(
                bottom: true,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  child: CustomButton(
                    borderClr: Colors.transparent,
                    color1: DynamicColor.blackClr,
                    color2: DynamicColor.blackClr,
                    onTap: () {
                      Get.toNamed(Routes.createNewTag,
                          arguments: {"isFromTagCollectionScreen": true});
                    },
                    text: "Create new Collection",
                  ),
                ),
              ),
            );
    });
  }

  Widget customWidget({theme, context, text, GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: DynamicColor.darkGrayClr,
        ),
        child: Text(
          text ?? "Music Tags",
          style: poppinsRegularStyle(
            fontSize: 12,
            context: context,
            color: theme.primaryColor,
          ),
        ),
      ),
    );
  }
}

class MyCollectionDetailsScreen extends StatefulWidget {
  const MyCollectionDetailsScreen({super.key});

  @override
  State<MyCollectionDetailsScreen> createState() =>
      _MyCollectionDetailsScreenState();
}

class _MyCollectionDetailsScreenState extends State<MyCollectionDetailsScreen> {
  int? id = Get.arguments?["id"];

  final _eventController = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<EventController>(initState: (state) async {
      await _eventController.getEventTagDetail(id: id);
    }, builder: (controller) {
      return _eventController.getTagCollectionDetails == false
          ? SizedBox()
          : SafeArea(
              child: Scaffold(
                appBar: customAppBar(theme: theme, text: "My Collection"),
                body: (controller.tagCollectionDetail == null ||
                        controller.tagCollectionDetail!.data == null ||
                        controller.tagCollectionDetail!.data!.isEmpty)
                    ? SizedBox(
                        child: Center(
                        child: noData(context: context, theme: theme),
                      ))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                  spacing: 10,
                                  children: controller
                                      .tagCollectionDetail!.data!
                                      .expand((tag) => tag.categoryItems ?? [])
                                      .map((data) {
                                    return Chip(
                                      backgroundColor: theme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      label: Text(
                                        '#${data.name}',
                                        style: poppinsRegularStyle(
                                            fontSize: 14,
                                            context: context,
                                            color:
                                                theme.scaffoldBackgroundColor),
                                      ),
                                    );
                                  }).toList()),
                            ],
                          ),
                        ),
                      ),
                bottomNavigationBar: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    child: CustomButton(
                      borderClr: Colors.transparent,
                      color1: DynamicColor.blackClr,
                      color2: DynamicColor.blackClr,
                      onTap: () {
                        Get.toNamed(Routes.createNewTag);
                      },
                      text: "Add More",
                    ),
                  ),
                ),
              ),
            );
    });
  }
}

class CreateNewTag extends StatefulWidget {
  const CreateNewTag({super.key});

  @override
  State<CreateNewTag> createState() => _CreateNewTagState();
}

class _CreateNewTagState extends State<CreateNewTag> {
  bool isFromTagCollectionScreen =
      Get.arguments?["isFromTagCollectionScreen"] ?? false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (isFromTagCollectionScreen) {
            Get.back();
          } else {
            Get.back();
            Get.back();
          }
        }
      },
      child: GetBuilder<EventController>(
          initState: (state) {},
          builder: (controller) {
            return Scaffold(
              appBar: customAppBar(theme: theme, text: "My Collection"),
              body: (controller.tagCollectionList == null ||
                      controller.tagCollectionList!.data == null ||
                      controller.tagCollectionList!.data!.isEmpty)
                  ? Center(
                      child: noData(context: context, theme: theme),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SearchTextFields(
                            controller: TextEditingController(),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: Get.height / 1.4,
                              child: SingleChildScrollView(
                                child: Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 10,
                                    children:
                                        (controller.tagCollectionList?.data ??
                                                [])
                                            .expand((tag) =>
                                                tag.categoryItems ??
                                                const <CategoryItem>[])
                                            .map((cat) {
                                      return InputChip(
                                        selected: cat.selected?.value ?? false,
                                        backgroundColor: theme.primaryColor,
                                        onSelected: (value) {
                                          if (cat.selected != null) {
                                            if (cat.selected == false) {
                                              cat.selected!.value = value;
                                              controller.id = cat.id.toString();
                                              controller.addTagCollection(
                                                  type: "music_choice");
                                              controller.update();
                                            } else {
                                              controller.id = cat.id.toString();
                                              cat.selected!.value = value;
                                              controller.removeTagCollection();
                                              controller.update();
                                            }
                                          }
                                        },
                                        selectedColor: DynamicColor.yellowClr,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        label: Text(
                                          '#${cat.name}',
                                          style: poppinsRegularStyle(
                                              fontSize: 14,
                                              context: context,
                                              color: theme
                                                  .scaffoldBackgroundColor),
                                        ),
                                      );
                                    }).toList()),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
              bottomNavigationBar: SafeArea(
                bottom: true,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  child: CustomButton(
                    borderClr: Colors.transparent,
                    color1: DynamicColor.blackClr,
                    color2: DynamicColor.blackClr,
                    onTap: () {
                      if (isFromTagCollectionScreen) {
                        Get.back();
                      } else {
                        Get.back();
                        Get.back();
                      }
                    },
                    text: "Save",
                  ),
                ),
              ),
            );
          }),
    );
  }
}
