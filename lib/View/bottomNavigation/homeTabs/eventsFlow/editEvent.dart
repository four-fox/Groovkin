import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:intl/intl.dart';

class EditEventScreen extends StatelessWidget {
  EditEventScreen({super.key});
  final format = DateFormat("HH:mm");
  final EventController _controller = Get.find();
  int eventId = Get.arguments['eventId'];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
        theme: theme,
        text: "Changes",
      ),
      body: GetBuilder<EventController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "Reschedule",
                    style: poppinsRegularStyle(
                      fontSize: 18,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  keyboardType: TextInputType.none,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        builder: (context, child) {
                          return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: DynamicColor.blackClr,
                                  onPrimary: DynamicColor.whiteClr,
                                  onSurface: Colors.grey,
                                ),
                              ),
                              child: child!);
                        },
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101));
                    if (pickedDate != null) {
                      controller.eventDateController.text =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      controller.datePost =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    } else {
                      print("Date is not selected");
                    }
                  },
                  readOnly: true,
                  controller: controller.eventDateController,
                  style: poppinsRegularStyle(
                    fontSize: 14,
                    color: DynamicColor.whiteClr,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(width: 1, color: DynamicColor.grayClr)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(width: 1, color: DynamicColor.grayClr)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: DynamicColor.grayClr), //<-- SEE HERE
                    ),
                    hintText: "Select meeting date",
                    label: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        "Proposed Date",
                        style: poppinsRegularStyle(
                          fontSize: 14,
                          color: DynamicColor.whiteClr,
                        ),
                      ),
                    ),
                    labelStyle: TextStyle(color: DynamicColor.grayClr),
                    hintStyle: const TextStyle(
                        fontFamily: 'poppinsRegular', fontSize: 13),
                    contentPadding: const EdgeInsets.all(5),
                    suffixIcon: Icon(
                      Icons.calendar_month,
                      color: DynamicColor.whiteClr,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                TextField(
                  keyboardType: TextInputType.none,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        builder: (context, child) {
                          return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: DynamicColor.blackClr,
                                  onPrimary: DynamicColor.whiteClr,
                                  onSurface: Colors.grey,
                                ),
                              ),
                              child: child!);
                        },
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101));
                    if (pickedDate != null) {
                      controller.eventEndDateController.text =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      controller.endDatePost =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    } else {
                      print("Date is not selected");
                    }
                  },
                  readOnly: true,
                  controller: controller.eventEndDateController,
                  style: poppinsRegularStyle(
                    fontSize: 14,
                    color: DynamicColor.whiteClr,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(width: 1, color: DynamicColor.grayClr)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(width: 1, color: DynamicColor.grayClr)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: DynamicColor.grayClr), //<-- SEE HERE
                    ),
                    hintText: "Select meeting date",
                    label: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        "Proposed New Date",
                        style: poppinsRegularStyle(
                          fontSize: 14,
                          color: DynamicColor.whiteClr,
                        ),
                      ),
                    ),
                    labelStyle: TextStyle(color: DynamicColor.grayClr),
                    hintStyle: const TextStyle(
                        fontFamily: 'poppinsRegular', fontSize: 13),
                    contentPadding: const EdgeInsets.all(5),
                    suffixIcon: Icon(
                      Icons.calendar_month,
                      color: DynamicColor.whiteClr,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                DateTimeField(
                  style: TextStyle(color: DynamicColor.whiteClr),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(width: 1, color: DynamicColor.grayClr)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(width: 1, color: DynamicColor.grayClr)),
                    // border: InputBorder.none,
                    label: Text(
                      'Event start time',
                      style: TextStyle(color: DynamicColor.whiteClr),
                    ),
                    labelStyle:
                        TextStyle(fontSize: 14, color: DynamicColor.whiteClr),
                    suffixIcon: const Icon(
                      Icons.access_time_rounded,
                      color: Colors.white,
                    ),
                  ),
                  controller: controller.proposedTimeWindowsController,
                  resetIcon: null,
                  format: format,
                  onShowPicker: (context, currentValue) async {
                    controller.proposedTimeWindowsController.clear();
                    final time = await showTimePicker(
                      initialEntryMode: TimePickerEntryMode.dial,
                      builder: (context, child) {
                        return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary:
                                    Colors.black, // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface: Colors.black, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Colors.red, // button text color
                                ),
                              ),
                            ),
                            child: child!);
                      },
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                    );
                    print(
                        "selected time--------->${DateTimeField.convert(time).toString()}");
                    if (time != null) {
                      print('time>>>>>>>>>> $time');
                      // var format = DateFormat("HH:mm ss");
                      controller.proposedTimeWindowsController.text =
                          DateFormat.jm().format(DateFormat("hh:mm:ss").parse(
                              DateTimeField.convert(time)
                                  .toString()
                                  .replaceRange(0, 11, "")));
                      controller.postTime = DateFormat("HH:mm")
                          .parse(controller.proposedTimeWindowsController.text)
                          .toString()
                          .replaceRange(0, 11, "")
                          .split(".")[0];
                      print(controller.postTime);
                    }
                    return;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                DateTimeField(
                  style: TextStyle(color: DynamicColor.whiteClr),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(width: 1, color: DynamicColor.grayClr)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(width: 1, color: DynamicColor.grayClr)),
                    // border: InputBorder.none,
                    label: Text(
                      'Event end time',
                      style: TextStyle(color: DynamicColor.whiteClr),
                    ),
                    labelStyle:
                        TextStyle(fontSize: 14, color: DynamicColor.whiteClr),
                    suffixIcon: const Icon(
                      Icons.access_time_rounded,
                      color: Colors.white,
                    ),
                  ),
                  controller: controller.endTimeController,
                  resetIcon: null,
                  format: format,
                  onShowPicker: (context, currentValue) async {
                    controller.endTimeController.clear();
                    final time = await showTimePicker(
                      initialEntryMode: TimePickerEntryMode.dial,
                      builder: (context, child) {
                        return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary:
                                    Colors.black, // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface: Colors.black, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Colors.red, // button text color
                                ),
                              ),
                            ),
                            child: child!);
                      },
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                    );
                    print(
                        "selected time--------->${DateTimeField.convert(time).toString()}");
                    if (time != null) {
                      print('time>>>>>>>>>> $time');
                      controller.endTimeController.text = DateFormat.jm()
                          .format(DateFormat("hh:mm:ss").parse(
                              DateTimeField.convert(time)
                                  .toString()
                                  .replaceRange(0, 11, "")));
                      controller.postEndTime = DateFormat("HH:mm")
                          .parse(controller.endTimeController.text)
                          .toString()
                          .replaceRange(0, 11, "")
                          .split(".")[0];
                      print(controller.postEndTime);
                    }
                    return;
                  },
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 23,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: theme.primaryColor,
                          ),
                          child: Radio(
                              activeColor: DynamicColor.yellowClr,
                              value: 0,
                              groupValue: controller.eventRateHourly.value,
                              onChanged: (v) {
                                controller.rateType!.value = "hourly";
                                controller.eventRateHourly.value = v!;
                                controller.update();
                              }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: Text(
                          "Hourly Rate",
                          style: poppinsRegularStyle(
                            fontSize: 12,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // CustomTextFields(
                //   labelText: "Propose New Date",
                //     suffixIcon: Icons.calendar_month,
                //     iconShow: true
                // ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Description',
                  style: poppinsRegularStyle(
                    fontSize: 16,
                    color: theme.primaryColor,
                    context: context,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextFieldsHintText(
                  maxLine: 6,
                  controller: controller.rescheduleDescriptionController,
                  borderClr: DynamicColor.grayClr.withValues(alpha: 0.5),
                  hintText: "write here...",
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () {
              _controller.eventPostponed(eventId: eventId);
              // Get.toNamed(Routes.disclaimerScreen);
            },
            text: "Send",
          ),
        ),
      ),
    );
  }
}
