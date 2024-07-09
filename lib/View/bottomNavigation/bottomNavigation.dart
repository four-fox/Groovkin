// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/GroovkinManager/eventRequest.dart';
import 'package:groovkin/View/GroovkinManager/venueListsScreen.dart';
import 'package:groovkin/View/bottomNavigation/AnalyticFlowBottomBar/AnalyticPortal.dart';
import 'package:groovkin/View/bottomNavigation/homeScreen.dart';
import 'package:groovkin/View/bottomNavigation/myGroovkinScreen.dart';
import 'package:groovkin/View/bottomNavigation/settingView/settingScreen.dart';

RxInt selectIndexxx = 0.obs;

get selectIndex => selectIndexxx.value;

set selectIndex(index) => selectIndexxx.value = index;

class BottomNavigationView extends StatelessWidget {
  BottomNavigationView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(sp.read("role"));
    var theme = Theme.of(context);
    final bodyContent = [
      HomeScreen(),
      sp.read("role") == "eventManager"
          ? VenueListScreen()
          : MyGroovkinScreen(),
      sp.read("role") == "eventManager"
          ? EventRequests()
          : AnalyticPortalScreen(),
      SettingScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: theme.primaryColor,
          content: Text(
            'Tap back again to exit the app',
            style: poppinsMediumStyle(
                fontSize: 15,
                context: context,
                color: theme.scaffoldBackgroundColor),
          ),
        ),
        child: Obx(
          () => Center(
            child: bodyContent.elementAt(selectIndex),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          height: kToolbarHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
              image: DecorationImage(
                  image: AssetImage("assets/grayClor.png"), fit: BoxFit.fill)),
          child: BottomBarBubble(
            backgroundColor: Colors.transparent,
            color: DynamicColor.yellowClr,
            items: [
              BottomBarItem(
                iconBuilder: ImageIcon(
                  AssetImage("assets/homeScreen.png"),
                  color: selectIndexxx.value == 0
                      ? DynamicColor.yellowClr
                      : DynamicColor.grayClr,
                ),
              ),
              BottomBarItem(
                iconBuilder: ImageIcon(
                  AssetImage("assets/groovkin.png"),
                  color: selectIndexxx.value == 1
                      ? DynamicColor.yellowClr
                      : DynamicColor.grayClr,
                ),
              ),
              BottomBarItem(
                iconBuilder: ImageIcon(
                  AssetImage(sp.read("role") == "eventManager"
                      ? "assets/request.png"
                      : "assets/locationIcon.png"),
                  color: selectIndexxx.value == 2
                      ? DynamicColor.yellowClr
                      : DynamicColor.grayClr,
                ),
              ),
              BottomBarItem(
                iconBuilder: ImageIcon(
                  AssetImage("assets/settingIcon.png"),
                  color: selectIndexxx.value == 3
                      ? DynamicColor.yellowClr
                      : DynamicColor.grayClr,
                ),
              ),
            ],
            selectedIndex: selectIndexxx.value,
            onSelect: (index) {
              selectIndexxx.value = index;
            },
          ),
        ),
      ),
    );
  }
}
