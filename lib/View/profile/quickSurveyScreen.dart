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

import '../../model/my_groovkin_model.dart';
import '../GroovkinUser/survey/surveyModel.dart';

class QuickSurveyScreen extends StatefulWidget {
  const QuickSurveyScreen({super.key});

  @override
  State<QuickSurveyScreen> createState() => _QuickSurveyScreenState();
}

class _QuickSurveyScreenState extends State<QuickSurveyScreen> {
  late final Map<String, dynamic> args;

  late final int addMoreSurvey;
  late final String appBarTitle;
  late final bool isFromEvent;
  late final bool isFromGroovkin;

  bool createEvent = false;

  final AuthController _controller = Get.find();

  late final EventController _eventController;
  late final HomeController _homeController;

  @override
  void initState() {
    super.initState();

    args = Get.arguments ?? {};

    addMoreSurvey = args['addMoreService'] ?? 0;
    appBarTitle = args['title'] ?? "Lifestyle Survey";
    isFromEvent = args['isFromEvent'] ?? false;
    isFromGroovkin = args['isFromGroovkin'] ?? false;

    _controller.myGroockingMusicListing = args['isMusic'] ?? [];

    if (addMoreSurvey == 1) {
      createEvent = args['createEvent'] ?? false;
    }

    _eventController = Get.isRegistered<EventController>()
        ? Get.find<EventController>()
        : Get.put(EventController());

    _homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final showDraftIcon = _eventController.eventDetail == null &&
        _eventController.draftCondition.value;

    return Scaffold(
      appBar: customAppBar(
        onTap: Get.back,
        theme: theme,
        text: appBarTitle,
        style: poppinsMediumStyle(
          fontSize: 17,
          context: context,
          color: theme.primaryColor,
        ),
        actions: [
          if (showDraftIcon)
            GestureDetector(
              onTap: () {
                _eventController.postEventFunction(
                  context,
                  theme,
                  draft: true,
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.drafts),
              ),
            ),
        ],
      ),
      body: GetBuilder<AuthController>(
        initState: (_) {
          _controller.getLifeStyle(
            surveyType: "music_genre",
            mygrookinHit: isFromGroovkin,
          );
        },
        builder: (controller) {
          final loaded = controller.getLifeStyleLoader.value &&
              controller.getAllServiceLoader.value;

          if (!loaded) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                _buildHeader(context, theme),
                const SizedBox(height: 15),
                Expanded(
                  child: _buildSurveyList(controller, theme),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: _onNextTap,
            text: _buttonText(),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Text(
            isFromEvent
                ? "Indicate the type of music\nyou are proposing for this event."
                : ((addMoreSurvey == 1) &&
                        (sp.read("role") == "eventOrganizer"))
                    ? "Let us know more about\nyour lifestyle preference"
                    : "Music Genre",
            textAlign: TextAlign.center,
            style: poppinsRegularStyle(
              fontSize: 16,
              context: context,
              color: theme.primaryColor,
            ),
          ),
          Text(
            "Please select from given option.",
            style: poppinsRegularStyle(
              fontSize: 12,
              context: context,
              color: DynamicColor.lightRedClr,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveyList(
    AuthController controller,
    ThemeData theme,
  ) {
    final surveys = controller.surveyData?.data ?? [];

    return ListView.builder(
      itemCount: surveys.length,
      itemBuilder: (context, index) {
        final survey = surveys[index];

        return Column(
          children: [
            musicGenreWidget(
              context: context,
              theme: theme,
              text: survey.name.toString(),
              icon: survey.showItems!.value
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              onTap: () {
                survey.showItems!.value = !survey.showItems!.value;
                controller.update();
              },
            ),
            _buildCategoryList(
              survey,
              controller,
              theme,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryList(
    dynamic survey,
    AuthController controller,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Visibility(
        visible: survey.showItems!.value,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: DynamicColor.dropDownClr,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: survey.categoryItems!.length,
            itemBuilder: (context, itemIndex) {
              final item = survey.categoryItems![itemIndex];

              return Column(
                children: [
                  Row(
                    children: [
                      Text(
                        item.name.toString(),
                        style: poppinsRegularStyle(
                          fontSize: 12,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      const Spacer(),
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.white,
                        ),
                        child: Checkbox(
                          activeColor: DynamicColor.yellowClr,
                          value: item.selectedItem!.value,
                          onChanged: (value) {
                            _onItemSelected(
                              controller,
                              survey,
                              item,
                              value,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _onItemSelected(
    AuthController controller,
    dynamic survey,
    dynamic item,
    bool? value,
  ) {
    if (isFromGroovkin) {
      controller.myGroovkingMusicGenerFunction(
        surveyObj: survey,
        value: value,
        items: item,
      );
    } else {
      controller.surveyAddFtn(
        surveyObj: survey,
        value: value,
        items: item,
      );
    }
  }

  String _buttonText() {
    if ((sp.read("role") == "User") && (appBarTitle == 'Edit Music Genre')) {
      return "Save";
    }

    if (addMoreSurvey == 2 && (sp.read("role") != "User")) {
      return "Update";
    }

    return "Next";
  }

  Future<void> _onNextTap() async {
    if (isFromGroovkin) {
      await _controller.myGroovkinMusicGenreUpdate();
      await _homeController.getMyGroovkinData();

      bottomToast(
        text: "Music Genre Updated Successfully",
      );

      Get.back();
      return;
    }

    if (sp.read("role") == "User") {
      if (addMoreSurvey == 2) {
        Get.back();
      } else {
        if (_controller.itemsList.isNotEmpty) {
          _controller.makeMethodHit(
            navigation: "music",
          );
        } else {
          bottomToast(
            text: "Please add life style for survey",
          );
        }
      }
      return;
    }

    if (addMoreSurvey == 2) {
      Get.back();
      Get.back();
      return;
    }

    if (createEvent) {
      if (_controller.surveyData != null &&
          _controller.surveyData!.data!.isNotEmpty) {
        _controller.itemsList.clear();
        for (int i = 0; i < _controller.surveyData!.data!.length; i++) {
          final list = _controller.surveyData!.data![i].categoryItems
              ?.where((e) => e.selectedItem!.value)
              .toList();

          if (list != null) {
            _controller.itemsList.addAll(list);
          }
        }
      }
      if (_controller.itemsList.isNotEmpty) {
        if (_eventController.eventDetail != null) {
          await _eventController.getHashtagCollectionApi(
            type: "music_choice",
          );
        }

        Get.toNamed(Routes.musicChoiceScreen);
      } else {
        bottomToast(
          text: "Please add life style for survey",
        );
      }
    } else {
      if (_controller.itemsList.isNotEmpty) {
        _controller.createEvent();
      } else {
        bottomToast(
          text: "Please add life style for survey",
        );
      }
    }
  }

  Widget musicGenreWidget({
    required BuildContext context,
    required ThemeData theme,
    required String text,
    GestureTapCallback? onTap,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: DynamicColor.secondaryClr,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: poppinsMediumStyle(
              fontSize: 16,
              context: context,
              color: theme.primaryColor,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Icon(
              icon,
              size: 30,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
