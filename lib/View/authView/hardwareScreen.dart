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

class HardwareScreen extends StatefulWidget {
  const HardwareScreen({super.key});

  @override
  State<HardwareScreen> createState() => _HardwareScreenState();
}

class _HardwareScreenState extends State<HardwareScreen> {
  late HomeController _homeController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<HomeController>()) {
      _homeController = Get.find<HomeController>();
    } else {
      _homeController = Get.put(HomeController());
    }
    _controller.myGroovkingHardwareListing = Get.arguments?["isHardware"] ?? [];
  }

  final AuthController _controller = Get.find();

  bool createEventValue = Get.arguments['createEvent'];

  bool isFromGroovkin = Get.arguments?["isFromGroovkin"] ?? false;

  final EventController _eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Hardware", actions: [
        ((_eventController.eventDetail == null) &&
                (_eventController.draftCondition.value == true))
            ? GestureDetector(
                onTap: () {
                  _eventController.postEventFunction(context, theme,
                      draft: true);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.drafts),
                ),
              )
            : const SizedBox.shrink()
      ]),
      body: GetBuilder<AuthController>(initState: (v) {
        _controller.getAllService(
          type: "hardware_provided",
          mygrookinHit:
              _controller.myGroovkingHardwareListing.isNotEmpty ? true : false,
        );
      }, builder: (controller) {
        return controller.getAllServiceLoader.value == false
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Hardware that can be provided by you?',
                        style: poppinsRegularStyle(
                          fontSize: 16,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      Text(
                        'Please tap to select',
                        style: poppinsRegularStyle(
                          fontSize: 11,
                          context: context,
                          color: DynamicColor.lightRedClr,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.hardwareListing.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: hardwareWidget(
                                    text: controller.hardwareListing[index].name
                                        .toString(),
                                    theme: theme,
                                    context: context,
                                    onTap: () {
                                      controller.hardwareListing[index]
                                              .showItems!.value =
                                          !controller.hardwareListing[index]
                                              .showItems!.value;
                                      controller.update();
                                    },
                                    icon: controller.hardwareListing[index]
                                            .showItems!.value
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Visibility(
                                    visible: controller.hardwareListing[index]
                                        .showItems!.value,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 12),
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.centerRight,
                                            end: Alignment.centerLeft,
                                            colors: [
                                              Color(0xff151415),
                                              Color(0xff232223),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: DynamicColor.whiteClr
                                                .withOpacity(0.5),
                                          )),
                                      child: ListView.builder(
                                          itemCount: controller
                                              .hardwareListing[index]
                                              .categoryItems!
                                              .length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder:
                                              (BuildContext context, indexes) {
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      controller
                                                          .hardwareListing[
                                                              index]
                                                          .categoryItems![
                                                              indexes]
                                                          .name
                                                          .toString(),
                                                      style:
                                                          poppinsRegularStyle(
                                                              fontSize: 12,
                                                              color: theme
                                                                  .primaryColor,
                                                              context: context),
                                                    ),
                                                    const Spacer(),
                                                    Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        unselectedWidgetColor:
                                                            Colors.white,
                                                      ),
                                                      child: SizedBox(
                                                        height: 40,
                                                        width: 25,
                                                        child: Checkbox(
                                                            activeColor:
                                                                DynamicColor
                                                                    .yellowClr,
                                                            value: controller
                                                                .hardwareListing[
                                                                    index]
                                                                .categoryItems![
                                                                    indexes]
                                                                .selectedItem!
                                                                .value,
                                                            onChanged: (v) {
                                                              if (_controller
                                                                  .hardwareCategoryId
                                                                  .isEmpty) {
                                                                controller.hardwareFunction(
                                                                    serviceObj: controller
                                                                        .hardwareListing[
                                                                            index]
                                                                        .categoryItems![indexes],
                                                                    value: v);
                                                              } else {
                                                                controller
                                                                    .myGroovkinhardwareFunction(
                                                                  serviceObj: controller
                                                                      .hardwareListing[
                                                                          index]
                                                                      .categoryItems![indexes],
                                                                  value: v,
                                                                );
                                                              }
                                                            }),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                  height: 1,
                                                  color: DynamicColor.grayClr
                                                      .withOpacity(0.3),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
      }),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () async {
              // Get.toNamed(Routes.surveyLifeStyleScreen,
              //   arguments: {
              //     "update": false
              //   }
              // );

              if (isFromGroovkin == true) {
                // print(_controller.hardwareCategoryId);
                // for (var data in _controller.hardwareCategory) {
                //   print(data.selectedItem);
                // }
                _controller.updateGroovkinghardware().then((_) {
                  _homeController.getMyGroovkinData().then((_) {
                    bottomToast(text: "Hardware Updated Successfully");
                    Get.back();
                  });
                });
              } else {
                if (_controller.eventItemsList.isNotEmpty) {
                  // if(_eventController.eventDetail != null){
                  //  await _controller.getLifeStyle(surveyType: "music_genre");
                  // }
                  Get.toNamed(Routes.quickSurveyScreen, arguments: {
                    "addMoreService": 1,
                    "createEvent": createEventValue,
                    "title": "Music Choice!",
                    "isFromEvent": true,
                  });
                } else {
                  bottomToast(
                      text: "Please select hardware that can be provided");
                }
              }
            },
            text: isFromGroovkin == true ? "Update" : "Next",
          ),
        ),
      ),
    );
  }

  Widget hardwareWidget(
      {theme, context, text, GestureTapCallback? onTap, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage("assets/grayClor.png"), fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.primaryColor, width: 0.7)),
      child: Row(
        children: [
          Text(
            text ?? 'Video / Audio',
            style: poppinsRegularStyle(
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
          )
        ],
      ),
    );
  }
}

class AddMoreHardwareScreen extends StatelessWidget {
  AddMoreHardwareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Hardware"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Hardware that provided by you!',
                style: poppinsRegularStyle(
                  fontSize: 16,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
              Text(
                'Please Tap to change.',
                style: poppinsRegularStyle(
                  fontSize: 11,
                  context: context,
                  color: DynamicColor.lightRedClr,
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: Get.height / 1.4,
                  child: ListView.builder(
                      itemCount: list.length,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, index) {
                        return Obx(
                          () => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: GestureDetector(
                              onTap: () {
                                list[index].selectedValue!.value =
                                    !list[index].selectedValue!.value;
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        list[index].selectedValue!.value != true
                                            ? Colors.transparent
                                            : DynamicColor.grayClr,
                                    image:
                                        list[index].selectedValue!.value == true
                                            ? null
                                            : const DecorationImage(
                                                image: AssetImage(
                                                    "assets/grayClor.png"),
                                                fit: BoxFit.fill)),
                                child: Row(
                                  children: [
                                    Text(
                                      list[index].text.toString(),
                                      style: poppinsRegularStyle(
                                        fontSize: 12,
                                        context: context,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                    const Spacer(),
                                    list[index].selectedValue!.value != true
                                        ? const SizedBox.shrink()
                                        : Icon(
                                            Icons.check,
                                            color: DynamicColor.blackClr,
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: CustomButton(
          onTap: () {
            Get.back();
          },
          text: "Update",
        ),
      ),
    );
  }

  List<HardwareClass> list = [
    HardwareClass(text: "Vinyl Turntables", selectedValue: false.obs),
    HardwareClass(text: "CD Turntables", selectedValue: false.obs),
    HardwareClass(
        text: "Club Lighting for Small to Med Room", selectedValue: false.obs),
    HardwareClass(
        text: "Club Lighting for Med to Large Room", selectedValue: false.obs),
    HardwareClass(
        text: "Audio Amplifier and Speakers (Small Room)",
        selectedValue: false.obs),
    HardwareClass(
        text: "Audio Amplifier and Speakers (Med Room)",
        selectedValue: false.obs),
    HardwareClass(
        text: "Audio Amplifier and Speakers (Large Room)",
        selectedValue: false.obs),
    HardwareClass(
        text: "Video  Projector and Screen (5’x8’)", selectedValue: false.obs),
    HardwareClass(
        text: "Video  Projector and Screen (8’x10’)", selectedValue: false.obs),
    HardwareClass(text: "Vinyl Turntables", selectedValue: false.obs),
    HardwareClass(text: "CD Turntables", selectedValue: false.obs),
    HardwareClass(
        text: "Club Lighting for Small to Med Room", selectedValue: false.obs),
    HardwareClass(
        text: "Club Lighting for Med to Large Room", selectedValue: false.obs),
    HardwareClass(
        text: "Audio Amplifier and Speakers (Small Room)",
        selectedValue: false.obs),
    HardwareClass(
        text: "Audio Amplifier and Speakers (Med Room)",
        selectedValue: false.obs),
    HardwareClass(
        text: "Audio Amplifier and Speakers (Large Room)",
        selectedValue: false.obs),
    HardwareClass(
        text: "Video  Projector and Screen (5’x8’)", selectedValue: false.obs),
    HardwareClass(
        text: "Video  Projector and Screen (8’x10’)", selectedValue: false.obs),
    HardwareClass(text: "Vinyl Turntables", selectedValue: false.obs),
    HardwareClass(text: "CD Turntables", selectedValue: false.obs),
    HardwareClass(
        text: "Club Lighting for Small to Med Room", selectedValue: false.obs),
    HardwareClass(
        text: "Club Lighting for Med to Large Room", selectedValue: false.obs),
    HardwareClass(
        text: "Audio Amplifier and Speakers (Small Room)",
        selectedValue: false.obs),
    HardwareClass(
        text: "Audio Amplifier and Speakers (Med Room)",
        selectedValue: false.obs),
    HardwareClass(
        text: "Audio Amplifier and Speakers (Large Room)",
        selectedValue: false.obs),
    HardwareClass(
        text: "Video  Projector and Screen (5’x8’)", selectedValue: false.obs),
    HardwareClass(
        text: "Video  Projector and Screen (8’x10’)", selectedValue: false.obs),
    HardwareClass(text: "Vinyl Turntables", selectedValue: false.obs),
    HardwareClass(text: "CD Turntables", selectedValue: false.obs),
    HardwareClass(
        text: "Club Lighting for Small to Med Room", selectedValue: false.obs),
    HardwareClass(
        text: "Club Lighting for Med to Large Room", selectedValue: false.obs),
    HardwareClass(
        text: "Audio Amplifier and Speakers (Small Room)",
        selectedValue: false.obs),
    HardwareClass(
        text: "Audio Amplifier and Speakers (Med Room)",
        selectedValue: false.obs),
    HardwareClass(
        text: "Audio Amplifier and Speakers (Large Room)",
        selectedValue: false.obs),
    HardwareClass(
        text: "Video  Projector and Screen (5’x8’)", selectedValue: false.obs),
    HardwareClass(
        text: "Video  Projector and Screen (8’x10’)", selectedValue: false.obs),
  ];
}

class HardwareClass {
  String? text;
  RxBool? selectedValue = false.obs;
  HardwareClass({this.text, this.selectedValue});
}
