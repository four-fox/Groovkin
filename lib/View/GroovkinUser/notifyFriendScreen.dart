// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';

class NotifyScreen extends StatelessWidget {
  NotifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: customAppBar(theme: theme,text: "Notify your friends"),
      body: Padding(   padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Send an invitation to your Friends!",
                    style: poppinsRegularStyle(
                      fontSize: 13,
                      color: DynamicColor.lightRedClr,
                      context: context,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SearchTextFields(
                    controller: TextEditingController(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: Get.height/1.34,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (BuildContext context,index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(list[index].img.toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(list[index].name.toString(),
                            style: poppinsMediumStyle(
                              fontSize: 15,
                              color: theme.primaryColor,
                              context: context,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Obx(()=>
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: DynamicColor.lightWhite,
                            child: Checkbox(
                              activeColor: DynamicColor.lightRedClr,
                              value: list[index].checkBoxVal!.value,
                              onChanged: (v){
                                list[index].checkBoxVal!.value = !list[index].checkBoxVal!.value;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(4),
        child: CustomButton(
          borderClr: Colors.transparent,
          widths: Get.width,
          heights: 48,
          text: "Notify",
          onTap: (){
              Future.delayed(const Duration(seconds: 2),(){
                Get.back();
                Get.back();
              });
              showDialog(
                  barrierColor: Colors.transparent,
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertWidget(
                      height: Get.height/3.5,
                      container: Column(
                        children: [
                          const Image(image: AssetImage("assets/notifySend.png")),
                          Text("Notify Send",
                            style: poppinsMediumStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: theme.primaryColor,
                              context: context,
                            ),
                          )
                        ],
                      ),
                    );
                  });
          },
          textClr: theme.primaryColor,
        ),
      ),
    );
  }

  List<NotifyFriends> list = [
    NotifyFriends(name: "The Squad",checkBoxVal: false.obs, img: "assets/deletedImg/friend1.png"),
    NotifyFriends(name: "Homies",checkBoxVal: false.obs, img: "assets/deletedImg/friend2.png"),
    NotifyFriends(name: "Fantastic Four",checkBoxVal: false.obs, img: "assets/deletedImg/friend3.png"),
    NotifyFriends(name: "The Squad",checkBoxVal: false.obs, img: "assets/deletedImg/friend1.png"),
    NotifyFriends(name: "Homies",checkBoxVal: false.obs, img: "assets/deletedImg/friend2.png"),
    NotifyFriends(name: "Fantastic Four",checkBoxVal: false.obs, img: "assets/deletedImg/friend3.png"),
    NotifyFriends(name: "The Squad",checkBoxVal: false.obs, img: "assets/deletedImg/friend1.png"),
    NotifyFriends(name: "Homies",checkBoxVal: false.obs, img: "assets/deletedImg/friend2.png"),
    NotifyFriends(name: "Fantastic Four",checkBoxVal: false.obs, img: "assets/deletedImg/friend3.png"),
    NotifyFriends(name: "The Squad",checkBoxVal: false.obs, img: "assets/deletedImg/friend1.png"),
    NotifyFriends(name: "Homies",checkBoxVal: false.obs, img: "assets/deletedImg/friend2.png"),
    NotifyFriends(name: "Fantastic Four",checkBoxVal: false.obs, img: "assets/deletedImg/friend3.png"),
  ];
}

class NotifyFriends{
  String? img,name;
  RxBool? checkBoxVal = false.obs;
  NotifyFriends({this.name,this.img,this.checkBoxVal});
}
