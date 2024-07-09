
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/authView/forgotPassword/otpScreen.dart';

class SendEmailScreen extends StatelessWidget {
  SendEmailScreen({Key? key}) : super(key: key);

  final forgotPasswordForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<AuthController>(
        builder: (controller) {
          return Form(
            key: forgotPasswordForm,
            child: Container(
              color: theme.scaffoldBackgroundColor,
              width: Get.width,
              height: Get.height,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: kToolbarHeight*2,
                    ),
                    Text(
                      "Forget Passwords",
                      style: poppinsRegularStyle(fontSize: 16,fontWeight: FontWeight.w700,context: context,color: theme.primaryColor,),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "To Reset your Password, Please Enter Your Email Address and Press Send",
                      style: poppinsRegularStyle(fontSize: 13,context: context,color: theme.primaryColor,),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CustomTextFields(
                      borderClr: DynamicColor.grayClr.withOpacity(0.4),
                      controller: controller.forgotPassEmailController,
                      validationError: "email",
                      isEmail: true,
                    ),
                    SizedBox(
                      height: kToolbarHeight * 3,
                    ),
                    CustomButton(
                      borderClr: Colors.transparent,
                      onTap: (){
                        if(forgotPasswordForm.currentState!.validate()){
                          controller.forgotPassword();
                        }
                      },
                      text: "Email Send",
                    ),
                    SizedBox(
                      height: 8,
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
