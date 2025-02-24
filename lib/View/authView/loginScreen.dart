// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final loginForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      // appBar: customAppBar(theme: theme,text: "New Hashtag",),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: theme.primaryColor,
          content: Text(
            'Tap back again to exit the app',
            style: poppinsMediumStyle(
                fontSize: 15,
                context: context,
                color: theme.scaffoldBackgroundColor),
          ),
        ),
        child: GetBuilder<AuthController>(builder: (controller) {
          return Form(
            key: loginForm,
            child: Container(
              height: Get.height,
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/loginBg.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: ImageIcon(
                        AssetImage("assets/backArrow.png"),
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Login",
                      style: poppinsMediumStyle(
                        fontSize: 30,
                        context: context,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    CustomTextFields(
                      borderClr: DynamicColor.grayClr.withOpacity(0.4),
                      controller: controller.loginEmailController,
                      validationError: "email",
                      isEmail: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextFields(
                      labelText: "Password",
                      borderClr: DynamicColor.grayClr.withOpacity(0.4),
                      controller: controller.loginPasswordController,
                      validationError: "password",
                      obscureText: controller.loginShowPassword.value,
                      iconShow: true,
                      suffixWidget: GestureDetector(
                        onTap: () {
                          controller.loginShowPassword.value =
                              !controller.loginShowPassword.value;
                          controller.update();
                        },
                        child: Icon(
                          controller.loginShowPassword.value != true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: DynamicColor.grayClr.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.sendEmailScreen);
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot Password",
                          style: poppinsMediumStyle(
                              fontSize: 15,
                              color: DynamicColor.lightRedClr.withOpacity(0.6),
                              context: context),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kToolbarHeight * 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width / 2.5,
                          height: 2,
                          color: DynamicColor.grayClr,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text(
                            "Or",
                            style: poppinsMediumStyle(
                              context: context,
                              color: DynamicColor.lightRedClr,
                            ),
                          ),
                        ),
                        Container(
                          width: Get.width / 2.5,
                          height: 2,
                          color: DynamicColor.grayClr,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomButtonWithIcon(
                        text: "Continue with Apple",
                        iconValue: true,
                        bgColor: Colors.transparent,
                        gradientClr: true,
                        color2: DynamicColor.grayClr.withOpacity(0.4),
                        color1: DynamicColor.grayClr.withOpacity(0.1),
                        imageIconn: ImageIcon(
                          AssetImage("assets/apple.png"),
                          color: theme.primaryColor,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButtonWithIcon(
                        text: "Continue with Google",
                        iconValue: true,
                        bgColor: Colors.transparent,
                        gradientClr: true,
                        color2: DynamicColor.grayClr.withOpacity(0.4),
                        color1: DynamicColor.grayClr.withOpacity(0.1),
                        imageIconn: ImageIcon(
                          AssetImage("assets/google.png"),
                          color: theme.primaryColor,
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.loginSelection);
                        // Get.back();
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account? ',
                              style: poppinsRegularStyle(
                                  fontSize: 15,
                                  context: context,
                                  fontWeight: FontWeight.w600,
                                  color: DynamicColor.lightRedClr),
                            ),
                            Text(
                              'Sign Up here',
                              style: poppinsRegularStyle(
                                fontSize: 15,
                                context: context,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      borderClr: Colors.transparent,
                      onTap: () {
                        if (loginForm.currentState!.validate()) {
                          controller.login();
                        }
                      },
                      text: "Login",
                    ),
                    SizedBox(
                      height: 8,
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
