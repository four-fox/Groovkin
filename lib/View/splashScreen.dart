import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Routes/app_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
      if (API().sp.read("intro") == true) {
        if (API().sp.read("token") != null) {
          print(API().sp.read("token"));
          print(API().sp.read("userId"));
          String userTypeInital = await API().sp.read('role');
          print(userTypeInital);
          if (API().sp.read("role") == "User") {
            print(API().sp.read("isUserCreated"));
            if (API().sp.read("isUserCreated") == 0) {
              print(API().sp.read("isUserCreated"));
              Get.offAllNamed(Routes.surveyLifeStyleScreen, arguments: {
                "update": false,
              });
            } else {
              Get.offAllNamed(Routes.userBottomNavigationNav);
            }
          } else {
            if (API().sp.read("role") == "eventOrganizer") {
              if (API().sp.read("isEventCreated") == 0) {
                Get.offAllNamed(Routes.serviceScreen,
                    arguments: {"addMoreService": 1});
              } else {
                Get.offAllNamed(Routes.bottomNavigationView,
                    arguments: {"indexValue": 0});
              }
            } else {
              Get.offAllNamed(Routes.bottomNavigationView,
                  arguments: {"indexValue": 0});
            }
          }
        } else {
          Get.offAllNamed(Routes.loginScreen);
          // Get.offAllNamed(Routes.loginSelection);
        }
      } else {
        Get.offAllNamed(Routes.introPages);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Image(
          image: AssetImage("assets/logo.png"),
        ),
      ),
    ));
  }
}
