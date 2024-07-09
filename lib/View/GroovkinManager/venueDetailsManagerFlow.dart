// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_final_fields
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/Url.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/showCustomMap.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:popup_banner/popup_banner.dart';

class VenueDetailsManagerScreen extends StatelessWidget {
  VenueDetailsManagerScreen({Key? key,this.serviceCondition = false}) : super(key: key);

  bool serviceCondition = false;

  ManagerController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar:serviceCondition==true?null: customAppBar(theme: theme,text: "Venue Detail",backArrow: true),
      body: GetBuilder<ManagerController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                serviceCondition==true?SizedBox.shrink(): Text("Venue Detail",
                  style: poppinsMediumStyle(
                      fontSize: 18,
                      color: theme.primaryColor,
                      context: context
                  ),
                ),
                serviceCondition==true?SizedBox.shrink(): Text('You have successfully added.',
                  style: poppinsRegularStyle(
                      fontSize: 12,
                      context: context,
                      color: DynamicColor.lightRedClr
                  ),
                ),
                SizedBox(
                  height:serviceCondition==true?0: 8,
                ),
                Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  color: DynamicColor.avatarBgClr.withOpacity(0.44),
                  child: Text("Contact Information",
                    style: poppinsRegularStyle(
                        fontSize: 16,
                        color: DynamicColor.lightRedClr
                    ),
                  ),
                ),
                venueService(context: context,theme: theme,text: controller.phoneNumController.text,image: "assets/phoneIcons.png",iconClr: theme.primaryColor.withOpacity(0.7)),
                venueService(context: context,theme: theme,text: "${controller.openingHoursController.text} to ${controller.closedHoursController.text}",iconClr: theme.primaryColor.withOpacity(0.7),image: "assets/clrlessClock.png"),
                venueService(context: context,theme: theme,text: controller.maxSeatingController.text,image: "assets/groupPeopleIcon.png",iconClr: theme.primaryColor.withOpacity(0.7)),
                venueService(context: context,theme: theme,text: controller.addressController.text,image: "assets/location.png",iconClr: theme.primaryColor.withOpacity(0.7)),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  color: DynamicColor.avatarBgClr.withOpacity(0.44),
                  child: Text("Max Occupancy",
                    style: poppinsRegularStyle(
                        fontSize: 16,
                        color: DynamicColor.lightRedClr
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: venueService(context: context,theme: theme,text: controller.maxOccupancyController.text,image: "assets/groupPeopleIcon.png",iconClr: theme.primaryColor.withOpacity(0.7)),
                ),
                Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  color: DynamicColor.avatarBgClr.withOpacity(0.44),
                  child:Text("Max Seating",
                    style: poppinsRegularStyle(
                        fontSize: 16,
                        color: DynamicColor.lightRedClr
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: venueService(context: context,theme: theme,text: controller.maxSeatingController.text,image: "assets/groupPeopleIcon.png",iconClr: theme.primaryColor.withOpacity(0.7)),
                ),
                Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  color: DynamicColor.avatarBgClr.withOpacity(0.44),
                  child:Text("Amenities",
                    style: poppinsRegularStyle(
                        fontSize: 16,
                        color: DynamicColor.lightRedClr
                    ),
                  ),
                ),
                ListView.builder(
                    itemCount: controller.selectedAmenities.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context,index){
                      return Padding(
                        padding: EdgeInsets.only(left: 12.0,top: 6),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage("assets/headingIcons.png"),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.0),
                              child: Text(controller.selectedAmenities[index].name.toString(),
                                style: poppinsRegularStyle(
                                    fontSize: 13,
                                    color: theme.primaryColor,
                                    context: context
                                ),
                              ),
                            ),
                            Icon(Icons.check,
                              color: DynamicColor.lightRedClr,
                              size: 17,
                            )
                          ],
                        ),
                      );
                    }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  color: DynamicColor.avatarBgClr.withOpacity(0.44),
                  child:Text("Active Licenses\\Permits",
                    style: poppinsRegularStyle(
                        fontSize: 16,
                        color: DynamicColor.lightRedClr
                    ),
                  ),
                ),
                ListView.builder(
                    itemCount: controller.selectedLicensesPermit.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context,index){
                      return Padding(
                        padding: EdgeInsets.only(left: 12.0,top: 6),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage("assets/headingIcons.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Text(controller.selectedLicensesPermit[index].name.toString(),
                                style: poppinsRegularStyle(
                                    fontSize: 13,color:
                                theme.primaryColor,
                                    context: context
                                ),
                              ),
                            ),
                            Icon(Icons.check,
                              color: DynamicColor.lightRedClr,
                              size: 17,
                            )
                          ],
                        ),
                      );
                    }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  color: DynamicColor.avatarBgClr.withOpacity(0.44),
                  child:Text("House Event Capabilites",
                    style: poppinsRegularStyle(
                        fontSize: 16,
                        color: DynamicColor.lightRedClr
                    ),
                  ),
                ),
                ListView.builder(
                    itemCount: controller.selectedHouseEventPermit.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context,index){
                      return Padding(
                        padding: EdgeInsets.only(left: 12.0,top: 6),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage("assets/headingIcons.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Text(controller.selectedHouseEventPermit[index].name.toString(),
                                style: poppinsRegularStyle(
                                    fontSize: 13,color:
                                theme.primaryColor,
                                    context: context
                                ),
                              ),
                            ),
                            Icon(Icons.check,
                              color: DynamicColor.lightRedClr,
                              size: 17,
                            )
                          ],
                        ),
                      );
                    }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  color: DynamicColor.avatarBgClr.withOpacity(0.44),
                  child:Text("Venue Pictures",
                    style: poppinsRegularStyle(
                        fontSize: 16,
                        color: DynamicColor.lightRedClr
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: kToolbarHeight*2,
                  width: Get.width,
                  child:controller.mediaClass.isNotEmpty? ListView.builder(
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
                                width: 100,
                                height: kToolbarHeight*2,
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
                          ],
                        );
                      }):SizedBox(
                  height: kToolbarHeight*2,
                  width: Get.width,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount:
                      controller.venueDetails!.data!.profilePicture!.length,
                      itemBuilder:
                          (BuildContext context, index) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(color: theme.primaryColor,),
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        fit: BoxFit
                                            .fill,
                                        image: NetworkImage(Url().imageUrl+controller.venueDetails!.data!.profilePicture![index].mediaPath.toString()))),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
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
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
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

                      suffixIcon: Icon(Icons.location_searching,
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
                SizedBox(
                  height: 10,
                ),
                controller.lat != "null"? ShowCustomMap(horizontalPadding:12.0,
                  lat: double.parse(controller.lat),
                  lng: double.parse(controller.lng),
                ):SizedBox.shrink(),

              ],
            ),
          );
        }
      ),
      bottomNavigationBar:serviceCondition==true?SizedBox.shrink(): Padding(
        padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(
              color2: Colors.transparent,
              color1: Colors.transparent,
              backgroundClr: false,
              textClr: DynamicColor.yellowClr,
              widths: Get.width/2.3,
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return

                        MapLocationPicker(
                          hideLocation: true,
                          // lat: double.parse(eventData.latitude.toString()),
                          // long: double.parse(eventData.longitude.toString()),
                          minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                          apiKey:
                          "AIzaSyCPDZxZYp3Su6ReZTh4lHRoie6HAM2P0sU",
                          // canPopOnNextButtonTaped: true,

                          onNext: (GeocodingResult? result) {
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
              widths: Get.width/2.3,
              onTap: (){
                if(_controller.updateAmenities.value == true){
                  _controller.editVenue();
                }else{
                  if(_controller.mediaClass.isNotEmpty){
                    _controller.createVenue(context,theme);
                  }else{
                    bottomToast(text: "Please venue pictures is required");
                  }
                }
              },
              text:_controller.updateAmenities.value == true?"Updated": "Completed",
            ),
          ],
        ),
      ),
    );
  }
}



/// those event details which done

class ViewOtherEventsDetails extends StatelessWidget {
  ViewOtherEventsDetails({Key? key}) : super(key: key);

  ManagerController _controller = Get.find();
  int venueId = Get.arguments['venueId'];
  bool btnShow = Get.arguments['buttonShow']??false;
  bool editButton = Get.arguments['editBtn']??false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight*3.0),
        child: Obx(
          ()=> _controller.getVenueDetailsLoader.value== false?SizedBox.shrink(): Container(
            height: kToolbarHeight*2.3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/grayClor.png"),
                    fit: BoxFit.fill
                )
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: ImageIcon(AssetImage("assets/backArrow.png"),
                      color: theme.primaryColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: DynamicColor.lightRedClr),
                          image: DecorationImage(
                              image: NetworkImage(Url().imageUrl+_controller.venueDetails!.data!.user!.profilePicture!.mediaPath.toString()),
                              fit: BoxFit.fill
                          )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_controller.venueDetails!.data!.user!.name.toString(),
                                style: poppinsRegularStyle(
                                  fontSize: 16,
                                  context: context,
                                  color: theme.primaryColor,
                                ),
                              ),
                              Text("Event Place",
                                style: poppinsRegularStyle(
                                  fontSize: 16,
                                  context: context,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        editButton == false?SizedBox.shrink(): GestureDetector(
                          onTap: (){
                            _controller.editVenueDataBind();
                          },
                          child: Icon(Icons.edit_calendar_rounded,
                          size: 30,
                            color: theme.primaryColor,
                          ),
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
      body: GetBuilder<ManagerController>(
          initState: (v){
            _controller.getVenueDetails(id: venueId);
          },
        builder: (controller) {
          return controller.getVenueDetailsLoader.value== false?SizedBox.shrink(): SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                eventsTitles(text: "Contact Information"),
                SizedBox(
                  height: 10,
                ),
                eventDateTime(theme: theme,context: context,iconBgClr: DynamicColor.lightBlackClr,
                    iconClr: DynamicColor.grayClr,
                text: "${controller.venueDetails!.data!.venueProperty!.openingHours} to ${controller.venueDetails!.data!.venueProperty!.closingHours}"
                ),
                SizedBox(
                  height: 10,
                ),
                eventDateTime(theme: theme,context: context,iconBgClr: DynamicColor.lightBlackClr,
                    iconClr: DynamicColor.grayClr,
                img: "assets/groupPeopleIcon.png",
                  text: controller.venueDetails!.data!.venueProperty!.maxSeating,
                ),
                SizedBox(
                  height: 10,
                ),
                eventDateTime(theme: theme,context: context,iconBgClr: DynamicColor.lightBlackClr,
                    iconClr: DynamicColor.grayClr,
                  icon: true,
                  text: controller.venueDetails!.data!.location.toString(),
                ),
                SizedBox(
                  height: 10,
                ),
                eventsTitles(text: "Image"),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: kToolbarHeight*2,
                  width: Get.width,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListView.builder(
                        itemCount: controller.venueDetails!.data!.profilePicture!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context,index){
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: 130,
                          height: kToolbarHeight*2,
                          decoration: BoxDecoration(
                              border: Border.all(color: theme.primaryColor,),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  fit: BoxFit
                                      .fill,
                                  image:
                                  controller.venueDetails!.data!.profilePicture![index].thumbnail !=null?NetworkImage(Url().imageUrl+controller.venueDetails!.data!.profilePicture![index].thumbnail.toString()):
                                  NetworkImage(Url().imageUrl+controller.venueDetails!.data!.profilePicture![index].mediaPath.toString())
                              )
                          ),
                          child:controller.venueDetails!.data!.profilePicture![index].thumbnail != null? GestureDetector(
                            onTap: (){
                              Get.toNamed(Routes.videoPlayerClass,
                                  arguments: {
                                    "type": "filedsaf",
                                    "url":Url().imageUrl+ controller.venueDetails!.data!.profilePicture![index].mediaPath.toString()
                                  }
                              );
                            },
                            child: Center(
                              child: Icon(Icons.play_arrow,
                                size: 35,
                                color: theme.primaryColor,
                              ),
                            ),
                          ):SizedBox.shrink(),
                        ),
                      );
                    }),
                  ),
                ),
                // venueListData(showViewAll: false,theme: theme,context: context,list: controller.imageList,
                //   onTap: (){
                //     PopupBanner(
                //       context: context,
                //       images: controller.imageList,
                //       useDots: false,
                //       onClick: (index) {
                //         debugPrint("CLICKED $index");
                //       },
                //     ).show();
                //   }
                // ),
                SizedBox(
                  height: 15,
                ),
                eventsTitles(text: "Max Occupancy"),
                SizedBox(
                  height: 15,
                ),
                eventDateTime(theme: theme,context: context,iconBgClr: DynamicColor.lightBlackClr,
                  iconClr: DynamicColor.grayClr,
                  img: "assets/groupPeopleIcon.png",
                  text: controller.venueDetails!.data!.venueProperty!.maxOccupancy,
                ),
                SizedBox(
                  height: 15,
                ),
                eventsTitles(text: "Max Seating"),
                SizedBox(
                  height: 15,
                ),
                eventDateTime(theme: theme,context: context,iconBgClr: DynamicColor.lightBlackClr,
                  iconClr: DynamicColor.grayClr,
                  img: "assets/groupPeopleIcon.png",
                  text: controller.venueDetails!.data!.venueProperty!.maxSeating,
                ),
                SizedBox(
                  height: 15,
                ),
                eventsTitles(text: "Amenities"),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: ListView.builder(
                      itemCount: controller.venueDetails!.data!.amenities!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context,index){
                    return Row(
                      children: [
          Image(
            image: AssetImage("assets/headingIcons.png"),
          ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(controller.venueDetails!.data!.amenities![index].venueItem!.name.toString(),
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
                SizedBox(
                  height: 15,
                ),
                eventsTitles(text: "House Event Capabilities"),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: ListView.builder(
                      itemCount: controller.venueDetails!.data!.houseEventCapabilities!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context,index){
                    return Row(
                      children: [
          Image(
            image: AssetImage("assets/headingIcons.png"),
          ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(controller.venueDetails!.data!.houseEventCapabilities![index].venueItem!.name.toString(),
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
                SizedBox(
                  height: 15,
                ),
                eventsTitles(text: "Licenses and permit"),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: ListView.builder(
                      itemCount: controller.venueDetails!.data!.licensesAndPermit!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context,index){
                    return Row(
                      children: [
          Image(
            image: AssetImage("assets/headingIcons.png"),
          ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(controller.venueDetails!.data!.licensesAndPermit![index].venueItem!.name.toString(),
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
              ],
            ),
          );
        }
      ),
      bottomNavigationBar: btnShow == false?SizedBox.shrink(): Padding(
        padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: (){
            Get.toNamed(Routes.eventPreview,
                arguments: {
                  "viewDetails": 1
                }
            );
          },
          text: "Continue",
        ),
      ),
    );
  }
  List list = ["assets/venue1.png","assets/venue2.png","assets/venue3.png","assets/venue1.png","assets/venue2.png","assets/venue3.png",];
}

// class  extends StatelessWidget {
//   const ({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }