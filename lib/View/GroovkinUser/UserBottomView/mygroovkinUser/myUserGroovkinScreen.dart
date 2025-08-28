import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';

class MyUsergroovkinscreen extends StatefulWidget {
  const MyUsergroovkinscreen({super.key});

  @override
  State<MyUsergroovkinscreen> createState() => _MyUsergroovkinscreenState();
}

class _MyUsergroovkinscreenState extends State<MyUsergroovkinscreen> {
  late HomeController homeController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<HomeController>()) {
      homeController = Get.find<HomeController>();
    } else {
      homeController = Get.put(HomeController());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<HomeController>(initState: (state) async {
      await homeController.fetchLifeSyle();
      await homeController.fetchMusicGenre();
    }, builder: (controller) {
      return Scaffold(
        appBar: customAppBar(
          theme: theme,
          text: "My Groovkin",
          backArrow: false,
        ),
        body: (controller.getSurveyLifeStyleLoader.value == false ||
                controller.getSurveyMusicGenreLoader.value == false)
            ? SizedBox()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),

                    // Life Style
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 18),
                      color: DynamicColor.avatarBgClr.withValues(alpha: 0.44),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Life Style",
                            style: poppinsRegularStyle(
                              fontSize: 16,
                              color: DynamicColor.lightRedClr,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.editUserLifeStyleScreen);
                            },
                            child:
                                Icon(Icons.edit, color: DynamicColor.yellowClr),
                          )
                        ],
                      ),
                    ),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data =
                            controller.surveyLifyStyleData!.data![index];
                        final filteredItems = data.categoryItems
                                ?.where(
                                    (item) => item.userCategoryItems != null)
                                .toList() ??
                            [];
                        // If no valid items, skip showing this category
                        if (filteredItems.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, top: 6),
                              child: Text(
                                data.name ?? "",
                                style: poppinsRegularStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: theme.primaryColor,
                                    context: context),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final filteredItems = data.categoryItems
                                        ?.where((item) =>
                                            item.userCategoryItems != null)
                                        .toList() ??
                                    [];
                                final lifeStyle = filteredItems[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 12.0, top: 6),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3.0),
                                        child: Text(
                                          lifeStyle.name ?? "",
                                          style: poppinsRegularStyle(
                                              fontSize: 13,
                                              color: theme.primaryColor,
                                              context: context),
                                        ),
                                      ),
                                      Icon(
                                        Icons.check,
                                        color: DynamicColor.lightRedClr,
                                        size: 17,
                                      )
                                    ],
                                  ),
                                );
                              },
                              itemCount: data.categoryItems
                                      ?.where((item) =>
                                          item.userCategoryItems != null)
                                      .toList()
                                      .length ??
                                  0,
                            )
                          ],
                        );
                      },
                      itemCount: controller.surveyLifyStyleData!.data!.length,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // Music Genre
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 18),
                      color: DynamicColor.avatarBgClr.withValues(alpha: 0.44),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Music Genre",
                            style: poppinsRegularStyle(
                              fontSize: 16,
                              color: DynamicColor.lightRedClr,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                  Routes.myusergroonvkinmusicgenrescreen);
                            },
                            child:
                                Icon(Icons.edit, color: DynamicColor.yellowClr),
                          ),
                        ],
                      ),
                    ),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data =
                            controller.surveyMusicGenreData!.data![index];
                        final filteredItems = data.categoryItems
                                ?.where(
                                    (item) => item.userCategoryItems != null)
                                .toList() ??
                            [];
                        // If no valid items, skip showing this category
                        if (filteredItems.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, top: 6),
                              child: Text(
                                data.name ?? "",
                                style: poppinsRegularStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: theme.primaryColor,
                                    context: context),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final filteredItems = data.categoryItems
                                        ?.where((item) =>
                                            item.userCategoryItems != null)
                                        .toList() ??
                                    [];
                                final lifeStyle = filteredItems[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 12.0, top: 6),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3.0),
                                        child: Text(
                                          lifeStyle.name ?? "",
                                          style: poppinsRegularStyle(
                                              fontSize: 13,
                                              color: theme.primaryColor,
                                              context: context),
                                        ),
                                      ),
                                      Icon(
                                        Icons.check,
                                        color: DynamicColor.lightRedClr,
                                        size: 17,
                                      )
                                    ],
                                  ),
                                );
                              },
                              itemCount: data.categoryItems
                                      ?.where((item) =>
                                          item.userCategoryItems != null)
                                      .toList()
                                      .length ??
                                  0,
                            )
                          ],
                        );
                      },
                      itemCount: controller.surveyMusicGenreData!.data!.length,
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
