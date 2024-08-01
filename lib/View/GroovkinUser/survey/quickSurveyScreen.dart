


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class UserQuickSurveyScreen extends StatelessWidget {
  UserQuickSurveyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
body: Column(
  children: [
    Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: kToolbarHeight*5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/quickBinner.png"),
              fit: BoxFit.fill
            )
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.0),
          child: Column(
            children: [
              Text('Quick Survey',
              style: poppinsMediumStyle(
                fontSize:
                  24,
                color: theme.primaryColor,
              ),),
              SizedBox(
                height: 25,
              ),
              Text('We\'d like to get to know you better!',
              style: poppinsMediumStyle(
                fontSize:
                  16,
                color: theme.primaryColor,
              ),),
              SizedBox(
                height: 10,
              ),
              Text('We will match your life style in interest section then you can get easily your desire events.',
                style: poppinsMediumStyle(
                fontSize:
                  12,
                color: DynamicColor.lightRedClr.withOpacity(0.9)
              ),),
            ],
          ),
        ),
      ],
    ),  SizedBox(
      height: 40,
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: CustomButton(
        borderClr: Colors.transparent,
        text: "Next",
        onTap: (){
          Get.toNamed(Routes.surveyLifeStyleScreen,
          arguments: {
            "update": false,
            "appBarTitle": "Quick Survey"
          }
          );
        },
      ),
    ),
    SizedBox(
      height: 15,
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: CustomButton(
        onTap: (){
          showDialog(
              barrierColor: Colors.transparent,
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertWidget(
                  height: kToolbarHeight*6,
                  radius: 20,
                  borderColor: Colors.transparent,
                  container: SizedBox(
                    width: Get.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                       SizedBox(
                      height: 90,
                         child: Image(
                           image: AssetImage("assets/logo.png"),
                           fit: BoxFit.fill,
                         ),
                       ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text("We hope to understand more about you in the future so that we can increase the visibility of communities with common interests!", overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: poppinsRegularStyle(
                                fontSize: 14,
                                context: context,
                                fontWeight: FontWeight.w700,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          CustomButton(
                            heights: 40,
                            widths: Get.width/2.8,
                            onTap: (){
                              Get.back();
                              Get.toNamed(Routes.surveyLifeStyleScreen,
                                  arguments: {
                                    "update": false,
                                  }
                              );
                            },
                            textClr: theme.primaryColor,
                            borderClr: Colors.transparent,
                            text: "Got it",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        color2: Colors.transparent,
        color1: Colors.transparent,
        backgroundClr: false,
        textClr: DynamicColor.lightYellowClr,
        text: "Skip",
      ),
    ),
  ],
),
    );
  }
}
