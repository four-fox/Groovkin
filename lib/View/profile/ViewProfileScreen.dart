// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/Network/Url.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userEventDetailsModel.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:intl/intl.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  late AuthController _controller;
  final TextEditingController eventReasonController = TextEditingController();
  final TextEditingController venueReasonController = TextEditingController();
  EventDetails? eventDetails;
  EventDetails? venueDetails;
  int? venueId;
  int? eventId;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AuthController>()) {
      _controller = Get.find<AuthController>();
    } else {
      _controller = Get.put(AuthController());
    }
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
    bool fromNotification = Get.arguments?['fromNotification'] ?? false;
    int? id = Get.arguments?['id'];
    var theme = Theme.of(context);
    return GetBuilder<AuthController>(initState: (state) {
      if (fromNotification == true && id != null) {
        _controller.getProfile(userId: id);
      }
    }, builder: (controller) {
      return controller.getProfileLoader.value == false
          ? const SizedBox()
          : DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                        // color:imagee==true?Colors.transparent: DynamicColor.yellowClr,
                        image: DecorationImage(
                            image: AssetImage("assets/grayClor.png"),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                  ),
                  title: Text(
                    'Profile',
                    style: poppinsMediumStyle(
                      fontSize: 17,
                      color: theme.primaryColor,
                    ),
                  ),
                  leading: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: ImageIcon(
                        const AssetImage("assets/backArrow.png"),
                        color: theme.primaryColor,
                      )),
                  actions: [
                    if (!fromNotification && eventDetails != null)
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    padding: const EdgeInsets.all(12.0),
                                    margin: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: eventReasonController,
                                          decoration: const InputDecoration(
                                            hintText: "Reason",
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                          ),
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 5,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CustomButton(
                                          borderClr: Colors.transparent,
                                          heights: 35,
                                          fontSized: 13,
                                          onTap: () async {
                                            Get.back();
                                            await _controller
                                                .reportAccount(
                                                    type: "event_owner",
                                                    sourceId: eventId!,
                                                    message:
                                                        eventReasonController
                                                            .text)
                                                .then((_) {
                                              eventReasonController.clear();
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
                          icon: const Icon(Icons.more_vert)),
                    if (!fromNotification && venueDetails != null)
                      IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    padding: const EdgeInsets.all(12.0),
                                    margin: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: venueReasonController,
                                          decoration: const InputDecoration(
                                            hintText: "Reason",
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                          ),
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 5,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CustomButton(
                                          borderClr: Colors.transparent,
                                          heights: 35,
                                          fontSized: 13,
                                          onTap: () async {
                                            Get.back();
                                            print(venueId);
                                            await _controller
                                                .reportAccount(
                                                    type: "venue_manager",
                                                    sourceId: venueId!,
                                                    message:
                                                        venueReasonController
                                                            .text)
                                                .then((_) {
                                              venueReasonController.clear();
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
                          icon: const Icon(Icons.more_vert)),
                  ],
                ),
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: DynamicColor.lightRedClr,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                venueDetails?.venue!.user!.profilePicture !=
                                        null
                                    ? venueDetails!
                                        .venue!.user!.profilePicture!.mediaPath!
                                    : eventDetails?.user?.profilePicture != null
                                        ? eventDetails!
                                            .user!.profilePicture!.mediaPath!
                                        : _controller.userData?.data
                                                    ?.profilePicture !=
                                                null
                                            ? "${Url().imageUrl}${_controller.userData!.data!.profilePicture!.mediaPath}"
                                            : groupPlaceholder,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  venueDetails != null &&
                                          venueDetails?.venue != null
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
                                  venueDetails != null &&
                                          venueDetails?.venue != null
                                      ? venueDetails?.venue?.user?.name ?? ""
                                      : eventDetails != null &&
                                              eventDetails?.user != null
                                          ? eventDetails?.user?.name ?? ""
                                          : _controller.userData?.data?.name ??
                                              "",
                                  style: poppinsRegularStyle(
                                    fontSize: 13,
                                    color: theme.primaryColor
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                                Text(
                                  venueDetails != null &&
                                          venueDetails?.venue != null
                                      ? "Member since ${DateFormat.MMMd().format(DateTime.parse(venueDetails!.venue!.user!.createdAt!))}"
                                      : eventDetails != null &&
                                              eventDetails?.user != null
                                          ? "Member since ${DateFormat.MMMd().format(DateTime.parse(eventDetails!.user!.createdAt!))}"
                                          : _controller.userData!.data!
                                                      .profile !=
                                                  null
                                              ? "Member since ${DateFormat.MMMd().format(_controller.userData!.data!.profile!.createdAt!)}"
                                              : "",
                                  style: poppinsRegularStyle(
                                    fontSize: 10,
                                    color: DynamicColor.grayClr
                                        .withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!fromNotification &&
                        eventDetails == null &&
                        !fromNotification &&
                        venueDetails == null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            customFollowingBtn(context, onTap: () {
                              Get.toNamed(Routes.followingScreen,
                                  arguments: {"appBarText": "Followings"});
                            }),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: customFollowingBtn(context, onTap: () {
                                Get.toNamed(Routes.followingScreen,
                                    arguments: {"appBarText": "Followers"});
                              }, text: "Followers"),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
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
                                      const AssetImage(
                                          "assets/profileEditIcons.png"),
                                      color: DynamicColor.yellowClr,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
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
                          color: DynamicColor.grayClr.withValues(alpha: 0.5)),
                      labelStyle: poppinsMediumStyle(
                          fontSize: 14,
                          context: context,
                          color: DynamicColor.grayClr),
                      labelPadding: const EdgeInsets.all(6),
                      indicatorPadding: const EdgeInsets.all(10),
                      indicatorColor: theme.primaryColor,
                      // onTap: (v){
                      //   tabValue.value = v;
                      // },
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      tabs: [
                        const Tab(
                          text: "About",
                        ),
                        const Tab(
                          text: "Contact",
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
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
                                  venueDetails != null &&
                                          venueDetails?.venue != null
                                      ? venueDetails
                                              ?.venue?.user?.profile?.about ??
                                          ''
                                      : eventDetails != null &&
                                              eventDetails?.user != null
                                          ? eventDetails
                                                  ?.user?.profile?.about ??
                                              ''
                                          : _controller.userData?.data?.profile
                                                  ?.about ??
                                              '',
                                  style: poppinsRegularStyle(
                                      fontSize: 12,
                                      context: context,
                                      color: theme.primaryColor
                                          .withValues(alpha: 0.5)),
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
                  ],
                ),
              ),
            );
    });
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
          color: DynamicColor.lightBlackClr.withValues(alpha: 0.8),
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
