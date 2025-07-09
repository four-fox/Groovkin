import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/customEventWidget.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/venueDetailsModel.dart';
import 'package:groovkin/View/bottomNavigation/myGroovkinScreen.dart';

class EventOrganizerScreen extends StatelessWidget {
  EventOrganizerScreen({super.key});

  int eventOrganizerVal = Get.arguments['eventOrganizerValue'];
  String profileImg = Get.arguments['profileImg'];
  String rolesType = Get.arguments['manager'];
  User? user = Get.arguments?["user"];
  // bool propertyShow = Get.arguments['propertyView'];

  RxBool recommendedVal = false.obs;
  RxBool cancelledVal = false.obs;
  RxBool propertyVal = false.obs;
  RxBool onGoingVal = false.obs;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            eventOrganizerVal == 1
                ? kToolbarHeight * 3.5
                : eventOrganizerVal == 3
                    ? kToolbarHeight * 5.45
                    : kToolbarHeight * 4.7,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width,
                height: eventOrganizerVal == 1
                    ? kToolbarHeight * 2.5
                    : kToolbarHeight * 1.4,
                padding: EdgeInsets.only(top: eventOrganizerVal == 1 ? 30 : 22),
                decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage("assets/grayClor.png"),
                        fit: BoxFit.fill),
                    borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.circular(eventOrganizerVal == 1 ? 0 : 20),
                      bottomRight:
                          Radius.circular(eventOrganizerVal == 1 ? 0 : 20),
                    )),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: ImageIcon(
                                const AssetImage("assets/backArrow.png"),
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        eventOrganizerVal != 1
                            ? const SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor:
                                          DynamicColor.lightYellowClr,
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            theme.scaffoldBackgroundColor,
                                        child: Image(
                                          image: AssetImage(profileImg),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Michael Logan",
                                            style: poppinsRegularStyle(
                                              fontSize: 14,
                                              context: context,
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                          Text(
                                            rolesType,
                                            style: poppinsRegularStyle(
                                              fontSize: 13,
                                              context: context,
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      ],
                    ),
                    eventOrganizerVal == 1
                        ? const SizedBox.shrink()
                        : Text(
                            "Profile",
                            style: poppinsMediumStyle(
                              fontSize: 17,
                              color: theme.primaryColor,
                            ),
                          ),
                  ],
                ),
              ),
              eventOrganizerVal == 1
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: DynamicColor.lightYellowClr,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: theme.scaffoldBackgroundColor,
                              child: Image(
                                image: user != null
                                    ? user?.profilePicture != null
                                        ? NetworkImage(
                                            user?.profilePicture?.mediaPath ??
                                                "")
                                        : AssetImage(profileImg)
                                            as ImageProvider
                                    : AssetImage(profileImg),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (user != null && user!.name != null)
                                      ? user!.name!
                                      : "Michael Logan",
                                  style: poppinsRegularStyle(
                                    fontSize: 14,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                // Text(
                                //   rolesType,
                                //   style: poppinsRegularStyle(
                                //     fontSize: 13,
                                //     context: context,
                                //     color: theme.primaryColor,
                                //   ),
                                // ),
                                Text(
                                  (user != null && user!.role != null)
                                      ? user!.role == "event_owner"
                                          ? "Event Organizer"
                                          : user!.role == "venue_manager"
                                              ? "Event Manager"
                                              : user!.role == "user"
                                                  ? "User"
                                                  : rolesType
                                      : rolesType,
                                  style: poppinsRegularStyle(
                                    fontSize: 13,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
              eventOrganizerVal == 1
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'About',
                        style: poppinsMediumStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: DynamicColor.whiteClr,
                        ),
                      ),
                    ),
              eventOrganizerVal == 1
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '90’s Century Western presented by Tonwsquare Media.\nGates will open at 10:30pm and music begin at night.\nParking lots open at 10:30pm.',
                        maxLines: 3,
                        style: poppinsRegularStyle(
                          fontSize: 12,
                          color: theme.primaryColor.withValues(alpha:0.7),
                        ),
                      ),
                    ),
              Divider(
                height: 9,
                color: DynamicColor.lightWhite.withValues(alpha:0.5),
              ),
              eventOrganizerVal != 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: DynamicColor.darkGrayClr,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "Following",
                                style: poppinsRegularStyle(
                                  fontSize: 12,
                                  context: context,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: DynamicColor.darkGrayClr,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "Followers",
                                  style: poppinsRegularStyle(
                                    fontSize: 12,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: DynamicColor.darkGrayClr,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                                child: ImageIcon(
                              const AssetImage("assets/updatedProfileIcon.png"),
                              color: DynamicColor.yellowClr,
                            )),
                          ),
                        ],
                      ),
                    )
                  : TabBar(
                      unselectedLabelStyle:
                          poppinsMediumStyle(fontSize: 14, context: context),
                      labelStyle:
                          poppinsMediumStyle(fontSize: 14, context: context),
                      labelPadding: const EdgeInsets.all(6),
                      indicatorPadding: const EdgeInsets.all(10),
                      indicatorColor: theme.primaryColor,
                      tabs: [
                        const Tab(text: "Organized event"),
                        Tab(
                          text:
                              eventOrganizerVal == 2 ? "Past Event" : "Service",
                        ),
                        Tab(
                          text: eventOrganizerVal == 2 ? "Property" : "About",
                        ),
                      ],
                    ),
              eventOrganizerVal == 3
                  ? TabBar(
                      unselectedLabelStyle:
                          poppinsMediumStyle(fontSize: 14, context: context),
                      labelStyle:
                          poppinsMediumStyle(fontSize: 14, context: context),
                      labelPadding: const EdgeInsets.all(6),
                      indicatorPadding: const EdgeInsets.all(10),
                      indicatorColor: theme.primaryColor,
                      tabs: [
                        const Tab(text: "Organized event"),
                        Tab(
                          text: eventOrganizerVal == 2
                              ? "Past Events"
                              : "Service",
                        ),
                        Tab(
                          text: eventOrganizerVal == 2 ? "Property" : "About",
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        body:
            // eventOrganizerVal !=2?
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: DynamicColor.darkGrayClr),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          recommendedVal.value =
                                              !recommendedVal.value;
                                        },
                                        child: Icon(
                                          recommendedVal.value == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
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
                                        itemCount: 12,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return userCustomEvent(
                                              isDelete: null,
                                              onTap: () {
                                                Get.toNamed(
                                                    Routes
                                                        .userEventDetailsScreen,
                                                    arguments: {
                                                      "notify": false,
                                                      "appBarTitle":
                                                          "Event Preview",
                                                      "statusText": 'upcoming',
                                                    });
                                              },
                                              context: context,
                                              theme: theme);
                                        }),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: DynamicColor.darkGrayClr),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Past Events",
                                      style: poppinsMediumStyle(
                                        fontSize: 14,
                                        context: context,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                    Obx(
                                      () => GestureDetector(
                                        onTap: () {
                                          cancelledVal.value =
                                              !cancelledVal.value;
                                        },
                                        child: Icon(
                                          cancelledVal.value == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          size: 35,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Obx(
                                  () => Visibility(
                                    visible: cancelledVal.value,
                                    child: ListView.builder(
                                        itemCount: 12,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return userCustomEvent(
                                              isDelete: null,
                                              onTap: () {
                                                Get.toNamed(
                                                    Routes
                                                        .userEventDetailsScreen,
                                                    arguments: {
                                                      "notify": false,
                                                      "appBarTitle":
                                                          "Past Event",
                                                      "statusText": 'upcoming',
                                                    });
                                              },
                                              context: context,
                                              theme: theme);
                                        }),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: DynamicColor.darkGrayClr),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          onGoingVal.value = !onGoingVal.value;
                                        },
                                        child: Icon(
                                          onGoingVal.value == false
                                              ? Icons.keyboard_arrow_down
                                              : Icons
                                                  .keyboard_arrow_up_outlined,
                                          size: 35,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Obx(
                                  () => Visibility(
                                    visible: onGoingVal.value,
                                    child: ListView.builder(
                                        itemCount: 12,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return userCustomEvent(
                                              isDelete: null,
                                              onTap: () {
                                                Get.toNamed(
                                                    Routes
                                                        .userEventDetailsScreen,
                                                    arguments: {
                                                      "notify": true,
                                                      "notifyBackBtn": true,
                                                      'appBarTitle':
                                                          "Event Preview",
                                                      "statusText": "ffff"
                                                    });
                                              },
                                              context: context,
                                              theme: theme);
                                        }),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: kToolbarHeight,
                          )
                        ],
                      ),
                    ),
                    // eventOrganizerVal == 3? OrganizedEventView(attendPeople: "sda",):OrganizedEventView(),
                    eventOrganizerVal == 2
                        ? OrganizedEventView(
                            attendPeople: "dsf",
                          ) /*VenueDetailsManagerScreen(serviceCondition: true)*/
                        : MyGroovkinScreen(
                            appBar: true,
                          ),
                    /*PropertyEventView()*/
                    eventOrganizerVal == 2
                        ? const PropertyEventView()
                        : AboutEventView(
                            user: user,
                          ),
                  ],
                )),
      ),
    );
  }
}

class OrganizedEventView extends StatelessWidget {
  OrganizedEventView({super.key, this.attendPeople});

  String? attendPeople;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ListView.builder(
        itemCount: 20,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: myEventCardWidget(
                theme: theme, context: context, attendedPeople: attendPeople),
          );
        });
  }
}

class PropertyEventView extends StatelessWidget {
  const PropertyEventView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ListView.builder(
        itemCount: 20,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, index) {
          return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: AssetImage('assets/grayClor.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: DynamicColor.yellowClr),
                          image: const DecorationImage(
                              image: AssetImage("assets/profileImg.png"),
                              fit: BoxFit.fill)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        children: [
                          Text(
                            "Herkimer County Fairgrounds",
                            style: poppinsRegularStyle(
                              fontSize: 16,
                              color: theme.primaryColor,
                              context: context,
                            ),
                          ),
                          Text(
                            "Tap to view detail about property",
                            style: poppinsRegularStyle(
                              fontSize: 12,
                              color: DynamicColor.grayClr,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}

class AboutEventView extends StatelessWidget {
  final User? user;
  const AboutEventView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: const DecorationImage(
              image: AssetImage('assets/grayClor.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Username',
                      style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                    Text(
                      (user != null && user!.name != null) ? user!.name! : "",
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: DynamicColor.lightRedClr),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 30,
                thickness: 1.6,
                color: DynamicColor.grayClr,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Email',
                      style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                    Text(
                      (user != null && user!.email != null)
                          ? user!.email!
                          : 'michael.logan@gmail.com',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: DynamicColor.lightRedClr),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 30,
                thickness: 1.6,
                color: DynamicColor.grayClr,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phone number',
                      style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                    Text(
                      (user != null &&
                              user!.profile != null &&
                              user!.profile!.phoneNumber != null)
                          ? user!.profile!.phoneNumber!
                          : '+1 (484) 4731 588',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: DynamicColor.lightRedClr),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
