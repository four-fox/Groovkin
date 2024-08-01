


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';

class BottomTextFields extends StatelessWidget {
  BottomTextFields({Key? key,this.userId,this.eventId}) : super(key: key);

  int? userId;
  int? eventId;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<ManagerController>(
      builder: (controller) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              color:theme.primaryColor,
              child: Column(
                children: [
                  ((controller.mediaClass.isNotEmpty) || (controller.profilePictures.isNotEmpty))?
            SizedBox(
              height: kToolbarHeight,
              width: Get.width,
              child:ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount:
                  controller.mediaClass.length,
                  itemBuilder:
                      (BuildContext context, index) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            width: 80,
                            height: kToolbarHeight,
                            decoration: BoxDecoration(
                                border: Border.all(color: theme.primaryColor,),
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    fit: BoxFit
                                        .fill,
                                    image: controller.mediaClass[index].thumbnail ==
                                        null
                                        ? FileImage(File(controller.mediaClass[index].filename.toString()))
                                        : FileImage(File(controller.mediaClass[index].thumbnail.toString()))
                                    as ImageProvider)),
                            child:controller.mediaClass[index].thumbnail !=
                                null? GestureDetector(
                              onTap: (){
                                Get.toNamed(Routes.videoPlayerClass,
                                    arguments: {
                                      "type": "file",
                                      "url": controller.mediaClass[index].filename
                                    }
                                );
                              },
                              child: Center(
                                child: Icon(Icons.play_arrow,
                                  size: 35,
                                ),
                              ),
                            ):SizedBox.shrink(),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            controller.mediaClass.remove(controller.mediaClass[index]);
                            controller.multiPartImg.remove(controller.multiPartImg[index]);
                            controller.profilePictures.remove(controller.profilePictures[index]);
                            controller.update();
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: theme.primaryColor,
                              child: CircleAvatar(
                                radius: 19,
                                backgroundColor: theme.scaffoldBackgroundColor,
                                child: Icon(Icons.close_outlined,
                                  color: theme.primaryColor,
                                  size: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ):SizedBox.shrink(),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: DynamicColor.grayClr)
                    ),
                    child: TextField(
                      style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.grayClr,
                      ),
                      minLines: 1,
                      maxLines: 3,
                      controller: controller.messageController,
                      decoration: InputDecoration(
                          hintText: "Write here  to Townsquare",
                          hintStyle: poppinsRegularStyle(
                            fontSize: 10,
                            context: context,
                            color: DynamicColor.grayClr,
                          ),
                          prefixIcon: GestureDetector(
                            onTap: (){
                              controller.pickFile();
                            },
                            child: Icon(Icons.attach_file_outlined,
                              color: DynamicColor.grayClr,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: (){
                              if(controller.messageController.text.isNotEmpty || controller.multiPartImg.isNotEmpty){
                                controller.sendMessage(receiverId: userId,eventId: eventId);
                                FocusScope.of(context).unfocus();
                              }else{
                                bottomToast(text: "Please write something");
                              }
                            },
                            child: ImageIcon(AssetImage("assets/sendIcon.png"),
                              color: DynamicColor.grayClr,
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
        )
        );
      }
    );
  }
}
