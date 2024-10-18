import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';

void alertMethod(
    {title,
    text,
    btn,
    context,
    childrenData,
    click,
    buttonText,
    titleText,
    theme}) {
  Get.defaultDialog(
      titlePadding: title == "" ? EdgeInsets.zero : EdgeInsets.all(8),
      title: title ?? 'Update event',
      content: childrenData ??
          Text(
            text ??
                '“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elitv',
            style: poppinsRegularStyle(
              fontSize: 12,
              context: context,
            ),
          ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.0),
          child: CustomButton(
            onTap: () {},
            backgroundClr: false,
            borderClr: Colors.transparent,
            color2: DynamicColor.greenClr,
            color1: DynamicColor.greenClr,
            text: btn ?? "Accept",
          ),
        ),
      ],
      radius: 10.0);
}

class AlertWidget extends StatelessWidget {
  AlertWidget(
      {Key? key,
      this.container,
      this.height,
      this.borderColor,
      this.radius,
      this.bgColor = false})
      : super(key: key);

  Widget? container;
  double? height;
  Color? borderColor;
  double? radius;
  bool bgColor = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        height: height ?? kToolbarHeight * 3.3,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 15),
          border: Border.all(
              color: borderColor ?? DynamicColor.grayClr.withOpacity(0.5)),
          image: bgColor == false
              ? DecorationImage(
                  image: AssetImage("assets/grayClor.png"), fit: BoxFit.fill)
              : null,
          color: bgColor == false ? Colors.transparent : Colors.white,
        ),
        child: container,
      ),
      contentPadding: EdgeInsets.all(0.0),
    );
  }
}

customAlertt(
    {String? title,
    String? text,
    String? cancelAlert,
    GestureTapCallback? onTap,
    String? btnSuccess,
    AlignmentGeometry? alignment,
    Widget? customWidget,
    Color? bgClr}) {
  return Get.defaultDialog(
      title: "",
      titlePadding: EdgeInsets.zero,
      backgroundColor: bgClr ?? Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      content: customWidget ??
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toString(),
                textAlign: TextAlign.center,
                style: poppinsRegularStyle(
                    fontSize: 16, color: DynamicColor.blackClr),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                text.toString(),
                textAlign: TextAlign.center,
                style: poppinsRegularStyle(
                    fontSize: 14, color: DynamicColor.blackClr),
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 35,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: DynamicColor.yellowClr,
                      ),
                      child: Center(
                        child: Text(
                          "No",
                          style: poppinsMediumStyle(
                              fontSize: 16, color: DynamicColor.whiteClr),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      height: 35,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          btnSuccess.toString(),
                          style: poppinsMediumStyle(
                              fontSize: 16, color: DynamicColor.whiteClr),
                        ),
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: onTap,
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 14.0),
                  //     child: Text(
                  //       btnSuccess.toString(),
                  //       style: gilroyRegularStyle(
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.w700,
                  //           color: DynamicColors.primaryClr),
                  //     ),
                  //   ),
                  // ),
                ],
              )
            ],
          ),
      radius: 10.0);
}
