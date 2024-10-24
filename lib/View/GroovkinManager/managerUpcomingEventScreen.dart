import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/showCustomMap.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class ManagerUpcomingEventScreen extends StatelessWidget {
  ManagerUpcomingEventScreen({Key? key}) : super(key: key);

  RxBool organizerFollowVal = false.obs;
  RxBool userVal = false.obs;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
          theme: theme, text: "Upcoming", actions: [Icon(Icons.more_vert)]),
      body: Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  border:
                      Border.all(color: DynamicColor.grayClr.withOpacity(0.6)),
                ),
                child: Column(
                  children: [
                    eventStatusWidget(
                        theme: theme, context: context, text: "Upcoming"),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: Row(
                        children: [
                          Image(
                            image: AssetImage("assets/profileImg.png"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Herkimer County Fairgrounds',
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
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomButton(
                        heights: 35,
                        color1: DynamicColor.redClr,
                        color2: DynamicColor.redClr,
                        widths: Get.width,
                        onTap: () {
                          Get.toNamed(Routes.cancelReason);
                        },
                        backgroundClr: false,
                        textClr: theme.primaryColor,
                        borderClr: Colors.transparent,
                        text: "Cancel",
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomButton(
                        heights: 35,
                        onTap: () {
                          Get.toNamed(Routes.editEventScreen);
                        },
                        backgroundClr: false,
                        borderClr: Colors.transparent,
                        color2: DynamicColor.greenClr,
                        color1: DynamicColor.greenClr,
                        text: "Changes",
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  "90’s Grunge and Bowling",
                  style: poppinsMediumStyle(
                    fontSize: 19,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: DynamicColor.darkBlueClr,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Image(
                      image: AssetImage("assets/lockIcon.png"),
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      '10:30 Pm to 5:00 Am (GMT-04:00)',
                      style: poppinsRegularStyle(
                        fontSize: 13,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: DynamicColor.darkBlueClr,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child: Image(
                        image: AssetImage("assets/calender.png"),
                      )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Text(
                        'Saturday, June 17th of 2023',
                        style: poppinsRegularStyle(
                          fontSize: 13,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 35,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: DynamicColor.darkBlueClr,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: ImageIcon(
                      AssetImage("assets/location.png"),
                      color: DynamicColor.yellowClr,
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      'Saturday, June 17th of 2023',
                      style: poppinsRegularStyle(
                        fontSize: 13,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              sp.read('role') == "eventManager"
                  ? SizedBox.shrink()
                  : Obx(
                      () => aboutEventCreator(
                        isDelete: null,
                          horizontalPadding: 0,
                          theme: theme,
                          context: context,
                          followBg: organizerFollowVal.value == true
                              ? DynamicColor.grayClr
                              : DynamicColor.lightBlackClr,
                          textClr: organizerFollowVal.value == true
                              ? theme.scaffoldBackgroundColor
                              : theme.primaryColor,
                          icons: organizerFollowVal.value == true
                              ? Icons.check
                              : Icons.add,
                          onTap: () {
                            organizerFollowVal.value =
                                !organizerFollowVal.value;
                          },
                          rowOnTap: () {
                            Get.toNamed(Routes.eventOrganizerScreen,
                                arguments: {
                                  "eventOrganizerValue": 3,
                                  'profileImg': "assets/eventOrganizer.png",
                                  "manager": sp.read("role")
                                });
                          }),
                    ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: DynamicColor.darkGrayClr),
                child: Column(
                  children: [
                    rateAndPriceWidget(theme: theme, context: context),
                    Divider(
                      color: DynamicColor.grayClr,
                    ),
                    rateAndPriceWidget(
                        theme: theme,
                        context: context,
                        text: "te",
                        value: "22-June-2023"),
                    Divider(
                      color: DynamicColor.grayClr,
                    ),
                    rateAndPriceWidget(
                        theme: theme,
                        context: context,
                        text: "End Date",
                        value: "22-June-2023"),
                    Divider(
                      color: DynamicColor.grayClr,
                    ),
                    rateAndPriceWidget(
                        theme: theme,
                        context: context,
                        text: "Hourly Rate",
                        value: "\$60"),
                    Divider(
                      color: DynamicColor.grayClr,
                    ),
                    rateAndPriceWidget(
                        theme: theme,
                        context: context,
                        text: "Total Rate",
                        value: "\$90"),
                  ],
                ),
              ),
              Obx(
                () => ourGuestWidget(
                  isDelete: null,
                  theme: theme,
                  context: context,
                  horizontalPadding: 0.0,
                  followPadding: 0.0,
                  rowPadding: 0.0,
                  avatarPadding: 8,
                  rowVerticalPadding: 0.0,
                  icon: userVal.value == true ? Icons.check : Icons.add,
                  followBgClr: userVal.value == false
                      ? DynamicColor.avatarBgClr
                      : DynamicColor.grayClr,
                  textClr: userVal.value == true
                      ? theme.scaffoldBackgroundColor
                      : theme.primaryColor,
                  onTap: () {
                    userVal.value = !userVal.value;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Location",
                    style: poppinsMediumStyle(
                        fontSize: 18,
                        context: context,
                        color: DynamicColor.lightRedClr,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Herkimer country Faigrounds",
                    style: poppinsMediumStyle(
                      fontSize: 13,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              ShowCustomMap(
                horizontalPadding: 2,
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 2, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Verbiage to come",
                    style: poppinsMediumStyle(
                      fontSize: 16,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    return Obx(
                      () => GestureDetector(
                        onTap: () {
                          list[index].value = !list[index].value;
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: list[index] == false ? 0 : 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: list[index] == false
                                  ? Colors.transparent
                                  : DynamicColor.avatarBgClr,
                            ),
                            child: Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: list[index] == false
                                      ? DynamicColor.darkBlueClr
                                      : DynamicColor.grayClr,
                                  child: ImageIcon(
                                    AssetImage("assets/avEquipment.png"),
                                    color: list[index] == false
                                        ? DynamicColor.yellowClr
                                        : DynamicColor.blackClr,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Text(
                                    "AV Equipment",
                                    style: poppinsRegularStyle(
                                      fontSize: 14,
                                      context: context,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                list[index] == false
                                    ? SizedBox.shrink()
                                    : Icon(Icons.check)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              Padding(
                padding: EdgeInsets.only(left: 2, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "All Hardware",
                    style: poppinsMediumStyle(
                      fontSize: 16,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                  itemCount: 7,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Image(
                              image: AssetImage("assets/headingIcons.png"),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 6.0),
                              child: Text(
                                "Vinyl Turntables",
                                style: poppinsRegularStyle(
                                  fontSize: 14,
                                  context: context,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Tags",
                    style: poppinsMediumStyle(
                      fontSize: 13,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: kToolbarHeight / 2,
                child: ListView.builder(
                    itemCount: 12,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: DynamicColor.lightRedClr,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              "#Nirvana",
                              style: poppinsRegularStyle(
                                fontSize: 12,
                                context: context,
                                color: theme.scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List list = [
    false.obs,
    false.obs,
    false.obs,
  ];

  Widget rateAndPriceWidget({theme, context, text, value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text ?? "Rate",
          style: poppinsRegularStyle(
            fontSize: 14,
            context: context,
            color: theme.primaryColor,
          ),
        ),
        Text(
          value ?? "\$1000.00",
          style: poppinsRegularStyle(
            fontSize: 14,
            context: context,
            color: DynamicColor.lightRedClr,
          ),
        ),
      ],
    );
  }
}
