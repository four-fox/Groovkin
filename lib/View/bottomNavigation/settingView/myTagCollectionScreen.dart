// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class MyTagCollection extends StatelessWidget {
  const MyTagCollection({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "My Tag Collection"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "Collection",
                style: poppinsMediumStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              customWidget(
                  theme: theme,
                  context: context,
                  onTap: () {
                    Get.toNamed(Routes.myCollectionDetailsScreen);
                  }),
              SizedBox(
                height: 8,
              ),
              customWidget(
                  theme: theme,
                  context: context,
                  text: "Foodie Pool Hall",
                  onTap: () {
                    Get.toNamed(Routes.myCollectionDetailsScreen);
                  }),
              SizedBox(
                height: 8,
              ),
              customWidget(
                  theme: theme,
                  context: context,
                  text: "for birthday",
                  onTap: () {
                    Get.toNamed(Routes.myCollectionDetailsScreen);
                  }),
              SizedBox(
                height: 8,
              ),
              customWidget(
                  theme: theme,
                  context: context,
                  text: "for birthday",
                  onTap: () {
                    Get.toNamed(Routes.myCollectionDetailsScreen);
                  }),
              SizedBox(
                height: 8,
              ),
              customWidget(
                  theme: theme,
                  context: context,
                  text: "for birthday",
                  onTap: () {
                    Get.toNamed(Routes.myCollectionDetailsScreen);
                  }),
              SizedBox(
                height: 8,
              ),
              customWidget(
                  theme: theme,
                  context: context,
                  text: "for birthday",
                  onTap: () {
                    Get.toNamed(Routes.myCollectionDetailsScreen);
                  }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: Platform.isIOS ? true : false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          child: CustomButton(
            borderClr: Colors.transparent,
            color1: DynamicColor.blackClr,
            color2: DynamicColor.blackClr,
            onTap: () {
              Get.toNamed(Routes.createNewTag);
            },
            text: "Create new Collection",
          ),
        ),
      ),
    );
  }

  Widget customWidget({theme, context, text, GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: DynamicColor.darkGrayClr,
        ),
        child: Text(
          text ?? "Music Tags",
          style: poppinsRegularStyle(
            fontSize: 12,
            context: context,
            color: theme.primaryColor,
          ),
        ),
      ),
    );
  }
}

class MyCollectionDetailsScreen extends StatelessWidget {
  const MyCollectionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "My Collection"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                children: <Widget>[
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Hamilton',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Pop music',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Popular music',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Hip hop music',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Rhythm and blues',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Popular music',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Outcast',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '##Outcast',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Hip hop music',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Rhythm and blues',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Popular music',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Outcast',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '##Outcast',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Hip hop music',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Rhythm and blues',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Popular music',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Outcast',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '##Outcast',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Hip hop music',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Rhythm and blues',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Popular music',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Outcast',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '##Outcast',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Hip hop music',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Rhythm and blues',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Popular music',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '#Outcast',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  Chip(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    label: Text(
                      '##Outcast',
                      style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        child: CustomButton(
          borderClr: Colors.transparent,
          color1: DynamicColor.blackClr,
          color2: DynamicColor.blackClr,
          onTap: () {
            Get.toNamed(Routes.createNewTag);
          },
          text: "Add More",
        ),
      ),
    );
  }
}

class CreateNewTag extends StatelessWidget {
  const CreateNewTag({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "My Collection"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            SearchTextFields(
              controller: TextEditingController(),
            ),
            Expanded(
              child: SizedBox(
                height: Get.height / 1.4,
                child: SingleChildScrollView(
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 10,
                    children: <Widget>[
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Hamilton',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Pop music',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Popular music',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Hip hop music',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Rhythm and blues',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Popular music',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Outcast',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '##Outcast',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Hip hop music',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Rhythm and blues',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Popular music',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Outcast',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '##Outcast',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Hip hop music',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Rhythm and blues',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Popular music',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Outcast',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '##Outcast',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Hip hop music',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Rhythm and blues',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Popular music',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Outcast',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '##Outcast',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Hip hop music',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Rhythm and blues',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Popular music',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '#Outcast',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                      Chip(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: Text(
                          '##Outcast',
                          style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.scaffoldBackgroundColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: Platform.isIOS ? true : false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          child: CustomButton(
            borderClr: Colors.transparent,
            color1: DynamicColor.blackClr,
            color2: DynamicColor.blackClr,
            onTap: () {
              Get.back();
            },
            text: "Save",
          ),
        ),
      ),
    );
  }
}
