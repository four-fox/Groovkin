import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AuthController>()) {
      controller = Get.find<AuthController>();
    } else {
      controller = Get.put(AuthController());
    }

    Future.delayed(const Duration(seconds: 3), () async {
      if (API().sp.read("intro") == true) {
        if (API().sp.read("token") != null) {

          print(API().sp.read("token"));
          print(API().sp.read("userId"));
          print(API().sp.read("role"));

          // String userTypeInital = await API().sp.read('role');
          // String selectedRole = userTypeInital == "eventOrganizer"
          //     ? "event_owner"
          //     : userTypeInital == "eventManager"
          //         ? "venue_manager"
          //         : "user";
          // var formData = form.FormData.fromMap({"role": selectedRole});
          // final response = await API().postApi(formData, "switch-profile");
          // if (response.statusCode == 200) {
          //   final data = SwitchProfile.fromJson(response.data);
          //   String userTypeInital = data.data!.activeRole == "user"
          //       ? "User"
          //       : data.data!.activeRole == "event_owner"
          //           ? "eventOrganizer"
          //           : "eventManager";
          //   API().sp.write('role', userTypeInital);

          //   if (API().sp.read("role") == "User") {
          //     print("<User>");
          //     if (data.data!.isUserCreated == 0) {
          //       Get.offAllNamed(Routes.welComeScreen);
          //     } else {
          //       selectUserIndexxx.value = 0;
          //       Get.offAllNamed(Routes.userBottomNavigationNav);
          //     }
          //   } else if (API().sp.read("role") == "eventOrganizer") {
          //     print("<Event>");
          //     if (data.data!.isEventCreated == 0) {
          //       Get.offAllNamed(Routes.welComeScreen);
          //     } else {
          //       selectIndexxx.value = 0;
          //       Get.offAllNamed(Routes.bottomNavigationView);
          //     }
          //   } else {
          //     print("<Manager>");
          //     // if (data.data!.isManagerCreated == 0) {
          //     //   Get.offAllNamed(Routes.welComeScreen);
          //     // } else {
          //     //   selectIndexxx.value = 0;
          //     //   Get.offAllNamed(Routes.bottomNavigationView);
          //     // }
          //     selectIndexxx.value = 0;
          //     Get.offAllNamed(Routes.bottomNavigationView);
          //   }
          // }
          
          if (API().sp.read("signupPlatform") != null) {
            if (API().sp.read("isCompleteProfile") == 1) {
              if (API().sp.read("role") == "User") {
                if (API().sp.read("isUserCreated") == 0) {
                  Get.offAllNamed(Routes.surveyLifeStyleScreen, arguments: {
                    "update": false,
                  });
                } else {
                  Get.offAllNamed(Routes.userBottomNavigationNav);
                }
              } else if (API().sp.read("role") == "eventOrganizer") {
                /// Event Organizer
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
                // Get.offAllNamed(Routes.createCompanyProfileScreen,
                //   arguments: {
                //   "updationCondition": false,
                //     "skipBtnHide": false,
                //   }
                // );
              }
            } else {
              controller.emailController.text = API().sp.read("emailSocial");
              print(API().sp.read("socialType"));
              controller.update();
              Get.toNamed(Routes.createProfile, arguments: {
                "socialType": API().sp.read("socialType"),
                "accessToken": API().sp.read("accessToken")
              });
            }
          } else {
            if (API().sp.read("role") == "User") {
              /// User
              if (API().sp.read("isUserCreated") == 0) {
                Get.offAllNamed(Routes.surveyLifeStyleScreen, arguments: {
                  "update": false,
                });
              } else {
                Get.offAllNamed(Routes.userBottomNavigationNav);
              }
            } else if (API().sp.read("role") == "eventOrganizer") {
              /// Event Organizer
              if (API().sp.read("isEventCreated") == 0) {
                Get.offAllNamed(Routes.serviceScreen,
                    arguments: {"addMoreService": 1});
              } else {
                Get.offAllNamed(Routes.bottomNavigationView,
                    arguments: {"indexValue": 0});
              }
            } else {
              /// Venue Manager
              Get.offAllNamed(Routes.bottomNavigationView,
                  arguments: {"indexValue": 0});
            }
          }
        } else {
          // Get.offAllNamed(Routes.loginScreen);
          Get.offAllNamed(Routes.loginSelection);
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
