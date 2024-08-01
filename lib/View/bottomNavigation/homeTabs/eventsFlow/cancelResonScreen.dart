


// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';

class CancelReason extends StatelessWidget {
  CancelReason({Key? key}) : super(key: key);



  int _eventId = Get.arguments['eventId'];
  bool doubleBack = Get.arguments['doubleBack'];

  EventController _controller = Get.find();
  final cancellationForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Cancel"),
      body: GetBuilder<EventController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text("Reason for cancellation",
                    style: poppinsRegularStyle(
                      fontSize: 18,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: DynamicColor.avatarBgClr.withOpacity(0.4),
                  child: TextFormField(
                    maxLines: 6,
                    controller: controller.cancellationController,
                    style:poppinsRegularStyle(
                        context: context,
                        fontSize: 14,
                        color: DynamicColor.whiteClr
                    ),
                      textInputAction:TextInputAction.done,
                    validator: (value){
                      if(value == null){
                        return null;
                      } else {
                        return "Please enter cancellation reason";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "write here",
                      hintStyle: poppinsRegularStyle(
                          context: context,
                          fontSize: 14,
                          color: DynamicColor.grayClr.withOpacity(0.7)
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: DynamicColor.grayClr.withOpacity(0.5)), //<-- SEE HERE
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: DynamicColor.grayClr.withOpacity(0.5)), //<-- SEE HERE
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: DynamicColor.grayClr.withOpacity(0.5)), //<-- SEE HERE
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: (){
            // if(cancellationForm.currentState!.validate()){
              _controller.cancelEvents(eventId: _eventId,back: doubleBack);
            // }
         // Get.offAllNamed(Routes.bottomNavigationView,
         // arguments: {
         //   "indexValue": 2
         // }
         // );
          },
          text: "Send",
        ),
      ),
    );
  }
}
