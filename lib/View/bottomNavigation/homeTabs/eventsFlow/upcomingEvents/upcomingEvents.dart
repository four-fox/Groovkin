


// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/customEventWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:intl/intl.dart';

import '../../organizerHomeModel/alleventsModel.dart';

class UpcomingEvents extends StatelessWidget {
  UpcomingEvents({Key? key}) : super(key: key);

  RxBool recommendedVal = false.obs;
  RxBool ongoingVal = false.obs;
  RxBool pastVal = false.obs;

  EventController _eventController = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<EventController>(
      initState: (v){
        if(API().sp.read('role') == "eventOrganizer"){
          _eventController.getAllEvents();
        }
      },
      builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: DynamicColor.darkGrayClr
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Upcoming Events",
                            style: poppinsMediumStyle(
                                fontSize: 14,
                                context: context,
                                color: theme.primaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async{
                              if(recommendedVal.value == false){
                               await controller.getUpcomingEvents();
                                recommendedVal.value = true;
                              }else{
                                recommendedVal.value = false;
                                controller.update();
                              }
                            },
                            child: Icon(recommendedVal.value ==false?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up_outlined,
                              size: 35,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                          Visibility(
                            visible: recommendedVal.value,
                            child:controller.upcomingEventData == null || controller.upcomingEventData!.data!.data!.isEmpty?
                            SizedBox(
                              height: kToolbarHeight*3,
                              child: noData(context: context,theme: theme),
                            )
                                : Column(
                                  children: [
                                    ListView.builder(
                                    itemCount: controller.upcomingEventData!.data!.data!.length>4?4:controller.upcomingEventData!.data!.data!.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context,index){
                                      EventData singleEventDat = controller.upcomingEventData!.data!.data![index];
                                      return
                                        userCustomEvent(
                                          isDelete: singleEventDat.user!.deleteAt==null? false:true,
                                            dayy: DateFormat.MMM().format(singleEventDat.startDateTime!),
                                            datee: "${singleEventDat.startDateTime!.day}\n",
                                            networkImg: singleEventDat.bannerImage == null?false:true,
                                            img:singleEventDat.bannerImage == null?null: singleEventDat.bannerImage!.mediaPath.toString(),
                                            title: singleEventDat.eventTitle.toString(),
                                            location: singleEventDat.location,
                                            subtitle: singleEventDat.venue!.venueName.toString(),
                                            onTap: (){
                                              recommendedVal.value = false;
                                              Get.toNamed(Routes.upcomingScreen,
                                                  arguments: {
                                                "eventId": singleEventDat.id,
                                                    "reportedEventView":1,
                                                    "notInterestedBtn": 1,
                                                    "appBarTitle": "Upcoming"
                                                  }
                                              );
                                            },
                                            context: context,
                                            theme: theme
                                        );
                                    }),
                                    CustomButton(
                                      onTap: (){
                                        Get.toNamed(Routes.viewAllRecommendedScreen
                                            ,arguments: {
                                              "urlText": "upcoming-events",
                                              "appBarText": "Upcoming"
                                            }
                                        );
                                      },
                                      borderClr: Colors.transparent,
                                      text: "View All ",
                                    ),
                                  ],
                                ),
                          ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: DynamicColor.darkGrayClr
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Ongoing Events",
                            style: poppinsMediumStyle(
                                fontSize: 14,
                                context: context,
                                color: theme.primaryColor,
                            ),
                          ),
                          GestureDetector(
                                  onTap: () async{
                                    if(ongoingVal.value == false){
                                      await controller.getAllOngoingEvents();
                                      ongoingVal.value = true;
                                    }else{
                                      ongoingVal.value = false;
                                      controller.update();
                                    }
                                  },
                              child: Icon(ongoingVal.value ==false?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up_outlined,
                                size: 35,
                                color: theme.primaryColor,
                              ),
                            ),
                        ],
                      ),
                      Visibility(
                            visible: ongoingVal.value,
                            child:
                            controller.ongoingEvents == null || controller.ongoingEvents!.data!.data!.isEmpty?
                            SizedBox(
                              height: kToolbarHeight*3,
                              child: noData(context: context,theme: theme),
                            )
                                :Column(
                                  children: [
                                    ListView.builder(
                                    itemCount: controller.ongoingEvents!.data!.data!.length>4?4:controller.ongoingEvents!.data!.data!.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context,index){
                                      EventData singleEvent = controller.ongoingEvents!.data!.data![index];
                                      return
                                        userCustomEvent(
                                          isDelete: singleEvent.user!.deleteAt==null?false:true,
                                            dayy: DateFormat.MMM().format(singleEvent.startDateTime!),
                                            datee: "${singleEvent.startDateTime!.day}\n",
                                            networkImg: singleEvent.bannerImage == null?false:true,
                                            img:singleEvent.bannerImage == null?null: singleEvent.bannerImage!.mediaPath.toString(),
                                            title: singleEvent.eventTitle.toString(),
                                            location: singleEvent.location,
                                            subtitle: singleEvent.venue!.venueName.toString(),
                                            onTap: (){
                                              ongoingVal.value = false;
                                              Get.toNamed(Routes.upcomingScreen,
                                                  arguments: {
                                                    "eventId": singleEvent.id,
                                                    "reportedEventView":1,
                                                    "notInterestedBtn": 1,
                                                    "appBarTitle": "On Going"
                                                  }
                                              );
                                            },
                                            context: context,
                                            theme: theme
                                        );
                                    }),
                                    CustomButton(
                                      onTap: (){
                                        Get.toNamed(Routes.viewAllRecommendedScreen
                                            ,arguments: {
                                              "urlText": "on-going-events",
                                              "appBarText": "On Going"
                                            }
                                        );
                                      },
                                      borderClr: Colors.transparent,
                                      text: "View All ",
                                    ),
                                  ],
                                ),
                          ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
             /* API().sp.read('role') == "eventOrganizer"? Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: DynamicColor.darkGrayClr
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Past Events",
                            style: poppinsMediumStyle(
                                fontSize: 14,
                                context: context,
                                color: theme.primaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async{
                              if(pastVal.value == false){
                                await controller.getPastEvent();
                                pastVal.value = true;
                              }else{
                                pastVal.value = false;
                                controller.update();
                              }
                            },
                            child: Icon(pastVal.value ==false?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up_outlined,
                              size: 35,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: pastVal.value,
                        child:controller.pastEventData == null || controller.pastEventData!.data!.data!.isEmpty?
                        SizedBox(
                          height: kToolbarHeight*3,
                          child: noData(context: context,theme: theme),
                        )
                            : Column(
                              children: [
                                ListView.builder(
                                itemCount: controller.pastEventData!.data!.data!.length>4?4:controller.pastEventData!.data!.data!.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context,index){
                                  EventData singleEventDat = controller.pastEventData!.data!.data![index];
                                  return
                                    userCustomEvent(
                                        dayy: DateFormat.MMM().format(singleEventDat.startDateTime!),
                                        datee: "${singleEventDat.startDateTime!.day}\n",
                                        networkImg: singleEventDat.bannerImage == null?false:true,
                                        img:singleEventDat.bannerImage == null?null: singleEventDat.bannerImage!.mediaPath.toString(),
                                        title: singleEventDat.eventTitle.toString(),
                                        location: singleEventDat.location,
                                        subtitle: singleEventDat.venue!.venueName.toString(),
                                        onTap: (){
                                          Get.toNamed(Routes.upcomingScreen,
                                              arguments: {
                                                "eventId": singleEventDat.id,
                                                "reportedEventView":1,
                                                "notInterestedBtn": 1,
                                                "appBarTitle": "Past Event"
                                              }
                                          );
                                        },
                                        context: context,
                                        theme: theme
                                    );
                                }),
                                CustomButton(
                                  onTap: (){
                                    Get.toNamed(Routes.viewAllRecommendedScreen
                                        ,arguments: {
                                          "urlText": "past-events-by-organizer",
                                          "appBarText": "Past Event"
                                        }
                                    );
                                  },
                                  borderClr: Colors.transparent,
                                  text: "View All ",
                                ),
                              ],
                            ),
                      ),
                    ],
                  ),
                ),
              ):SizedBox.shrink(),
              SizedBox(
                height: 10,
              ),*/
              sp.read("role") == "eventOrganizer"?  GestureDetector(
                onTap: (){
                  Get.toNamed(Routes.myEventsScreen,
                    arguments: {
                      "pageTitle": "drafts"
                    }
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: DynamicColor.darkGrayClr
                    ),
                    child: Text("Draft Events",
                      style: poppinsMediumStyle(
                        fontSize: 14,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ):SizedBox.shrink(),
            ],
          ),
        );
      }
    );
  }
}
