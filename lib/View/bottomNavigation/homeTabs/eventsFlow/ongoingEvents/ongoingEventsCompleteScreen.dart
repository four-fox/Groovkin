// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userEventDetailsModel.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';

import '../../../../../Components/colors.dart';

class CompleteOnGoingEventsScreen extends StatelessWidget {
  CompleteOnGoingEventsScreen({super.key});

  EventDetails? eventDetails = Get.arguments['eventData'];
  final EventController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Complete Event"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Review',
                style: poppinsRegularStyle(
                  fontSize: 16,
                  color: theme.primaryColor,
                  context: context,
                ),
              ),
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              unratedColor: Colors.grey,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _controller.ratingValue = rating.toString();
                print(rating);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Description',
                style: poppinsRegularStyle(
                  fontSize: 16,
                  color: theme.primaryColor,
                  context: context,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            CustomTextFieldsHintText(
              maxLine: 6,
              controller: _controller.ratingDescriptionController,
              borderClr: DynamicColor.grayClr.withValues(alpha:0.5),
              hintText: "write here...",
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () {
              _controller.completeEvent(eventDetails: eventDetails);
              // Get.toNamed(Routes.disclaimerScreen);
            },
            text: "Send",
          ),
        ),
      ),
    );
  }
}
