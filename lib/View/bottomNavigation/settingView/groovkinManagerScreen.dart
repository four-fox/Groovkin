


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Routes/app_pages.dart';

class GroovkinManagerScreen extends StatelessWidget {
  const GroovkinManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Groovkin Invites"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            CustomTextFields(
              labelText: "Name",
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextFields(
              labelText: "Email/phone number",
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
            Get.toNamed(Routes.sendInvitationScreen);
          },
          text: "Send",
        ),
      ),
    );
  }
}
