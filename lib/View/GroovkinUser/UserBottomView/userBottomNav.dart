



// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userHistory/UserMyEvents.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/groupFlow/groupScreen.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userHome.dart';
import 'package:groovkin/View/bottomNavigation/AnalyticFlowBottomBar/AnalyticPortal.dart';
import 'package:groovkin/View/bottomNavigation/homeScreen.dart';
import 'package:groovkin/View/bottomNavigation/myGroovkinScreen.dart';
import 'package:groovkin/View/bottomNavigation/settingView/settingScreen.dart';

RxInt selectUserIndexxx = 0.obs;
get selectIndex => selectUserIndexxx.value;
set selectIndex(index) => selectUserIndexxx.value = index;

class UserBottomNavigationNav extends StatelessWidget {
  UserBottomNavigationNav({
    Key? key,
// this.initialIndex = 1,
  }) : super(key: key);

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final bodyContent = [
      UserHomeScreen(),
      MyEventsScreen(),
      GroupScreen(),
      SettingScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: theme.primaryColor,
          content: Text('Tap back again to exit the app',
          style: poppinsMediumStyle(
            fontSize: 15,
            context: context,
            color: theme.scaffoldBackgroundColor
          ),
          ),
        ),
        child: Obx(
              () => Center(
            child: bodyContent.elementAt(selectIndex),
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => Container(
        height: kToolbarHeight,
        decoration: BoxDecoration(
            borderRadius:  BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            ),
            image: DecorationImage(
                image: AssetImage("assets/grayClor.png"),
                fit: BoxFit.fill
            )
        ),
        child: BottomBarBubble(
          backgroundColor: Colors.transparent,
          color: DynamicColor.yellowClr,
          items: [
            BottomBarItem(
              label: "Home",
              labelTextStyle: poppinsMediumStyle(
                  fontSize: 12,
                  context: context,
                  color: theme.scaffoldBackgroundColor),
              iconBuilder: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: ImageIcon(AssetImage("assets/userHomeIcon.png"),color:selectUserIndexxx.value==0? DynamicColor.yellowClr:DynamicColor.grayClr,),
              ),
            ),
            BottomBarItem(
              label: "My Events",
              labelTextStyle: poppinsMediumStyle(
                  fontSize: 12,
                  context: context,
                  color: theme.scaffoldBackgroundColor),
              iconBuilder: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: ImageIcon(AssetImage("assets/userMyEvents.png"),color:selectUserIndexxx.value==1? DynamicColor.yellowClr:DynamicColor.grayClr,),
              ),
            ),
            BottomBarItem(
              label: "Groups",
              labelTextStyle: poppinsMediumStyle(
                  fontSize: 12,
                  context: context,
                  color: theme.scaffoldBackgroundColor),
              iconBuilder: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: ImageIcon(AssetImage("assets/groups.png"),color:selectUserIndexxx.value==2? DynamicColor.yellowClr:DynamicColor.grayClr,),
              ),
            ),
            BottomBarItem(
              label: "Setting",
              labelTextStyle: poppinsMediumStyle(
                  fontSize: 12,
                  context: context,
                  color: theme.scaffoldBackgroundColor),
              iconBuilder: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: ImageIcon(AssetImage("assets/settingIcon.png"),color:selectUserIndexxx.value==3? DynamicColor.yellowClr:DynamicColor.grayClr,),
              ),
            ),
          ],
          selectedIndex: selectUserIndexxx.value,
          onSelect: (index) {
            selectUserIndexxx.value = index;
            // implement your select function here
          },
        ),
      ),
      ),
    );
  }
}