// ignore_for_file: prefer_const_literals_to_create_immutables


import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class WelComeScreen extends StatefulWidget {
  const WelComeScreen({super.key});

  @override
  State<WelComeScreen> createState() => _WelComeScreenState();
}

class _WelComeScreenState extends State<WelComeScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    // print(intialRole);
    return SafeArea(
      top: false,
      bottom: true ,
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: theme.scaffoldBackgroundColor,
        //   elevation: 0,
        //   centerTitle: true,
        //   title: Text("Welcome Message",
        //   style: poppinsMediumStyle(
        //     fontSize: 16,
        //     color: theme.primaryColor,
        //     context: context,
        //   ),
        //   ),
        // ),
        body: DoubleBackToCloseApp(
          snackBar: const SnackBar(
              content: Text(
            "Please complete the profile screen",
          )),
          child: Column(
            children: [
              const SizedBox(
                height: 200,
                width: double.infinity,
                child: Image(
                  image: AssetImage("assets/welcomeScreen.png"),
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Welcome to Groovkin!',
                style: poppinsMediumStyle(
                  fontSize: 18,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Welcome to Groovkin!  We welcome you to our platform and encourage you to organize new and exciting events in your local area using our service.  Please complete the registration process to tell us about the services you can provide.',
                  style: poppinsRegularStyle(
                    fontSize: 14,
                    context: context,
                    color: DynamicColor.grayClr,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                  height: 130,
                  width: 130,
                  child: Image(image: AssetImage("assets/handshake.png")))
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () {
              if (API().sp.read("role") == "User") {
                Get.offAllNamed(Routes.userQuickSurveyScreen);
              } else if (API().sp.read("role") == "eventOrganizer") {
                Get.offAllNamed(Routes.subscriptionScreen);
              } else {
                Get.offAllNamed(Routes.createCompanyProfileScreen, arguments: {
                  "updationCondition": false,
                  "skipBtnHide": false,
                });
              }
              // Get.toNamed(Routes.loginWithScreen);
            },
            text: sp.read("role") == "eventManager"
                ? "Service Availability Survey"
                : "Let's Get Started",
          ),
        ),
      ),
    );
  }
}

//  if (didPop == true && intialRole != null) {
//           await API().sp.write("role", intialRole);
//           Get.back(); // Only pop if role is written
//         } else if (!didPop) {
          // Pop the screen if `didPop` is false, otherwise do nothing
//           Get.back();
//         }