import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';

class SurveyLifeStyleScreen extends StatelessWidget {
  SurveyLifeStyleScreen({Key? key}) : super(key: key);

  bool updatedCond = Get.arguments['update'] ?? false;

  String title = Get.arguments['appBarTitle'] ?? "Lifestyle Survey";

  AuthController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    print(title);
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
          onTap: () {
            Get.back();
          },
          theme: theme,
          text: updatedCond == true ? "Edit $title" : title,
          style: poppinsMediumStyle(
            fontSize: 17,
            context: context,
            color: theme.primaryColor,
          )),
      body: GetBuilder<AuthController>(initState: (v) {
        _controller.getLifeStyle(surveyType: "life_style");
      }, builder: (controller) {
        return controller.getLifeStyleLoader.value == false
            ? SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      updatedCond == true
                          ? title == "Lifestyle"
                              ? "How is your lifestyle?"
                              : "Imported Genre Form Spotify"
                          : title == "Quick Survey"
                              ? "How is your lifestyle?"
                              : 'Let us know more about your\nlifestyle preference',
                      textAlign: TextAlign.center,
                      style: poppinsRegularStyle(
                        fontSize: 16,
                        context: context,
                        color: theme.primaryColor,
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
                      height: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: Get.height / 1.47,
                        child: ListView.builder(
                            itemCount: controller.surveyData!.data!.length,
                            itemBuilder: (BuildContext context, index) {
                              return Column(
                                children: [
                                  musicGenreWidget(
                                    text: controller
                                        .surveyData!.data![index].name,
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
                                        EdgeInsets.only(top: 4.0, bottom: 4),
                                    child: Visibility(
                                      visible: controller.surveyData!
                                          .data![index].showItems!.value,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        decoration: BoxDecoration(
                                          // image: DecorationImage(
                                          //     image: AssetImage("assets/buttonBg.png"),
                                          //     fit: BoxFit.fill
                                          // ),
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
                                                indexxs) {
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        controller
                                                            .surveyData!
                                                            .data![index]
                                                            .categoryItems![
                                                                indexxs]
                                                            .name!,
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
                                                                    indexxs]
                                                                .selectedItem!
                                                                .value,
                                                            onChanged: (v) {
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
                                                                      .categoryItems![indexxs]);
                                                            }),
                                                      )
                                                    ],
                                                  ),
                                                  Divider(
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
      }),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: () {
            if (updatedCond == true) {
              Get.back();
            } else {
              if (_controller.itemsList.isNotEmpty) {
                _controller.makeMethodHit(navigation: "survey");
              } else {
                bottomToast();
              }
            }
          },
          text: updatedCond == true ? "Save" : "Next",
        ),
      ),
    );
  }

  Widget musicGenreWidget(
      {context,
      theme,
      text,
      GestureTapCallback? onTap,
      IconData? icon,
      String? img}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage("assets/buttonBg.png"),
          //     fit: BoxFit.fill
          // ),
          color: DynamicColor.secondaryClr,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: theme.primaryColor,
              radius: 15,
              child: Image(image: AssetImage(img ?? 'assets/foodies.png'))),
          SizedBox(
            width: 6,
          ),
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
              size: 35,
              color: theme.primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
