// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_final_fields
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/showCustomMap.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/main.dart';
import 'package:map_location_picker/map_location_picker.dart';

class VenueDetailsManagerScreen extends StatelessWidget {
  VenueDetailsManagerScreen({super.key, this.serviceCondition = false});

  bool serviceCondition = false;

  ManagerController _controller = Get.find();

  RxDouble latAssign = 0.0.obs;
  RxDouble lngAssign = 0.0.obs;
  RxBool mapUpdate = true.obs;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: serviceCondition == true
          ? null
          : customAppBar(theme: theme, text: "Venue Detail", backArrow: true),
      body: GetBuilder<ManagerController>(builder: (controller) {
        if (controller.lat != "null" || controller.lng != "null") {
          latAssign.value = double.parse(controller.lat);
          lngAssign.value = double.parse(controller.lng);
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              serviceCondition == true
                  ? const SizedBox.shrink()
                  : Text(
                      "Venue Detail",
                      style: poppinsMediumStyle(
                          fontSize: 18,
                          color: theme.primaryColor,
                          context: context),
                    ),
              serviceCondition == true
                  ? const SizedBox.shrink()
                  : Text(
                      'You have successfully added.',
                      style: poppinsRegularStyle(
                          fontSize: 12,
                          context: context,
                          color: DynamicColor.lightRedClr),
                    ),
              SizedBox(
                height: serviceCondition == true ? 0 : 8,
              ),
              Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                color: DynamicColor.avatarBgClr.withValues(alpha: 0.44),
                child: Text(
                  "Contact Information",
                  style: poppinsRegularStyle(
                      fontSize: 16, color: DynamicColor.lightRedClr),
                ),
              ),
              if (controller.phoneNumController.text.isNotEmpty)
                venueService(
                    context: context,
                    theme: theme,
                    text: controller.phoneNumController.text,
                    image: "assets/phoneIcons.png",
                    iconClr: theme.primaryColor.withValues(alpha: 0.7)),
              venueService(
                  context: context,
                  theme: theme,
                  text:
                      "${controller.openingHoursController.text} to ${controller.closedHoursController.text}",
                  iconClr: theme.primaryColor.withValues(alpha: 0.7),
                  image: "assets/clrlessClock.png"),
              venueService(
                  context: context,
                  theme: theme,
                  text: controller.maxSeatingController.text,
                  image: "assets/groupPeopleIcon.png",
                  iconClr: theme.primaryColor.withValues(alpha: 0.7)),
              venueService(
                  context: context,
                  theme: theme,
                  text: controller.addressController.text,
                  image: "assets/location.png",
                  iconClr: theme.primaryColor.withValues(alpha: 0.7)),
              if (controller.websiteController1.text.isNotEmpty)
                Column(
                  children: [
                    eventDateTime(
                      theme: theme,
                      context: context,
                      iconBgClr:
                          DynamicColor.avatarBgClr.withValues(alpha: 0.8),
                      iconClr: theme.primaryColor.withValues(alpha: 0.7),
                      icon: true,
                      Iconss: Icons.public,
                      text: controller.websiteController1.text.toString(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              if (controller.facebookController.text.isNotEmpty)
                Column(
                  children: [
                    eventDateTime(
                        theme: theme,
                        context: context,
                        iconBgClr:
                            DynamicColor.avatarBgClr.withValues(alpha: 0.8),
                        iconClr: theme.primaryColor.withValues(alpha: 0.7),
                        icon: true,
                        text: controller.facebookController.text.toString(),
                        Iconss: FontAwesomeIcons.facebook),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              if (controller.instagramController1.text.isNotEmpty)
                Column(
                  children: [
                    eventDateTime(
                      theme: theme,
                      context: context,
                      iconBgClr:
                          DynamicColor.avatarBgClr.withValues(alpha: 0.8),
                      iconClr: theme.primaryColor.withValues(alpha: 0.7),
                      icon: true,
                      text: controller.instagramController1.text.toString(),
                      Iconss: FontAwesomeIcons.instagram,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),

              const SizedBox(
                height: 10,
              ),
              Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                color: DynamicColor.avatarBgClr.withValues(alpha: 0.44),
                child: Text(
                  "Max Occupancy",
                  style: poppinsRegularStyle(
                      fontSize: 16, color: DynamicColor.lightRedClr),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: venueService(
                    context: context,
                    theme: theme,
                    text: controller.maxOccupancyController.text,
                    image: "assets/groupPeopleIcon.png",
                    iconClr: theme.primaryColor.withValues(alpha: 0.7)),
              ),
              Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                color: DynamicColor.avatarBgClr.withValues(alpha: 0.44),
                child: Text(
                  "Max Seating",
                  style: poppinsRegularStyle(
                      fontSize: 16, color: DynamicColor.lightRedClr),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: venueService(
                    context: context,
                    theme: theme,
                    text: controller.maxSeatingController.text,
                    image: "assets/groupPeopleIcon.png",
                    iconClr: theme.primaryColor.withValues(alpha: 0.7)),
              ),
              Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                color: DynamicColor.avatarBgClr.withValues(alpha: 0.44),
                child: Text(
                  "Amenities",
                  style: poppinsRegularStyle(
                      fontSize: 16, color: DynamicColor.lightRedClr),
                ),
              ),
              ListView.builder(
                  itemCount: controller.selectedAmenities.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 6),
                      child: Row(
                        children: [
                          const Image(
                            image: AssetImage("assets/headingIcons.png"),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Text(
                              controller.selectedAmenities[index].name
                                  .toString(),
                              style: poppinsRegularStyle(
                                  fontSize: 13,
                                  color: theme.primaryColor,
                                  context: context),
                            ),
                          ),
                          Icon(
                            Icons.check,
                            color: DynamicColor.lightRedClr,
                            size: 17,
                          )
                        ],
                      ),
                    );
                  }),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                color: DynamicColor.avatarBgClr.withValues(alpha: 0.44),
                child: Text(
                  "Active Licenses\\Permits",
                  style: poppinsRegularStyle(
                      fontSize: 16, color: DynamicColor.lightRedClr),
                ),
              ),
              ListView.builder(
                  itemCount: controller.selectedLicensesPermit.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 6),
                      child: Row(
                        children: [
                          const Image(
                            image: AssetImage("assets/headingIcons.png"),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Text(
                              controller.selectedLicensesPermit[index].name
                                  .toString(),
                              style: poppinsRegularStyle(
                                  fontSize: 13,
                                  color: theme.primaryColor,
                                  context: context),
                            ),
                          ),
                          Icon(
                            Icons.check,
                            color: DynamicColor.lightRedClr,
                            size: 17,
                          )
                        ],
                      ),
                    );
                  }),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                color: DynamicColor.avatarBgClr.withValues(alpha: 0.44),
                child: Text(
                  "House Event Capabilites",
                  style: poppinsRegularStyle(
                      fontSize: 16, color: DynamicColor.lightRedClr),
                ),
              ),
              ListView.builder(
                  itemCount: controller.selectedHouseEventPermit.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 6),
                      child: Row(
                        children: [
                          const Image(
                            image: AssetImage("assets/headingIcons.png"),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Text(
                              controller.selectedHouseEventPermit[index].name
                                  .toString(),
                              style: poppinsRegularStyle(
                                  fontSize: 13,
                                  color: theme.primaryColor,
                                  context: context),
                            ),
                          ),
                          Icon(
                            Icons.check,
                            color: DynamicColor.lightRedClr,
                            size: 17,
                          )
                        ],
                      ),
                    );
                  }),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                color: DynamicColor.avatarBgClr.withValues(alpha: 0.44),
                child: Text(
                  "Venue Pictures",
                  style: poppinsRegularStyle(
                      fontSize: 16, color: DynamicColor.lightRedClr),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: kToolbarHeight * 2,
                width: Get.width,
                child: controller.mediaClass.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: controller.mediaClass.length,
                        itemBuilder: (BuildContext context, index) {
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  width: 100,
                                  height: kToolbarHeight * 2,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: theme.primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: controller.mediaClass[index]
                                                      .thumbnail ==
                                                  null
                                              ? FileImage(File(controller
                                                  .mediaClass[index].filename
                                                  .toString()))
                                              : FileImage(File(controller
                                                      .mediaClass[index]
                                                      .thumbnail
                                                      .toString()))
                                                  as ImageProvider)),
                                  child: controller
                                              .mediaClass[index].thumbnail !=
                                          null
                                      ? GestureDetector(
                                          onTap: () {
                                            Get.toNamed(Routes.videoPlayerClass,
                                                arguments: {
                                                  "type": "file",
                                                  "url": controller
                                                      .mediaClass[index]
                                                      .filename
                                                });
                                          },
                                          child: const Center(
                                            child: Icon(
                                              Icons.play_arrow,
                                              size: 35,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ),
                            ],
                          );
                        })
                    : controller.venueDetails != null
                        ? SizedBox(
                            height: kToolbarHeight * 2,
                            width: Get.width,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: controller
                                    .venueDetails!.data!.profilePicture!.length,
                                itemBuilder: (BuildContext context, index) {
                                  return Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: theme.primaryColor,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(controller
                                                      .venueDetails!
                                                      .data!
                                                      .profilePicture![index]
                                                      .mediaPath
                                                      .toString()))),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          )
                        : const SizedBox(),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
              //   child: Container(
              //     width: double.infinity,
              //     padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         color: DynamicColor.darkGrayClr
              //     ),
              //     child: Row(
              //       children: [
              //         Container(
              //           decoration: BoxDecoration(
              //             color: DynamicColor.blackClr,
              //             shape:BoxShape.circle,
              //             border: Border.all(color: DynamicColor.lightYellowClr),
              //           ),
              //           child: Image(
              //             image: AssetImage("assets/profileImg.png"),
              //           ),
              //         ),
              //         Padding(
              //           padding: EdgeInsets.only(left: 8.0),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text("Micheel Logan",
              //                 style: poppinsRegularStyle(
              //                   fontSize: 11,
              //                   context: context,
              //                   color: theme.primaryColor,
              //                 ),
              //               ),
              //               Text("Property Owner",
              //                 style: poppinsRegularStyle(
              //                   fontSize: 11,
              //                   context: context,
              //                   color: theme.primaryColor,
              //                 ),
              //               ),
              //               Text("Be Our Guest Events",
              //                 style: poppinsRegularStyle(
              //                   fontSize: 11,
              //                   context: context,
              //                   color: DynamicColor.lightRedClr,
              //                 ),
              //               ),
              //               RatingBar.builder(
              //                 initialRating: 3,
              //                 minRating: 1,
              //                 direction: Axis.horizontal,
              //                 allowHalfRating: true,
              //                 itemCount: 5,
              //                 itemSize: 13,
              //                   unratedcolor: theme.primaryColor,
              //                 itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              //                 itemBuilder: (context, _) => Icon(
              //                   Icons.star,
              //                   color: Colors.amber,
              //                 ),
              //                 onRatingUpdate: (rating) {
              //                   print(rating);
              //                 },
              //               )
              //             ],
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  readOnly: true,
                  controller: controller.addressController,
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
              ),
              const SizedBox(
                height: 10,
              ),
              controller.lat != "null"
                  ? Obx(
                      () => mapUpdate.value == false
                          ? const SizedBox.shrink()
                          : ShowCustomMap(
                              horizontalPadding: 12.0,
                              lat: double.parse(latAssign.value.toString()),
                              lng: double.parse(lngAssign.value.toString()),
                            ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      }),
      bottomNavigationBar: serviceCondition == true
          ? const SizedBox.shrink()
          : SafeArea(
              child: GetBuilder<ManagerController>(builder: (controller) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        color2: Colors.transparent,
                        color1: Colors.transparent,
                        backgroundClr: false,
                        textClr: DynamicColor.yellowClr,
                        widths: Get.width / 2.3,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MapLocationPicker(
                                  // hideLocation: true,
                                  // lat: double.parse(eventData.latitude.toString()),
                                  // long: double.parse(eventData.longitude.toString()),
                                  minMaxZoomPreference:
                                      const MinMaxZoomPreference(0, 16),
                                  apiKey:
                                      "AIzaSyC_-hLFYGAJC_IBMnFBKZLq2IS1qr7tJgQ",
                                  // canPopOnNextButtonTaped: true,
                                  canPopOnNextButtonTaped: true,
                                  searchHintText: controller.address != "null"
                                      ? controller.address
                                      : "Start typing to search",
                                  latLng: controller.latLng,
                                  initAddress: controller.address,
                                  backBtnn: true,
                                  onTappp: () {
                                    print("object2222");
                                  },
                                  onNext: (GeocodingResult? result) {
                                    if (result != null) {
                                      mapUpdate(false);
                                      controller.lat = result
                                          .geometry.location.lat
                                          .toString();
                                      controller.lng = result
                                          .geometry.location.lng
                                          .toString();
                                      controller.address =
                                          result.formattedAddress ?? "";
                                      _controller.latLng = LatLng(
                                          result.geometry.location.lat,
                                          result.geometry.location.lng);
                                      controller.addressController.text =
                                          result.formattedAddress!;
                                      Get.back();
                                      mapUpdate(true);
                                      _controller.update();
                                    }
                                  },
                                  onSuggestionSelected:
                                      (PlacesDetailsResponse? result) {
                                    if (result != null) {
                                      mapUpdate(false);
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
                                      mapUpdate(true);
                                      controller.update();
                                    }
                                  },
                                );
                                /*MapLocationPicker(
                              apiKey: "AIzaSyC_-hLFYGAJC_IBMnFBKZLq2IS1qr7tJgQ",
                              popOnNextButtonTaped: true,
                              currentLatLng: _controller.lat != "null"?
                              LatLng(double.parse(_controller.lat.toString()), double.parse(_controller.lng.toString())):
                              LatLng(28.8993468, 76.6250249),
                              btnOnTap: (){
                                Get.back();
                              },
                              onNext: (GeocodingResult? result) {
                                if (result != null) {
                                  _controller.address = result.formattedAddress ?? "";
                                  _controller.addressController.text = _controller.address;
                                  _controller.lat = result.geometry.location.lat.toString();
                                  _controller.lng = result.geometry.location.lng.toString();
                                  _controller.update();
                                }
                              },
                              onSuggestionSelected: (PlacesDetailsResponse? result) {
                                if (result != null) {
                                  _controller.autocompletePlace =
                                      result.result.formattedAddress ?? "";
                                  _controller.addressController.text = _controller.autocompletePlace;
                                  _controller.lat = result.result.geometry!.location.lat.toString();
                                  _controller.lng = result.result.geometry!.location.lng.toString();
                                  _controller.update();
                                }
                              },
                            );*/
                              },
                            ),
                          );
                        },
                        fontSized: 13,
                        text: "Add another location",
                      ),
                      CustomButton(
                        borderClr: Colors.transparent,
                        widths: Get.width / 2.3,
                        onTap: () {
                          if (_controller.updateAmenities.value == true) {
                            _controller.editVenue();
                          } else {
                            if (_controller.mediaClass.isNotEmpty) {
                              _controller.createVenue(context, theme);
                            } else {
                              bottomToast(
                                  text: "Please venue pictures is required");
                            }
                          }
                        },
                        text: _controller.updateAmenities.value == true
                            ? "Update"
                            : "Complete",
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }
}

/// those event details which done

class ViewOtherEventsDetails extends StatefulWidget {
  const ViewOtherEventsDetails({super.key});

  @override
  State<ViewOtherEventsDetails> createState() => _ViewOtherEventsDetailsState();
}

class _ViewOtherEventsDetailsState extends State<ViewOtherEventsDetails> {
  ManagerController _controller = Get.find();
  final TextEditingController venueReasonController = TextEditingController();
  int venueId = Get.arguments['venueId'];

  bool btnShow = Get.arguments['buttonShow'] ?? false;

  bool editButton = Get.arguments['editBtn'] ?? false;

  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight * 3.0),
        child: Obx(
          () => _controller.getVenueDetailsLoader.value == false
              ? const SizedBox.shrink()
              : Container(
                  height: kToolbarHeight * 2.3 + 30,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/grayClor.png"),
                          fit: BoxFit.fill)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: ImageIcon(
                                const AssetImage("assets/backArrow.png"),
                                color: isDark(context)
                                    ? theme.primaryColor
                                    : DynamicColor.whiteClr,
                              ),
                            ),
                            API().sp.read("role") == "eventOrganizer"
                                ? IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              margin:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller:
                                                        venueReasonController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: "Reason",
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    maxLines: 5,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  CustomButton(
                                                    borderClr:
                                                        Colors.transparent,
                                                    heights: 35,
                                                    fontSized: 13,
                                                    onTap: () async {
                                                      Get.back();
                                                      await _authController
                                                          .reportAccount(
                                                              type: "venue",
                                                              sourceId: venueId,
                                                              message:
                                                                  venueReasonController
                                                                      .text)
                                                          .then((value) {
                                                        venueReasonController
                                                            .clear();
                                                      });
                                                    },
                                                    text: "Report",
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.more_vert,
                                        color: isDark(context)
                                            ? theme.primaryColor
                                            : DynamicColor.whiteClr))
                                : const SizedBox()
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: DynamicColor.lightRedClr),
                                    image: DecorationImage(
                                        image: NetworkImage(_controller
                                                    .venueDetails!
                                                    .data!
                                                    .user!
                                                    .profilePicture ==
                                                null
                                            ? groupPlaceholder
                                            : _controller.venueDetails!.data!
                                                .user!.profilePicture!.mediaPath
                                                .toString()),
                                        fit: BoxFit.fill)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _controller.venueDetails!.data!.user!.name
                                          .toString(),
                                      style: poppinsRegularStyle(
                                          fontSize: 16,
                                          context: context,
                                          color: isDark(context)
                                              ? theme.primaryColor
                                              : DynamicColor.whiteClr),
                                    ),
                                    Text(
                                      "Event Place",
                                      style: poppinsRegularStyle(
                                          fontSize: 16,
                                          context: context,
                                          color: isDark(context)
                                              ? theme.primaryColor
                                              : DynamicColor.whiteClr),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              editButton == false
                                  ? const SizedBox.shrink()
                                  : GestureDetector(
                                      onTap: () {
                                        _controller.editVenueDataBind();
                                      },
                                      child: Icon(Icons.edit_calendar_rounded,
                                          size: 30,
                                          color: isDark(context)
                                              ? theme.primaryColor
                                              : DynamicColor.whiteClr),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
      body: GetBuilder<ManagerController>(initState: (v) {
        _controller.getVenueDetails(id: venueId);
      }, builder: (controller) {
        return ((controller.getVenueDetailsLoader.value == false) ||
                (controller.venueDetails == null))
            ? const SizedBox.shrink()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    eventsTitles(text: "Contact Information"),
                    const SizedBox(
                      height: 10,
                    ),
                    eventDateTime(
                        theme: theme,
                        context: context,
                        iconBgClr: DynamicColor.lightBlackClr,
                        iconClr: DynamicColor.grayClr,
                        text:
                            "${controller.venueDetails!.data!.venueProperty!.openingHours} to ${controller.venueDetails!.data!.venueProperty!.closingHours}"),
                    const SizedBox(
                      height: 10,
                    ),
                    eventDateTime(
                      theme: theme,
                      context: context,
                      iconBgClr: DynamicColor.lightBlackClr,
                      iconClr: DynamicColor.grayClr,
                      img: "assets/groupPeopleIcon.png",
                      text: controller
                          .venueDetails!.data!.venueProperty!.maxSeating,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    eventDateTime(
                      theme: theme,
                      context: context,
                      iconBgClr: DynamicColor.lightBlackClr,
                      iconClr: DynamicColor.grayClr,
                      icon: true,
                      text: controller.venueDetails!.data!.location.toString(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (controller.venueDetails!.data!.website != null)
                      eventDateTime(
                        theme: theme,
                        context: context,
                        iconBgClr: DynamicColor.lightBlackClr,
                        iconClr: DynamicColor.grayClr,
                        icon: true,
                        Iconss: Icons.public,
                        text: controller.venueDetails!.data!.website.toString(),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (controller.venueDetails?.data?.socialLinks != null &&
                        controller
                            .venueDetails!.data!.socialLinks!.isNotEmpty &&
                        controller.venueDetails!.data!.socialLinks!.first
                                .facebook !=
                            null)
                      Column(
                        children: [
                          eventDateTime(
                            theme: theme,
                            context: context,
                            iconBgClr: DynamicColor.lightBlackClr,
                            iconClr: DynamicColor.grayClr,
                            icon: true,
                            Iconss: FontAwesomeIcons.facebookF,
                            text: controller
                                .venueDetails!.data!.socialLinks!.first.facebook
                                .toString(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    if (controller.venueDetails?.data?.socialLinks != null &&
                        controller
                            .venueDetails!.data!.socialLinks!.isNotEmpty &&
                        controller.venueDetails!.data!.socialLinks!.first
                                .instagram !=
                            null)
                      Column(
                        children: [
                          eventDateTime(
                            theme: theme,
                            context: context,
                            iconBgClr: DynamicColor.lightBlackClr,
                            iconClr: DynamicColor.grayClr,
                            icon: true,
                            Iconss: FontAwesomeIcons.instagram,
                            text: controller.venueDetails!.data!.socialLinks!
                                .first.instagram
                                .toString(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    eventsTitles(text: "Image"),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: kToolbarHeight * 2,
                      width: Get.width,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ListView.builder(
                            itemCount: controller
                                .venueDetails!.data!.profilePicture!.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  width: 130,
                                  height: kToolbarHeight * 2,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: theme.primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: controller
                                                      .venueDetails!
                                                      .data!
                                                      .profilePicture![index]
                                                      .thumbnail !=
                                                  null
                                              ? NetworkImage(controller
                                                  .venueDetails!
                                                  .data!
                                                  .profilePicture![index]
                                                  .thumbnail
                                                  .toString())
                                              : NetworkImage(controller
                                                  .venueDetails!
                                                  .data!
                                                  .profilePicture![index]
                                                  .mediaPath
                                                  .toString()))),
                                  child: controller
                                              .venueDetails!
                                              .data!
                                              .profilePicture![index]
                                              .thumbnail !=
                                          null
                                      ? GestureDetector(
                                          onTap: () {
                                            Get.toNamed(Routes.videoPlayerClass,
                                                arguments: {
                                                  "type": "filedsaf",
                                                  "url": controller
                                                      .venueDetails!
                                                      .data!
                                                      .profilePicture![index]
                                                      .mediaPath
                                                      .toString()
                                                });
                                          },
                                          child: Center(
                                            child: Icon(
                                              Icons.play_arrow,
                                              size: 35,
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              );
                            }),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    eventsTitles(text: "Max Occupancy"),
                    const SizedBox(
                      height: 15,
                    ),
                    eventDateTime(
                      theme: theme,
                      context: context,
                      iconBgClr: DynamicColor.lightBlackClr,
                      iconClr: DynamicColor.grayClr,
                      img: "assets/groupPeopleIcon.png",
                      text: controller
                          .venueDetails!.data!.venueProperty!.maxOccupancy,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    eventsTitles(text: "Max Seating"),
                    const SizedBox(
                      height: 15,
                    ),
                    eventDateTime(
                      theme: theme,
                      context: context,
                      iconBgClr: DynamicColor.lightBlackClr,
                      iconClr: DynamicColor.grayClr,
                      img: "assets/groupPeopleIcon.png",
                      text: controller
                          .venueDetails!.data!.venueProperty!.maxSeating,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    eventsTitles(text: "Amenities"),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ListView.builder(
                          itemCount:
                              controller.venueDetails!.data!.amenities!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, index) {
                            return Row(
                              children: [
                                const Image(
                                  image: AssetImage("assets/headingIcons.png"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    controller.venueDetails!.data!
                                        .amenities![index].venueItem!.name
                                        .toString(),
                                    style: poppinsRegularStyle(
                                      fontSize: 12,
                                      context: context,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    eventsTitles(text: "House Event Capabilities"),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ListView.builder(
                          itemCount: controller.venueDetails!.data!
                              .houseEventCapabilities!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, index) {
                            return Row(
                              children: [
                                const Image(
                                  image: AssetImage("assets/headingIcons.png"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    controller
                                        .venueDetails!
                                        .data!
                                        .houseEventCapabilities![index]
                                        .venueItem!
                                        .name
                                        .toString(),
                                    style: poppinsRegularStyle(
                                      fontSize: 12,
                                      context: context,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    eventsTitles(text: "Licenses and permit"),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ListView.builder(
                          itemCount: controller
                              .venueDetails!.data!.licensesAndPermit!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, index) {
                            return Row(
                              children: [
                                const Image(
                                  image: AssetImage("assets/headingIcons.png"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    controller
                                        .venueDetails!
                                        .data!
                                        .licensesAndPermit![index]
                                        .venueItem!
                                        .name
                                        .toString(),
                                    style: poppinsRegularStyle(
                                      fontSize: 12,
                                      context: context,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
      }),
      bottomNavigationBar: btnShow == false
          ? const SizedBox.shrink()
          : SafeArea(
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: CustomButton(
                  borderClr: Colors.transparent,
                  onTap: () {
                    Get.toNamed(Routes.eventPreview,
                        arguments: {"viewDetails": 1});
                  },
                  text: "Continue",
                ),
              ),
            ),
    );
  }

  List list = [
    "assets/venue1.png",
    "assets/venue2.png",
    "assets/venue3.png",
    "assets/venue1.png",
    "assets/venue2.png",
    "assets/venue3.png",
  ];
}

// class  extends StatelessWidget {
//   const ({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
