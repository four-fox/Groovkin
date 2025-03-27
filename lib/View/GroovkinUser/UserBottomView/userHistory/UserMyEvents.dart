// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/customEventWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';
import 'package:intl/intl.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  RxInt tabValue = 0.obs;
  RxInt selectedFilter = 0.obs;
  RxBool showFilter = false.obs;
  @override
  void initState() {
    super.initState();
    tabValue.value = 0;
  }

  RxBool recommendedVal = false.obs;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight * 2.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Center(
                  child: Text(
                    "My Events",
                    style: poppinsMediumStyle(
                      fontSize: 17,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TabBar(
                unselectedLabelStyle:
                    poppinsMediumStyle(fontSize: 14, context: context),
                labelStyle: poppinsMediumStyle(
                    fontSize: 14,
                    context: context,
                    color: DynamicColor.grayClr.withOpacity(0.5)),
                labelPadding: const EdgeInsets.all(6),
                indicatorPadding: const EdgeInsets.all(10),
                indicatorColor: Colors.transparent,
                indicator: const BoxDecoration(color: Colors.white),
                onTap: (v) {
                  tabValue.value = v;
                },
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                tabs: [
                  Tab(
                    child: Obx(
                      () => CustomButton(
                        borderClr: Colors.transparent,
                        backgroundClr: tabValue.value == 0 ? true : false,
                        color2: DynamicColor.lightBlackClr,
                        color1: DynamicColor.lightBlackClr,
                        text: "History",
                      ),
                    ),
                  ),
                  Tab(
                    child: Obx(
                      () => CustomButton(
                        borderClr: Colors.transparent,
                        color2: DynamicColor.lightBlackClr,
                        color1: DynamicColor.lightBlackClr,
                        backgroundClr: tabValue.value == 1 ? true : false,
                        text: "Upcoming",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  showFilter.value = !showFilter.value;
                  // Get.toNamed(Routes.searchFilterScreen);
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ImageIcon(
                      const AssetImage("assets/filterIcons.png"),
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              const TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  HistoryTab(),
                  // UpComingEventView(historyVal: true,selectedValue: selectedFilter.value,),
                  // PastEventView(),
                  // UpComingEventView(historyVal: false, selectedValue: 0,),
                  UpcomingEvent(),
                ],
              ),
              Obx(
                () => Visibility(
                  visible: showFilter.value,
                  child: GestureDetector(
                    onTap: () {
                      selectedFilter.value = 0;
                    },
                    child: Container(
                      height: tabValue.value == 0 ? 220 : 150,
                      width: Get.width / 2,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: DynamicColor.whiteClr),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                selectedFilter.value = 0;
                                showFilter.value = false;
                              },
                              child: Container(
                                width: Get.width,
                                height: 35,
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: selectedFilter.value != 0
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
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                selectedFilter.value = 1;
                                showFilter.value = false;
                              },
                              child: Container(
                                width: Get.width,
                                height: 35,
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: selectedFilter.value != 1
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
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                selectedFilter.value = 2;
                                showFilter.value = false;
                              },
                              child: Container(
                                width: Get.width,
                                height: 35,
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: selectedFilter.value != 2
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
                          ),
                          tabValue.value != 0
                              ? const SizedBox.shrink()
                              : Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      selectedFilter.value = 3;
                                      showFilter.value = false;
                                    },
                                    child: Container(
                                      width: Get.width,
                                      height: 35,
                                      padding: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: selectedFilter.value != 3
                                              ? Colors.transparent
                                              : DynamicColor.yellowClr),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Finished",
                                          style: poppinsMediumStyle(
                                              fontSize: 14,
                                              color:
                                                  theme.scaffoldBackgroundColor,
                                              context: context),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          tabValue.value != 0
                              ? const SizedBox.shrink()
                              : Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      selectedFilter.value = 4;
                                      showFilter.value = false;
                                    },
                                    child: Container(
                                      width: Get.width,
                                      height: 35,
                                      padding: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: selectedFilter.value != 4
                                              ? Colors.transparent
                                              : DynamicColor.yellowClr),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Cancel",
                                          style: poppinsMediumStyle(
                                              fontSize: 14,
                                              color:
                                                  theme.scaffoldBackgroundColor,
                                              context: context),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

///>>>>>>>>>>>>history tab

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  late HomeController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<HomeController>()) {
      controller = Get.find<HomeController>();
    } else {
      controller = Get.put(HomeController());
    }
  }

  RxBool recommendedVal = false.obs;

  RxBool cancelledVal = false.obs;

  RxBool ongoingVal = false.obs;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          children: [
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
                          "Past Events",
                          style: poppinsMediumStyle(
                            fontSize: 14,
                            context: context,
                            color: theme.primaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (recommendedVal.value == false) {
                              controller.userPastEventHistory();
                              recommendedVal.value = true;
                            } else {
                              recommendedVal.value = false;
                              controller.update();
                            }
                          },
                          child: Icon(
                            recommendedVal.value == false
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up_outlined,
                            size: 35,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    controller.getUserHistoryLoader.value == false
                        ? const SizedBox.shrink()
                        : Visibility(
                            visible: recommendedVal.value,
                            child: controller.userPastHistory == null ||
                                    controller
                                        .userPastHistory!.data!.data!.isEmpty
                                ? noData(theme: theme, context: context)
                                : Column(
                                    children: [
                                      ListView.builder(
                                          itemCount: controller.userPastHistory!
                                                      .data!.data!.length >
                                                  4
                                              ? 4
                                              : controller.userPastHistory!
                                                  .data!.data!.length,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            EventData singleEventData =
                                                controller.userPastHistory!
                                                    .data!.data![index];
                                            return userCustomEvent(
                                                isDelete: singleEventData
                                                            .user?.deleteAt ==
                                                        null
                                                    ? false
                                                    : true,
                                                dayy:
                                                    DateFormat
                                                            .MMM()
                                                        .format(
                                                            singleEventData
                                                                .startDateTime!),
                                                datee:
                                                    "${singleEventData.startDateTime!.day}\n",
                                                networkImg:
                                                    singleEventData.bannerImage == null
                                                        ? false
                                                        : true,
                                                img:
                                                    singleEventData
                                                        .bannerImage?.mediaPath
                                                        .toString(),
                                                title: singleEventData.eventTitle
                                                    .toString(),
                                                location:
                                                    singleEventData.location,
                                                subtitle: singleEventData
                                                    .venue!.venueName
                                                    .toString(),
                                                onTap: () {
                                                  Get.toNamed(
                                                      Routes
                                                          .userEventDetailsScreen,
                                                      arguments: {
                                                        "notify": true,
                                                        "notifyBackBtn": true,
                                                        'appBarTitle':
                                                            "Event Preview",
                                                        "statusText":
                                                            singleEventData.id
                                                                .toString(),
                                                        "isCancel": true,
                                                      });
                                                },
                                                context: context,
                                                theme: theme);
                                          }),
                                      CustomButton(
                                        onTap: () {
                                          Get.toNamed(
                                              Routes.viewAllRecommendedScreen,
                                              arguments: {
                                                "urlText": "past-events",
                                                "appBarText": "All Past Event"
                                              });
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
                          "Cancelled Events",
                          style: poppinsMediumStyle(
                            fontSize: 14,
                            context: context,
                            color: theme.primaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (cancelledVal.value == false) {
                              controller.cancelEventUserHistory();
                              cancelledVal.value = true;
                            } else {
                              cancelledVal.value = false;
                              controller.update();
                            }
                          },
                          child: Icon(
                            cancelledVal.value == false
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up_outlined,
                            size: 35,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    controller.cancelEventUserHistoryLoader.value == false
                        ? const SizedBox.shrink()
                        : Visibility(
                            visible: cancelledVal.value,
                            child: controller.recommendedEventData == null ||
                                    controller.recommendedEventData!.data!.data!
                                        .isEmpty
                                ? noData(theme: theme, context: context)
                                : Column(
                                    children: [
                                      ListView.builder(
                                          itemCount: controller
                                                      .recommendedEventData!
                                                      .data!
                                                      .data!
                                                      .length >
                                                  4
                                              ? 4
                                              : controller.recommendedEventData!
                                                  .data!.data!.length,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            EventData singleEventData =
                                                controller.recommendedEventData!
                                                    .data!.data![index];
                                            return userCustomEvent(
                                                isDelete: singleEventData
                                                            .user?.deleteAt ==
                                                        null
                                                    ? false
                                                    : true,
                                                dayy:
                                                    DateFormat
                                                            .MMM()
                                                        .format(
                                                            singleEventData
                                                                .startDateTime!),
                                                datee:
                                                    "${singleEventData.startDateTime!.day}\n",
                                                networkImg:
                                                    singleEventData.bannerImage == null
                                                        ? false
                                                        : true,
                                                img:
                                                    singleEventData
                                                        .bannerImage?.mediaPath
                                                        .toString(),
                                                title: singleEventData.eventTitle
                                                    .toString(),
                                                location:
                                                    singleEventData.location,
                                                subtitle: singleEventData
                                                    .venue!.venueName
                                                    .toString(),
                                                onTap: () {
                                                  Get.toNamed(
                                                      Routes
                                                          .userEventDetailsScreen,
                                                      arguments: {
                                                        "notify": true,
                                                        "notifyBackBtn": true,
                                                        'appBarTitle':
                                                            "Event Preview",
                                                        "statusText":
                                                            singleEventData.id
                                                                .toString()
                                                      });
                                                },
                                                context: context,
                                                theme: theme);
                                          }),
                                      CustomButton(
                                        onTap: () {
                                          Get.toNamed(
                                              Routes.viewAllRecommendedScreen,
                                              arguments: {
                                                "urlText": "past-events",
                                                "appBarText": "All Past Event"
                                              });
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
            const SizedBox(
              height: kToolbarHeight,
            )
          ],
        ),
      );
    });
  }
}

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>> upComing
class UpcomingEvent extends StatefulWidget {
  const UpcomingEvent({super.key});

  @override
  State<UpcomingEvent> createState() => _UpcomingEventState();
}

class _UpcomingEventState extends State<UpcomingEvent> {
  late HomeController _controller;
  RxBool recommendedVal = true.obs;

  // HomeController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<HomeController>()) {
      _controller = Get.find<HomeController>();
    } else {
      _controller = Get.put(HomeController());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels ==
            scrollNotification.metrics.maxScrollExtent) {
          if (_controller.recommendedEventData!.data!.nextPageUrl != null) {
            if (_controller.newsFeedWait == false) {
              _controller.newsFeedWait = true;
              Future.delayed(const Duration(seconds: 2), () {
                _controller.newsFeedWait = false;
              });
              _controller.getRecommended(
                  fullUrl: _controller.recommendedEventData!.data!.nextPageUrl);
              return true;
            }
          }
          return false;
        }
        return false;
      },
      child: GetBuilder<HomeController>(initState: (v) {
        _controller.getRecommended(url: "user-upcoming-events");
      }, builder: (controller) {
        return controller.getRecommendedLoader.value == false
            ? const SizedBox.shrink()
            : controller.recommendedEventData!.data!.data!.isEmpty
                ? noData(context: context, theme: theme)
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: DynamicColor.darkGrayClr),
                      child: ListView.builder(
                          itemCount: controller
                              .recommendedEventData!.data!.data!.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, index) {
                            EventData singleEventData = controller
                                .recommendedEventData!.data!.data![index];
                            return userCustomEvent(
                                isDelete: singleEventData.user?.deleteAt == null
                                    ? false
                                    : true,
                                dayy: DateFormat.MMM()
                                    .format(singleEventData.startDateTime!),
                                datee:
                                    "${singleEventData.startDateTime!.day}\n",
                                networkImg: singleEventData.bannerImage == null
                                    ? false
                                    : true,
                                img: singleEventData.bannerImage?.mediaPath
                                    .toString(),
                                title: singleEventData.eventTitle.toString(),
                                location: singleEventData.location,
                                subtitle:
                                    singleEventData.venue!.venueName.toString(),
                                onTap: () {
                                  Get.toNamed(Routes.userEventDetailsScreen,
                                      arguments: {
                                        "notify": true,
                                        "notifyBackBtn": true,
                                        'appBarTitle': "Event Preview",
                                        "statusText":
                                            singleEventData.id.toString()
                                      });
                                },
                                context: context,
                                theme: theme);
                          }),
                    ),
                  );
      }),
    );
  }
}


// ///Upcoming Event
//
// class UpComingEventView extends StatefulWidget {
//   UpComingEventView({Key? key,this.historyVal,this.selectedValue = 12}) : super(key: key);
//
//   bool? historyVal = true;
//   int selectedValue = 12;
//
//   @override
//   State<UpComingEventView> createState() => _UpComingEventViewState();
// }
//
// class _UpComingEventViewState extends State<UpComingEventView> {
//
//   String? status;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if(widget.selectedValue == 0){
//       status = "upcoming";
//     }else if(widget.selectedValue == 3){
//       status = "Finished";
//     }else if (widget.selectedValue == 4){
//       status = "Cancel";
//     }
//   }
//
//   RxBool recommendedVal= false.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     return ListView.builder(itemBuilder: (BuildContext context,index){
//
//         GestureDetector(
//         onTap: (){
//           Get.toNamed(Routes.userEventDetailsScreen,
//           arguments: {
//             "notify": false,
//             "appBarTitle": "Event Preview",
//             "statusText": status,
//           }
//           );
//         },
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
//           child: Column(
//             children: [
//               Container(
//                 height: kToolbarHeight*2.2,
//                 width: Get.width,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("assets/event1.png"),
//                     fit: BoxFit.fill
//                   )
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     widget.historyVal==true?  Align(
//                       alignment: Alignment.topLeft,
//                       child: Container(
//                         width: 60,
//                         height: 23,
//                         decoration: BoxDecoration(
//                           color: DynamicColor.finishedTextClr,
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(6),
//                               bottomRight: Radius.circular(8),
//                             )
//                         ),
//                         child: Center(
//                           child: Text("Finished",
//                             style: poppinsRegularStyle(
//                               fontSize: 10,
//                               color: color: theme.primaryColor,
//                               context: context,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ):SizedBox.shrink(),
//                     Padding(
//                       padding: EdgeInsets.only(right: 10),
//                       child: Align(
//                         alignment: Alignment.topRight,
//                         // child: Container(
//                         //   height: 45,
//                         //   width: 50,
//                         //   decoration: BoxDecoration(
//                         //       shape: BoxShape.circle,
//                         //       color: DynamicColor.darkGrayClr.withOpacity(0.6),
//                         //       border: Border.all(color: color: theme.primaryColor,)
//                         //   ),
//                         //   child: Column(
//                         //     mainAxisAlignment: MainAxisAlignment.center,
//                         //     children: [
//                         //       Text('17',style: poppinsRegularStyle(fontSize: 11,context: context,color: DynamicColor.pinkClr),),
//                         //       Text('june',
//                         //         style: poppinsRegularStyle(fontSize: 11,context: context,color: color: theme.primaryColor,
//                         //             fontWeight: FontWeight.w600),)
//                         //     ],
//                         //   ),
//                         // ),
//                         child: eventDateWidget(theme: theme),
//                       ),
//                     ),
//                     Padding(padding: EdgeInsets.symmetric(vertical: 6),
//                     child: locationWidget(verticalPadding:4,theme: theme,context: context, bgClr: DynamicColor.blackClr),
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(vertical: 8),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: DynamicColor.lightWhite),
//                   borderRadius: BorderRadius.circular(10),
//                   // borderRadius: BorderRadius.only(
//                   //   bottomRight: Radius.circular(8),
//                   //   bottomLeft: Radius.circular(8),
//                   // ),
//                   image: DecorationImage(
//                       image: AssetImage("assets/grayClor.png"),
//                       fit: BoxFit.fill
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Text("90’s Grunge and Bowling",
//                       style: poppinsMediumStyle(
//                           fontSize: 16,
//                           context: context,
//                           color: theme.primaryColor,
//                       ),
//                     ),
//                     Text("The Burning Cactus",
//                       style: poppinsMediumStyle(
//                           fontSize: 12,
//                           context: context,
//                           color: DynamicColor.grayClr
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }


