

// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:intl/intl.dart';

class BookingFormFields extends StatelessWidget {
  BookingFormFields({Key? key}) : super(key: key);
  final format = DateFormat("HH:mm");
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Booking form"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              CustomTextFields(
                labelText: "Title",
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextFields(
                labelText: "Featuring",
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Get.width/1.5,
                    child: TextField(
                      keyboardType: TextInputType.none,
                      onTap: () async {
                         await showDatePicker(
                            builder: (context, child) {
                              return Theme(
                                  data: Theme.of(context)
                                      .copyWith(
                                    colorScheme: ColorScheme
                                        .light(
                                      primary: DynamicColor.grayClr,
                                      onPrimary: DynamicColor.grayClr,
                                      onSurface:
                                      Colors
                                          .black,
                                    ),
                                  ),
                                  child: child!);
                            },
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101));
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius
                                .circular(8),
                            borderSide: BorderSide(
                                width: 1,
                                color: DynamicColor.grayClr)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius
                                .circular(8),
                            borderSide: BorderSide(
                                width: 1,
                                color: DynamicColor.grayClr)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: DynamicColor.grayClr), //<-- SEE HERE
                        ),
                        hintText: "Select meeting date",
                        label: Padding(
                          padding: EdgeInsets.only(
                              left: 15.0),
                          child: Text("Date",
                            style: poppinsRegularStyle(
                              fontSize: 14,
                              color: DynamicColor.grayClr,
                            ),
                          ),
                        ),
                        labelStyle:
                        TextStyle(
                            color: DynamicColor.grayClr),
                        hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 13),
                        contentPadding: EdgeInsets.all(5),
                        suffixIcon: Icon(
                          Icons.calendar_month,
                          color: DynamicColor.grayClr,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: DynamicColor.darkGrayClr
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("One Time",
                        style: poppinsRegularStyle(
                          fontSize: 13,
                          context: context,
                          color: theme.primaryColor,
                        ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded,
                        size: 26,
                          color: DynamicColor.whiteClr,
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 50,
                child: DateTimeField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: DynamicColor.grayClr), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius
                            .circular(8),
                        borderSide: BorderSide(
                            width: 1,
                            color: DynamicColor.grayClr)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius
                            .circular(8),
                        borderSide: BorderSide(
                            width: 1,
                            color:DynamicColor.grayClr)),
                    // border: InputBorder.none,
                    label: Text('Check in'),
                    labelStyle: poppinsRegularStyle(
                      fontSize: 14,
                      color: DynamicColor.whiteClr,
                    ),
                    suffixIcon: Icon(
                      Icons.access_time_rounded,
                      color: Colors.white,
                    ),
                    hintStyle: poppinsRegularStyle(
                        fontSize: 16, color: Colors.black),
                  ),
                    onChanged: (DateTime? value) async{
                    await showTimePicker(
                     initialEntryMode:
                     TimePickerEntryMode.dial,
                     builder: (context, child) {
                       return Theme(
                           data: Theme.of(context)
                               .copyWith(
                             colorScheme: ColorScheme
                                 .light(
                               primary: DynamicColor.blackClr,
                               // <-- SEE HERE
                               onPrimary: DynamicColor.blackClr,
                               // <-- SEE HERE
                               onSurface:
                               Colors
                                   .black, // <-- SEE HERE
                             ),
                           ),
                           child: child!);
                     },
                     context: context,
                     initialTime: TimeOfDay.fromDateTime(
                         DateTime.now()),
                   );
                 },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 50,
                child: DateTimeField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: DynamicColor.grayClr), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius
                            .circular(8),
                        borderSide: BorderSide(
                            width: 1,
                            color: DynamicColor.grayClr)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius
                            .circular(8),
                        borderSide: BorderSide(
                            width: 1,
                            color:DynamicColor.grayClr)),
                    // border: InputBorder.none,
                    label: Text('Check out'),
                    labelStyle: poppinsRegularStyle(
                      fontSize: 14,
                      color: DynamicColor.whiteClr,
                    ),
                    suffixIcon: Icon(
                      Icons.access_time_rounded,
                      color: Colors.white,
                    ),
                    hintStyle: poppinsRegularStyle(
                        fontSize: 16, color: Colors.black),
                  ),
                    onChanged: (DateTime? value)  async{
                 await showTimePicker(
                     initialEntryMode:
                     TimePickerEntryMode.dial,
                     builder: (context, child) {
                       return Theme(
                           data: Theme.of(context)
                               .copyWith(
                             colorScheme: ColorScheme
                                 .light(
                               primary: DynamicColor.blackClr,
                               // <-- SEE HERE
                               onPrimary: DynamicColor.blackClr,
                               // <-- SEE HERE
                               onSurface:
                               Colors
                                   .black, // <-- SEE HERE
                             ),
                           ),
                           child: child!);
                     },
                     context: context,
                     initialTime: TimeOfDay.fromDateTime(
                         DateTime.now()),
                   );
                 }, 
                ),
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextFieldsHintText(
                maxLine: 5,
                controller: TextEditingController(),
                hintText: "Featuring",
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                borderClr: Colors.transparent,
                color1: DynamicColor.blackClr,
                color2: DynamicColor.blackClr,
                onTap: (){
                  Future.delayed(Duration(seconds: 2),(){
                    Get.offAllNamed(Routes.bottomNavigationView,
                        arguments: {
                          "indexValue": 0
                        }
                    );
                  });
                  showDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertWidget(
                          height: kToolbarHeight*4.4,
                          container: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Congratulation!',
                                  style: poppinsRegularStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                Text('The proposal has been sent to\nthe Venue Manager',
                                  style: poppinsRegularStyle(
                                    fontSize: 16,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 90,
                                  child: Image(
                                    image: AssetImage("assets/handshake.png"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                text: "Send Booking Request",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
