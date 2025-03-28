import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/authView/social_sign_in.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/loginBg.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
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
                    const SizedBox(
                      height: 25,
                    ),
                    CustomTextFields(
                      borderClr: DynamicColor.grayClr.withOpacity(0.4),
                      controller: controller.loginEmailController,
                      validationError: "email",
                      isEmail: true,
                    ),
                    const SizedBox(
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
                    const SizedBox(
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
                    const SizedBox(
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
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
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
                    const SizedBox(
                      height: 15,
                    ),
                    const SocialSignIn(
                      showSpotify: true,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.loginSelection);
                        // Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
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
                    const SizedBox(
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
                    const SizedBox(
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
