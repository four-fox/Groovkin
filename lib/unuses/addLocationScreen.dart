// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';

class AddLocationScreen extends StatelessWidget {
  AddLocationScreen({super.key});

  // ignore: unused_field, prefer_final_fields
  EventController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
        theme: theme,
        text: "Create Event",
      ),
      body: GetBuilder<EventController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
          child: Column(
            children: [
              CustomTextFields(
                textClr: theme.primaryColor,
                labelText: "Max Capacity",
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Obx(
          () => CustomButton(
            onTap: () {
              // _controller.filterCondition.value = !_controller.filterCondition.value;
            },
            // text:_controller.filterCondition.value? "Search Filter":"Continue",
          ),
        ),
      ),
    );
  }
}
