


// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class BookingFormScreen extends StatelessWidget {
  const BookingFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Booking form"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text("After confirmation of property owner you can\norganize your event here!",
              textAlign: TextAlign.center,
              style: poppinsRegularStyle(
                fontSize: 12,
                context: context,
                color: DynamicColor.lightRedClr
              ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text.rich(
                TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Venue rent is',
                        style: poppinsRegularStyle(fontSize: 12,color: DynamicColor.grayClr.withOpacity(0.6)),
                      ),
                      TextSpan(
                        text: ' \$1500.00',
                        style: poppinsRegularStyle(fontSize: 12,color: theme.primaryColor,fontWeight: FontWeight.w600,),
                      ),

                      TextSpan(
                        text: ' but you can still negotiate with venue owner. is it ok for you?',
                        style: poppinsRegularStyle(fontSize: 12,color: DynamicColor.grayClr.withOpacity(0.6)),
                      ),
                    ]
                )
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    widths: Get.width/2.4,
                    heights: 48,
                    borderClr: DynamicColor.yellowClr,
                    color1: DynamicColor.yellowClr,
                    color2: DynamicColor.yellowClr,
                    onTap: (){
                      Get.toNamed(Routes.bookingFormFields);
                    },
                    text: "Yes",
                  ),
                  CustomButton(
                    widths: Get.width/2.4,
                    heights: 48,
                    borderClr: DynamicColor.yellowClr,
                    color1: Colors.transparent,
                    color2: Colors.transparent,
                    backgroundClr: false,
                    textClr: DynamicColor.yellowClr,
                    text: "No",
                    onTap: (){
                      Get.back();
                      Get.back();
                      Get.back();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
