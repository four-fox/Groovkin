// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userEventDetailsModel.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:intl/intl.dart';

class ViewProfileScreen extends StatefulWidget {
  ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  AuthController _controller = Get.find();
  EventDetails? eventDetails;
  EventDetails? venueDetails;
  int? venueId;
  int? eventId;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    if (API().sp.read("role") == "eventOrganizer") {
      venueDetails = Get.arguments['venueDetails'];
      venueId = Get.arguments["venueId"];
    } else if (API().sp.read("role") == "User") {
      venueDetails = Get.arguments['venueDetails'];
      venueId = Get.arguments["venueId"];
      eventDetails = Get.arguments['eventDetails'];
      eventId = Get.arguments["eventId"];
    } else {
      eventDetails = Get.arguments['eventDetails'];
      eventId = Get.arguments["eventId"];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(eventDetails);
    print(eventId);
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight * 4.3),
          child: Column(
            children: [
              Container(
                width: Get.width,
                height: kToolbarHeight * 1.56,
                decoration: BoxDecoration(
                    // color:imagee==true?Colors.transparent: DynamicColor.yellowClr,
                    image: DecorationImage(
                        image: AssetImage("assets/grayClor.png"),
                        fit: BoxFit.fill),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        'Profile',
                        style: poppinsMediumStyle(
                          fontSize: 17,
                          color: theme.primaryColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: ImageIcon(
                                AssetImage("assets/backArrow.png"),
                                color: theme.primaryColor,
                              )),
                        ),
                      ),
                      if (eventDetails != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        padding: EdgeInsets.all(12.0),
                                        margin: EdgeInsets.all(10.0),
                                        child: CustomButton(
                                          borderClr: Colors.transparent,
                                          heights: 35,
                                          fontSized: 13,
                                          onTap: () async {
                                            Get.back();
                                            await _controller.reportAccount(
                                                "event_owner", eventId!);
                                          },
                                          text: "Report",
                                        ),
                                      );
                                    });
                              },
                              icon: Icon(Icons.more_vert)),
                        ),
                      if (venueDetails != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        padding: EdgeInsets.all(12.0),
                                        margin: EdgeInsets.all(10.0),
                                        child: CustomButton(
                                          borderClr: Colors.transparent,
                                          heights: 35,
                                          fontSized: 13,
                                          onTap: () async {
                                            Get.back();
                                            print(venueId);
                                            await _controller.reportAccount(
                                                "venue_manager", venueId!);
                                          },
                                          text: "Report",
                                        ),
                                      );
                                    });
                              },
                              icon: Icon(Icons.more_vert)),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: DynamicColor.lightRedClr,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          venueDetails?.venue?.user?.profilePicture
                                      ?.mediaPath !=
                                  null
                              ? venueDetails!
                                  .venue!.user!.profilePicture!.mediaPath!
                              : eventDetails?.user?.profilePicture?.mediaPath !=
                                      null
                                  ? eventDetails!
                                      .user!.profilePicture!.mediaPath!
                                  : _controller
                                              .userData?.data?.profilePicture !=
                                          null
                                      ? _controller
                                          .userData!.data!.profilePicture!
                                      : groupPlaceholder,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            venueDetails != null && venueDetails?.venue != null
                                ? "${venueDetails?.venue?.user?.name ?? ''} ${venueDetails?.venue?.user?.profile?.lastName ?? ''}"
                                    .trim()
                                : eventDetails != null &&
                                        eventDetails?.user != null
                                    ? "${eventDetails?.user?.name ?? ''} ${eventDetails?.user?.profile?.lastName ?? ''}"
                                        .trim()
                                    : "${_controller.userData?.data?.profile?.firstName ?? ''} ${_controller.userData?.data?.profile?.lastName ?? ''}"
                                        .trim(),
                            style: poppinsMediumStyle(
                              fontSize: 15,
                              color: theme.primaryColor,
                            ),
                          ),
                          Text(
                            venueDetails != null && venueDetails?.venue != null
                                ? venueDetails?.venue?.user?.name ?? ""
                                : eventDetails != null &&
                                        eventDetails?.user != null
                                    ? eventDetails?.user?.name ?? ""
                                    : _controller.userData?.data?.name ?? "",
                            style: poppinsRegularStyle(
                              fontSize: 13,
                              color: theme.primaryColor.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            venueDetails != null && venueDetails?.venue != null
                                ? "Member since ${DateFormat.MMMd().format(DateTime.parse(venueDetails!.venue!.user!.createdAt!))}"
                                : eventDetails != null &&
                                        eventDetails?.user != null
                                    ? "Member since ${DateFormat.MMMd().format(DateTime.parse(eventDetails!.user!.createdAt!))}"
                                    : "Member since ${DateFormat.MMMd().format(_controller.userData!.data!.profile!.createdAt!)}",
                            style: poppinsRegularStyle(
                              fontSize: 10,
                              color: DynamicColor.grayClr.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (eventDetails == null && venueDetails == null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      customFollowingBtn(context, onTap: () {
                        Get.toNamed(Routes.followingScreen,
                            arguments: {"appBarText": "Followings"});
                      }),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: customFollowingBtn(context, onTap: () {
                          Get.toNamed(Routes.followingScreen,
                              arguments: {"appBarText": "Followers"});
                        }, text: "Followers"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: customFollowingBtn(context, onTap: () {
                          Get.toNamed(Routes.allUserScreen);
                        }, text: "Follow"),
                      ),
                      customFollowingBtn(context, onTap: () {
                        _controller.profileDataBind();
                      },
                          customWidget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageIcon(
                                AssetImage("assets/profileEditIcons.png"),
                                color: DynamicColor.yellowClr,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Text(
                                  "Edit",
                                  style: poppinsRegularStyle(
                                      fontSize: 13,
                                      context: context,
                                      color: DynamicColor.whiteClr),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              TabBar(
                unselectedLabelStyle: poppinsMediumStyle(
                    fontSize: 14,
                    context: context,
                    color: DynamicColor.grayClr.withOpacity(0.5)),
                labelStyle: poppinsMediumStyle(
                    fontSize: 14,
                    context: context,
                    color: DynamicColor.grayClr),
                labelPadding: EdgeInsets.all(6),
                indicatorPadding: EdgeInsets.all(10),
                indicatorColor: theme.primaryColor,
                // onTap: (v){
                //   tabValue.value = v;
                // },
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                tabs: [
                  Tab(
                    text: "About",
                  ),
                  Tab(
                    text: "Contact",
                  ),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About",
                    style: poppinsMediumStyle(
                      fontSize: 16,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                  Text(
                    venueDetails != null && venueDetails?.venue != null
                        ? venueDetails?.venue?.user?.profile?.about ?? ''
                        : eventDetails != null && eventDetails?.user != null
                            ? eventDetails?.user?.profile?.about ?? ''
                            : _controller.userData?.data?.profile?.about ?? '',
                    style: poppinsRegularStyle(
                        fontSize: 12,
                        context: context,
                        color: theme.primaryColor.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                "No Data",
                style: poppinsMediumStyle(
                  fontSize: 17,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
            ),
            /*Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: customFollowingBtn(context,text: "lucas.henry@gmail.com",
                      width: Get.width/2.5,
                      height: 35
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                    child: customFollowingBtn(context,text: "+14844731588",
                      width: Get.width/3,
                      height: 35
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget customFollowingBtn(
    context, {
    text,
    GestureTapCallback? onTap,
    Widget? customWidget,
    double? width,
    double? height,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 40,
        width: width ?? 80,
        // padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
        decoration: BoxDecoration(
          color: DynamicColor.lightBlackClr.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: customWidget ??
            Center(
              child: Text(
                text ?? "Following",
                style: poppinsRegularStyle(
                    fontSize: 12,
                    context: context,
                    color: DynamicColor.whiteClr),
              ),
            ),
      ),
    );
  }
}
