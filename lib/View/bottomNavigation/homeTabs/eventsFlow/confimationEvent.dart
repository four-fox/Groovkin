import 'dart:developer';

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
  DateFormat format = DateFormat("yyyy-MM-dd");
  DateFormat timeFormat = DateFormat("hh:mm a");

  double CalculateHoursFromDate() {
    String startDate = _controller.eventDateController.text;
    String endDate = _controller.eventEndDateController.text;

    String time =
        _controller.proposedTimeWindowsController.text.toString().trim();
    List<String> parts = time.split(RegExp(r'\s+'));

    DateTime dt1 = DateFormat("dd-MM-yyyy hh:mm a")
        .parse("${startDate} ${parts.first} ${parts.last}");

    String time2 = _controller.endTimeController.text.toString().trim();
    List<String> parts2 = time2.split(RegExp(r'\s+'));
    print(parts2);
    DateTime dt2 = DateFormat("dd-MM-yyyy hh:mm a")
        .parse("${endDate} ${parts2.first} ${parts2.last}");

    log("String time ${_controller.proposedTimeWindowsController.text}");
    log("First Date ${dt1.millisecondsSinceEpoch}");
    log("Second Date ${dt2}");

    Duration diff = dt2.difference(dt1);
    double totalHours = diff.inMinutes / 60;

    return totalHours;
  }

  @override
  void initState() {
    super.initState();

    if (_controller.datePost != null &&
        _controller.postTime != null &&
        _controller.endDatePost != null &&
        _controller.postEndTime != null) {
      // String startStr = '${_controller.datePost} ${_controller.postTime}';
      // String endStr = '${_controller.endDatePost} ${_controller.postEndTime}';
      String startStr = '${_controller.datePost} ';
      String endStr = '${_controller.endDatePost} ';
      String startTi = _controller.postTime!;
      String endTi = _controller.postEndTime!;

      // Normalize the input string by replacing non-breaking spaces with regular spaces
      startStr = startStr.replaceAll('\u202F', ' ');
      endStr = endStr.replaceAll('\u202F', ' ');
      startTi = startTi.replaceAll('\u202F', ' ').trim();
      endTi = endTi.replaceAll('\u202F', ' ').trim();
      // Parse start and end times
      DateTime startTime = timeFormat.parse(startTi);
      DateTime endTime = timeFormat.parse(endTi);
      DateTime startDt = format.parse(startStr);
      DateTime endDt = format.parse(endStr);
      // Check if the end time is earlier than the start time (indicating it is the next day)
      if (endTime.isBefore(startTime)) {
        // If so, add 1 day to the end time
        endTime = endTime.add(Duration(days: 1));
      }

      Duration difference = endTime.difference(startTime);
      double dailyHours =
          difference.inHours + (difference.inMinutes % 60) / 60.0;

      // Calculate total days
      int totalDays = endDt.difference(startDt).inDays;

      // Total hours across all days
      double totalHours = dailyHours * totalDays;
      hoursDifference = totalHours;
      if (_controller.rateType!.value == "hourly") {
        subTotal = (double.tryParse(_controller.hourlyRateController.text)) ??
            0 * hoursDifference!;
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
    return Scaffold(
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
                value:
                    "${_controller.eventDateController.text}/${_controller.eventEndDateController.text}"),
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
                value: CalculateHoursFromDate().toString()),
            SizedBox(
              height: 10,
            ),
            customWidget(
                theme: theme,
                context: context,
                title: "Subtotal",
                value:
                    "\$ ${(double.parse(_controller.hourlyRateController.text) * CalculateHoursFromDate() )}"),
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
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
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
