


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';

class LoginOrSignUpScreen extends StatelessWidget {
  LoginOrSignUpScreen({Key? key}) : super(key: key);

  final signUpForm = GlobalKey<FormState>();

  AuthController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Form(
      key: signUpForm,
      child: Scaffold(
        body: GetBuilder<AuthController>(
          builder: (controller) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/loginSelection3.png"),
                  fit: BoxFit.fill
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: kToolbarHeight/1.5,
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: ImageIcon(AssetImage('assets/backArrow.png'),
                        size: 32,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(/*sp.read("role")=="eventManager"?*/"Sign Up"/*:'Let’s get Started'*/,
                      style: poppinsMediumStyle(
                        fontSize: 28,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: kToolbarHeight*1.5,
                    ),
                    CustomTextFields(
                      controller: controller.emailController,
                      isEmail: true,
                      validationError: "email",
                    ),
                    SizedBox(
                      height:15,
                    ),
                CustomTextFields(
                  controller: controller.passwordController,
                      labelText: "Password",
                  obscureText: controller.showPassword.value,
                    validationError: "password",
                    iconShow: true,
                    suffixWidget: GestureDetector(
                        onTap: (){
                          controller.showPassword.value = !controller.showPassword.value;
                          controller.update();
                        },
                      child: Icon(controller.showPassword.value !=true? Icons.visibility:Icons.visibility_off,
                      color: DynamicColor.grayClr.withOpacity(0.6),
                      ),
                      ),
                    ),
                    SizedBox(
                      height:15,
                    ),
                    CustomTextFields(
                      controller: controller.confirmPasswordController,
                      labelText: "Confirm Password",
                      validationError: "confirm password",
                      obscureText: controller.showConfirmPassword.value,
                      iconShow: true,
                      suffixWidget: GestureDetector(
                        onTap: (){
                          controller.showConfirmPassword.value = !controller.showConfirmPassword.value;
                          controller.update();
                        },
                        child: Icon(controller.showConfirmPassword.value !=true? Icons.visibility:Icons.visibility_off,
                          color: DynamicColor.grayClr.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kToolbarHeight/2.5,
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.offAllNamed(Routes.loginScreen);
                      },
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account? ',
                              style: poppinsRegularStyle(
                                  fontSize: 15,
                                  context: context,
                                  fontWeight: FontWeight.w600,
                                  color: DynamicColor.lightRedClr
                              ),
                            ),
                            Text('Login here',
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
                    )

                  ],
                ),
              ),
            );
          }
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: (){
              print(API().sp.read("role"));
              if(signUpForm.currentState!.validate()){
                if(_controller.confirmPasswordController.text == _controller.passwordController.text){
                  Get.toNamed(Routes.createProfile);
                }else{
                  bottomToast(text: "Please make sure your passwords match");
                }
              }
            },
            text: "Next",
          ),
        ),
      ),
    );
  }
}
