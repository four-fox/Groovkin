
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';

class DisclaimerScreen extends StatelessWidget {
  DisclaimerScreen({super.key});

  RxBool checkBoxValue = false.obs;
  final EventController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: kToolbarHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Disclaimer",
                  style: poppinsMediumStyle(
                    fontSize: 20,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
                ((_controller.eventDetail == null) &&
                        (_controller.draftCondition.value == true))
                    ? GestureDetector(
                        onTap: () {
                          _controller.postEventFunction(context, theme,
                              draft: true);
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.drafts),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” “Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”",
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
              style: poppinsMediumStyle(
                fontSize: 13,
                context: context,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(
              height: kToolbarHeight / 2,
            ),
            Text(
              "Cancellation policy",
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
              "“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” “Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”",
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
              style: poppinsMediumStyle(
                fontSize: 13,
                context: context,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(
              height: 20,
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
                          value: checkBoxValue.value,
                          onChanged: (v) {
                            if (checkBoxValue.value == true) {
                              checkBoxValue.value = false;
                            } else {
                              showDialog(
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertWidget(
                                        height: kToolbarHeight * 5,
                                        borderColor: Colors.transparent,
                                        container: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "Terms and conditions",
                                                style: poppinsMediumStyle(
                                                  fontSize: 18,
                                                  context: context,
                                                  color: theme.primaryColor,
                                                ),
                                              ),
                                              Text(
                                                "“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”",
                                                maxLines: 4,
                                                style: poppinsRegularStyle(
                                                  fontSize: 12,
                                                  context: context,
                                                  color: theme.primaryColor,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 7, vertical: 4),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CustomButton(
                                                      borderClr:
                                                          Colors.transparent,
                                                      backgroundClr: false,
                                                      color1:
                                                          DynamicColor.redClr,
                                                      color2:
                                                          DynamicColor.redClr,
                                                      widths: Get.width / 3.2,
                                                      heights: 35,
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                      text: "Decline",
                                                    ),
                                                    CustomButton(
                                                      borderClr:
                                                          Colors.transparent,
                                                      backgroundClr: false,
                                                      color1:
                                                          DynamicColor.greenClr,
                                                      color2:
                                                          DynamicColor.greenClr,
                                                      widths: Get.width / 3.2,
                                                      heights: 35,
                                                      onTap: () {
                                                        checkBoxValue.value =
                                                            v!;
                                                        Get.back();
                                                      },
                                                      text: "Accept",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ));
                                  });
                            }
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
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom:  true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                widths: Get.width / 2.3,
                heights: 39,
                color2: DynamicColor.redClr,
                color1: DynamicColor.redClr,
                backgroundClr: false,
                borderClr: Colors.transparent,
                onTap: () {
                  Get.back();
                },
                text: "Decline",
              ),
              CustomButton(
                widths: Get.width / 2.3,
                heights: 39,
                borderClr: Colors.transparent,
                onTap: () {
                  if (checkBoxValue.value == true) {
                    if (_controller.eventDetail != null &&
                        _controller.duplicateValue.value == false &&
                        _controller.draftValue.value == false) {
                      _controller.editEventFunction();
                    } else {
                      // if(_controller.duplicateValue.value == false || _controller.draftValue.value ==true){
                      //   _controller.editEventFunction();
                      // }else{
                      _controller.postEventFunction(
                        context,
                        theme, /*location: _controller.duplicateValue.value == false?null:_controller.eventDetail*/
                      );
                    }
                  } else {
                    bottomToast(text: "Please accept terms and condition");
                  }
                },
                text: "Send Now",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
