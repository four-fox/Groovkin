


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class LinkYourAccountSurveyScreen extends StatelessWidget {
  LinkYourAccountSurveyScreen({Key? key}) : super(key: key);

  RxBool iTuneVal = false.obs;
  RxBool spotifyVal = false.obs;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Lifestyle Survey"),
body: Padding(
  padding: EdgeInsets.symmetric(horizontal: 12.0),
  child:Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 15,
        ),
        Text("Music Preferences",
          style: poppinsRegularStyle(
            fontSize: 16,
            context: context,
            color: theme.primaryColor,
          ),
        ) ,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Groovkin wants to know more about the\ntype of music you enjoy!',
            textAlign: TextAlign.center,
            style: poppinsRegularStyle(
              fontSize: 12,
              context: context,
              color: DynamicColor.lightRedClr,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        SwitchWiget(text: "Link your iTunes account",theme: theme,context: context,
            showCheckBox: false,
          bgClr: true,
        ),
        SizedBox(
          height: 23,
        ),
        SwitchWiget(text: "Link your Spotify account",theme: theme,context: context,img: "assets/spotifyIcon.png",
          showCheckBox: false,
            bgClr: true,
        ),
      ],
    ),
  ),
),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: (){
            Get.toNamed(Routes.quickSurveyScreen,
                arguments: {
                  'addMoreService': 1,
                  "createEvent": false
                }
            );
          },
          text: "Enter manually",
        ),
        // CustomButton(
        //   borderClr: Colors.transparent,
        //   onTap: (){
        //     Get.offAllNamed(Routes.userBottomNavigationNav,
        //         // arguments: {
        //         //   "indexValue": 0
        //         // }
        //     );
        //   },
        //   text: "Next",
        // ),
      ),
    );
  }
}
