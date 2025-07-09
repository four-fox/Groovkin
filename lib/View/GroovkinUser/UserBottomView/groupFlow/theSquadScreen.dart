// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class TheSquadScreen extends StatelessWidget {
  TheSquadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
          theme: theme,
          container: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage("assets/profileImg.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "The Squad",
                  style: poppinsMediumStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
              )
            ],
          )),
      body: SizedBox(
        // width: Get.width/1.4,
        child: ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (BuildContext context, index) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.userEventDetailsScreen, arguments: {
                    "notify": true,
                    'notifyBackBtn': false,
                    "statusText": "adsf",
                    "appBarTitle": "Event Preview",
                    // "notifyBackBtn": true,
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Align(
                    alignment: list[index] == true
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      width: Get.width / 1.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage("assets/grayClor.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/profileImg.png"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "john",
                                    style: poppinsMediumStyle(
                                      fontSize: 14,
                                      context: context,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "16.46",
                              style: poppinsRegularStyle(
                                  fontSize: 11,
                                  context: context,
                                  color: DynamicColor.grayClr),
                            ),
                          ),
                          Container(
                            height: kToolbarHeight * 3,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            // height: kToolbarHeight*2,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/event1.png"),
                                    fit: BoxFit.fill)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8, top: 8),
                                      child: eventDateWidget(
                                          theme: theme, context: context),
                                    )),
                                locationWidget(theme: theme, context: context)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 0.0, left: 6.0),
                            child: Text(
                              "90's Grunge and Bowling",
                              style: poppinsRegularStyle(
                                fontSize: 14,
                                context: context,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, bottom: 6),
                            child: Text(
                              "The Burning Cactus",
                              style: poppinsRegularStyle(
                                  fontSize: 11,
                                  context: context,
                                  color: DynamicColor.grayClr),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  List list = [false, true, false, true, true, false, false];
}
