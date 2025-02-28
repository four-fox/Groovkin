// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_final_fields

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';


import '../bottomNavigation/homeController.dart';

class ServiceScreen extends StatefulWidget {
  ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  AuthController _controller = Get.find();

  bool? isComingFromMyGroovkin =
      Get.arguments?["isComingFromMyGroovkin"] ?? false;

  int moreServiceAdd = Get.arguments['addMoreService'] ?? 1;

  late EventController _eventController;

  late HomeController _homeController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<EventController>()) {
      _eventController = Get.find<EventController>();
    } else {
      _eventController = Get.put(EventController());
    }
    if (Get.isRegistered<HomeController>()) {
      _homeController = Get.find<HomeController>();
    } else {
      _homeController = Get.put(HomeController());
    }
    _controller.myGroovkinServiceListing = Get.arguments?["isService"] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: customAppBar(
        theme: theme,
        text: "Service",
        actions: [
          ((_eventController.eventDetail == null) &&
                  (_eventController.draftCondition.value == true))
              ? GestureDetector(
                  onTap: () {
                    _eventController.postEventFunction(context, theme,
                        draft: true);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.drafts),
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
      body: GetBuilder<AuthController>(initState: (v) {
        _controller.getAllService(
            type: "services",
            mygrookinHit:
                _controller.myGroovkinServiceListing.isNotEmpty ? true : false);
      }, builder: (controller) {
        return controller.getAllServiceLoader.value == false
            ? SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'The services you can provide!',
                        style: poppinsMediumStyle(
                          fontSize: 16,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      Text(
                        'Please select from given option.',
                        style: poppinsMediumStyle(
                          fontSize: 12,
                          context: context,
                          color: DynamicColor.lightRedClr,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: Get.height / 1.5,
                        child: ListView.builder(
                            itemCount: controller.serviceListing.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, index) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_controller
                                          .myGroovkinServiceListing.isEmpty) {
                                        controller.serviceAddFtn(
                                            items: controller
                                                .serviceListing[index]);
                                      } else {
                                        controller.myGroovkingServiceToggleFuc(
                                            controller.serviceListing[index]);
                                      }

                                      // controller.surveyData!.data![index].showItems!.value = !controller.surveyData!.data![index].showItems!.value;
                                      // controller.update();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: controller.serviceListing[index]
                                                    .showItems!.value ==
                                                true
                                            ? null
                                            : DecorationImage(
                                                image: AssetImage(
                                                    "assets/buttonBg.png"),
                                                fit: BoxFit.fill),
                                        color: controller.serviceListing[index]
                                                    .showItems!.value ==
                                                true
                                            ? DynamicColor.lightBlackClr
                                            : Colors.transparent,
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 17,
                                            backgroundColor: controller
                                                        .serviceListing[index]
                                                        .showItems!
                                                        .value ==
                                                    false
                                                ? theme.primaryColor
                                                : DynamicColor.grayClr,
                                            // child: (list[index] != null ||
                                            //         list[index].img == null)
                                            //     ? SizedBox()
                                            //     : Image(
                                            //         image: AssetImage(
                                            //             list[index]
                                            //                 .img
                                            //                 .toString()),
                                            //       ),
                                            child:
                                                Image.asset("assets/djing.png"),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            controller
                                                .serviceListing[index].name
                                                .toString(),
                                            style: poppinsMediumStyle(
                                              fontSize: 16,
                                              context: context,
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                          Spacer(),
                                          controller.serviceListing[index]
                                                      .showItems!.value ==
                                                  true
                                              ? Icon(
                                                  Icons.check,
                                                  color: theme.primaryColor,
                                                )
                                              : SizedBox.shrink(),
                                          // Spacer(),
                                          // Checkbox(
                                          //     activeColor: DynamicColor.lightRedClr,
                                          //     value:djValue , onChanged:onChanged)
                                        ],
                                      ),
                                    ),
                                  ));
                            }),
                      ),
                      //                   serviceWidget(context: context,theme: theme,
                      //                       onChanged: (v){
                      //                       controller.djing.value = v!;
                      //                       controller.update();
                      //                   },
                      //                     djValue: controller.djing.value
                      //                   ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      //                   serviceWidget(context: context,theme: theme,onChanged: (v){
                      //                       controller.lighting.value = v!;
                      //                       controller.update();
                      //                   },text: "Lighting",
                      //                       image: "assets/lighting.png",
                      //                     djValue: controller.lighting.value
                      //                     ),
                      //   SizedBox(
                      //     height: 15,
                      //   ),
                      //                     serviceWidget(context: context,theme: theme,onChanged: (v){
                      //                       controller.photoBooth.value = v!;
                      //                         controller.update();
                      //                     },text: "Photobooth",
                      //
                      //                         image: "assets/lighting.png",
                      //                       djValue: controller.photoBooth.value
                      //                     ),
                      //   SizedBox(
                      //     height: 15,
                      //   ),
                      //                     serviceWidget(context: context,theme: theme,onChanged: (v){
                      //                       controller.masterOf.value = v!;
                      //                         controller.update();
                      //                     },text: "Master of Ceremony",
                      //
                      //                         image: "assets/master.png",
                      //                       djValue: controller.masterOf.value
                      //                     ),
                      //   SizedBox(
                      //     height: 15,
                      //   ),
                      //                     serviceWidget(context: context,theme: theme,onChanged: (v){
                      //                       controller.avEquipment.value = v!;
                      //                         controller.update();
                      //                     },text: "AV Equipment",
                      //
                      //                         image: "assets/avEquipment.png",
                      //                       djValue: controller.avEquipment.value
                      //                     ),
                    ],
                  ),
                ),
              );
      }),
      bottomNavigationBar: SafeArea(
        bottom: Platform.isIOS ? true : false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () async {
              if (isComingFromMyGroovkin == true) {
                if (_controller.serviceLista.isNotEmpty) {
                  _controller.updateGroovkinService().then((_) {
                    _homeController.getMyGroovkinData().then((_) {
                      bottomToast(text: "Services Updated Successfully");
                      Get.back();
                    });
                  });
                } else {
                  bottomToast(text: "Please Select Services");
                }
              } else if (moreServiceAdd == 2) {
                Get.toNamed(Routes.quickSurveyScreen,
                    arguments: {"addMoreService": moreServiceAdd});
              } else if (moreServiceAdd == 3) {
                if (_controller.serviceList.isNotEmpty) {
                  // if(_eventController.eventDetail != null) {
                  //   await _controller.getAllService(type: "hardware_provided");
                  // }
                  Get.toNamed(Routes.hardwareScreen,
                      arguments: {"createEvent": true});
                } else {
                  bottomToast(text: "Please add service");
                }
                // Get.toNamed(Routes.hardwareProvidedScreen);
              } else {
                if (_controller.serviceList.isNotEmpty) {
                  Get.toNamed(Routes.insuranceScreen, arguments: {
                    "insuranceNavigation": 1,
                  });
                } else {
                  bottomToast(text: "Please add service");
                }
              }
            },
            text: isComingFromMyGroovkin == true ? "Update" : "Next",
          ),
        ),
      ),
    );
  }

  Widget serviceWidget(
      {theme,
      image,
      context,
      onChanged,
      djValue,
      text,
      GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: AssetImage("assets/buttonBg.png"), fit: BoxFit.fill)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: theme.primaryColor,
              child: Image(
                image: AssetImage(image ?? "assets/djing.png"),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              text ?? "DJing",
              style: poppinsMediumStyle(
                fontSize: 16,
                context: context,
                color: theme.primaryColor,
              ),
            ),
            Spacer(),
            Icon(
              Icons.check,
              color: theme.primaryColor,
            ),
            // Spacer(),
            // Checkbox(
            //     activeColor: DynamicColor.lightRedClr,
            //     value:djValue , onChanged:onChanged)
          ],
        ),
      ),
    );
  }

//   List<ServiceList> list = [
//     ServiceList(
//         text: 'DJing', img: "assets/djing.png", clickCondition: false.obs),
//     ServiceList(
//         text: 'Lighting',
//         img: "assets/lighting.png",
//         clickCondition: false.obs),
//     ServiceList(
//         text: 'Photobooth',
//         img: "assets/lighting.png",
//         clickCondition: false.obs),
//     ServiceList(
//         text: 'Master of Ceremony',
//         img: "assets/master.png",
//         clickCondition: false.obs),
//     ServiceList(
//         text: 'AV Equipment',
//         img: "assets/avEquipment.png",
//         clickCondition: false.obs),
//   ];
}

class ServiceList {
  String? img, text;
  RxBool? clickCondition = false.obs;
  ServiceList({this.text, this.img, this.clickCondition});
}
