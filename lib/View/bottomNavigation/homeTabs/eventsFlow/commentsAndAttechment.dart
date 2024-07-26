


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/mediaModel.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:map_location_picker/map_location_picker.dart';

import '../../../../Components/Network/Url.dart';

class CommentsAndAttachment extends StatefulWidget {
  CommentsAndAttachment({Key? key}) : super(key: key);

  @override
  State<CommentsAndAttachment> createState() => _CommentsAndAttachmentState();
}

class _CommentsAndAttachmentState extends State<CommentsAndAttachment> {
  String address = "null";

  String autocompletePlace = "null";

  Prediction? initialValue;

  AuthController authController = Get.find();

  EventController _controller = Get.find();

  // ManagerController managerController = Get.find();

  final commentsForm = GlobalKey<FormState>();

  late ManagerController managerController;

  @override
  void initState() {
    if (Get.isRegistered<ManagerController>()) {
      managerController = Get.find<ManagerController>();
    } else {
      managerController = Get.put(ManagerController());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "",imagee: true,
          actions: [
            ((_controller.eventDetail == null) && (_controller.draftCondition.value == true))?
            GestureDetector(
              onTap: (){
                _controller.postEventFunction(context,theme,draft: true);
              },
              child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.drafts),),
            ):SizedBox.shrink()]
      ),
      body: GetBuilder<ManagerController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Form(
              key: commentsForm,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Comment',
                          textAlign: TextAlign.center,
                          style: poppinsMediumStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            context: context,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: DynamicColor.darkGrayClr,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:CustomTextFieldsHintText(
                        maxLine: 5,
                        validation: "comments",
                        controller: _controller.commentsController,
                        hintText: "write her..",
                          borderClr: DynamicColor.grayClr.withOpacity(0.6)
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: DynamicColor.darkGrayClr,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: DynamicColor.avatarBgClr)
                      ),
                      child: Column(
                        children: [
                          ((_controller.imageListtt.isNotEmpty) && (_controller.duplicateValue.value == false)) || controller.mediaClass.isNotEmpty? SizedBox(
                            height: 180,
                            width: Get.width,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: ((controller.mediaClass.isNotEmpty))?
                                controller.mediaClass.length:_controller.imageListtt.length,
                                itemBuilder: (BuildContext context, index) {
                                  return assetImage(
                                    eventController: _controller,
                                    controller: controller,
                                    mediaItem: controller.mediaClass.isNotEmpty?
                                    controller.mediaClass[index]:_controller.imageListtt[index],
                                  );
                                }),
                          ): Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 10.0),
                            child: Icon(Icons.attach_file_outlined,
                            color: DynamicColor.grayClr,
                              size: 35,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: GestureDetector(
                              onTap: (){
                                if(Platform.isAndroid){
                                  managerController.pickFile();
                                }else{
                                  managerController.pickFileee();
                                }
                              },
                              child: Container(
                                width: 120,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: DynamicColor.grayClr.withOpacity(0.2),
                                ),
                                child: Center(
                                  child: Text("Attached file",
                                    style: poppinsRegularStyle(
                                      fontSize: 15,
                                      context: context,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    )
                  ],
                ),
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
            if(commentsForm.currentState!.validate()){
              // if(managerController.mediaClass.isNotEmpty || ((_controller.imageListtt.isNotEmpty) && (_controller.duplicateValue.value == false))){
                if(_controller.eventDetail !=null && _controller.eventDetail!.data!.location != null){
                  Get.toNamed(Routes.eventPreview,
                  arguments: {
                    "viewDetails": 1
                  }
                  );
                }else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return
                          MapLocationPicker(
                            onTappp: (){
                              print(managerController.lat);
                              print(managerController.lng);
                              Get.toNamed(Routes.listOfVenuesScreen);
                            },
                            // onTapShow: true,
                            // hideLocation: true,
                            // lat: double.parse(eventData.latitude.toString()),
                            // long: double.parse(eventData.longitude.toString()),
                            minMaxZoomPreference: MinMaxZoomPreference(0, 15),
                            apiKey:
                            "AIzaSyC_-hLFYGAJC_IBMnFBKZLq2IS1qr7tJgQ",
                            canPopOnNextButtonTaped: true,
                            searchHintText:
                            managerController.address != "null"
                                ? managerController.address
                                : "Start typing to search",
                            // canPopOnNextButtonTaped: true,
                            latLng: managerController.latLng,
                            initAddress: managerController.address,
                              nextPage:(){
                                Get.toNamed(Routes.listOfVenuesScreen);
                                managerController.update();
                              },
                            onNext: (GeocodingResult? result) {
                              if (result != null) {
                                managerController.lat = result
                                    .geometry.location.lat
                                    .toString();
                                managerController.lng = result
                                    .geometry.location.lng
                                    .toString();
                                managerController.address =
                                    result.formattedAddress ?? "";
                                managerController.latLng = LatLng(
                                    result.geometry.location.lat,
                                    result.geometry.location.lng);
                                managerController.addressController.text = result.formattedAddress!;
                                Get.toNamed(Routes.listOfVenuesScreen);
                                managerController.update();
                              }
                            },
                            onSuggestionSelected:
                                (PlacesDetailsResponse? result) {
                              if (result != null) {
                                managerController.lat = result
                                    .result.geometry!.location.lat
                                    .toString();
                                managerController.lng = result
                                    .result.geometry!.location.lng
                                    .toString();
                                managerController.autocompletePlace =
                                    result.result
                                        .formattedAddress ??
                                        "";
                                managerController.address = result
                                    .result.formattedAddress ??
                                    "";
                                managerController.latLng = LatLng(
                                    result.result.geometry!.location
                                        .lat,
                                    result.result.geometry!.location
                                        .lng);
                                managerController.addressController.text = result.result.formattedAddress!;

                                Get.toNamed(Routes.listOfVenuesScreen);
                                managerController.update();
                              }
                            },
                          );

                        //   MapLocationPicker(
                        //   apiKey: "AIzaSyC_-hLFYGAJC_IBMnFBKZLq2IS1qr7tJgQ",
                        //   popOnNextButtonTaped: true,
                        //   currentLatLng: const LatLng(29.146727, 76.464895),
                        //   btnOnTap: (){
                        //     Get.toNamed(Routes.listOfVenuesScreen);
                        //   },
                        //   onNext: (GeocodingResult? result) {
                        //     if (result != null) {
                        //       managerController.address = result.formattedAddress ?? "";
                        //       managerController.addressController.text = managerController.address;
                        //       managerController.lat = result.geometry.location.lat.toString();
                        //       managerController.lng = result.geometry.location.lng.toString();
                        //       managerController.update();
                        //     }
                        //   },
                        //   onSuggestionSelected: (PlacesDetailsResponse? result) {
                        //     if (result != null) {
                        //       managerController.autocompletePlace =
                        //           result.result.formattedAddress ?? "";
                        //       managerController.addressController.text = managerController.autocompletePlace;
                        //       managerController.lat = result.result.geometry!.location.lat.toString();
                        //       managerController.lng = result.result.geometry!.location.lng.toString();
                        //       managerController.update();
                        //     }
                        //   },
                        // );
                      },
                    ),
                  );
                }
              // }else{
              //   bottomToast(text: "Please choose image");
              // }
            }
            // Get.toNamed(Routes.confirmationEventScreen);
          },
          text: "Continue",
        ),
      ),
    );
  }
}


assetImage({eventController,controller, mediaItem, bool closedIcon = true}){
  return Stack(
    alignment: Alignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: mediaItem!.thumbnail != null ?
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(10),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: mediaItem.id == null
                      ? FileImage(File(mediaItem.thumbnail.toString()))
                      : NetworkImage(mediaItem.mediaPath.toString())
                  as ImageProvider)),
          child: closedIcon == false?SizedBox.shrink(): GestureDetector(
            onTap: (){
              if(mediaItem!.thumbnail == null){
                print("tapping123");
              }else{
                if(mediaItem.id == null){
                  print(mediaItem);
                }
                // controller.mediaClass.remove(mediaItem);
              }
              // controller.mediaClass.remove(mediaItem);
            },
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                  radius: 15,
                  child: Icon(Icons.clear)),
            ),
          ),
        ) :
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              borderRadius:
              BorderRadius
                  .circular(
                  10),
              image: DecorationImage(
                  fit: BoxFit
                      .fill,
                  image: mediaItem.id ==
                      null
                      ? FileImage(File(mediaItem.filename.toString()))
                      : NetworkImage(mediaItem.mediaPath.toString())
                  as ImageProvider)),
        child: GestureDetector(
          onTap: () async{
            if(mediaItem!.thumbnail == null ){
              if(mediaItem.id == null){
                controller.mediaClass.remove(mediaItem);
                controller.update();
              }else{
                eventController.removeImageList.add(mediaItem.id);
               await eventController.deleteImage(id: eventController.eventDetail!.data!.id,eventImg: true);
                eventController.imageListtt.remove(mediaItem);
                eventController.update();
                controller.update();
              }
              print("tapping22");
            }else{
              print("tapping11");
            }
            // controller.mediaClass.remove(mediaItem);
          },
          child:closedIcon == false?SizedBox.shrink(): Align(
            alignment: Alignment.topRight,
            child: CircleAvatar(
                radius: 15,
                child: Icon(Icons.clear)),
          ),
        ),
        ),

      ),
      mediaItem.thumbnail ==null?
      SizedBox.shrink():
      closedIcon ==false?SizedBox.shrink():
      GestureDetector(
        onTap: (){
          Get.toNamed(Routes.videoPlayerClass, arguments: {
            'url': mediaItem.filename,
            'type': "file"/*controller.mediaClass[index].fileType*/,
          });
        },
        child: CircleAvatar(
          backgroundColor: DynamicColor.blackClr,
          radius: 15,
          child: Icon(Icons.play_arrow,
            color: DynamicColor.whiteClr,
          ),
        ),
      ),
    ],
  );
}


///>>>>>>>>>>>>>>>>>>>>>>>>>> get list of venues
  class ListOfVenuesScreen extends StatelessWidget {
  ListOfVenuesScreen({Key? key}) : super(key: key);

  EventController _controller = Get.find();

    @override
    Widget build(BuildContext context) {
      var theme = Theme.of(context);
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight*3.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: kToolbarHeight*1.8,
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/map.png"),
                    fit: BoxFit.fill
                  )
                ),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text("Search the venue you want to\nnegotiate with",
                      textAlign: TextAlign.center,
                        style: poppinsMediumStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        context: context,
                        color: theme.scaffoldBackgroundColor
                      ),
                      ),
                    ),
                    GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: ImageIcon(AssetImage("assets/backArrow.png"),)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
                child: CustomTextFields(
                    borderClr: theme.primaryColor,
                    iconShow:true,
                    labelText: "Add here",
                    suffixWidget: GestureDetector(
                      onTap: (){
                        Get.toNamed(Routes.addLocationScreen);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: theme.primaryColor,
                          ),
                          child: Icon(Icons.filter_alt,
                            color: theme.scaffoldBackgroundColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text("Venue",
                style: poppinsMediumStyle(
                  fontSize: 18,
                  context: context,
                  color: theme.primaryColor,
                ),
                ),
              )
            ],
          ),
        ),
        body: GetBuilder<EventController>(
          initState: (v){
            _controller.getVenuesLatLng();
          },
          builder: (controller) {
            return controller.getVenuesLatLngLoader.value == false?SizedBox.shrink():
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: controller.allVenueList!.data!.data!.isEmpty?Center(
                child: Text("No Data",
                  style: poppinsMediumStyle(
                      fontSize: 17,
                      context: context,
                      color: theme.primaryColor,
                  ),
                ),
              ): ListView.builder(
                  itemCount: controller.allVenueList!.data!.data!.length,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context,index){
                return GestureDetector(
                  onTap: (){
                    controller.venuesDetails = controller.allVenueList!.data!.data![index];
                    Get.toNamed(Routes.viewOtherEventsDetails,
                        arguments: {
                          "venueId": controller.allVenueList!.data!.data![index].id,
                          "buttonShow": true,
                          "editBtn": false
                        }
                    );
                    // Get.toNamed(Routes.venueInfoScreen);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/grayClor.png"),
                        fit: BoxFit.fill
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: DynamicColor.darkYellowClr,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundImage:
                              NetworkImage(controller.allVenueList!.data!.data![index].profilePicture![0].thumbnail ==null?
                              Url().imageUrl+controller.allVenueList!.data!.data![index].profilePicture![0].mediaPath.toString():
                              Url().imageUrl+controller.allVenueList!.data!.data![index].profilePicture![0].thumbnail.toString()),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 7.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(controller.allVenueList!.data!.data![index].venueName.toString(),
                                  style: poppinsRegularStyle(
                                    fontSize: 14,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                Text("Tap to view detail about property",
                                  style: poppinsRegularStyle(
                                    fontSize: 12,
                                    context: context,
                                    color: theme.primaryColor.withOpacity(0.5)
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })
            );
          }
        ),
      );
    }
  }



///>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Add Location

class AddLocationScreen extends StatelessWidget {
  const AddLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Add location"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: DynamicColor.avatarBgClr
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Radius in mile",
                      style: poppinsMediumStyle(
                        fontSize: 18,
                        color: theme.primaryColor,
                        context: context,
                      ),
                    ),
                    Row(
                      children: [
                        Text("Select Radius",
                          style: poppinsRegularStyle(
                            fontSize: 15,
                            context: context,color: theme.primaryColor,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text("Type here",
                            style: poppinsRegularStyle(
                                fontSize: 11,
                                color: DynamicColor.grayClr.withOpacity(0.9),
                                context: context
                            ),
                          ),
                        ),
                        Container(
                          width: Get.width/7,
                          // height: 30,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: DynamicColor.whiteClr)
                          ),
                          child: TextField(
                            textAlign: TextAlign.center,
                            style: poppinsRegularStyle(
                                fontSize: 12,
                                color: theme.primaryColor,
                                context: context
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "00",
                              hintStyle: poppinsRegularStyle(
                                  fontSize: 12,
                                  color: theme.primaryColor,
                                  context: context
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextFields(
                borderClr: theme.primaryColor,
                labelText: "Max Capacity",

              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: (){
            Get.back();
            // Get.toNamed(Routes.confirmationEventScreen);
          },
          text: "Search Filter",
        ),
      ),
    );
  }
}
