import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';

class Myusergroovkinlifestylescreen extends StatefulWidget {
  const Myusergroovkinlifestylescreen({super.key});

  @override
  State<Myusergroovkinlifestylescreen> createState() =>
      _MyusergroovkinlifestylescreenState();
}

class _MyusergroovkinlifestylescreenState
    extends State<Myusergroovkinlifestylescreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final HomeController controller = Get.find();
    return GetBuilder<HomeController>(builder: (context) {
      return Scaffold(
        appBar: customAppBar(
            onTap: () {
              Get.back();
            },
            theme: theme,
            text: "Edit Life Style",
            style: poppinsMediumStyle(
              fontSize: 17,
              context: context,
              color: theme.primaryColor,
            )),
        body: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: Get.height / 1.47,
                child: ListView.builder(
                    itemCount: controller.surveyLifyStyleData!.data!.length,
                    itemBuilder: (BuildContext context, index) {
                      return Column(
                        children: [
                          // musicGenreWidget(
                          //   text: controller.surveyData!.data![index].name,
                          //   onTap: () {
                          //     controller.surveyData!.data![index].showItems!
                          //             .value =
                          //         !controller.surveyData!.data![index]
                          //             .showItems!.value;
                          //     controller.update();
                          //   },
                          //   theme: theme,
                          //   context: context,
                          //   icon: controller
                          //           .surveyData!.data![index].showItems!.value
                          //       ? Icons.keyboard_arrow_up
                          //       : Icons.keyboard_arrow_down,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                            child: Visibility(
                              visible: controller.surveyLifyStyleData!
                                  .data![index].showItems!.value,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //     image: AssetImage("assets/buttonBg.png"),
                                  //     fit: BoxFit.fill
                                  // ),
                                  color: DynamicColor.dropDownClr,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListView.builder(
                                    itemCount: controller.surveyLifyStyleData!
                                        .data![index].categoryItems!.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, indexxs) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                controller
                                                    .surveyLifyStyleData!
                                                    .data![index]
                                                    .categoryItems![indexxs]
                                                    .name!,
                                                style: poppinsRegularStyle(
                                                    fontSize: 12,
                                                    color: theme.primaryColor,
                                                    context: context),
                                              ),
                                              const Spacer(),
                                              Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  unselectedWidgetColor:
                                                      Colors.white,
                                                ),
                                                child: Checkbox(
                                                    activeColor:
                                                        DynamicColor.yellowClr,
                                                    value: controller
                                                        .surveyLifyStyleData!
                                                        .data![index]
                                                        .categoryItems![indexxs]
                                                        .selectedItem!
                                                        .value,
                                                    onChanged: (v) {
                                                      // controller.surveyAddFtn(
                                                      //     surveyObj: controller
                                                      //         .surveyData!
                                                      //         .data![index],
                                                      //     value: v,
                                                      //     items: controller
                                                      //             .surveyData!
                                                      //             .data![index]
                                                      //             .categoryItems![
                                                      //         indexxs]);
                                                    }),
                                              )
                                            ],
                                          ),
                                          const Divider(
                                            height: 1,
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
              ),
            ),
          ],
        ),
      );
    });
  }
}
