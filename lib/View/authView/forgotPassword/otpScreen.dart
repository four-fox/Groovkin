// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({super.key});

  final newPasswordForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<AuthController>(builder: (controller) {
        return Form(
          key: newPasswordForm,
          child: Container(
            width: Get.width,
            height: Get.height,
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: ImageIcon(
                        const AssetImage("assets/backArrow.png"),
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: kToolbarHeight * 1.8,
                    ),
                    CustomTextFields(
                      labelText: "email",
                      borderClr: DynamicColor.grayClr.withValues(alpha: 0.4),
                      controller: controller.forgotPassEmailController,
                      validationError: "new password",
                      isEmail: true,
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OTPTextField(
                      length: 4,
                      otpFieldStyle:
                          OtpFieldStyle(focusBorderColor: Colors.orange //(here)
                              ),
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 55,
                      style: TextStyle(
                        fontSize: 17,
                        color: theme.primaryColor,
                      ),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.box,
                      onChanged: (v) {
                        print('value of v>>>>>>$v');
                        controller.newPassOTPController.text = v;
                      },
                      onCompleted: (pin) {
                        print("Completed: $pin");
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFields(
                      labelText: "password",
                      borderClr: DynamicColor.grayClr.withValues(alpha: 0.4),
                      controller: controller.newPassController,
                      validationError: "new password",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFields(
                      labelText: 'confirm password',
                      borderClr: DynamicColor.grayClr.withValues(alpha: 0.4),
                      controller: controller.newConfirmPassController,
                      validationError: "confirm password",
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomButton(
                      borderClr: Colors.transparent,
                      onTap: () {
                        if (newPasswordForm.currentState!.validate()) {
                          if (controller.newPassOTPController.text.length ==
                              4) {
                            controller.newPassword();
                          } else {
                            bottomToast(text: "Please complete otp fields");
                          }
                        }
                      },
                      text: "Next",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
