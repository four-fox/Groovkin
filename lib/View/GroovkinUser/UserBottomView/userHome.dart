



// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_final_fields, prefer_null_aware_operators

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/customEventWidget.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:intl/intl.dart';

import '../../bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';

class UserHomeScreen extends StatefulWidget {
  UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  RxBool recommendedVal = false.obs;

  RxBool nearbyVal = false.obs;

  RxBool topRatedVal = false.obs;

  RxBool ongoingVal = false.obs;


  late HomeController _controller;
  late EventController _eventController;
  late AuthController _authController;
  late ManagerController _managerController;

  @override
  void initState() {
    if (Get.isRegistered<HomeController>()) {
      _controller = Get.find<HomeController>();
    } else {
      _controller = Get.put(HomeController());
    }

    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }

    if (Get.isRegistered<ManagerController>()) {
      _managerController = Get.find<ManagerController>();
    } else {
      _managerController = Get.put(ManagerController());
    }

    if (Get.isRegistered<EventController>()) {
      _eventController = Get.find<EventController>();
    } else {
      _eventController = Get.put(EventController());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: kToolbarHeight),
        child: GestureDetector(
          onTap: (){
            Get.toNamed(Routes.viewAllEventListScreen);
          },
          child: Container(
            height: 35,
            width: 90,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              // color: Colors.amberAccent
                color: DynamicColor.darkGrayClr,
              borderRadius: BorderRadius.circular(8)
            ),
            child: Center(
              child: Text("View All",
                style: poppinsMediumStyle(
                    fontSize: 14,
                    context: context,
                    color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
     appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight*2),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
          ),
          child: Column(
              children: [
                SizedBox(
                  height: 38,
                ),
                Row(
                  children: [
                    Text("Welcome to Groovkin",
                      style: poppinsMediumStyle(
                        fontSize: 16,
                        context: context,color:
                      DynamicColor.lightYellowClr,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: (){
                        Get.toNamed(Routes.notificationScreen);
                      },
                      child: Icon(
                        Icons.notification_important,
                        color: theme.primaryColor,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width/1.3,
                      child: SearchTextFields(
                        controller: TextEditingController(),
                        readOnly: true,
                        onTap: (){
                          Get.toNamed(Routes.viewAllEventListScreen,
                            arguments: {
                              "searchFieldShow": true
                            }
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.toNamed(Routes.searchFilterScreen);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(color: DynamicColor.grayClr.withOpacity(0.6)),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: ImageIcon(AssetImage("assets/filterIcon.png"),
                          color: DynamicColor.grayClr,),
                      ),
                    )
                  ],
                ),
              ]),
        ),
      ),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: (){
                    Get.toNamed(Routes.userMyGroovkinScreen);
                  },
                  child: Container(
                    height: kToolbarHeight*2,
                    width: double.infinity,
                    decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/myGroovkin.png"),
                      fit: BoxFit.fill,
                    )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("My Groovkin",
                          style: poppinsMediumStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            context: context,
                            latterSpacing: 1.1,
                            color: theme.primaryColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: DynamicColor.yellowClr.withOpacity(0.7),
                              child: ImageIcon(AssetImage("assets/groupIcons.png"),
                              color: theme.primaryColor,
                              ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0),
                                child: CircleAvatar(
                                  backgroundColor: DynamicColor.yellowClr.withOpacity(0.7),
                                child: ImageIcon(AssetImage("assets/musicIcons.png"),
                                color: theme.primaryColor,
                                ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: DynamicColor.yellowClr.withOpacity(0.7),
                              child: ImageIcon(AssetImage("assets/supportIcon.png"),
                              color: theme.primaryColor,
                              ),
                              ),
                            ],
                          ),
                        )
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
                           Text("Recommended for you",
                            style: poppinsMediumStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.primaryColor,
                            ),
                           ),
                         GestureDetector(
                                onTap: (){
                                 if(recommendedVal.value==false){
                                   controller.getRecommended();
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
                      controller.getRecommendedLoader.value==false?SizedBox.shrink():
                      Visibility(
                          visible: recommendedVal.value,
                          child: controller.recommendedEventData == null || controller.recommendedEventData!.data!.data!.isEmpty?
                              noData(theme: theme,context: context):
                          Column(
                            children: [
                              ListView.builder(
                                  itemCount: controller.recommendedEventData!.data!.data!.length>4?4:controller.recommendedEventData!.data!.data!.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,index){
                                    EventData singleEventData = controller.recommendedEventData!.data!.data![index];
                                    return
                                      userCustomEvent(
                                          dayy: DateFormat.MMM().format(singleEventData.startDateTime!),
                                          datee: "${singleEventData.startDateTime!.day}\n",
                                          networkImg: singleEventData.bannerImage == null?false:true,
                                          img:singleEventData.bannerImage == null?null: singleEventData.bannerImage!.mediaPath.toString(),
                                          title: singleEventData.eventTitle.toString(),
                                          location: singleEventData.location,
                                          subtitle: singleEventData.venue!.venueName.toString(),
                                          onTap: (){
                                            Get.toNamed(Routes.userEventDetailsScreen,
                                                arguments: {
                                                  "notify": true,
                                                  "notifyBackBtn": true,
                                                  'appBarTitle': "Event Preview",
                                                  "statusText": singleEventData.id.toString()
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
                                    "urlText": "recommended-for-you-events",
                                        "appBarText": "All Recommended Event"
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
                           Text("Nearby",
                            style: poppinsMediumStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.primaryColor,
                            ),
                           ),
                            GestureDetector(
                                onTap: (){
                                  if(nearbyVal.value==false){
                                    controller.getEventNearByMe();
                                    nearbyVal.value = true;
                                  }else{
                                    nearbyVal.value = false;
                                    controller.update();
                                  }
                                },
                                child: Icon(nearbyVal.value ==false?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up_outlined,
                                size: 35,
                                  color: theme.primaryColor,
                                ),
                              ),
                          ],
                        ),
                        controller.getEventNearByMeLoader.value==false?SizedBox.shrink():
                        Visibility(
                            visible: nearbyVal.value,
                            child:
                            controller.eventNearByMe == null || controller.eventNearByMe!.data!.data!.isEmpty?
                            noData(theme: theme,context: context):
                            Column(
                              children: [
                                ListView.builder(
                                  itemCount: controller.eventNearByMe!.data!.data!.length>4?4:controller.eventNearByMe!.data!.data!.length,
                                  shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,index){
                                    EventData singleEvent = controller.eventNearByMe!.data!.data![index];
                                  return
                                    userCustomEvent(
                                        dayy: DateFormat.MMM().format(singleEvent.startDateTime!),
                                        datee: "${singleEvent.startDateTime!.day}\n",
                                        networkImg: singleEvent.bannerImage == null?false:true,
                                        img:singleEvent.bannerImage == null?null: singleEvent.bannerImage!.mediaPath.toString(),
                                        title: singleEvent.eventTitle.toString(),
                                        location: singleEvent.location,
                                        subtitle: singleEvent.venue!.venueName.toString(),
                                        onTap: (){
                                          Get.toNamed(Routes.userEventDetailsScreen,
                                              arguments: {
                                                "notify": true,
                                                "notifyBackBtn": true,
                                                'appBarTitle': "Event Preview",
                                                "statusText": singleEvent.id.toString()
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
                                          "urlText": "near-by-events",
                                          "appBarText": "All Near By Event"
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
                           Text("Top rated",
                            style: poppinsMediumStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.primaryColor,
                            ),
                           ),
                            GestureDetector(
                                onTap: (){
                                  if(topRatedVal.value==false){
                                    controller.getTopRatedEvent();
                                    topRatedVal.value = true;
                                  }else{
                                    topRatedVal.value = false;
                                    controller.update();
                                  }
                                },
                                child: Icon(topRatedVal.value ==false?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up_outlined,
                                size: 35,
                                  color: theme.primaryColor,
                                ),
                              ),
                          ],
                        ),
                        controller.getTopRatedEventLoader.value==false?SizedBox.shrink():
                        Visibility(
                          visible: topRatedVal.value,
                          child:
                          controller.topRatingData == null || controller.topRatingData!.data!.data!.isEmpty?
                          noData(theme: theme,context: context):
                          Column(
                            children: [
                              ListView.builder(
                                  itemCount: controller.topRatingData!.data!.data!.length>4?4:controller.topRatingData!.data!.data!.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,index){
                                    EventData singleEvent = controller.topRatingData!.data!.data![index];
                                    return
                                      userCustomEvent(
                                          dayy: DateFormat.MMM().format(singleEvent.startDateTime!),
                                          datee: "${singleEvent.startDateTime!.day}\n",
                                          networkImg: singleEvent.bannerImage == null?false:true,
                                          img:singleEvent.bannerImage == null?null: singleEvent.bannerImage!.mediaPath.toString(),
                                          title: singleEvent.eventTitle.toString(),
                                          location: singleEvent.location,
                                          subtitle: singleEvent.venue!.venueName.toString(),
                                          onTap: (){
                                            Get.toNamed(Routes.userEventDetailsScreen,
                                                arguments: {
                                                  "notify": true,
                                                  "notifyBackBtn": true,
                                                  'appBarTitle': "Event Preview",
                                                  "statusText": singleEvent.id.toString()
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
                                        "urlText": "top-rated-events",
                                        "appBarText": "All Top Rated Event"
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

                                onTap: (){

          if(ongoingVal.value==false){
          controller.getOngoingEventUser();
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
                        controller.userOngoingLoader.value==false?SizedBox.shrink():
                        Visibility(
                          visible: ongoingVal.value,
                          child:
                          controller.userOngoing == null || controller.userOngoing!.data!.data!.isEmpty?
                          noData(theme: theme,context: context):
                          Column(
                            children: [
                              ListView.builder(
                                  itemCount: controller.userOngoing!.data!.data!.length>4?4:controller.userOngoing!.data!.data!.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,index){
                                    EventData singleEvent = controller.userOngoing!.data!.data![index];
                                    return
                                      userCustomEvent(
                                          dayy: DateFormat.MMM().format(singleEvent.startDateTime!),
                                          datee: "${singleEvent.startDateTime!.day}\n",
                                          networkImg: singleEvent.bannerImage == null?false:true,
                                          img:singleEvent.bannerImage == null?null: singleEvent.bannerImage!.mediaPath.toString(),
                                          title: singleEvent.eventTitle.toString(),
                                          location: singleEvent.location,
                                          subtitle: singleEvent.venue!.venueName.toString(),
                                          onTap: (){
                                            Get.toNamed(Routes.userEventDetailsScreen,
                                                arguments: {
                                                  "notify": true,
                                                  "notifyBackBtn": true,
                                                  'appBarTitle': "Event Preview",
                                                  "statusText": singleEvent.id.toString()
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
                                        "urlText": "user-interested-on-going-list",
                                        "appBarText": "OnGoing Events"
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
                  height: kToolbarHeight*1.3,
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  List list = ["assets/eventPreview.png","assets/venueImg.png","assets/eventPreview.png","assets/venueImg.png","assets/eventPreview.png","assets/venueImg.png","assets/eventPreview.png","assets/venueImg.png",];
}


class ViewAllEventListScreen extends StatefulWidget {
  ViewAllEventListScreen({Key? key}) : super(key: key);

  @override
  State<ViewAllEventListScreen> createState() => _ViewAllEventListScreenState();
}

class _ViewAllEventListScreenState extends State<ViewAllEventListScreen> {
  // EventController _eventController = Get.find<EventController>();


  late HomeController _controller;
  late EventController _eventController;
  late AuthController _authController;
  late ManagerController _managerController;
  bool searchingShow = false;

  @override
  void initState() {
    if (Get.isRegistered<HomeController>()) {
      _controller = Get.find<HomeController>();
    } else {
      _controller = Get.put(HomeController());
    }

    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }

    if (Get.isRegistered<ManagerController>()) {
      _managerController = Get.find<ManagerController>();
    } else {
      _managerController = Get.put(ManagerController());
    }

    if (Get.isRegistered<EventController>()) {
      _eventController = Get.find<EventController>();
    } else {
      _eventController = Get.put(EventController());
    }
if(Get.arguments != null){
  searchingShow = Get.arguments['searchFieldShow'];
}
    super.initState();
  }

  DateTime pre_backpress = DateTime.now();

  Timer? onStoppedTyping;
  _onChangeHandler() {
    const duration = Duration(
        milliseconds:
        800); // set the duration that you want call stopTyping() after that.
    onStoppedTyping = Timer(duration, () => stopTyping());
  }

  stopTyping() {
    _eventController.searchingEvent();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(searchingShow==true?kToolbarHeight*2:kToolbarHeight),
        child: Column(
          children: [
            customAppBar(theme: theme,text: "All Events"),
            searchingShow == true?Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: SearchTextFields(
                controller: _eventController.searchingController,
                onChanged: (v){
                  if(v != ""){
                    _onChangeHandler();
                  }else{
                    _eventController.searchingController.clear();
                  }
                },
              ),
            ):SizedBox.shrink()
          ],
        )
      ),
      body: GetBuilder<EventController>(
        initState: (v){
          WidgetsBinding.instance.addPostFrameCallback((_){
            _eventController.searchingController.clear();
            if(searchingShow == true){
              _eventController.searchingEvent();
            }else{
              _eventController.getAllEvents();
            }

          });
        },
        builder: (controller) {
          return
            NotificationListener<ScrollNotification>(
              onNotification: (scroll) {
            if (scroll.metrics.pixels ==
                scroll.metrics.maxScrollExtent) {
              if (controller.getAllEventWaiting == false) {
                controller.getAllEventWaiting = true;
                if (controller.allEvents!.data!.nextPageUrl !=
                    null) {
                  if(searchingShow == true){
                    _eventController.searchingEvent(nextUrl: controller.allEvents!.data!.nextPageUrl);
                  }else{
                    controller.getAllEvents(
                        nextUrl: controller.allEvents!.data!.nextPageUrl);
                  }

                  return true;
                } else {
                  print("next Url Null");
                }
              }
              return false;
            }
            return false;
          },
          child:
            controller.getAllEventsLoader.value==false?SizedBox.shrink():
          controller.allEvents==null|| controller.allEvents!.data!.data!.isEmpty?noData(context: context,theme: theme):
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                  color: DynamicColor.darkGrayClr
              ),
              child: ListView.builder(
                  itemCount: controller.allEvents!.data!.data!.length,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context,index){
                    EventData singleEventDat = controller.allEvents!.data!.data![index];
                    return userCustomEvent(
                      dayy: DateFormat.MMM().format(singleEventDat.startDateTime!),
                      datee: "${singleEventDat.startDateTime!.day}\n",
                      networkImg: singleEventDat.bannerImage == null?false:true,
                      img:singleEventDat.bannerImage == null?null: singleEventDat.bannerImage!.mediaPath.toString(),
                        title: singleEventDat.eventTitle.toString(),
                        location: singleEventDat.location,
                        subtitle: singleEventDat.venue!.venueName.toString(),
                        onTap: (){
                          Get.toNamed(Routes.userEventDetailsScreen,
                              arguments: {
                                "notify": true,
                                "notifyBackBtn": true,
                                'appBarTitle': "Event Preview",
                                "statusText": singleEventDat.id.toString()
                              }
                          );
                        },
                        context: context,
                        theme: theme
                    );
                  }),
            ),
          ),
            );
        }
      ),
    );
  }
}
