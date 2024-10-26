// ignore_for_file: unnecessary_new, prefer_final_fields

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/showCustomMap.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:map_location_picker/map_location_picker.dart';

import '../../Components/colors.dart';

class CreateCompanyProfileScreen extends StatefulWidget {
  CreateCompanyProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateCompanyProfileScreen> createState() =>
      _CreateCompanyProfileScreenState();
}

class _CreateCompanyProfileScreenState
    extends State<CreateCompanyProfileScreen> {
  final venueForm = GlobalKey<FormState>();

  PhoneNumber number = PhoneNumber(isoCode: "US");
  ManagerController _controller = Get.find();
  bool editVenue = Get.arguments['updationCondition'];

  @override
  void initState() {
    super.initState();
    if (editVenue == true) {
      extractNumber(_controller.phoneNumController.text);
    }
  }

  extractNumber(String phone) async {
    if (_controller.venueDetails!.data != null) {
      PhoneNumber numbers =
          await PhoneNumber.getRegionInfoFromPhoneNumber(phone);
      number = PhoneNumber(
        phoneNumber: numbers.phoneNumber,
        isoCode: numbers.isoCode,
      );
      _controller.update();
    }
  }

  bool skipBtn = Get.arguments['skipBtnHide'];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight * 1.9),
        child: Container(
          height: kToolbarHeight * 1.9,
          padding: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/grayClor.png"), fit: BoxFit.fill),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              skipBtn == true
                  ? GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.arrow_back,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              Text(
                "Add a new venue",
                style: poppinsMediumStyle(
                  fontSize: 17,
                  color: theme.primaryColor,
                ),
              ),
              skipBtn == true
                  ? SizedBox.shrink()
                  : Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.offAllNamed(Routes.bottomNavigationView,
                              arguments: {"indexValue": 1});
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 6.0),
                          child: Container(
                            height: 25,
                            width: 60,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: DynamicColor.grayClr.withOpacity(0.4)),
                            child: Center(
                              child: Text(
                                "Skip",
                                style: poppinsRegularStyle(
                                  fontSize: 13,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      body: Form(
        key: venueForm,
        child: GetBuilder<ManagerController>(builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  GestureDetector(
                    onTap: () {
                      if ((controller.mediaClass.isEmpty) ||
                          (controller.profilePictures.isEmpty)) {
                        controller.pickFile();
                        // if(Platform.isAndroid){
                        //   controller.pickFile();
                        // }else{
                        //   controller.pickFileee();
                        // }
                      }
                    },
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(20),
                      color: DynamicColor.whiteClr.withOpacity(0.8),
                      child: Container(
                        height: kToolbarHeight * 2.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: theme.scaffoldBackgroundColor,
                        ),
                        width: Get.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ((controller.mediaClass.isNotEmpty) ||
                                    (controller.profilePictures.isNotEmpty))
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (Platform.isAndroid) {
                                          controller.pickFile();
                                        } else {
                                          controller.pickFileee();
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.0),
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            controller.profilePictures.isEmpty
                                ? ((editVenue == false) &&
                                        (controller.mediaClass.isNotEmpty))
                                    ? SizedBox(
                                        height: kToolbarHeight * 2,
                                        width: Get.width,
                                        child: ListView.builder(
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.0),
                                                    child: Container(
                                                      width: 100,
                                                      height:
                                                          kToolbarHeight * 2,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: theme
                                                                .primaryColor,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: controller.mediaClass[index].thumbnail ==
                                                                      null
                                                                  ? FileImage(File(controller
                                                                      .mediaClass[
                                                                          index]
                                                                      .filename
                                                                      .toString()))
                                                                  : FileImage(File(controller
                                                                      .mediaClass[index]
                                                                      .thumbnail
                                                                      .toString())) as ImageProvider)),
                                                      child: controller
                                                                  .mediaClass[
                                                                      index]
                                                                  .thumbnail !=
                                                              null
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                Get.toNamed(
                                                                    Routes
                                                                        .videoPlayerClass,
                                                                    arguments: {
                                                                      "type":
                                                                          "file",
                                                                      "url": controller
                                                                          .mediaClass[
                                                                              index]
                                                                          .filename
                                                                    });
                                                              },
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .play_arrow,
                                                                  size: 35,
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox.shrink(),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      controller.mediaClass
                                                          .remove(controller
                                                                  .mediaClass[
                                                              index]);
                                                      controller.multiPartImg
                                                          .remove(controller
                                                                  .multiPartImg[
                                                              index]);
                                                      controller.update();
                                                    },
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: CircleAvatar(
                                                        radius: 15,
                                                        backgroundColor:
                                                            theme.primaryColor,
                                                        child: CircleAvatar(
                                                          radius: 14,
                                                          backgroundColor: theme
                                                              .scaffoldBackgroundColor,
                                                          child: Icon(
                                                            Icons
                                                                .close_outlined,
                                                            color: theme
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                      )
                                    : Image(
                                        image: AssetImage(
                                            "assets/locationIcon.png"),
                                        height: 45,
                                        width: 45,
                                        fit: BoxFit.contain,
                                      )
                                : controller.profilePictures.isEmpty
                                    ? Image(
                                        image: AssetImage(
                                            "assets/locationIcon.png"),
                                        height: 45,
                                        width: 45,
                                        fit: BoxFit.contain,
                                      )
                                    : SizedBox(
                                        height: kToolbarHeight * 2,
                                        width: Get.width,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: controller
                                                .profilePictures.length,
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              return Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.0),
                                                    child: Container(
                                                      width: 100,
                                                      height:
                                                          kToolbarHeight * 2,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: theme
                                                                .primaryColor,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          image:
                                                              DecorationImage(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  image: controller.profilePictures[index].mediaFor ==
                                                                          null
                                                                      ? controller.profilePictures[index].thumbnail ==
                                                                              null
                                                                          ? FileImage(File(controller.profilePictures[index].mediaPath
                                                                              .toString()))
                                                                          : FileImage(File(controller.profilePictures[index].thumbnail
                                                                              .toString()))
                                                                      : NetworkImage(controller.profilePictures[index].thumbnail !=
                                                                              null
                                                                          ? controller
                                                                              .profilePictures[index]
                                                                              .thumbnail
                                                                              .toString()
                                                                          : controller.profilePictures[index].mediaPath.toString()) as ImageProvider)),
                                                      child: controller
                                                                  .profilePictures[
                                                                      index]
                                                                  .thumbnail !=
                                                              null
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                Get.toNamed(
                                                                    Routes
                                                                        .videoPlayerClass,
                                                                    arguments: {
                                                                      "type":
                                                                          "filedsaf",
                                                                      "url": controller
                                                                          .profilePictures[
                                                                              index]
                                                                          .mediaPath
                                                                    });
                                                              },
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .play_arrow,
                                                                  size: 35,
                                                                  color: theme
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox.shrink(),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      controller.removeImgList
                                                          .add(controller
                                                              .profilePictures[
                                                                  index]
                                                              .id);
                                                      controller.profilePictures
                                                          .remove(controller
                                                                  .profilePictures[
                                                              index]);
                                                      controller.update();
                                                    },
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: CircleAvatar(
                                                        radius: 15,
                                                        backgroundColor:
                                                            theme.primaryColor,
                                                        child: CircleAvatar(
                                                          radius: 14,
                                                          backgroundColor: theme
                                                              .scaffoldBackgroundColor,
                                                          child: Icon(
                                                            Icons
                                                                .close_outlined,
                                                            color: theme
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                      ),
                            ((controller.mediaClass.isEmpty) &&
                                    (controller.profilePictures.isEmpty))
                                ? Text(
                                    "Upload Venue’s Photo",
                                    style: poppinsMediumStyle(
                                      context: context,
                                      fontSize: 14,
                                      color: DynamicColor.grayClr,
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // CustomTextFields(
                  //   labelText: "Add Location",
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  CustomTextFields(
                    labelText: "Venue name",
                    controller: controller.venueNameController,
                    validationError: "venue name",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFields(
                    labelText: "Street Address",
                    controller: controller.streetAddressController,
                    validationError: "street address",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFields(
                    labelText: "State",
                    controller: controller.stateController,
                    validationError: "state",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFields(
                    labelText: "City",
                    controller: controller.cityController,
                    validationError: "city",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      validateMobile(number.phoneNumber!);
                      controller.phoneNumController.text =
                          number.phoneNumber.toString();
                      // controller.numberAssign = number.dialCode.toString();
                      // controller.update();
                    },
                    inputDecoration: InputDecoration(
                      fillColor: Colors.black,
                      hintStyle: TextStyle(
                        color: DynamicColor.grayClr,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: DynamicColor.grayClr),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: DynamicColor.grayClr),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: DynamicColor.grayClr),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.only(
                        left: 15,
                      ),
                      hintText: "Enter Phone No",
                      labelStyle: TextStyle(
                        color: DynamicColor.grayClr,
                      ),
                    ),
                    onInputValidated: (bool value) {},
                    onFieldSubmitted: (value) {
                      // getPhoneNumber(signUpController.phoneController.text);
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      setSelectorButtonAsPrefixIcon: true,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: poppinsRegularStyle(
                      context: context,
                      fontSize: 14,
                      color: DynamicColor.grayClr,
                    ),
                    initialValue: number,
                    hintText: "Phone Number(optional)",
                    hintStyle: poppinsRegularStyle(
                        context: context,
                        fontSize: 14,
                        color: DynamicColor.grayClr),
                    textStyle: poppinsRegularStyle(
                      context: context,
                      fontSize: 14,
                      color: DynamicColor.grayClr,
                    ),
                    spaceBetweenSelectorAndTextField: 0,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: InputBorder.none,
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFields(
                    labelText: "Zip Code",
                    controller: controller.zipController,
                    validationError: "zip code",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    readOnly: true,
                    controller: controller.addressController,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MapLocationPicker(
                              backBtnn: true,
                              // hideLocation: true,
                              // lat: double.parse(eventData.latitude.toString()),
                              // long: double.parse(eventData.longitude.toString()),
                              minMaxZoomPreference: MinMaxZoomPreference(0, 15),
                              apiKey: "AIzaSyC_-hLFYGAJC_IBMnFBKZLq2IS1qr7tJgQ",
                              canPopOnNextButtonTaped: true,
                              searchHintText: controller.address != "null"
                                  ? controller.address
                                  : "Start typing to search",
                              // canPopOnNextButtonTaped: true,
                              latLng: controller.latLng,
                              initAddress: controller.address,
                              onNext: (GeocodingResult? result) {
                                if (result != null) {
                                  controller.lat =
                                      result.geometry.location.lat.toString();
                                  controller.lng =
                                      result.geometry.location.lng.toString();
                                  controller.address =
                                      result.formattedAddress ?? "";
                                  controller.latLng = LatLng(
                                      result.geometry.location.lat,
                                      result.geometry.location.lng);
                                  controller.addressController.text =
                                      result.formattedAddress!;
                                  controller.update();
                                }
                              },
                              onSuggestionSelected:
                                  (PlacesDetailsResponse? result) {
                                if (result != null) {
                                  controller.lat = result
                                      .result.geometry!.location.lat
                                      .toString();
                                  controller.lng = result
                                      .result.geometry!.location.lng
                                      .toString();
                                  controller.autocompletePlace =
                                      result.result.formattedAddress ?? "";
                                  controller.address =
                                      result.result.formattedAddress ?? "";
                                  controller.latLng = LatLng(
                                      result.result.geometry!.location.lat,
                                      result.result.geometry!.location.lng);
                                  controller.addressController.text =
                                      result.result.formattedAddress!;
                                  controller.update();
                                }
                              },
                            );
                            //   MapLocationPicker(
                            //   apiKey: "AIzaSyC_-hLFYGAJC_IBMnFBKZLq2IS1qr7tJgQ",
                            //   popOnNextButtonTaped: true,
                            //   currentLatLng: controller.lat != "null"?
                            //   LatLng(double.parse(controller.lat.toString()),
                            //       double.parse(controller.lng.toString())):
                            //   LatLng(40.730610, -73.935242),
                            //   btnOnTap: (){
                            //     Get.back();
                            //     controller.update();
                            //   },
                            //   onNext: (GeocodingResult? result) {
                            //     if (result != null) {
                            //       controller.address = result.formattedAddress ?? "";
                            //       controller.addressController.text = controller.address;
                            //       controller.lat = result.geometry.location.lat.toString();
                            //       controller.lng = result.geometry.location.lng.toString();
                            //       print("object2222");
                            //       controller.update();
                            //     }
                            //   },
                            //   onSuggestionSelected: (PlacesDetailsResponse? result) {
                            //     if (result != null) {
                            //       controller.autocompletePlace =
                            //           result.result.formattedAddress ?? "";
                            //       controller.addressController.text = controller.autocompletePlace;
                            //       controller.lat = result.result.geometry!.location.lat.toString();
                            //       controller.lng = result.result.geometry!.location.lng.toString();
                            //       print("object111");
                            //       controller.update();
                            //     }
                            //   },
                            // );
                          },
                        ),
                      );
                    },
                    style: poppinsRegularStyle(
                      fontSize: 15,
                      color: theme.primaryColor,
                      context: context,
                    ),
                    decoration: InputDecoration(
                      labelText: "Location",
                      labelStyle: poppinsRegularStyle(
                        fontSize: 15,
                        color: theme.primaryColor,
                        context: context,
                      ),
                      suffixIcon: Icon(
                        Icons.location_searching,
                        size: 20,
                        color: theme.primaryColor,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: DynamicColor.grayClr),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: DynamicColor.grayClr),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  controller.lat != "null"
                      ? ShowCustomMap(
                          horizontalPadding: 0.0,
                          lat: double.parse(controller.lat),
                          lng: double.parse(controller.lng),
                        )
                      : SizedBox.shrink(),
                  Row(
                    children: [
                      SizedBox(
                        width: 25,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.white,
                          ),
                          child: Checkbox(
                              activeColor: DynamicColor.lightRedClr,
                              value: controller.termsConditionAgree.value,
                              onChanged: (v) {
                                if (controller.termsConditionAgree.value ==
                                    false) {
                                  showDialog(
                                      barrierColor: Colors.transparent,
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertWidget(
                                          height: kToolbarHeight * 5,
                                          container: SizedBox(
                                            width: Get.width,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0.0, horizontal: 4),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.0),
                                                    child: Text(
                                                      '“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 5,
                                                      style:
                                                          poppinsRegularStyle(
                                                        fontSize: 13,
                                                        context: context,
                                                        color:
                                                            theme.primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        CustomButton(
                                                          heights: 40,
                                                          color1: theme
                                                              .primaryColor,
                                                          color2: theme
                                                              .primaryColor,
                                                          widths:
                                                              Get.width / 3.0,
                                                          onTap: () {
                                                            Get.back();
                                                          },
                                                          backgroundClr: false,
                                                          textClr: theme
                                                              .scaffoldBackgroundColor,
                                                          borderClr: Colors
                                                              .transparent,
                                                          text: "Deny",
                                                        ),
                                                        CustomButton(
                                                          heights: 40,
                                                          widths:
                                                              Get.width / 3.0,
                                                          color1: DynamicColor
                                                              .redClr,
                                                          color2: DynamicColor
                                                              .redClr,
                                                          onTap: () {
                                                            Get.back();
                                                            controller
                                                                .termsConditionAgree
                                                                .value = v!;
                                                            controller.update();
                                                          },
                                                          borderClr: Colors
                                                              .transparent,
                                                          text: "Agree",
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                } else {
                                  controller.termsConditionAgree.value = false;
                                }
                                controller.update();
                              }),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: Text(
                          "agree to terms and condition",
                          style: poppinsRegularStyle(
                            fontSize: 14,
                            context: context,
                            color: theme.primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    text: "Add Venue Detail",
                    onTap: () {
                      if (venueForm.currentState!.validate()) {
                        if (controller.termsConditionAgree.value == false) {
                          bottomToast(
                              text: "Please accept terms and condition");
                        } else {
                          if (controller.multiPartImg.isEmpty &&
                              editVenue == false) {
                            bottomToast(text: "Please choose venue image");
                          } else {
                            Get.toNamed(Routes.addVenueScreen);
                          }
                        }
                      }
                    },
                    borderClr: Colors.transparent,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
