


// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';

class InsuranceScreen extends StatelessWidget {
  InsuranceScreen({Key? key}) : super(key: key);

  int insuranceNavigation = Get.arguments['insuranceNavigation'];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Insurance"),
      body: GetBuilder<AuthController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              Text('Can you provide insurance if\nrequired?',
              textAlign: TextAlign.center,
              style: poppinsRegularStyle(
                fontSize: 15,
                context: context,
                color: DynamicColor.lightRedClr
              ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      widths: Get.width/2.3,
                      heights: 45,
                        borderClr: controller.insuranceVal.value==0?Colors.transparent: DynamicColor.yellowClr,
                      backgroundClr:controller.insuranceVal.value==0?true: false,
                    color1: Colors.transparent,
                    color2: Colors.transparent,
                      onTap: (){
                        controller.insuranceVal.value = 0;
                        if(insuranceNavigation==2){
                          Get.back();
                        }else{
                          Get.toNamed(Routes.hardwareScreen,
                          arguments: {
                            "createEvent": false,
                          }
                          );
                        }
                        controller.update();
                      },
                      textClr:controller.insuranceVal.value==0?theme.primaryColor: DynamicColor.yellowClr,
                      text: "Yes",
                    ),
                    CustomButton(
                      widths: Get.width/2.3,
                      heights: 45,
                        onTap: (){
                          controller.insuranceVal.value = 1;
                          if(insuranceNavigation==2){
                            Get.back();
                          }else{
                            Get.toNamed(Routes.hardwareScreen,
                                arguments: {
                                  "createEvent": false,
                                }
                            );
                          }
                          controller.update();
                        },
                      borderClr: controller.insuranceVal.value==1?Colors.transparent: DynamicColor.yellowClr,
                      backgroundClr:controller.insuranceVal.value==1?true: false,
                      color1: Colors.transparent,
                      color2: Colors.transparent,
                      textClr:controller.insuranceVal.value==1?theme.primaryColor: DynamicColor.yellowClr,
                      text: "No",
                    ),
                  ],
                ),
              )
            ],
          );
        }
      ),
    );
  }
}
