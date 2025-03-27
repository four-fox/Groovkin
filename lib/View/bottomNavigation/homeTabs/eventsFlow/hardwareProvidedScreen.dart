


// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class HardwareProvidedScreen extends StatelessWidget {
  HardwareProvidedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Create Event",),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 10),
        child: Center(
          child: Column(
            children: [
              Text("Hardware you will provide",
              style: poppinsRegularStyle(
                fontSize: 16,
                context: context,
                color: theme.primaryColor,
              ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text("Check all that apply",
                style: poppinsRegularStyle(
                  fontSize: 12,
                  context: context,
                  color: DynamicColor.lightRedClr,
                ),
                ),
              ),
SizedBox(
  height: Get.height/1.44,
  child: ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context,index){
    return Row(
      children: [
        const SizedBox(
          width: 25,
          height: 25,
          child: Image(
          image: AssetImage("assets/headingIcons.png"),
          ),
        ),
        SizedBox(
          width: Get.width/1.33,
          child: Text(list[index].text.toString(),
            style: poppinsRegularStyle(
              fontSize: 12,
              color: theme.primaryColor,
            ),
          ),
        ),
        SizedBox(
          width: 35,
          height: 30,
          child: Obx(
            ()=> Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.white,
              ),
              child: Checkbox(
                activeColor: DynamicColor.lightRedClr,
                value: list[index].checkBox!.value,
                onChanged: (v){
                  list[index].checkBox!.value = v!;
                },
              ),
            ),
          ),
        )
      ],
    );
  }),
)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: (){
            Get.toNamed(Routes.proposedMusicScreen);
          },
          text: "Continue",
        ),
      ),
    );
  }

  List<HardwareProvide> list = [
    HardwareProvide(text: "Vinyl Turntables",checkBox: true.obs),
    HardwareProvide(text: "CD Turntables",checkBox: true.obs),
    HardwareProvide(text: "Club Lighting for Small to Med Room",checkBox: false.obs),
    HardwareProvide(text: "Club Lighting for Med to Large Room",checkBox: false.obs),
    HardwareProvide(text: "Audio Amplifier and Speakers (Small Room)",checkBox: false.obs),
    HardwareProvide(text: "Audio Amplifier and Speakers (Med Room)",checkBox: false.obs),
    HardwareProvide(text: "Audio Amplifier and Speakers (Large Room)",checkBox: false.obs),
    HardwareProvide(text: "Video  Projector and Screen (5’x8’)",checkBox: false.obs),
    HardwareProvide(text: "Video  Projector and Screen (8’x10’)",checkBox: false.obs),
    HardwareProvide(text: "Video  Projector and Screen (10’x12’)",checkBox: false.obs),
    HardwareProvide(text: "Wired Microphones",checkBox: false.obs),
    HardwareProvide(text: "Wireless Microphones",checkBox: false.obs),
  ];
}

class HardwareProvide{
  String? text;
  RxBool? checkBox = false.obs;
  HardwareProvide({this.text,this.checkBox});
}
