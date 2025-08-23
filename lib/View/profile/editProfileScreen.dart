import 'dart:io';

import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/Network/Url.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class editProfileScreen extends StatefulWidget {
  const editProfileScreen({super.key});

  @override
  State<editProfileScreen> createState() => _editProfileScreenState();
}

class _editProfileScreenState extends State<editProfileScreen> {
  String initialCountry = 'NG';

  PhoneNumber number = PhoneNumber(isoCode: 'US');

  final AuthController _controller = Get.find();

  @override
  void initState() {
    // controller.getUserModel!.data!.name =
    //     controller.editProfileNameController.text;
    super.initState();
    extractNumber(_controller.phoneNumController.text);
  }

  extractNumber(String phone) async {
    if (_controller.userData!.data != null) {
      PhoneNumber numbers =
          await PhoneNumber.getRegionInfoFromPhoneNumber(phone);
      number = PhoneNumber(
        phoneNumber: numbers.phoneNumber,
        isoCode: numbers.isoCode,
      );
      _controller.update();
    }
  }

  final editProfileForm = GlobalKey<FormState>();
  List<int> dobYear = [];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
          appBar: customAppBar(theme: theme, text: "Edit Profile"),
          body: Form(
            key: editProfileForm,
            child: GetBuilder<AuthController>(initState: (v) {
              for (int a = DateTime.now().year - 18; a >= 1950; a--) {
                dobYear.add(a);
              }
            }, builder: (controller) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: kToolbarHeight * 2.5,
                      width: double.infinity,
                      color: DynamicColor.darkGrayClr,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: DynamicColor.blackClr,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: DynamicColor.lightRedClr),
                                        image: DecorationImage(
                                          image: controller.imageBytes == null
                                              ? NetworkImage(controller
                                                          .userData!
                                                          .data
                                                          ?.profilePicture !=
                                                      null
                                                  ? Url().imageUrl +
                                                      controller
                                                          .userData!
                                                          .data!
                                                          .profilePicture!
                                                          .mediaPath
                                                  : groupPlaceholder)
                                              : FileImage(File(
                                                      controller.imageBytes!))
                                                  as ImageProvider,
                                          fit: BoxFit.fill,
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      pictureAlert(context, cameraFtn: () {
                                        controller.cameraImage(
                                            context, ImageSource.camera);
                                        Get.back();
                                      }, galleryFtn: () {
                                        controller.cameraImage(
                                            context, ImageSource.gallery);
                                        Get.back();
                                      });
                                    },
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 35,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            color: DynamicColor.darkGrayClr
                                                .withValues(alpha: 0.9)),
                                        child: const Image(
                                          image: AssetImage(
                                              "assets/refreshIcon.png"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: CustomButton(
                                    heights: 27,
                                    widths: 100,
                                    onTap: () {
                                      if (editProfileForm.currentState!
                                          .validate()) {
                                        controller.createProfile(
                                            userId: API().sp.read("userId"));
                                      }
                                    },
                                    text: "Save changes",
                                    style: poppinsMediumStyle(
                                        context: context,
                                        fontSize: 10,
                                        color: DynamicColor.whiteClr),
                                    borderClr: Colors.transparent,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text(
                            // controller.userData!.data!.profile!.firstName! +
                            //     controller.userData!.data!.profile!.lastName!,
                            controller.userData?.data?.name ?? "Guest",
                            style: poppinsMediumStyle(
                              context: context,
                              fontSize: 16,
                              color: theme.primaryColor,
                            ),
                          ),
                          Text(
                            'Member since ${DateFormat.MMMd().format(controller.userData!.data!.profile!.createdAt!)}',
                            style: poppinsMediumStyle(
                                context: context,
                                fontSize: 10,
                                color: DynamicColor.grayClr
                                    .withValues(alpha: 0.9)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: CustomTextFields(
                        labelText: "First Name",
                        validationError: "first name",
                        controller: controller.firstNameController,
                        iconShow: false,
                        labelStyling: poppinsRegularStyle(
                            context: context,
                            fontSize: 14,
                            color: DynamicColor.grayClr),
                        // readOnly: nameEdit.value,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: CustomTextFields(
                        labelText: "Last Name",
                        validationError: "last name",
                        controller: controller.lastNameController,
                        iconShow: false,

                        labelStyling: poppinsRegularStyle(
                            context: context,
                            fontSize: 14,
                            color: DynamicColor.grayClr),
                        // readOnly: nameLast.value,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: CustomTextFields(
                        labelText: "Username",
                        validationError: "username",
                        iconShow: false,
                        controller: controller.displayNameController,
                        labelStyling: poppinsRegularStyle(
                          context: context,
                          fontSize: 14,
                          color: DynamicColor.grayClr,
                        ),
                        // readOnly: userName.value,
                      ),
                    ),
                    SizedBox(
                      height: sp.read('role') == "eventManager" ? 15 : 0,
                    ),
                    sp.read('role') == "eventManager"
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: CustomTextFields(
                              labelText: "Company Name",
                              validationError: "company Name",
                              iconShow: false,
                              ignoredValidation: true,
                              controller: controller.companyNameController,
                              labelStyling: poppinsRegularStyle(
                                context: context,
                                fontSize: 14,
                                color: DynamicColor.grayClr,
                              ),
                              // readOnly: userName.value,
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: CustomTextFields(
                        labelText: "Email",
                        iconShow: false,
                        readOnly: true,
                        controller: controller.emailController,
                        labelStyling: poppinsRegularStyle(
                            context: context,
                            fontSize: 14,
                            color: DynamicColor.grayClr),
                        // readOnly: email.value,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextField(
                        keyboardType: TextInputType.none,
                        style: poppinsRegularStyle(
                          context: context,
                          fontSize: 14,
                          color: DynamicColor.grayClr,
                        ),
                        readOnly: true,
                        controller: controller.dobController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: DynamicColor.grayClr
                                      .withValues(alpha: 0.6)), //<-- SEE HERE
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: DynamicColor.grayClr
                                      .withValues(alpha: 0.6)), //<-- SEE HERE
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: DynamicColor.grayClr
                                      .withValues(alpha: 0.6)), //<-- SEE HERE
                            ),
                            hintText: "Enter Date of birth",
                            label: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Year of Birth",
                                style: poppinsRegularStyle(
                                    context: context,
                                    fontSize: 14,
                                    color: DynamicColor.grayClr),
                              ),
                            ),
                            labelStyle: TextStyle(color: DynamicColor.grayClr),
                            hintStyle: const TextStyle(
                                fontFamily: 'Montserrat', fontSize: 13),
                            contentPadding: const EdgeInsets.all(5),
                            suffixIcon: GestureDetector(
                              onTap: () async {
                                Get.bottomSheet(Container(
                                  color: theme.scaffoldBackgroundColor,
                                  height: kToolbarHeight * 3,
                                  child: ListView.builder(
                                      itemCount: dobYear.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            controller.dobController.text =
                                                dobYear[index].toString();
                                            Get.back();
                                          },
                                          child: Column(
                                            children: [
                                              Text(dobYear[index].toString()),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 4),
                                child: Container(
                                  height: 40,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: DynamicColor.avatarBgClr
                                          .withValues(alpha: 0.6)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "YYYY",
                                        style: poppinsRegularStyle(
                                            fontSize: 12,
                                            context: context,
                                            color: DynamicColor.grayClr),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 25,
                                        color: theme.primaryColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    sp.read("role") == "eventOrganizer"
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: CountryStateCityPicker(
                                country: controller.countryController,
                                state: controller.stateController,
                                // dialogColor: Colors.grey.shade200,
                                textFieldDecoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                      fontSize: 14, color: Color(0xff9DA3B5)),
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  // suffixIcon: Icon(Icons.arrow_downward_rounded),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: DynamicColor.grayClr.withValues(
                                            alpha: 0.6)), //<-- SEE HERE
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: DynamicColor.grayClr.withValues(
                                            alpha: 0.6)), //<-- SEE HERE
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: DynamicColor.grayClr.withValues(
                                            alpha: 0.6)), //<-- SEE HERE
                                  ),
                                )),
                          )
                        : const SizedBox.shrink(),
                    SizedBox(
                      height:
                          API().sp.read("role") == "eventOrganizer" ? 15 : 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: InternationalPhoneNumberInput(
                        // textFieldController: controller.phoneNumController,
                        onInputChanged: (PhoneNumber number) {
                          validateMobile(number.phoneNumber!);
                          controller.phoneNumController.text =
                              number.phoneNumber.toString();
                          controller.numberAssign = number.dialCode.toString();
                          controller.update();
                        },
                        inputDecoration: InputDecoration(
                          fillColor: Colors.black,
                          hintStyle: TextStyle(color: DynamicColor.grayClr),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: DynamicColor.grayClr),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: DynamicColor.grayClr),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: DynamicColor.grayClr),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          contentPadding: const EdgeInsets.only(
                            left: 15,
                          ),
                          hintText: "Enter Phone No",
                          labelStyle: TextStyle(color: DynamicColor.blackClr),
                        ),
                        onInputValidated: (bool value) {},
                        onFieldSubmitted: (value) {
                          // getPhoneNumber(signUpController.phoneController.text);
                        },
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          setSelectorButtonAsPrefixIcon: true,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: poppinsRegularStyle(
                          context: context,
                          fontSize: 14,
                          color: theme.primaryColor,
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
                          color: theme.primaryColor,
                        ),
                        spaceBetweenSelectorAndTextField: 0,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputBorder: InputBorder.none,
                        onSaved: (PhoneNumber number) {
                          print('On Saved: $number');
                        },
                      ),
                    ),

                    // CustomTextFields(
                    //     labelText: "Birth Year",
                    //     iconShow: true,
                    //       style: poppinsRegularStyle(
                    //           context: context,
                    //           fontSize: 14,
                    //           color: DynamicColor.lightRedClr
                    //       ),
                    //     labelStyling: poppinsRegularStyle(
                    //           context: context,
                    //           fontSize: 14,
                    //           color: DynamicColor.grayClr
                    //       ),
                    //     onTap: (){
                    //       dob.value = !dob.value;
                    //     },
                    //     // readOnly: dob.value,
                    //   ),

                    const SizedBox(
                      height: 15,
                    ),

                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 12.0),
                    //   child: InternationalPhoneNumberInput(
                    //     onInputChanged: (PhoneNumber number) {
                    //       print(number.phoneNumber);
                    //     },
                    //     onInputValidated: (bool value) {
                    //       print(value);
                    //     },
                    //     selectorConfig: SelectorConfig(
                    //       selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    //     ),
                    //     ignoreBlank: false,
                    //     autoValidateMode: AutovalidateMode.disabled,
                    //     selectorTextStyle: poppinsRegularStyle(
                    //         context: context,
                    //         fontSize: 14,
                    //       color: theme.primaryColor,
                    //     ),
                    //     textStyle: poppinsRegularStyle(
                    //         context: context,
                    //         fontSize: 14,
                    //         color: theme.primaryColor,
                    //     ),
                    //     initialValue: number,
                    //     textFieldController: controller.phoneNumController,
                    //     formatInput: true,
                    //     keyboardType:
                    //     TextInputType.numberWithOptions(signed: true, decimal: true),
                    //     inputBorder: InputBorder.none,
                    //     onSaved: (PhoneNumber number) {
                    //       print('On Saved: $number');
                    //     },
                    //   ),
                    // ),
                    if (controller.zipController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: CustomTextFields(
                          labelText: "Zip Code",
                          iconShow: false,
                          readOnly: false,
                          controller: controller.zipController,
                          labelStyling: poppinsRegularStyle(
                              context: context,
                              fontSize: 14,
                              color: DynamicColor.grayClr),
                          // readOnly: email.value,
                        ),
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (controller.instagramController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: CustomTextFields(
                          labelText: "Instagram",
                          iconShow: false,
                          readOnly: false,
                          controller: controller.instagramController,
                          labelStyling: poppinsRegularStyle(
                              context: context,
                              fontSize: 14,
                              color: DynamicColor.grayClr),
                          // readOnly: email.value,
                        ),
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (controller.twitterXController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: CustomTextFields(
                          labelText: "Twitter X",
                          iconShow: false,
                          readOnly: false,
                          controller: controller.twitterXController,
                          labelStyling: poppinsRegularStyle(
                              context: context,
                              fontSize: 14,
                              color: DynamicColor.grayClr),
                          // readOnly: email.value,
                        ),
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (controller.youtubeController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: CustomTextFields(
                          labelText: "Youtube",
                          iconShow: false,
                          readOnly: false,
                          controller: controller.youtubeController,
                          labelStyling: poppinsRegularStyle(
                              context: context,
                              fontSize: 14,
                              color: DynamicColor.grayClr),
                          // readOnly: email.value,
                        ),
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: CustomTextFields(
                        labelText: "about",
                        iconShow: false,
                        validationError: "about",
                        maxLine: 5,
                        controller: controller.aboutController,
                        // style: poppinsRegularStyle(
                        //     context: context,
                        //     fontSize: 14,
                        //     color: DynamicColor.lightRedClr
                        // ),
                        labelStyling: poppinsRegularStyle(
                            context: context,
                            fontSize: 14,
                            color: DynamicColor.grayClr),
                        // readOnly: email.value,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }),
          )),
    );
  }
}

pictureAlert(context,
    {GestureTapCallback? cameraFtn,
    GestureTapCallback? galleryFtn,
    bool gallery = true}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context)
              .copyWith(dialogBackgroundColor: DynamicColor.avatarBgClr),
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            content: Container(
              height: 150,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  gallery == true
                      ? GestureDetector(
                          onTap: galleryFtn,
                          child: Row(
                            children: [
                              Icon(
                                Icons.photo_library,
                                color: DynamicColor.lightRedClr,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  "Gallery",
                                  style: poppinsMediumStyle(
                                    fontSize: 20,
                                    latterSpacing: 1.1,
                                    fontWeight: FontWeight.w600,
                                    color: DynamicColor.lightRedClr,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  GestureDetector(
                    onTap: cameraFtn,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.photo_camera,
                            color: DynamicColor.lightRedClr,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              'Camera',
                              style: poppinsMediumStyle(
                                fontSize: 20,
                                latterSpacing: 1.1,
                                fontWeight: FontWeight.w600,
                                color: DynamicColor.lightRedClr,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.close,
                          color: DynamicColor.lightRedClr,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Cancel",
                            style: poppinsMediumStyle(
                              fontSize: 20,
                              latterSpacing: 1.1,
                              fontWeight: FontWeight.w600,
                              color: DynamicColor.lightRedClr,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      /*CupertinoAlertDialog(
      content: Column(
        children: [
          gallery==true? GestureDetector(
            onTap: galleryFtn,
            child: Row(
              children: [
                Icon(
                  Icons.photo_library,
                  color: DynamicColor.lightRedClr,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Gallery",
                    style: poppinsMediumStyle(
                      fontSize: 20,
                      latterSpacing: 1.1,
                      fontWeight: FontWeight.w600,
                      color: DynamicColor.lightRedClr,),
                  ),
                ),
              ],
            ),
          ):SizedBox.shrink(),
          GestureDetector(
            onTap: cameraFtn,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  Icon(
                    Icons.photo_camera,
                    color: DynamicColor.lightRedClr,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Camera',
                      style: poppinsMediumStyle(
                        fontSize: 20,
                        latterSpacing: 1.1,
                        fontWeight: FontWeight.w600,
                        color: DynamicColor.lightRedClr,),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Row(
              children: [
                Icon(
                  Icons.close,
                  color: DynamicColor.lightRedClr,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Cancel",
                    style: poppinsMediumStyle(
                      fontSize: 20,
                      latterSpacing: 1.1,
                      fontWeight: FontWeight.w600,
                      color: DynamicColor.lightRedClr,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),*/
      );
}
