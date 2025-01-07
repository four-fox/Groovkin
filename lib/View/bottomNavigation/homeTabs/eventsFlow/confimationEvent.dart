import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:intl/intl.dart';

class ConfirmationEventScreen extends StatefulWidget {
  ConfirmationEventScreen({super.key});

  @override
  State<ConfirmationEventScreen> createState() =>
      _ConfirmationEventScreenState();
}

class _ConfirmationEventScreenState extends State<ConfirmationEventScreen> {
  EventController _controller = Get.find();

  num? downPayment;
  num? tax;
  num? groovkinTax;
  num? stripeTax;
  num? balanceDue;
  num? subTotalWithText;
  num? subTotal;
  double? hoursDifference;

  @override
  void initState() {
    super.initState();
    if (_controller.datePost != null &&
        _controller.postTime != null &&
        _controller.endDatePost != null &&
        _controller.postEndTime != null) {
      String startStr = '${_controller.datePost} ${_controller.postTime}';
      String endStr = '${_controller.endDatePost} ${_controller.postEndTime}';
      DateTime startDt = DateTime.parse(startStr);
      DateTime endDt = DateTime.parse(endStr);
      Duration difference = endDt.difference(startDt);
      hoursDifference = difference.inSeconds / 3600;
      if (_controller.rateType!.value == "hourly") {
        subTotal = double.parse(_controller.hourlyRateController.text) *
            hoursDifference!;
        double tempDownPayment = (subTotal! *
            (double.parse(_controller.paymentSchedule!.value) / 100));
        stripeTax = 0.10 * subTotal!;
        groovkinTax = 0.05 * subTotal!;
        subTotalWithText = subTotal! + (0.20 * subTotal!);
        tax = 0.05 * subTotal!;
        downPayment = tempDownPayment + (0.20 * subTotal!);
        balanceDue = subTotalWithText! - downPayment!;
      } else {
        subTotal = double.parse(_controller.hourlyRateController.text);
        double tempDownPayment = (subTotal! *
            (double.parse(_controller.paymentSchedule!.value) / 100));
        stripeTax = 0.10 * subTotal!;
        groovkinTax = 0.05 * subTotal!;
        subTotalWithText = subTotal! + (0.20 * subTotal!);
        tax = 0.05 * subTotal!;
        downPayment = tempDownPayment + (0.20 * subTotal!);
        balanceDue = subTotalWithText! - downPayment!;
      }
    }
  }

  // AuthController _authController = Get.find();
  @override
  Widget build(BuildContext context) {
    print("Hours: ${hoursDifference!.toInt()}");
    var theme = Theme.of(context);
    return SafeArea(
      top: false,
      bottom: Platform.isIOS ? true : false,
      child: Scaffold(
        appBar: customAppBar(theme: theme, text: "Confirmation", actions: [
          ((_controller.eventDetail == null) &&
                  (_controller.draftCondition.value == true))
              ? GestureDetector(
                  onTap: () {
                    _controller.postEventFunction(context, theme, draft: true);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.drafts),
                  ),
                )
              : SizedBox.shrink()
        ]),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              // customWidget(theme: theme,context: context),
              SizedBox(
                height: 10,
              ),
              Text(
                ((_controller.eventDetail != null) &&
                        (_controller.eventDetail!.data!.venue != null))
                    ? _controller.eventDetail!.data!.venue!.venueName!
                    : _controller.venuesDetails!.venueName!,
                style: poppinsRegularStyle(
                  fontSize: 14,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
              Text(
                ((_controller.eventDetail != null) &&
                        (_controller.eventDetail!.data!.venue != null))
                    ? _controller.eventDetail!.data!.venue!.location!
                    : _controller.venuesDetails!.location!,
                style: poppinsRegularStyle(
                    fontSize: 14,
                    context: context,
                    color: DynamicColor.grayClr.withOpacity(0.7)),
              ),
              SizedBox(
                height: 10,
              ),
              customWidget(
                  theme: theme,
                  context: context,
                  title: "Date",
                  value: _controller.eventDateController.text),
              SizedBox(
                height: 10,
              ),
              // customWidget(
              //     theme: theme,
              //     context: context,
              //     title: "Time",
              //     value: _controller.proposedTimeWindowsController.text),
              // SizedBox(
              //   height: 10,
              // ),
              customWidget(
                  theme: theme,
                  context: context,
                  title: "Start Time",
                  value: _controller.proposedTimeWindowsController.text),
              SizedBox(
                height: 10,
              ),
              customWidget(
                  theme: theme,
                  context: context,
                  title: "End Time",
                  value: _controller.endTimeController.text),
              SizedBox(
                height: 10,
              ),
              customWidget(
                  theme: theme,
                  context: context,
                  title: "No. hours",
                  value: hoursDifference?.toStringAsFixed(2)),
              SizedBox(
                height: 10,
              ),
              customWidget(
                  theme: theme,
                  context: context,
                  title: "Subtotal",
                  value: "\$ ${subTotal?.toStringAsFixed(2)}"),
              SizedBox(
                height: 10,
              ),

              customWidget(
                  theme: theme,
                  context: context,
                  title: "Tax (5%) ",
                  value: "\$${tax?.toStringAsFixed(2)}"),
              SizedBox(
                height: 10,
              ),
              customWidget(
                  theme: theme,
                  context: context,
                  title: "Groovkin Tax(5%)",
                  value: "\$${groovkinTax?.toStringAsFixed(2)}"),
              SizedBox(
                height: 10,
              ),
              customWidget(
                  theme: theme,
                  context: context,
                  title: "Stripe Tax(10%)",
                  value: "\$${stripeTax?.toStringAsFixed(2)}"),
              SizedBox(
                height: 10,
              ),
              customWidget(
                  theme: theme,
                  context: context,
                  title: "Down Payment Inc. Tax",
                  value: "\$${downPayment?.toStringAsFixed(2)}"),
              SizedBox(
                height: 10,
              ),
              customWidget(
                  theme: theme,
                  context: context,
                  title: "Balance Due",
                  value: "\$${balanceDue?.toStringAsFixed(2)}"),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: DynamicColor.grayClr,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () {
              Get.toNamed(Routes.disclaimerScreen);
            },
            text: "Next",
          ),
        ),
      ),
    );
  }

  Widget customWidget({context, theme, title, value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title ?? "Invoice Number",
          style: poppinsRegularStyle(
            fontSize: 16,
            context: context,
            color: theme.primaryColor,
          ),
        ),
        Text(
          value ?? "# SB-001598",
          style: poppinsRegularStyle(
            fontSize: 14,
            context: context,
            color: theme.primaryColor,
          ),
        ),
      ],
    );
  }
}
