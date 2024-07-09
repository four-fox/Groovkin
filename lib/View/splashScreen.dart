// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Routes/app_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3),(){
      print(API().sp.read("token"));
      if(API().sp.read("intro") == true){
        if(API().sp.read("token") != null){
          if(API().sp.read("role") == "User"){
            if(API().sp.read("isUserCreated") == 0){
              Get.offAllNamed(Routes.surveyLifeStyleScreen,
                  arguments: {
                    "update": false,
                  }
              );
            }else{
              Get.offAllNamed(Routes.userBottomNavigationNav);
            }
          }else{
            if(API().sp.read("role")=="eventOrganizer"){
              if(API().sp.read("isEventCreated") == 0){
                Get.offAllNamed(Routes.serviceScreen,
                    arguments: {
                      "addMoreService": 1
                    }
                );
              }else{
                Get.offAllNamed(Routes.bottomNavigationView,
                    arguments: {
                      "indexValue": 0
                    }
                );
              }
            }else{
              Get.offAllNamed(Routes.bottomNavigationView,
                  arguments: {
                    "indexValue": 0
                  }
              );
            }
          }
        }else{
          Get.offAllNamed(Routes.loginScreen);
          // Get.offAllNamed(Routes.loginSelection);
        }
      }else{
        Get.offAllNamed(Routes.introPages);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Image(
            image: AssetImage("assets/logo.png"),
          ),
        ),
      )
    );
  }
}
