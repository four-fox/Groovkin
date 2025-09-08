// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';

class NewPasswordScreen extends StatefulWidget {
  NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final AuthController _authController = Get.find();

  @override
  void initState() {
    super.initState();
    _authController.oldPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Change password"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Reset Password",
                style: poppinsMediumStyle(
                  fontSize: 17,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
                style: poppinsRegularStyle(
                    fontSize: 14,
                    context: context,
                    color: DynamicColor.grayClr.withValues(alpha: 0.8)),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextFields(
                validationError: "old password",
                labelText: "Old Password",
                controller: _authController.oldPasswordController,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextFields(
                isEmail: false,
                labelText: "New Password",
                controller: _authController.newPasswordController,
                validationError: "new password",
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextFields(
                labelText: "Confirm Password",
                validationError: "confirm password",
                controller: _authController.newConfirmPasswordController,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          child: CustomButton(
            borderClr: Colors.transparent,
            color1: DynamicColor.blackClr,
            color2: DynamicColor.blackClr,
            onTap: () {
              final validate = _formKey.currentState!.validate();
              if (!validate) return;
              if (validate) {
                if (_authController.newPasswordController.text ==
                    _authController.newConfirmPasswordController.text) {
                  _authController.changePassword(context, theme);
                } else {
                  bottomToast(text: "Please make sure your passwords match");
                }
              }
              // Get.toNamed(Routes.newPasswordScreen);
            },
            text: "Continue",
          ),
        ),
      ),
    );
  }
}
