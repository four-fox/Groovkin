import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/textStyle.dart';

import 'colors.dart';

cancelEventWidget({context, theme, final GestureTapCallback? onTap}) {
  return showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertWidget(
          height: kToolbarHeight * 5,
          container: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Not interested /decline',
                  textAlign: TextAlign.center,
                  style: poppinsRegularStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
                Text(
                  '“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: poppinsRegularStyle(
                    fontSize: 13,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        heights: 30,
                        color1: theme.primaryColor,
                        color2: theme.primaryColor,
                        widths: Get.width / 3.0,
                        onTap: () {
                          Get.back();
                        },
                        backgroundClr: false,
                        textClr: theme.scaffoldBackgroundColor,
                        borderClr: Colors.transparent,
                        text: "Cancel",
                      ),
                      CustomButton(
                        heights: 30,
                        widths: Get.width / 3.0,
                        color1: DynamicColor.redClr,
                        color2: DynamicColor.redClr,
                        onTap: onTap,
                        backgroundClr: false,
                        borderClr: Colors.transparent,
                        text: "Decline",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
