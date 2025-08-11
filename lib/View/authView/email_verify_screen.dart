import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AuthController>()) {
      authController = Get.find<AuthController>();
    } else {
      authController = Get.put(AuthController());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<AuthController>(builder: (controller) {
      return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      height: kToolbarHeight * 1.2,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Verification code on email",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: kToolbarHeight * .15,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "We will send verification code on \n your email id.",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.grey.withValues(alpha: 0.9),
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: kToolbarHeight * 1.5,
                    ),
                    Theme(
                      data: ThemeData(
                          textSelectionTheme: TextSelectionThemeData(
                        cursorColor: DynamicColor.yellowClr,
                        selectionColor: DynamicColor.yellowClr,
                        selectionHandleColor: DynamicColor.yellowClr,
                      )),
                      child: OTPTextField(
                        length: 4,
                        otpFieldStyle: OtpFieldStyle(
                          focusBorderColor: DynamicColor.yellowClr,
                          borderColor: DynamicColor.yellowClr,
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
                          if (v.isEmpty) {
                            controller.setOtpController("");
                          } else {
                            controller.setOtpController(v);
                          }
                        },
                        onCompleted: (pin) {
                          controller.setOtpController(pin);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: kToolbarHeight * 1.2,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: CustomButton(
                        onTap: () {
                          controller.verifyEmail();
                        },
                        text: "Verify",
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
