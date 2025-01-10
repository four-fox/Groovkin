// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';

class FollowingScreen extends StatelessWidget {
  FollowingScreen({super.key});

  RxInt selectedVal = 0.obs;

  final AuthController _controller = Get.find();

  String appBarText = Get.arguments["appBarText"] ?? "Following";

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/grayClor.png"),
                    fit: BoxFit.fill)),
          ),
          title: Text(
            appBarText,
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
              AssetImage("assets/backArrow.png"),
              color: theme.primaryColor,
            ),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              unselectedLabelStyle:
                  poppinsMediumStyle(fontSize: 14, context: context),
              labelStyle: poppinsMediumStyle(fontSize: 14, context: context),
              labelPadding: EdgeInsets.all(6),
              indicatorPadding: EdgeInsets.all(10),
              indicatorColor: Colors.transparent,
              onTap: (v) {
                selectedVal.value = v;
                if (v == 0) {
                  _controller.getAllFollowings(
                      userType: "user", apiHit: appBarText);
                } else if (v == 1) {
                  _controller.getAllFollowings(
                      userType: "event_owner", apiHit: appBarText);
                } else {
                  _controller.getAllFollowings(
                      userType: "venue_manager", apiHit: appBarText);
                }
              },
              tabs: [
                Tab(
                  child: Obx(
                    () => Container(
                      // height: 35,
                      // padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedVal.value == 0
                            ? DynamicColor.yellowClr
                            : DynamicColor.darkGrayClr,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "User",
                          style: poppinsRegularStyle(
                              fontSize: 12,
                              context: context,
                              color: selectedVal.value == 0
                                  ? theme.primaryColor
                                  : DynamicColor.whiteClr.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Obx(
                    () => Container(
                      // height: 35,
                      // padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedVal.value == 1
                            ? DynamicColor.yellowClr
                            : DynamicColor.darkGrayClr,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Event Organizer",
                          style: poppinsRegularStyle(
                              fontSize: 12,
                              context: context,
                              color: selectedVal.value == 1
                                  ? theme.primaryColor
                                  : DynamicColor.whiteClr.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Obx(
                    () => Container(
                      // height: 35,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedVal.value == 2
                            ? DynamicColor.yellowClr
                            : DynamicColor.darkGrayClr,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Venue Manager",
                          style: poppinsRegularStyle(
                              fontSize: 12,
                              context: context,
                              color: selectedVal.value == 2
                                  ? theme.primaryColor
                                  : DynamicColor.whiteClr.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GetBuilder<AuthController>(initState: (v) {
                _controller.allUnFollower = null;
                _controller.getAllFollowings(
                    userType: "user", apiHit: appBarText);
              }, builder: (controller) {
                return Obx(
                  () => NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification.metrics.pixels ==
                          scrollNotification.metrics.maxScrollExtent) {
                        if (_controller.getAllFollowersWait == false) {
                          _controller.getAllFollowersWait = true;
                          if (_controller.allUnFollower!.data!.nextPageUrl !=
                              null) {
                            String link =
                                _controller.allUnFollower!.data!.nextPageUrl!;
                            _controller.getAllFollowings(
                                nextUrl: link,
                                userType: selectedVal.value == 0
                                    ? "user"
                                    : selectedVal.value == 1
                                        ? "event_owner"
                                        : "venue_manager",
                                apiHit: appBarText);
                            return true;
                          }
                        }
                        return false;
                      }
                      return false;
                    },
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        controller.getAllUnfollowingLoader.value == false
                            ? SizedBox.shrink()
                            : AllUsers(
                                userValue: "User",
                                type: appBarText,
                              ),
                        controller.getAllUnfollowingLoader.value == false
                            ? SizedBox.shrink()
                            : AllUsers(
                                userValue: "Event Organizer",
                                type: appBarText,
                              ),
                        controller.getAllUnfollowingLoader.value == false
                            ? SizedBox.shrink()
                            : AllUsers(
                                userValue: "Event Organizer",
                                type: appBarText,
                              ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class AllUsers extends StatelessWidget {
  AllUsers({super.key, this.userValue, this.heights, this.type});

  String? userValue;
  double? heights;
  String? type;

  final AuthController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SizedBox(
        height: heights ?? Get.height / 1.25,
        child: _controller.allUnFollower!.data!.data!.isEmpty
            ? noData(theme: theme)
            : ListView.builder(
                itemCount: _controller.allUnFollower!.data!.data!.length,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: DynamicColor.darkGrayClr),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: DynamicColor.blackClr,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: DynamicColor.lightYellowClr),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        _controller.allUnFollower == null
                                            ? dummyProfile
                                            : _controller
                                                        .allUnFollower!
                                                        .data!
                                                        .data![index]
                                                        .profilePicture ==
                                                    null
                                                ? dummyProfile
                                                : _controller
                                                    .allUnFollower!
                                                    .data!
                                                    .data![index]
                                                    .profilePicture!
                                                    .mediaPath!),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: SizedBox(
                              width: Get.width / 2.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _controller
                                        .allUnFollower!.data!.data![index].name
                                        .toString(),
                                    style: poppinsMediumStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: DynamicColor.grayClr,
                                    ),
                                  ),
                                  Text(
                                    _controller
                                        .allUnFollower!.data!.data![index].role
                                        .toString()
                                        .replaceAll("_", " ")
                                        .capitalize!,
                                    style: poppinsRegularStyle(
                                      fontSize: 14,
                                      context: context,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (heights != null) {
                                  _controller.followUser(
                                      userData: _controller
                                          .allUnFollower!.data!.data![index]);
                                } else if ((_controller.allUnFollower!.data!
                                            .data![index].following ==
                                        null) &&
                                    (_controller.allUnFollower!.data!
                                            .data![index].follower !=
                                        null)) {
                                  _controller.followUser(
                                      userData: _controller
                                          .allUnFollower!.data!.data![index]);
                                } else {
                                  _controller.unfollow(
                                      userData: _controller
                                          .allUnFollower!.data!.data![index]);
                                }
                                // list[index].value = !list[index].value;
                              },
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: /*_controller.allUnFollower!.data!.data![index].isFollow!.value ==true?DynamicColor.grayClr.withOpacity(0.3): */
                                        DynamicColor.grayClr),
                                child: Center(
                                  child: Text(
                                    heights != null
                                        ? "Follow"
                                        : _controller
                                                        .allUnFollower!
                                                        .data!
                                                        .data![index]
                                                        .follower ==
                                                    null &&
                                                _controller
                                                        .allUnFollower!
                                                        .data!
                                                        .data![index]
                                                        .following ==
                                                    null
                                            ? "Follow"
                                            : ((_controller
                                                            .allUnFollower!
                                                            .data!
                                                            .data![index]
                                                            .following ==
                                                        null) &&
                                                    (_controller
                                                            .allUnFollower!
                                                            .data!
                                                            .data![index]
                                                            .follower !=
                                                        null))
                                                ? "FollowBack"
                                                : "UnFollow",
                                    style: poppinsRegularStyle(
                                      fontSize: 14,
                                      context: context,
                                      color: /*list[index].value ==true?theme.primaryColor:*/
                                          theme.scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }));
  }
}
