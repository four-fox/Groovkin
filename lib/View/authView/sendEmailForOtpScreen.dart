


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class SendEmailForOtp extends StatelessWidget {
  const SendEmailForOtp({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 90,
            ),
            Text("Email",
            style: poppinsMediumStyle(
              fontSize: 17,
              context: context,
              color: theme.primaryColor,
            ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
            style: poppinsRegularStyle(
              fontSize: 14,
              context: context,
              color: DynamicColor.grayClr.withOpacity(0.8)
            ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextFields(
              labelText: "email",
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 4),
        child: CustomButton(
          borderClr: Colors.transparent,
          color1: DynamicColor.blackClr,
          color2: DynamicColor.blackClr,
          onTap: (){
            Get.toNamed(Routes.newPasswordScreen);
          },
          text: "Continue",
        ),
      ),
    );
  }
}
