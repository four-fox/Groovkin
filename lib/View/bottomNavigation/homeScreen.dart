// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/cancelEventWidget.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/PostEvents.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventHistory.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/upcomingEvents/upcomingEvents.dart';
import 'package:groovkin/utils/utils.dart';
import 'homeTabs/organizerHomeModel/alleventsModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // HomeController _controller = Get.put(HomeController());
  // EventController _eventController = Get.put(EventController());

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

    if (Get.isRegistered<EventController>()) {
      _eventController = Get.find<EventController>();
    } else {
      _eventController = Get.put(EventController());
    }

    if (Get.isRegistered<ManagerController>()) {
      _managerController = Get.find<ManagerController>();
    } else {
      _managerController = Get.put(ManagerController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 3,
      // initialIndex: widget.showIndexValue!.value,
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: GetBuilder<HomeController>(initState: (v) {
          _controller.showIndexValue!.value = 0;
        }, builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Obx(
              () => controller.showIndexValue!.value != 0
                  ? const SizedBox.shrink()
                  : GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.viewAllEventListScreen);
                      },
                      child: Container(
                        height: 35,
                        width: 90,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            // color: Colors.amberAccent
                            color: DynamicColor.darkGrayClr,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.primaryColor,
                            )),
                        child: Center(
                          child: Text(
                            "View All",
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
              preferredSize: const Size.fromHeight(kToolbarHeight * 3.7),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                ),
                child: Column(children: [
                  SizedBox(
                    height: context.height * 0.05,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          API().sp.read("role") == "eventOrganizer"
                              ? "Welcome Event Organizer"
                              : "Welcome Venue Manager",
                          style: poppinsMediumStyle(
                            fontSize: 16,
                            context: context,
                            color: theme.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.chatRoomScreen);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage("assets/eventDays.png"),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(8),
                              // border: Border.all(color: DynamicColor.yellowClr.withOpacity(0.6)),
                            ),
                            child: Icon(
                              Icons.chat,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.notificationScreen);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage("assets/eventDays.png"),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(8),
                            // border: Border.all(color: DynamicColor.yellowClr.withOpacity(0.6)),
                          ),
                          child: Icon(
                            Icons.notification_important,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: sp.read("role") == "eventOrganizer"
                            ? Get.width / 1.3
                            : Get.width / 1.08,
                        child: SearchTextFields(
                          controller: TextEditingController(),
                          readOnly: true,
                          onTap: () {
                            Get.toNamed(Routes.viewAllEventListScreen,
                                    arguments: {"searchFieldShow": true})!
                                .then((value) =>
                                    controller.showIndexValue!.value == 2
                                        ? _eventController
                                            .getAllSendingRequest()
                                        : _controller.completedEvent());
                          },
                        ),
                      ),
                      sp.read("role") == "eventOrganizer"
                          ? GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.myEventsScreen,
                                    arguments: {"pageTitle": "myEvents"});
                              },
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: DynamicColor.yellowClr
                                              .withOpacity(0.6)),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Image(
                                    image:
                                        AssetImage("assets/addEventIcon.png"),
                                  )),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                  TabBar(
                    unselectedLabelStyle:
                        poppinsMediumStyle(fontSize: 14, context: context),
                    labelStyle:
                        poppinsMediumStyle(fontSize: 14, context: context),
                    labelPadding: const EdgeInsets.all(6),
                    indicatorPadding: const EdgeInsets.all(10),
                    indicator: const BoxDecoration(color: Colors.transparent),
                    indicatorColor: Colors.transparent,
                    onTap: (v) {
                      controller.selectedFilter.value = 0;
                      controller.showIndexValue!.value = v;
                      controller.showFilter.value = false;
                      controller.update();
                    },
                    tabs: [
                      Tab(
                        child: Obx(
                          () => Container(
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: controller.showIndexValue!.value == 0
                                    ? DynamicColor.secondaryClr
                                    : DynamicColor.lightBlackClr),
                            child: Center(
                              child: Text(
                                /*sp.read("role") == "eventManager"
                                    ? "Upcoming"
                                    :*/
                                "Scheduled",
                                style: poppinsMediumStyle(
                                    fontSize: 14,
                                    context: context,
                                    color: controller.showIndexValue!.value == 0
                                        ? theme.primaryColor
                                        : DynamicColor.lightWhite),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Obx(
                          () => Container(
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: controller.showIndexValue!.value == 1
                                    ? DynamicColor.secondaryClr
                                    : DynamicColor.lightBlackClr),
                            child: Center(
                              child: Text(
                                "History",
                                style: poppinsMediumStyle(
                                    fontSize: 14,
                                    context: context,
                                    color: controller.showIndexValue!.value == 1
                                        ? theme.primaryColor
                                        : DynamicColor.lightWhite),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Obx(
                          () => Container(
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: controller.showIndexValue!.value == 2
                                    ? DynamicColor.secondaryClr
                                    : DynamicColor.lightBlackClr),
                            child: Center(
                              child: Text(
                                /*sp.read("role") == "eventManager"
                                    ? "Pending"
                                    :*/
                                "Requests",
                                style: poppinsMediumStyle(
                                    fontSize: 14,
                                    context: context,
                                    color: controller.showIndexValue!.value == 2
                                        ? theme.primaryColor
                                        : DynamicColor.lightWhite),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (controller.showIndexValue!.value != 0)
                    GestureDetector(
                      onTap: () {
                        controller.showFilter.value =
                            !controller.showFilter.value;
                      },
                      child: Align(
                          alignment: Alignment.topRight,
                          child: ImageIcon(
                            const AssetImage("assets/filterIcons.png"),
                            color: DynamicColor.grayClr,
                          )),
                    )
                ]),
              ),
            ),
            body: Stack(
              alignment: Alignment.topRight,
              children: [
                TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    /*sp.read("role") == "eventManager"?ManagerUpcomingEventsView() : */
                    UpcomingEvents(),
                    PostEvents(),
                    sp.read("role") == "eventManager"
                        ? const ManagerPendingView()
                        : PendingScreen(),
                  ],
                ),

                // Shahzain
                Obx(
                  () => Visibility(
                    visible: controller.showFilter.value,
                    child: GestureDetector(
                      onTap: () {
                        controller.selectedFilter.value = 0;
                      },
                      child: Container(
                        height:
                            controller.showIndexValue!.value == 0 ? 100 : 130,
                        width: Get.width / 2,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: DynamicColor.whiteClr),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.selectedFilter.value = 0;
                                controller.showFilter.value = false;
                                controller.update();

                                if (controller.showIndexValue == 1) {
                                  controller.completedEvent();
                                }
                                if (controller.showIndexValue == 2 &&
                                    sp.read("role") != "eventManager") {
                                  _eventController.getAllSendingRequest();
                                }
                                if (controller.showIndexValue == 2 &&
                                    sp.read("role") == "eventManager") {
                                  _managerController.getAllPendingEvents();
                                }
                              },
                              child: Container(
                                width: Get.width,
                                height: 35,
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: controller.selectedFilter.value != 0
                                        ? Colors.transparent
                                        : DynamicColor.yellowClr),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Recent",
                                    style: poppinsMediumStyle(
                                        fontSize: 14,
                                        color: theme.scaffoldBackgroundColor,
                                        context: context),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.selectedFilter.value = 1;
                                controller.showFilter.value = false;
                                controller.update();
                                if (controller.showIndexValue == 1) {
                                  controller.completedEvent();
                                }
                                if (controller.showIndexValue == 2 &&
                                    sp.read("role") != "eventManager") {
                                  _eventController.getAllSendingRequest();
                                }
                                if (controller.showIndexValue == 2 &&
                                    sp.read("role") == "eventManager") {
                                  _managerController.getAllPendingEvents();
                                }
                              },
                              child: Container(
                                width: Get.width,
                                height: 35,
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: controller.selectedFilter.value != 1
                                        ? Colors.transparent
                                        : DynamicColor.yellowClr),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Past Week",
                                    style: poppinsMediumStyle(
                                        fontSize: 14,
                                        color: theme.scaffoldBackgroundColor,
                                        context: context),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.selectedFilter.value = 2;
                                controller.showFilter.value = false;
                                controller.update();
                                if (controller.showIndexValue == 1) {
                                  controller.completedEvent();
                                }
                                if (controller.showIndexValue == 2 &&
                                    sp.read("role") != "eventManager") {
                                  _eventController.getAllSendingRequest();
                                }
                                if (controller.showIndexValue == 2 &&
                                    sp.read("role") == "eventManager") {
                                  _managerController.getAllPendingEvents();
                                }
                              },
                              child: Container(
                                width: Get.width,
                                height: 35,
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: controller.selectedFilter.value != 2
                                        ? Colors.transparent
                                        : DynamicColor.yellowClr),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Older then 1 month",
                                    style: poppinsMediumStyle(
                                        fontSize: 14,
                                        color: theme.scaffoldBackgroundColor,
                                        context: context),
                                  ),
                                ),
                              ),
                            ),
                            // controller.showIndexValue!.value == 0
                            //     ? SizedBox.shrink()
                            //     : GestureDetector(
                            //         onTap: () {
                            //           controller.selectedFilter.value = 3;
                            //           controller.showFilter.value = false;
                            //           controller.historyStatus();
                            //         },
                            //         child: Container(
                            //           width: Get.width,
                            //           height: 35,
                            //           padding: EdgeInsets.only(left: 10),
                            //           decoration: BoxDecoration(
                            //               borderRadius:
                            //                   BorderRadius.circular(10),
                            //               color:
                            //                   controller.selectedFilter.value !=
                            //                           3
                            //                       ? Colors.transparent
                            //                       : DynamicColor.yellowClr),
                            //           child: Align(
                            //             alignment: Alignment.centerLeft,
                            //             child: Text(
                            //               controller.showIndexValue!.value == 2
                            //                   ? "Requested"
                            //                   : "Completed",
                            //               style: poppinsMediumStyle(
                            //                   fontSize: 14,
                            //                   color:
                            //                       theme.scaffoldBackgroundColor,
                            //                   context: context),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            // controller.showIndexValue!.value == 0
                            //     ? SizedBox.shrink()
                            //     : GestureDetector(
                            //         onTap: () {
                            //           controller.selectedFilter.value = 4;
                            //           controller.showFilter.value = false;
                            //           controller.historyStatus();
                            //         },
                            //         child: Container(
                            //           width: Get.width,
                            //           height: 35,
                            //           padding: EdgeInsets.only(left: 10),
                            //           decoration: BoxDecoration(
                            //               borderRadius:
                            //                   BorderRadius.circular(10),
                            //               color:
                            //                   controller.selectedFilter.value !=
                            //                           4
                            //                       ? Colors.transparent
                            //                       : DynamicColor.yellowClr),
                            //           child: Align(
                            //             alignment: Alignment.centerLeft,
                            //             child: Text(
                            //               controller.showIndexValue!.value == 2
                            //                   ? "Pending"
                            //                   : "Cancelled",
                            //               style: poppinsMediumStyle(
                            //                   fontSize: 14,
                            //                   color:
                            //                       theme.scaffoldBackgroundColor,
                            //                   context: context),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class ManagerUpcomingEventsView extends StatelessWidget {
  ManagerUpcomingEventsView({super.key});

  RxBool recommendedVal = false.obs;
  RxBool ongoingVal = false.obs;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    List list = [
      'false',
      "true",
      'false',
      'true',
      'true',
      'false',
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: DynamicColor.darkGrayClr),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Upcoming Events",
                        style: poppinsMediumStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      Obx(
                        () => GestureDetector(
                          onTap: () {
                            recommendedVal.value = !recommendedVal.value;
                          },
                          child: Icon(
                            recommendedVal.value == false
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up_outlined,
                            size: 35,
                            color: theme.primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  Obx(
                    () => Visibility(
                      visible: recommendedVal.value,
                      child: ListView.builder(
                          itemCount: 1,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, index) {
                            return SizedBox(
                              height: kToolbarHeight * 3,
                              child: Center(
                                child: Text(
                                  "No Data",
                                  style: poppinsMediumStyle(
                                    fontSize: 17,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ),
                            )
                                /* userCustomEvent(
                                  onTap: (){
                                    Get.toNamed(Routes.managerUpcomingEventScreen);
                                  },
                                  context: context,
                                  theme: theme
                              )*/
                                ;
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: DynamicColor.darkGrayClr),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ongoing Events",
                        style: poppinsMediumStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      Obx(
                        () => GestureDetector(
                          onTap: () {
                            ongoingVal.value = !ongoingVal.value;
                          },
                          child: Icon(
                            ongoingVal.value == false
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up_outlined,
                            size: 35,
                            color: theme.primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  Obx(
                    () => Visibility(
                      visible: ongoingVal.value,
                      child: ListView.builder(
                          itemCount: 1,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, index) {
                            return SizedBox(
                              height: kToolbarHeight * 3,
                              child: Center(
                                child: Text(
                                  "No Data",
                                  style: poppinsMediumStyle(
                                    fontSize: 17,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ),
                            )
                                /*userCustomEvent(
                                  onTap: (){
                                    if(list[index]=="false"){
                                      Get.toNamed(Routes.chatCenterScreen,
                                          arguments: {
                                            "onGoing": 'ongoing'
                                          }
                                      );
                                    }else{
                                      Get.toNamed(Routes.managerApprovedEventScreen);
                                    }
                                    },
                                  context: context,
                                  theme: theme
                              )*/
                                ;
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: kToolbarHeight * 1.2,
          ),
        ],
      ),
    );
    /*ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context,index){
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 10),
            child: GestureDetector(
              onTap: (){
                Get.toNamed(Routes.managerUpcomingEventScreen);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  children: [
                    Container(
                      height: kToolbarHeight*3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: AssetImage(list[index]),
                              fit: BoxFit.fill
                          )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10.0,right: 10),
                            child:
                            Align(
                              alignment: Alignment.topRight,
                              child: eventDateWidget(theme: theme,context: context),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                width: Get.width/2.0,
                                padding: EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                    color: DynamicColor.darkGrayClr,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomRight: Radius.circular(12)
                                    )
                                ),
                                child: Row(
                                  children: [
                                    ImageIcon(AssetImage("assets/location.png"),
                                      color: DynamicColor.grayClr,
                                    ),
                                    Text('Herkimer County Fairgrounds',style: poppinsRegularStyle(fontSize: 11,context: context,color: theme.primaryColor,
                                        fontWeight: FontWeight.w600),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          image: DecorationImage(
                              image: AssetImage("assets/lightBg.png"),
                              fit: BoxFit.fill
                          )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("90’s Grunge and Bowling",
                            style: poppinsMediumStyle(
                                fontSize: 14,
                                color: DynamicColor.whiteClr,
                                context: context
                            ),
                          ),
                          Text("The Burning Cactus",
                            style: poppinsMediumStyle(
                                fontSize: 14,
                                color: DynamicColor.grayClr.withOpacity(0.7),
                                context: context
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
        });*/
  }

  List list = [
    "assets/eventPreview.png",
    "assets/venueImg.png",
    "assets/eventPreview.png",
    "assets/venueImg.png",
    "assets/eventPreview.png",
    "assets/venueImg.png",
    "assets/eventPreview.png",
    "assets/venueImg.png",
  ];
}

class ManagerPendingView extends StatefulWidget {
  const ManagerPendingView({super.key});

  @override
  State<ManagerPendingView> createState() => _ManagerPendingViewState();
}

class _ManagerPendingViewState extends State<ManagerPendingView> {
  late ManagerController _controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ManagerController>()) {
      _controller = Get.find<ManagerController>();
    } else {
      _controller = Get.put(ManagerController());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<ManagerController>(initState: (v) {
      _controller.getAllPendingEvents();
    }, builder: (controller) {
      return controller.getAllPendingEventsLoader.value == false
          ? const SizedBox.shrink()
          : controller.managerPendingEvents!.data!.data!.isEmpty
              ? noData(theme: theme, context: context)
              : ListView.builder(
                  itemCount:
                      controller.managerPendingEvents!.data!.data!.length,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    EventData eventData =
                        controller.managerPendingEvents!.data!.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                              color: DynamicColor.grayClr.withOpacity(0.6)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: ImageIcon(
                                    const AssetImage("assets/pin.png"),
                                    color: theme.primaryColor,
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (eventData.user!.deleteAt != null)
                                      Utils.accountDelete(context),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/topbtnGradent.png"),
                                              fit: BoxFit.fill)),
                                      child: Center(
                                        child: Text(
                                          "New Request",
                                          style: poppinsRegularStyle(
                                            fontSize: 11,
                                            context: context,
                                            color:
                                                theme.scaffoldBackgroundColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                        eventData.bannerImage == null
                                            ? dummyProfile
                                            : eventData
                                                .bannerImage!.mediaPath!),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          eventData.eventTitle.toString(),
                                          style: poppinsRegularStyle(
                                              fontSize: 12,
                                              context: context,
                                              color: theme.primaryColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          'Want to book for an event.',
                                          style: poppinsRegularStyle(
                                              fontSize: 12,
                                              context: context,
                                              color: DynamicColor.lightRedClr,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                    heights: 35,
                                    color2: eventData.user!.deleteAt == null
                                        ? DynamicColor.redClr.withOpacity(0.8)
                                        : DynamicColor.disabledColor,
                                    color1: eventData.user!.deleteAt == null
                                        ? DynamicColor.redClr.withOpacity(0.8)
                                        : DynamicColor.disabledColor,
                                    widths: Get.width / 2.4,
                                    backgroundClr: false,
                                    fontSized: 12,
                                    text: "Not interested/decline",
                                    onTap: eventData.user!.deleteAt == null
                                        ? () {
                                            cancelEventWidget(
                                                context: context,
                                                theme: theme,
                                                onTap: () {
                                                  Get.back();
                                                  Get.toNamed(
                                                          Routes.cancelReason,
                                                          arguments: {
                                                        "eventId": eventData.id,
                                                        "doubleBack": false,
                                                      })!
                                                      .then(
                                                    (value) => controller
                                                        .getAllPendingEvents(),
                                                  );
                                                });
                                          }
                                        : () {
                                            Utils.showToast();
                                          },
                                    borderClr: Colors.transparent,
                                  ),
                                  CustomButton(
                                    heights: 35,
                                    text: "Accept",
                                    fontSized: 12,
                                    onTap: eventData.user!.deleteAt == null
                                        ? () {
                                            controller.checkBoxValue.value =
                                                false;
                                            showDialog(
                                                barrierColor:
                                                    Colors.transparent,
                                                context: context,
                                                barrierDismissible: true,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertWidget(
                                                    height: Get.height / 2.5,
                                                    container: SizedBox(
                                                      width: Get.width,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12.0,
                                                                horizontal: 4),
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "Disclaimer",
                                                                style:
                                                                    poppinsMediumStyle(
                                                                  fontSize: 20,
                                                                  context:
                                                                      context,
                                                                  color: theme
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                "“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” “Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”",
                                                                maxLines: 8,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    poppinsMediumStyle(
                                                                  fontSize: 13,
                                                                  context:
                                                                      context,
                                                                  color: theme
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Obx(
                                                                    () => Theme(
                                                                      data: Theme.of(
                                                                              context)
                                                                          .copyWith(
                                                                        unselectedWidgetColor:
                                                                            Colors.white,
                                                                      ),
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            30,
                                                                        child: Checkbox(
                                                                            activeColor: DynamicColor.yellowClr,
                                                                            value: controller.checkBoxValue.value,
                                                                            onChanged: (v) {
                                                                              controller.checkBoxValue.value = v!;
                                                                              controller.update();
                                                                            }),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            2.0),
                                                                    child: Text(
                                                                      'i have read and agree to the terms and\nconditions',
                                                                      style:
                                                                          poppinsRegularStyle(
                                                                        fontSize:
                                                                            13,
                                                                        context:
                                                                            context,
                                                                        color: theme
                                                                            .primaryColor,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              CustomButton(
                                                                heights: 35,
                                                                text: "Accept",
                                                                fontSized: 12,
                                                                onTap: () {
                                                                  if (controller
                                                                      .checkBoxValue
                                                                      .value) {
                                                                    controller.eventAcceptDeclineFtn(
                                                                        event: controller
                                                                            .managerPendingEvents!
                                                                            .data!
                                                                            .data![index],
                                                                        status: "accepted");
                                                                  } else {
                                                                    bottomToast(
                                                                        text:
                                                                            "Please agree with the disclaimer to accept the event request");
                                                                  }
                                                                },
                                                                color2: DynamicColor
                                                                    .greenClr
                                                                    .withOpacity(
                                                                        0.8),
                                                                color1: DynamicColor
                                                                    .greenClr
                                                                    .withOpacity(
                                                                        0.8),
                                                                widths:
                                                                    Get.width /
                                                                        1.4,
                                                                backgroundClr:
                                                                    false,
                                                                borderClr: Colors
                                                                    .transparent,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          }
                                        : () {
                                            Utils.showToast();
                                          },
                                    color2: eventData.user!.deleteAt == null
                                        ? DynamicColor.greenClr.withOpacity(0.8)
                                        : DynamicColor.disabledColor,
                                    color1: eventData.user!.deleteAt == null
                                        ? DynamicColor.greenClr.withOpacity(0.8)
                                        : DynamicColor.disabledColor,
                                    widths: Get.width / 2.4,
                                    backgroundClr: false,
                                    borderClr: Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CustomButton(
                                heights: 35,
                                color2: DynamicColor.secondaryClr,
                                color1: DynamicColor.secondaryClr,
                                backgroundClr: false,
                                onTap: eventData.user!.deleteAt == null
                                    ? () {
                                        Get.toNamed(Routes.pendingEventDetails,
                                                arguments: {
                                              "eventId": controller
                                                  .managerPendingEvents!
                                                  .data!
                                                  .data![index]
                                                  .id,
                                              "notInterestedBtn": 1,
                                              "title": "About Event",
                                              "type": "event",
                                            })!
                                            .then(
                                          (value) =>
                                              _controller.getAllPendingEvents(),
                                        );
                                      }
                                    : () {
                                        Utils.showToast();
                                      },
                                borderClr: Colors.transparent,
                                text: "View Detail",
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
    });
  }
}
