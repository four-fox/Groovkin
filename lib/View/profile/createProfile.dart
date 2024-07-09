


import 'dart:io';

import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/profile/createProfileController.dart';
import 'package:groovkin/View/profile/editProfileScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:month_year_picker/month_year_picker.dart';

class CreateProfile extends StatelessWidget {
  CreateProfile({Key? key}) : super(key: key);

  final createProfileForm = GlobalKey<FormState>();
  PhoneNumber number = PhoneNumber(isoCode: "US");

  AuthController _controller = Get.find();
  List<int> dobYear = [];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Form(
      key: createProfileForm,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          leading:  GestureDetector(
            onTap: (){
              Get.back();
            },
            child: ImageIcon(AssetImage('assets/backArrow.png'),
              size: 32,
              color: theme.primaryColor,
            ),
          ),
          centerTitle: true,
          title: Text(sp.read("role")=="User"?"Create your user account":"Create your account",
          style: poppinsMediumStyle(
            fontSize: 16,
            color:sp.read("role")=="User"? DynamicColor.lightYellowClr: theme.primaryColor,
            context: context,
          ),
          ),
        ),
        body: GetBuilder<AuthController>(
          initState: (v){
            for (int a = DateTime.now().year; a >= 1900; a--) {
              dobYear.add(a);
            }
            _controller.dobController.clear();
          },
          builder: (controller) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        pictureAlert(
                            context,
                            cameraFtn: () {
                              controller.cameraImage(context,ImageSource.camera);
                              Get.back();
                            },
                            galleryFtn: () {
                              controller.cameraImage(context,ImageSource.gallery);
                              Get.back();
                            });
                      },
                      child: controller.imageBytes !=null? CircleAvatar(
                        radius: 40,
                        backgroundImage: FileImage(File(controller.imageBytes!)),
                      ) : CircleAvatar(
                        radius: 40,
                        backgroundColor: sp.read("role")=="eventManager"?theme.primaryColor: DynamicColor.avatarBgClr,
                        child: ImageIcon(
                          AssetImage("assets/imageUploadIcon.png"),
                          color: DynamicColor.yellowClr,
                          size: 31,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Upload Profile Photo",
                    style: poppinsMediumStyle(
                      context: context,
                      fontSize: 14,
                      color: theme.primaryColor,
                    ),
                    ),
                    sp.read("role")=="User"? Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text("(optional)",
                      style: poppinsMediumStyle(
                        context: context,
                        fontSize: 14,
                        color: DynamicColor.lightRedClr,
                      ),
                      ),
                    ):SizedBox.shrink(),
                    SizedBox(
                      height: 28,
                    ),
                    CustomTextFields(
                      labelText: "First name",
                      controller: controller.firstNameController,
                      validationError: "first name",
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextFields(
                      labelText: "Last name (Not displayed)",
                      controller: controller.lastNameController,
                      validationError: "last name",
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextFields(
                      labelText: "Display name",
                      controller: controller.displayNameController,
                      validationError: "display name",
                    ),
                    SizedBox(
                      height: sp.read("role")=="User"? 15:0,
                    ),
                    sp.read("role")=="User"? TextField(
                      keyboardType: TextInputType.none,
                      style:poppinsRegularStyle(
                          context: context,
                          fontSize: 14,
                          color:DynamicColor.grayClr
                      ),
                      readOnly: true,
                      controller: controller.dobController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: DynamicColor.grayClr.withOpacity(0.6)), //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: DynamicColor.grayClr.withOpacity(0.6)), //<-- SEE HERE
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: DynamicColor.grayClr.withOpacity(0.6)), //<-- SEE HERE
                          ),
                        hintText: "Enter Year of birth",
                        label: Padding(
                          padding: EdgeInsets.only(
                              left: 15.0),
                          child: Text("Year Of Birth",
                            style: poppinsRegularStyle(
                                context: context,
                                fontSize: 14,
                                color: DynamicColor.grayClr
                            ),
                          ),
                        ),
                        labelStyle: TextStyle(
                            color: DynamicColor.grayClr),
                        hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 13),
                        contentPadding: EdgeInsets.all(5),
                      suffixIcon: GestureDetector(
                          onTap: () async {

                            Get.bottomSheet(Container(
                              color: theme.scaffoldBackgroundColor,
                              height: kToolbarHeight*3,
                              child: ListView.builder(
                                itemCount: dobYear.length,
                                  itemBuilder: (BuildContext context,index){
                                return GestureDetector(
                                  onTap: (){
                                    controller.dobController.text = dobYear[index].toString();
                                    Get.back();
                                  },
                                  child: Column(
                                    children: [
                                      Text(dobYear[index].toString(),
                                        style: TextStyle(
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                      Divider(
                                        color: theme.primaryColor,
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ));
                          },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0,vertical: 4),
                          child: Container(
                            height: 40,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: DynamicColor.avatarBgClr.withOpacity(0.6)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("YYYY",
                                style: poppinsRegularStyle(
                                  fontSize: 12,
                                  context: context,
                                  color: DynamicColor.grayClr
                                ),
                                ),
                                Icon(Icons.keyboard_arrow_down,
                                size: 25,
                                    color: DynamicColor.grayClr
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      ),
                    ):SizedBox.shrink(),
                    SizedBox(
                      height: 15,
                    ),

                    InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        validateMobile(number.phoneNumber!);
                        controller.phoneNumController.text =
                            number.phoneNumber.toString();
                        controller.numberAssign = number.dialCode.toString();
                        controller.update();
                      },
                      inputDecoration: InputDecoration(
                        fillColor: Colors.black,
                        hintStyle: TextStyle(
                            color: DynamicColor.grayClr
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: DynamicColor.grayClr),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                              DynamicColor.grayClr),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                              DynamicColor.grayClr),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.only(
                          left: 15,
                        ),
                        hintText: "Enter Phone No",
                        labelStyle: TextStyle(
                            color: DynamicColor.blackClr
                        ),
                      ),
                      onInputValidated: (bool value) {},
                      onFieldSubmitted: (value) {
                        // getPhoneNumber(signUpController.phoneController.text);
                      },
                      selectorConfig: SelectorConfig(
                        selectorType:
                        PhoneInputSelectorType.BOTTOM_SHEET,
                        setSelectorButtonAsPrefixIcon: true,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: poppinsRegularStyle(
                          context: context,
                          fontSize: 14,
                          color: DynamicColor.grayClr
                      ),
                      initialValue: number,
                      hintText: "Phone Number(optional)",
                      hintStyle: poppinsRegularStyle(
                          context: context,
                          fontSize: 14,
                          color: DynamicColor.grayClr
                      ),
                      textStyle: poppinsRegularStyle(
                          context: context,
                          fontSize: 14,
                          color: DynamicColor.grayClr
                      ),
                      spaceBetweenSelectorAndTextField: 0,
                      keyboardType:
                      TextInputType.numberWithOptions(signed: true, decimal: true),
                      inputBorder: InputBorder.none,
                      onSaved: (PhoneNumber number) {
                        print('On Saved: $number');
                      },
                    ),

                    // InternationalPhoneNumberInput(
                    //   onInputChanged: (PhoneNumber number) {
                    //     validateMobile(number.phoneNumber!);
                    //     controller.phoneNumController.text =
                    //         number.phoneNumber.toString();
                    //     controller.numberAssign = number.dialCode.toString();
                    //     controller.update();
                    //     },
                    //   onInputValidated: (bool value) {
                    //     print(value);
                    //   },
                    //   selectorConfig: SelectorConfig(
                    //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    //   ),
                    //   ignoreBlank: false,
                    //   autoValidateMode: AutovalidateMode.disabled,
                    //   selectorTextStyle: poppinsRegularStyle(
                    //       context: context,
                    //       fontSize: 14,
                    //     color: theme.primaryColor,
                    //   ),
                    //   initialValue: number,
                    //   textFieldController: controller.phoneNumController,
                    //   formatInput: true,
                    //   hintText: "Phone Number(optional)",
                    //   hintStyle: poppinsRegularStyle(
                    //       context: context,
                    //       fontSize: 14,
                    //       color: DynamicColor.grayClr
                    //   ),
                    //   textStyle: poppinsRegularStyle(
                    //       context: context,
                    //       fontSize: 14,
                    //       color: theme.primaryColor,
                    //   ),
                    //   keyboardType:
                    //   TextInputType.numberWithOptions(signed: true, decimal: true),
                    //   inputBorder: InputBorder.none,
                    //   onSaved: (PhoneNumber number) {
                    //     print('On Saved: $number');
                    //   },
                    // ),
                    SizedBox(
                      height:sp.read('role')=="eventManager"? 15:0,
                    ),
                    SizedBox(
                      height: 15,
                    ),


                    sp.read("role")=="eventOrganizer"? CountryStateCityPicker(
                        country: controller.countryController,
                        state: controller.stateController,
                        // dialogColor: Colors.grey.shade200,
                        textFieldDecoration: InputDecoration(
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xff9DA3B5)
                          ),
                            fillColor: Colors.transparent,
                            filled: true,
                            // suffixIcon: Icon(Icons.arrow_downward_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: DynamicColor.grayClr.withOpacity(0.6)), //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: DynamicColor.grayClr.withOpacity(0.6)), //<-- SEE HERE
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: DynamicColor.grayClr.withOpacity(0.6)), //<-- SEE HERE
                          ),
                        )
                    ):SizedBox.shrink(),


                    // sp.read("role")=="eventOrganizer"? CustomTextFields(
                    //   labelText: "Select State",
                    //   validationError: "select state",
                    //   controller: controller.stateController,
                    // ):SizedBox.shrink(),
                    sp.read("role")=="eventOrganizer"? SizedBox(
                      height: 15,
                    ):SizedBox.shrink(),
                    CustomTextFields(
                      labelText: "About us",
                      maxLine: 5,
                      controller: controller.aboutController,
                      validationError: "about us",
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // SizedBox(
                    //   height: sp.read("role")=="User"? 15:0,
                    // ),
                    // sp.read("role")=="User"? CustomTextFields(
                    //   labelText: "Password",
                    // ):SizedBox.shrink(),
                    // SizedBox(
                    //   height: 28,
                    // ),
                  ],
                ),
              ),
            );
          }
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: (){
              if(createProfileForm.currentState!.validate()){
                if(API().sp.read("role")=="eventOrganizer"){
                  showDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertWidget(
                            height: kToolbarHeight*4,
                            borderColor: Colors.transparent,
                            container: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Terms and conditions",
                                    style: poppinsMediumStyle(
                                        fontSize: 18,
                                        context: context,
                                        color: theme.primaryColor,
                                    ),
                                  ),
                                  Text("“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”",
                                    maxLines: 4,
                                    style: poppinsRegularStyle(
                                        fontSize: 10,
                                        context: context,
                                        color: theme.primaryColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomButton(
                                          borderClr: Colors.transparent,
                                          backgroundClr: false,
                                          color1: DynamicColor.redClr,
                                          color2: DynamicColor.redClr,
                                          widths: Get.width/3.25,
                                          heights: 30,
                                          fontSized: 12,
                                          onTap: (){
                                            // Get.offAllNamed(Routes.subscriptionScreen);
                                            Get.back();
                                          },
                                          text: "Decline",
                                        ),
                                        CustomButton(
                                          borderClr: Colors.transparent,
                                          backgroundClr: false,
                                          color1: DynamicColor.greenClr,
                                          color2: DynamicColor.greenClr,
                                          widths: Get.width/3.25,
                                          heights: 30,
                                          fontSized: 12,
                                          onTap: (){
                                            // if(_controller.imageBytes != null){
                                              _controller.sigUp(context);
                                            // }else{
                                            //   bottomToast(text: "Please upload profile image");
                                            // }
                                          },
                                          text: "Accept",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                        );
                      });
                }else{
                  // if(_controller.imageBytes != null){
                    _controller.sigUp(context);
                  // }else{
                  //   bottomToast(text: "Please upload profile image");
                  // }
                }
              }
              // Get.offAllNamed(Routes.welComeScreen);
            },
            text: "Next",
          ),
        ),
      ),
    );
  }
}


List yearList = [
  ""
];