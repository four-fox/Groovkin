import 'dart:io';

import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/GroovkinManager/eventRequest.dart';
import 'package:groovkin/View/GroovkinManager/venueListsScreen.dart';
import 'package:groovkin/View/bottomNavigation/AnalyticFlowBottomBar/AnalyticPortal.dart';
import 'package:groovkin/View/bottomNavigation/homeScreen.dart';
import 'package:groovkin/View/bottomNavigation/myGroovkinScreen.dart';
import 'package:groovkin/View/bottomNavigation/settingView/settingScreen.dart';
import 'package:groovkin/utils/utils.dart';

RxInt selectIndexxx = 0.obs;

get selectIndex => selectIndexxx.value;

set selectIndex(index) => selectIndexxx.value = index;

class BottomNavigationView extends StatelessWidget {
  const BottomNavigationView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(sp.read("role"));
    }
    var theme = Theme.of(context);
    final bodyContent = [
      const HomeScreen(),
      sp.read("role") == "eventManager"
          ? VenueListScreen()
          : MyGroovkinScreen(),
      sp.read("role") == "eventManager"
          ? const EventRequests()
          : const AnalyticPortalScreen(),
      const SettingScreen(),
    ];

    return Scaffold(
      extendBody: false,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
   customAlertt(
              context: context,
              title: "Exit Application",
              text: "Are You Sure?",              btnSuccess: "Yes",
              onTap: () {
                SystemNavigator.pop();
              },
            );
          }
        },
        child: Obx(
          () => Center(
            child: bodyContent.elementAt(selectIndex),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => SafeArea(
          // bottom: Platform.isIOS ? true : false,
          child: Padding(
            padding: Platform.isIOS
                ? const EdgeInsets.only(bottom: 10)
                : EdgeInsets.zero,
            child: Container(
              height: kToolbarHeight,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                  ),
                  image: DecorationImage(
                      image: AssetImage("assets/grayClor.png"),
                      fit: BoxFit.fill)),
              child: BottomBarBubble(
                backgroundColor: Colors.transparent,
                color: DynamicColor.yellowClr,
                items: [
                  BottomBarItem(
                    labelTextStyle: poppinsMediumStyle(
                        fontSize: 12,
                        context: context,
                        color: theme.scaffoldBackgroundColor),
                    iconBuilder: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: ImageIcon(
                        const AssetImage("assets/homeScreen.png"),
                        color: selectIndexxx.value == 0
                            ? DynamicColor.yellowClr
                            : DynamicColor.grayClr,
                      ),
                    ),
                    label: "Home",
                  ),
                  BottomBarItem(
                      labelTextStyle: poppinsMediumStyle(
                          fontSize: 12,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                      iconBuilder: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: ImageIcon(
                          const AssetImage("assets/groovkin.png"),
                          color: selectIndexxx.value == 1
                              ? DynamicColor.yellowClr
                              : DynamicColor.grayClr,
                        ),
                      ),
                      label: "My Groovkin"),
                  BottomBarItem(
                    labelTextStyle: poppinsMediumStyle(
                        fontSize: 12,
                        context: context,
                        color: theme.scaffoldBackgroundColor),
                    iconBuilder: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: ImageIcon(
                        AssetImage(sp.read("role") == "eventManager"
                            ? "assets/request.png"
                            : "assets/locationIcon.png"),
                        color: selectIndexxx.value == 2
                            ? DynamicColor.yellowClr
                            : DynamicColor.grayClr,
                      ),
                    ),
                    label: sp.read("role") == "eventManager"
                        ? "My Events"
                        : "Analytics",
                  ),
                  BottomBarItem(
                      labelTextStyle: poppinsMediumStyle(
                          fontSize: 12,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                      iconBuilder: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: ImageIcon(
                          const AssetImage("assets/settingIcon.png"),
                          color: selectIndexxx.value == 3
                              ? DynamicColor.yellowClr
                              : DynamicColor.grayClr,
                        ),
                      ),
                      label: "Settings"),
                ],
                selectedIndex: selectIndexxx.value,
                onSelect: (index) {
                  selectIndexxx.value = index;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
