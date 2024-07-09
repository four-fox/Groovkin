// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class SendInvitationScreen extends StatelessWidget {
  const SendInvitationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              Image(image: AssetImage("assets/sendInvitation.png"),
              ),
              SizedBox(
                height: 30,
              ),
              CircleAvatar(
                radius: 40,
                backgroundColor: DynamicColor.greenClr.withOpacity(0.3),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: DynamicColor.greenClr,
                  child: Icon(Icons.check,
                      color: theme.primaryColor,
                    size: 35,
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text(' Your event invitations have been sent successfully. Thank you for spreading the excitement!',
              textAlign: TextAlign.center,
                style: poppinsRegularStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                context: context,
                color: theme.primaryColor,
              ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),
        child: CustomButton(
          borderClr: Colors.transparent,
          color1: DynamicColor.blackClr,
          color2: DynamicColor.blackClr,
          onTap: (){
            if(sp.read("role") =="User"){
              Get.offAllNamed(Routes.userBottomNavigationNav);
            }else{
              Get.offAllNamed(Routes.bottomNavigationView,
                  arguments: {
                    "indexValue": 1
                  }
              );
            }
          },
          text: "Ok",
        ),
      ),
    );
  }
}
