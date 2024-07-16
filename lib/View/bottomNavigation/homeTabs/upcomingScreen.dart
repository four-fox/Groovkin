// ignore_for_file: prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/cancelEventWidget.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/interestedWidget.dart';
import 'package:groovkin/Components/showCustomMap.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:intl/intl.dart';


class UpcomingScreen extends StatelessWidget {
  UpcomingScreen({Key? key}) : super(key: key);

  int reportedEventPreview =Get.arguments['reportedEventView']?? 1;
  int flowBtn = Get.arguments['notInterestedBtn'];
  String appBarTitle = Get.arguments['appBarTitle'];
  RxBool organizerGuestVal = false.obs;
  int eventId = Get.arguments['eventId']??1;

  final EventController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            /*flowBtn==2 ?*/ kToolbarHeight*1.1
            //     :flowBtn==3?
            // kToolbarHeight*1.3
            //     :kToolbarHeight*4.9
        ),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/grayClor.png"),
                  fit: BoxFit.fill
              )
          ),
          child: customAppBar(theme: theme,text:appBarTitle,
            actions: [reportedEventPreview==3?SizedBox.shrink(): Padding(
              padding: const EdgeInsets.only(right: 7.0),
              child: GestureDetector(
                  onTap: (){
                    _controller.assignValueForUpdate();
                  },
                  child: Icon(appBarTitle=="Pending"?Icons.edit_calendar:Icons.more_vert)),
            )],
            imagee: false,
          ),
        ),
      ),
    body: GetBuilder<EventController>(
      initState: (v){
        _controller.eventDetails(eventId: eventId);
      },
      builder: (controller) {
        return controller.eventDetailsLoader.value==false?SizedBox.shrink() : Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 6),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: DynamicColor.avatarBgClr.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: DynamicColor.grayClr.withOpacity(0.6)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.all(6),
                              child: ImageIcon(AssetImage("assets/pin.png"),
                                color: theme.primaryColor,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 6,horizontal: 18),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage("assets/topbtnGradent.png"),
                                    fit: BoxFit.fill,
                                  )
                              ),
                              child: Center(
                                child: Text(appBarTitle,
                                  style: poppinsRegularStyle(
                                    fontSize:11,context: context,
                                    color:theme.scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            Get.toNamed(Routes.eventOrganizerScreen,
                                arguments: {
                                  "eventOrganizerValue": 3,
                                  'profileImg': "assets/eventOrganizer.png",
                                  "manager": sp.read("role"),
                                  "propertyView": true
                                }
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0,),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(_controller.eventDetail!.data!.bannerImage ==null?dummyProfile: _controller.eventDetail!.data!.bannerImage!.mediaPath!),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: SizedBox(
                                    width: Get.width/1.7,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_controller.eventDetail!.data!.venue!.location.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: poppinsRegularStyle(fontSize: 12,context: context,color: theme.primaryColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(_controller.eventDetail!.data!.eventTitle!,
                                          style: poppinsRegularStyle(fontSize: 12,context: context,color: DynamicColor.lightRedClr,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ((API().sp.read("role") == "eventManager") && (appBarTitle == "On Going"))
                            ?SizedBox.shrink():
                        SizedBox(
                          child: Column(
                            children: [
                              /// da organizer che kala ongoing event details goree
                              appBarTitle == "On Going" || appBarTitle =="Past Event" ?
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CustomButton(
                                  heights: 33,
                                  widths:Get.width/1.15,
                                  color1: DynamicColor.greenClr,
                                  color2: DynamicColor.greenClr,
                                  backgroundClr: false,
                                  borderClr: Colors.transparent,
                                  onTap: (){
                                    if((API().sp.read("role") == "eventManager")&&(appBarTitle =="Past Event")){
                                      controller.acknowledgedEvent(eventId: controller.eventDetail!.data!.id);
                                    }else{
                                      if(controller.eventDetail!.data!.isEventComplete!.value == 0){
                                        Get.toNamed(Routes.completeOnGoingEventsScreen,
                                            arguments: {
                                              "eventData": _controller.eventDetail!.data!
                                            }
                                        );
                                      }
                                    }
                                    // Get.toNamed(Routes.upcomingScreen,
                                    //     arguments: {
                                    //       "reportedEventView": flowBtn==2?3: 1
                                    //     }
                                    // );
                                  },
                                  textClr: theme.primaryColor,
                                  text:((API().sp.read("role") == "eventManager")&&(appBarTitle =="Past Event"))?
                                      "Acknowledged Event":
                                  controller.eventDetail!.data!.isEventComplete!.value == 1?"Waiting for acknowledged":"Complete",
                                ),
                              ):
                              appBarTitle ==  "Upcoming"?
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:flowBtn==2? MainAxisAlignment.spaceBetween:
                                  MainAxisAlignment.center,
                                  children: [
                                    CustomButton(
                                      backgroundClr: false,
                                      heights: 33,
                                      widths: flowBtn==2?Get.width/2.4:Get.width/1.15,
                                      onTap: (){
                                        cancelEventWidget(context: context,theme: theme,
                                            onTap: (){
                                              Get.back();
                                              Get.toNamed(Routes.cancelReason,
                                                  arguments: {
                                                    "eventId": controller.eventDetail!.data!.id,
                                                    "doubleBack": false,
                                                  }
                                              );
                                            }
                                        );
                                      },
                                      borderClr: Colors.transparent,
                                      color2: DynamicColor.redClr,
                                      color1:  DynamicColor.redClr,
                                      fontSized: 13,
                                      text:flowBtn==2?"Not interested/decline": "Cancel",
                                      // fontSized: 12,
                                    ),
                                    flowBtn==2? CustomButton(
                                      backgroundClr: false,
                                      widths: flowBtn==2?Get.width/2.4:Get.width/1.15,
                                      heights: 33,
                                      onTap: (){
                                        showDialog(
                                            barrierColor: Colors.transparent,
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return AlertWidget(
                                                height: kToolbarHeight*10,
                                                container: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: DisclaimerView(
                                                    onTap: (){
                                                      Get.back();
                                                      Get.toNamed(Routes.addCardDetails,
                                                          arguments: {
                                                            'paymentMethod':3
                                                          }
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      borderClr: Colors.transparent,
                                      color2: DynamicColor.greenClr,
                                      color1:  DynamicColor.greenClr,
                                      text: "Accept",
                                      fontSized: 12,
                                    ):
                                    SizedBox.shrink(),
                                  ],
                                ),
                              ):SizedBox(),
                             appBarTitle=="Completed Event"? Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                                child: CustomButton(
                                  heights: 33,
                                  color2: DynamicColor.secondaryClr,
                                  color1: DynamicColor.secondaryClr,
                                  backgroundClr: false,
                                  onTap: (){
                                    Get.toNamed(Routes.counterScreen,
                                        arguments: {
                                          "textField": false,
                                          "acceptVal": false,
                                          "userId": API().sp.read("role") == "eventOrganizer"?
                                          controller.eventDetail!.data!.venue!.user!.id:controller.eventDetail!.data!.user!.id,
                                          "eventId": controller.eventDetail!.data!.id,
                                        }
                                    );
                                  },
                                  borderClr: Colors.transparent,
                                  text: "See Counter",
                                ),
                              ):SizedBox.shrink(),
                              SizedBox(
                                height:flowBtn ==2?0: 8,
                              ),
                              /// da che kala organizer upcoming events details check kyee
                              ((appBarTitle=="Upcoming")&& (API().sp.read("role") == "eventOrganizer"))?
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CustomButton(
                                  heights: 33,
                                  widths:Get.width/1.15,
                                  color1: DynamicColor.greenClr,
                                  color2: DynamicColor.greenClr,
                                  backgroundClr: false,
                                  borderClr: Colors.transparent,
                                  onTap: (){
                                    _controller.postponedAssign();
                                  },
                                  textClr: theme.primaryColor,
                                  text: "Reschedule",
                                ),
                              ):SizedBox.shrink(),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                appBarTitle=="Completed Event"? Align(
                  alignment: Alignment.centerRight,
                  child: interestedWidget(theme: theme,context: context,
                  text: "Attended user ${controller.eventDetail!.data!.eventsGoingCount}"
                  ),
                ):SizedBox.shrink(),
                SizedBox(
                  height:flowBtn==3?0: 12,
                ),
                ///todo dalta counter button data
                // API().sp.read("role") == "eventManager"? Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                //   child: CustomButton(
                //     heights: 33,
                //     color1: DynamicColor.lightYellowClr,
                //     color2: DynamicColor.lightYellowClr,
                //     backgroundClr: false,
                //     borderClr: Colors.transparent,
                //     onTap: (){
                //       Get.toNamed(Routes.counterScreen,
                //           arguments: {
                //             "textField": true,
                //             "acceptVal": false,
                //           }
                //       );
                //       // Get.toNamed(Routes.upcomingScreen,
                //       //     arguments: {
                //       //       "reportedEventView": flowBtn==2?3: 1
                //       //     }
                //       // );
                //     },
                //     textClr: theme.scaffoldBackgroundColor,
                //     text: "Counter",
                //   ),
                // ):SizedBox.shrink(),
                ///todo dalta counter button data
                SizedBox(
                  height:flowBtn==3?0: 10,
                ),
                SizedBox(
                  height: kToolbarHeight*3,
                  width: Get.width,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.venueImageList.length,
                      itemBuilder: (BuildContext context,index){
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Container(
                            width:controller.venueImageList.length == 1?Get.width: Get.width/1.5,
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.primaryColor,),
                              image: DecorationImage(
                                image:controller.venueImageList[index].toString().split(".").last != "mp4"?
                                NetworkImage(controller.venueImageList[index].toString()):
                                NetworkImage(controller.venueImageList[index].toString()),
                                fit: BoxFit.fill,
                              )
                            ),
                          ),
                        );
                      }),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0,bottom: 10,left: 12),
                    child: Text(controller.eventDetail!.data!.eventTitle.toString(),
                      style: poppinsMediumStyle(
                        fontSize: 21,
                        color: theme.primaryColor,
                        context: context,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                eventDateTime(text: "${DateFormat.jm().format(controller.eventDetail!.data!.startDateTime!)} to ${DateFormat.jm().format(controller.eventDetail!.data!.endDateTime!)}",theme: theme,context: context,iconClr: DynamicColor.yellowClr),
                SizedBox(
                  height: 10,
                ),
                eventDateTime(
                    theme: theme,context: context,img: "assets/calender.png",
                    text: DateFormat.yMMMMEEEEd().format(controller.eventDetail!.data!.startDateTime!),iconClr: DynamicColor.yellowClr,
                ),
                SizedBox(
                  height: 10,
                ),
                eventDateTime(theme: theme,context: context,icon: true,text: "${controller.eventDetail!.data!.location}",iconClr: DynamicColor.yellowClr,

                ),
                customWidget(context,theme,title: "Event Comments",value: controller.eventDetail!.data!.comment.toString()),
                customWidget(context,theme,title: "Event About",value: controller.eventDetail!.data!.about.toString()),
                customWidget(context,theme,title: "Event theme",value: controller.eventDetail!.data!.themeOfEvent.toString()),
                customWidget(context,theme,title: "Featuring",value: controller.eventDetail!.data!.featuring.toString()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 10),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: DynamicColor.darkGrayClr
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Service",
                            style: poppinsRegularStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                context: context,
                                underline: true,
                                color: theme.primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: kToolbarHeight,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.eventDetail!.data!.services!.length,
                                itemBuilder: (BuildContext context,indx){
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6),
                                    child: Chip(
                                      backgroundColor: DynamicColor.lightBlackClr,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      label: Text(controller.eventDetail!.data!.services![indx].eventItem!.name.toString(),
                                        style: poppinsRegularStyle(
                                            fontSize: 14,
                                            context: context,
                                            color: theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Hardware Provided",
                            style: poppinsRegularStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                context: context,
                                underline: true,
                                color: theme.primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: kToolbarHeight,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ListView.builder(
                                itemCount: controller.eventDetail!.data!.hardwareProvide!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context,index){
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6),
                                    child: Chip(
                                      backgroundColor: DynamicColor.lightBlackClr,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      label: Text(controller.eventDetail!.data!.hardwareProvide![index].hardwareItems!.name.toString(),
                                        style: poppinsRegularStyle(
                                          fontSize: 14,
                                          context: context,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  );
                                  // return ListView.builder(
                                  //     shrinkWrap: true,
                                  //     scrollDirection: Axis.horizontal,
                                  //     physics: NeverScrollableScrollPhysics(),
                                  //     itemCount: controller.eventDetail!.data!.hardwareProvide![index].eventItem!.categoryItems!.length,
                                  //     itemBuilder: (BuildContext context,indx){
                                  //       return Padding(
                                  //         padding: EdgeInsets.symmetric(horizontal: 6),
                                  //         child: Chip(
                                  //           backgroundColor: DynamicColor.lightBlackClr,
                                  //           shape: RoundedRectangleBorder(
                                  //             borderRadius: BorderRadius.circular(8),
                                  //           ),
                                  //           label: Text(controller.eventDetail!.data!.hardwareProvide![index].eventItem!.categoryItems![indx].name.toString(),
                                  //             style: poppinsRegularStyle(
                                  //                 fontSize: 14,
                                  //                 context: context,
                                  //                 color: theme.primaryColor,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       );
                                  //     });
                                }),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Music Genre",
                            style: poppinsRegularStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                context: context,
                                underline: true,
                                color: theme.primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: kToolbarHeight,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.eventDetail!.data!.services!.length,
                                itemBuilder: (BuildContext context,indx){
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6),
                                    child: Chip(
                                      backgroundColor: DynamicColor.lightBlackClr,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      label: Text(controller.eventDetail!.data!.services![indx].eventItem!.name.toString(),
                                        style: poppinsRegularStyle(
                                            fontSize: 14,
                                            context: context,
                                            color: theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Music Choice",
                            style: poppinsRegularStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                context: context,
                                underline: true,
                                color: theme.primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: kToolbarHeight,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ListView.builder(
                                itemCount: controller.eventDetail!.data!.eventMusicChoiceTags!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context,index){
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6),
                                    child: Chip(
                                      backgroundColor: DynamicColor.lightBlackClr,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      label: Text(controller.eventDetail!.data!.eventMusicChoiceTags![index].musicChoiceItems!.name.toString(),
                                        style: poppinsRegularStyle(
                                          fontSize: 14,
                                          context: context,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  );
                                  /*return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: controller.eventDetail!.data!.eventMusicChoiceTags![index].eventTagItem!.categoryItems!.length,
                                      itemBuilder: (BuildContext context,indx){
                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6),
                                          child: Chip(
                                            backgroundColor: DynamicColor.lightBlackClr,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            label: Text(controller.eventDetail!.data!.eventMusicChoiceTags![index].eventTagItem!.categoryItems![indx].name.toString(),
                                              style: poppinsRegularStyle(
                                                  fontSize: 14,
                                                  context: context,
                                                  color: theme.primaryColor,
                                              ),
                                            ),
                                          ),
                                        );
                                      });*/
                                }),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Activity Choice",
                            style: poppinsRegularStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                context: context,
                                underline: true,
                                color: theme.primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: kToolbarHeight,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ListView.builder(
                                itemCount: controller.eventDetail!.data!.eventActivityChoiceTags!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context,index){
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6),
                                    child: Chip(
                                      backgroundColor: DynamicColor.lightBlackClr,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      label: Text(controller.eventDetail!.data!.eventActivityChoiceTags![index].activityChoiceItems!.name.toString(),
                                        style: poppinsRegularStyle(
                                          fontSize: 14,
                                          context: context,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  );
                                  // return ListView.builder(
                                  //     shrinkWrap: true,
                                  //     scrollDirection: Axis.horizontal,
                                  //     physics: NeverScrollableScrollPhysics(),
                                  //     itemCount: controller.eventDetail!.data!.eventActivityChoiceTags![index].eventTagItem!.categoryItems!.length,
                                  //     itemBuilder: (BuildContext context,indx){
                                  //       return Padding(
                                  //         padding: EdgeInsets.symmetric(horizontal: 6),
                                  //         child: Chip(
                                  //           backgroundColor: DynamicColor.lightBlackClr,
                                  //           shape: RoundedRectangleBorder(
                                  //             borderRadius: BorderRadius.circular(8),
                                  //           ),
                                  //           label: Text(controller.eventDetail!.data!.eventActivityChoiceTags![index].eventTagItem!.categoryItems![indx].name.toString(),
                                  //             style: poppinsRegularStyle(
                                  //                 fontSize: 14,
                                  //                 context: context,
                                  //                 color: theme.primaryColor,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       );
                                  //     });
                                }),
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
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("Live Location",
                    style: poppinsMediumStyle(
                        fontWeight: FontWeight.w700,
                        color: DynamicColor.lightRedClr,
                        context: context,
                        fontSize: 17
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(controller.eventDetail!.data!.location.toString(),
                    style: poppinsMediumStyle(
                        color: theme.primaryColor,
                        context: context,
                        fontSize: 16
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                ShowCustomMap(
                  lat: double.parse(controller.eventDetail!.data!.latitude!),
                  lng: double.parse(controller.eventDetail!.data!.longitude!),
                ),
                SizedBox(
                  height: 10,
                ),
                sp.read('role')=="eventManager"?
                SizedBox.shrink():
                    aboutEventCreator(
                      // text: controller.eventDetail!.data!.venue!.streetAddress.toString(),
                        horizontalPadding: 12,theme: theme,context: context,
                        image:controller.eventDetail!.data!.profilePicture!.isNotEmpty?
                        controller.eventDetail!.data!.profilePicture![0].thumbnail:controller.venueImageList[0],
                        organizerName: controller.eventDetail!.data!.venue!.venueName.toString(),
                        icons: Icons.add,
                        followBg: DynamicColor.grayClr,
                        textClr: theme.primaryColor,
                        onTap: (){
                          // followBgClr.value = !followBgClr.value;
                        }
                    ),
                sp.read('role')=="eventOrganizer"?SizedBox.shrink():
                    ourGuestWidget(
                        horizontalPadding: 12,
                        networkImg: controller.eventDetail!.data!.profilePicture!.isNotEmpty?
                        controller.eventDetail!.data!.profilePicture![0].thumbnail:
                        controller.venueImageList[0],
                        venueOwner: controller.eventDetail!.data!.user!.name.toString(),
                        theme: theme,context: context,rowPadding: 0.0,avatarPadding: 6,rowVerticalPadding: 0.0,
                        followBgClr: DynamicColor.avatarBgClr,
                        textClr: theme.scaffoldBackgroundColor,
                        onTap: (){
                          // followBgClr.value = !followBgClr.value;
                        }
                ),

                API().sp.read("role") == "eventOrganizer"?    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    interestedWidget(
                        height: 36,
                        theme: theme,context: context,
                        text: "Interested users ${controller.eventDetail!.data!.eventsInterestedCount}"
                    ),
                    interestedWidget(
                        height: 36,
                        theme: theme,context: context,
                        text: "Ongoing users ${controller.eventDetail!.data!.eventsGoingCount}"
                    ),
                  ],
                ):SizedBox.shrink(),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        );
      }
    )
    );
  }

  eventDateTime({theme,context,text,img,bool icon =false,Color? iconClr,Color? iconBgClr,double? iconSize, Color? textClr,
    IconData? iconData,
  }) {
    return Padding( padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor:iconBgClr?? theme.primaryColor,
            child:icon==false? ImageIcon(AssetImage(img??"assets/clock2.png"),
              color:iconClr?? DynamicColor.grayClr,
              size: iconSize?? 21,
            ):Icon(iconData??Icons.location_on_sharp,
              color:iconClr?? DynamicColor.grayClr,
              size:iconSize?? 21,
            ),
          ),
          SizedBox(
            width:Get.width/1.3,
            child: Padding(
              padding: EdgeInsets.only(left: 6.0),
              child: Text(text??"04:00pm to 10:00pm",
                style: poppinsRegularStyle(
                  fontSize: 12,
                  context: context,
                  color:textClr?? theme.primaryColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  customWidget(context,theme, {title, value}){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(title??"Event Comments",
              style: poppinsRegularStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  context: context,
                  underline: true,
                  color: theme.primaryColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(value,
              style: poppinsRegularStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  context: context,
                  underline: true,
                  color: DynamicColor.whiteClr.withOpacity(0.6)
              ),
            ),
          ),
        ),
      ],
    );
  }

}
