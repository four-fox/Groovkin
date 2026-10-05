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
  const ConfirmationEventScreen({super.key});

  @override
  State<ConfirmationEventScreen> createState() =>
      _ConfirmationEventScreenState();
}

class _ConfirmationEventScreenState extends State<ConfirmationEventScreen> {
  final EventController _controller = Get.find();

  num? downPayment;
  num? groovkinFee;
  num? balanceDue;
  num? totalAmount;
  num? subTotal;
  double? hoursDifference;

  double CalculateHoursFromDate() {
    final startDate = _controller.eventDateController.text.trim();
    final endDate = _controller.eventEndDateController.text.trim();
    final startClock = _controller.proposedTimeWindowsController.text.trim();
    final endClock = _controller.endTimeController.text.trim();
    if (startDate.isEmpty ||
        endDate.isEmpty ||
        startClock.isEmpty ||
        endClock.isEmpty) {
      return 0;
    }
    final start = DateFormat('dd-MM-yyyy HH:mm').parse('$startDate $startClock');
    var end = DateFormat('dd-MM-yyyy HH:mm').parse('$endDate $endClock');
    if (!end.isAfter(start)) {
      end = end.add(const Duration(days: 1));
    }
    return end.difference(start).inMinutes / 60;
  }

  @override
  void initState() {
    super.initState();

    _applyApiOrLocalPrice();
  }

  void _applyApiOrLocalPrice() {
    final detail = _controller.eventDetail?.data;
    final apiPrice = double.tryParse(
      detail?.eventPrice ?? detail?.baseAmount ?? '',
    );
    final hourly =
        (detail?.rateType ?? _controller.rateType?.value) == 'hourly';
    final rate = double.tryParse(
          detail?.rate ?? _controller.hourlyRateController.text,
        ) ??
        0;
    final apiHours = double.tryParse(detail?.durationHours ?? '');
    hoursDifference = apiHours ?? CalculateHoursFromDate();
    if (apiPrice != null) {
      subTotal = apiPrice;
    } else if (hourly) {
      subTotal = rate * (hoursDifference ?? 0);
    } else {
      subTotal = rate;
    }
    final apiTotal = double.tryParse(detail?.totalAmount ?? '');
    totalAmount = apiTotal ?? (subTotal! * 1.2);
    groovkinFee = totalAmount! - subTotal!;
    final schedulePercent =
        double.tryParse(_controller.paymentSchedule?.value ?? '0') ?? 0;
    downPayment = (subTotal! / 100) * schedulePercent;
    balanceDue = totalAmount! - downPayment!;
  }

  bool get _hourlyCalculated {
    final detail = _controller.eventDetail?.data;
    return (detail?.rateType ?? _controller.rateType?.value) == 'hourly';
  }

  @override
  Widget build(BuildContext context) {
    // print("Hours: ${hoursDifference!.toInt()}");
    var theme = Theme.of(context);
    final selectedVenue = _controller.selectedVenue;
    final detail = _controller.eventDetail?.data;
    final venueName =
        selectedVenue?.venueName ?? detail?.venue?.venueName ?? '';
    final venueLocation = selectedVenue == null
        ? (detail?.venue?.location ?? detail?.location ?? '')
        : (selectedVenue.addressLabel.isNotEmpty
            ? selectedVenue.addressLabel
            : selectedVenue.location ?? '');
    return Scaffold(
      appBar: customAppBar(
        theme: theme,
        text: "Confirmation",
        actions: [
          ((_controller.eventDetail == null) &&
                  (_controller.draftCondition.value == true))
              ? GestureDetector(
                  onTap: () {
                    _controller.postEventFunction(context, theme, draft: true);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.drafts),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // customWidget(theme: theme,context: context),
            const SizedBox(height: 10),
            Text(
              venueName,
              style: poppinsRegularStyle(
                fontSize: 14,
                context: context,
                color: theme.primaryColor,
              ),
            ),
            Text(
              venueLocation,
              style: poppinsRegularStyle(
                fontSize: 14,
                context: context,
                color: DynamicColor.grayClr.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 10),
            customWidget(
              theme: theme,
              context: context,
              title: "Date",
              value:
                  "${_controller.eventDateController.text}/${_controller.eventEndDateController.text}",
            ),
            const SizedBox(height: 10),
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
              value: _controller.proposedTimeWindowsController.text,
            ),
            const SizedBox(height: 10),
            customWidget(
              theme: theme,
              context: context,
              title: "End Time",
              value: _controller.endTimeController.text,
            ),
            const SizedBox(height: 10),
            customWidget(
              theme: theme,
              context: context,
              title: "No. hours",
              value: CalculateHoursFromDate().toStringAsFixed(2),
            ),
            const SizedBox(height: 10),
            customWidget(
              theme: theme,
              context: context,
              title: _hourlyCalculated
                  ? "Calculated event price"
                  : "Event price",
              value: "\$ ${subTotal?.toStringAsFixed(2) ?? "0.00"}",
            ),
            if (_hourlyCalculated) ...[
              const SizedBox(height: 10),
              customWidget(
                theme: theme,
                context: context,
                title: "Rate",
                value:
                    "\$ ${detail?.rate ?? _controller.hourlyRateController.text}",
              ),
              const SizedBox(height: 10),
              customWidget(
                theme: theme,
                context: context,
                title: "Duration hours",
                value: (detail?.durationHours ??
                        hoursDifference?.toStringAsFixed(2) ??
                        '')
                    .toString(),
              ),
            ],
            const SizedBox(height: 10),
            customWidget(
              theme: theme,
              context: context,
              title: "Fees (20%)",
              value: "\$${groovkinFee?.toStringAsFixed(2) ?? "0.00"}",
            ),
            const SizedBox(height: 10),
            customWidget(
              theme: theme,
              context: context,
              title: "Total",
              value: "\$${totalAmount?.toStringAsFixed(2) ?? "0.00"}",
            ),
            const SizedBox(height: 10),
            customWidget(
              theme: theme,
              context: context,
              title:
                  "Down Payment (${_controller.paymentSchedule?.value ?? "0"}%)",
              value: "\$${downPayment?.toStringAsFixed(2) ?? "0.00"}",
            ),
            const SizedBox(height: 10),
            customWidget(
              theme: theme,
              context: context,
              title: "Balance Due",
              value: "\$${balanceDue?.toStringAsFixed(2) ?? "0.00"}",
            ),
            const SizedBox(height: 10),
            Divider(color: DynamicColor.grayClr),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () {
              Get.toNamed(Routes.disclaimerScreen);
              // calcPerHour();
              // calcFlatRate();
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
