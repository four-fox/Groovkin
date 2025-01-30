// ignore_for_file: prefer_final_fields

import 'dart:io';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
// import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:groovkin/View/profile/editProfileScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:map_location_picker/map_location_picker.dart';

class UpGradeEvents extends StatefulWidget {
  UpGradeEvents({super.key});

  @override
  State<UpGradeEvents> createState() => _UpGradeEventsState();
}

class _UpGradeEventsState extends State<UpGradeEvents> {
  final format = DateFormat("HH:mm");

  String address = "null";

  String autocompletePlace = "null";

  Prediction? initialValue;

  late AuthController _authController;

  final eventForm = GlobalKey<FormState>();
  late EventController _eventController;

  String intialTime = DateFormat.jm().format(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    12,
  ));

  String intialEndTime = DateFormat.jm().format(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    24,
  ));

  @override
  void initState() {
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }

    if (Get.isRegistered<EventController>()) {
      _eventController = Get.find<EventController>();
    } else {
      _eventController = Get.put(EventController());
    }
    _eventController.proposedTimeWindowsController.text = intialTime;
    _eventController.endTimeController.text = intialEndTime;
    _eventController.postTime = intialTime;
    _eventController.postEndTime = intialEndTime;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Create Event"),
      body: GetBuilder<EventController>(builder: (controller) {
        return Form(
          key: eventForm,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                        onTap: () {
                          pictureAlert(context, cameraFtn: () {
                            _authController.cameraImage(
                                context, ImageSource.camera);
                            Get.back();
                          }, galleryFtn: () {
                            _authController.cameraImage(
                                context, ImageSource.gallery);
                            Get.back();
                          });
                        },
                        child: Obx(
                          () => ((_authController.imageLoaders.value ==
                                      false) ||
                                  (_authController.imageBytes == null))
                              ? Container(
                                  height: context.height * 0.20,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        ((controller.eventDetail != null) &&
                                                (controller.eventDetail!.data!
                                                        .bannerImage !=
                                                    null))
                                            ? BorderRadius.circular(12)
                                            : BorderRadius.circular(12),
                                    color: DynamicColor.avatarBgClr,
                                    image: ((controller.duplicateValue.value ==
                                                false) &&
                                            (controller.eventDetail != null) &&
                                            (controller.eventDetail!.data!
                                                    .bannerImage !=
                                                null))
                                        ? DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(controller
                                                .eventDetail!
                                                .data!
                                                .bannerImage!
                                                .mediaPath!))
                                        : null,
                                  ),
                                  child:
                                      ((_authController.imageBytes != null) &&
                                              ((controller.eventDetail?.data
                                                      ?.bannerImage !=
                                                  null)))
                                          ? SizedBox.shrink()
                                          : ImageIcon(
                                              AssetImage(
                                                  "assets/imageUploadIcon.png"),
                                              color: DynamicColor.yellowClr,
                                            ),
                                )
                              : Container(
                                  height: context.height * 0.20,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: DynamicColor.yellowClr,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.file(
                                      File(_authController.imageBytes!),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Upload event’s banner',
                      style: poppinsRegularStyle(
                        fontSize: 12,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    textFields(
                        theme: theme,
                        controller: controller.eventTitleController,
                        error: "event title"),
                    SizedBox(
                      height: 15,
                    ),
                    textFields(
                        theme: theme,
                        labelText: "Featuring",
                        controller: controller.featuringController,
                        error: "featuring"),
                    SizedBox(
                      height: 15,
                    ),
                    textFields(
                        theme: theme,
                        labelText: "About",
                        maxLine: 5,
                        controller: controller.aboutController,
                        error: "about"),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // textFields(
                    //     theme: theme,
                    //     labelText: "Theme of Event",
                    //     controller: controller.themeOfEventController,
                    //     error: "theme of event"),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // textFields(theme: theme,labelText: "Max capacity",
                    // controller: controller.maxCapacityController,
                    //   error: "max capacity",
                    //   keyBoardType: true
                    // ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      keyboardType: TextInputType.none,
                      style: TextStyle(
                        fontSize: 14,
                        color: DynamicColor.whiteClr,
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            builder: (context, child) {
                              return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors
                                          .white, // header background color
                                      onPrimary: Colors.black,
                                      onSecondary: Colors.white,
                                      surface: Colors.black,
                                      onSurface: Colors.white,
                                      secondary: Colors.black,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            Colors.white, // button text color
                                      ),
                                    ),
                                  ),
                                  child: child!);
                            },
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2201));
                        if (pickedDate != null) {
                          controller.eventDateController.text =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          controller.datePost =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        } else {
                          print("Date is not selected");
                        }
                      },
                      controller: controller.eventDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: DynamicColor.grayClr.withOpacity(0.6))),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: DynamicColor.grayClr.withOpacity(0.6))),
                        hintText: "Select meeting date",
                        label: Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Start Date",
                            style: TextStyle(
                              fontSize: 14,
                              color: DynamicColor.whiteClr,
                            ),
                          ),
                        ),
                        labelStyle: TextStyle(color: DynamicColor.whiteClr),
                        hintStyle:
                            TextStyle(fontFamily: 'Montserrat', fontSize: 13),
                        contentPadding: EdgeInsets.all(5),
                        suffixIcon: Icon(
                          Icons.calendar_month,
                          color: DynamicColor.whiteClr,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      keyboardType: TextInputType.none,
                      style: TextStyle(
                        fontSize: 14,
                        color: DynamicColor.whiteClr,
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            builder: (context, child) {
                              return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors
                                          .white, // header background color
                                      onPrimary: Colors.black,
                                      onSecondary: Colors.white,
                                      surface: Colors.black,
                                      onSurface: Colors.white,
                                      secondary: Colors.black,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            Colors.white, // button text color
                                      ),
                                    ),
                                  ),
                                  child: child!);
                            },
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2201));
                        if (pickedDate != null) {
                          controller.eventEndDateController.text =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          controller.endDatePost =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        } else {
                          print("Date is not selected");
                        }
                      },
                      controller: controller.eventEndDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: DynamicColor.grayClr.withOpacity(0.6))),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: DynamicColor.grayClr.withOpacity(0.6))),
                        hintText: "Select meeting date",
                        label: Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            "End Date",
                            style: TextStyle(
                              fontSize: 14,
                              color: DynamicColor.whiteClr,
                            ),
                          ),
                        ),
                        labelStyle: TextStyle(color: DynamicColor.whiteClr),
                        hintStyle:
                            TextStyle(fontFamily: 'Montserrat', fontSize: 13),
                        contentPadding: EdgeInsets.all(5),
                        suffixIcon: Icon(
                          Icons.calendar_month,
                          color: DynamicColor.whiteClr,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DateTimeField(
                      style: TextStyle(color: DynamicColor.whiteClr),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                width: 1, color: DynamicColor.grayClr)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                width: 1, color: DynamicColor.grayClr)),
                        // border: InputBorder.none,
                        label: Text(
                          'Event start time',
                          style: TextStyle(color: DynamicColor.whiteClr),
                        ),
                        labelStyle: TextStyle(
                            fontSize: 14, color: DynamicColor.whiteClr),
                        suffixIcon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.white,
                        ),
                      ),
                      controller: controller.proposedTimeWindowsController,
                      resetIcon: null,
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          initialEntryMode: TimePickerEntryMode.dial,
                          builder: (context, child) {
                            return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary:
                                        Colors.black, // header background color
                                    onPrimary:
                                        Colors.white, // header text color
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
                          controller.proposedTimeWindowsController.clear();
                          print('time>>>>>>>>>> $time');
                          final now = DateTime.now();
                          final selectedTime = DateTime(now.year, now.month,
                              now.day, time.hour, time.minute);

                          controller.proposedTimeWindowsController.text =
                              DateFormat.jm().format(selectedTime);

                          controller.postTime =
                              DateFormat("HH:mm a").format(selectedTime);
                        }
                        return;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DateTimeField(
                      style: TextStyle(color: DynamicColor.whiteClr),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                width: 1, color: DynamicColor.grayClr)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                width: 1, color: DynamicColor.grayClr)),
                        // border: InputBorder.none,
                        label: Text(
                          'Event end time',
                          style: TextStyle(color: DynamicColor.whiteClr),
                        ),
                        labelStyle: TextStyle(
                            fontSize: 14, color: DynamicColor.whiteClr),
                        suffixIcon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.white,
                        ),
                      ),
                      controller: controller.endTimeController,
                      resetIcon: null,
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          initialEntryMode: TimePickerEntryMode.dial,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
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
                              child: child!,
                            );
                          },
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                        );
                        print(
                            "selected time--------->${DateTimeField.convert(time).toString()}");
                        if (time != null) {
                          controller.endTimeController.clear();
                          print('time>>>>>>>>>> $time');
                          DateTime now = DateTime.now();
                          final selectedTime = DateTime(now.year, now.month,
                              now.day, time.hour, time.minute);

                          controller.endTimeController.text =
                              DateFormat.jm().format(selectedTime);
                          controller.postEndTime =
                              DateFormat("HH:mm a").format(selectedTime);
                          print(controller.postEndTime);
                        }
                        return;
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.rateType!.value = "hourly";
                        controller.eventRateHourly.value = 0;
                        controller.hourlyRateController.clear();
                        controller.update();
                      },
                      child: SizedBox(
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
                                    groupValue:
                                        controller.eventRateHourly.value,
                                    onChanged: (v) {
                                      controller.rateType!.value = "hourly";
                                      controller.eventRateHourly.value = v!;
                                      controller.hourlyRateController.clear();
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
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.rateType!.value = "flat";
                        controller.eventRateHourly.value = 1;
                        controller.hourlyRateController.clear();
                        controller.update();
                      },
                      child: SizedBox(
                        height: 30,
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
                                    value: 1,
                                    groupValue:
                                        controller.eventRateHourly.value,
                                    onChanged: (v) {
                                      controller.rateType!.value = "flat";
                                      controller.eventRateHourly.value = v!;
                                      controller.hourlyRateController.clear();
                                      controller.update();
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7.0),
                              child: Text(
                                "Flat Free",
                                style: poppinsRegularStyle(
                                  fontSize: 12,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    textFields(
                        theme: theme,
                        labelText:
                            "${controller.rateType!.value.capitalize} Rate",
                        keyBoardType: true,
                        error: "${controller.rateType!.value} rate",
                        controller: controller.hourlyRateController),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // textFields(theme: theme,labelText: "Select the event hour",
                    // error: "event hour",
                    //   keyBoardType: true,
                    //   controller: controller.eventHoursController,
                    // ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select the payment schedule',
                        style: poppinsRegularStyle(
                          context: context,
                          fontSize: 14,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.paymentSchedule!.value = "0";
                        controller.paymentScheduleValue.value = 0;
                        controller.update();
                      },
                      child: SizedBox(
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
                                    groupValue:
                                        controller.paymentScheduleValue.value,
                                    onChanged: (v) {
                                      controller.paymentSchedule!.value = "0";
                                      controller.paymentScheduleValue.value =
                                          v!;
                                      controller.update();
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7.0),
                              child: Text(
                                "0% Down Payment",
                                style: poppinsRegularStyle(
                                  fontSize: 12,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: 23,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: theme.primaryColor,
                                ),
                                child: Radio(
                                    activeColor: DynamicColor.yellowClr,
                                    value: 1,
                                    groupValue:
                                        controller.paymentScheduleValue.value,
                                    onChanged: (v) {
                                      controller.paymentSchedule!.value = "25";
                                      controller.paymentScheduleValue.value =
                                          v!;
                                      controller.update();
                                    }),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.paymentSchedule!.value = "25";
                                controller.paymentScheduleValue.value = 1;
                                controller.update();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 7.0),
                                child: Text(
                                  "25% Down Payment",
                                  style: poppinsRegularStyle(
                                    fontSize: 12,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.paymentSchedule!.value = "50";
                        controller.paymentScheduleValue.value = 2;
                        controller.update();
                      },
                      child: SizedBox(
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
                                    value: 2,
                                    groupValue:
                                        controller.paymentScheduleValue.value,
                                    onChanged: (v) {
                                      controller.paymentSchedule!.value = "50";
                                      controller.paymentScheduleValue.value =
                                          v!;
                                      controller.update();
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7.0),
                              child: Text(
                                "50% Down Payment",
                                style: poppinsRegularStyle(
                                  fontSize: 12,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: 23,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: theme.primaryColor,
                                ),
                                child: Radio(
                                    activeColor: DynamicColor.yellowClr,
                                    value: 3,
                                    groupValue:
                                        controller.paymentScheduleValue.value,
                                    onChanged: (v) {
                                      controller.paymentSchedule!.value = "75";
                                      controller.paymentScheduleValue.value =
                                          v!;
                                      controller.update();
                                    }),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.paymentSchedule!.value = "75";
                                controller.paymentScheduleValue.value = 3;
                                controller.update();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 7.0),
                                child: Text(
                                  "75% Down Payment",
                                  style: poppinsRegularStyle(
                                    fontSize: 12,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 40,
                    //   child: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 23,
                    //         child: Theme(
                    //           data: Theme.of(context).copyWith(
                    //             unselectedWidgetColor: theme.primaryColor,
                    //           ),
                    //           child: Radio(
                    //               activeColor: DynamicColor.yellowClr,
                    //               value: 4,
                    //               groupValue:
                    //                   controller.paymentScheduleValue.value,
                    //               onChanged: (v) {
                    //                 controller.paymentSchedule!.value = "0";
                    //                 controller.paymentScheduleValue.value =
                    //                     v!;
                    //                 controller.update();
                    //               }),
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 7.0),
                    //         child: Text(
                    //           "Other Down Payment",
                    //           style: poppinsRegularStyle(
                    //             fontSize: 12,
                    //             color: theme.primaryColor,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 15,
                    ),
                    // controller.paymentScheduleValue.value == 4
                    //     ? textFields(
                    //         theme: theme,
                    //         labelText: "Other Rate",
                    //         keyBoardType: true,
                    //         error: "Other Rate",
                    //         iconShow: true,
                    //         suffixWidget: Padding(
                    //           padding: EdgeInsets.only(left: 10, top: 8.0),
                    //           child: Text(
                    //             "%",
                    //             style: poppinsRegularStyle(
                    //                 context: context,
                    //                 fontSize: 24,
                    //                 color: DynamicColor.grayClr),
                    //           ),
                    //         ),
                    //         controller: controller.otherRateController)
                    //     : SizedBox.shrink(),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // textFields(
                    //     theme: theme,
                    //     labelText: "Payment Schedule",
                    //     keyBoardType: true,
                    //     error: "Payment Schedule",
                    //     iconShow: true,
                    //     suffixWidget: Padding(
                    //       padding: EdgeInsets.only(left: 10, top: 8.0),
                    //       child: Text(
                    //         "%",
                    //         style: poppinsRegularStyle(
                    //             context: context,
                    //             fontSize: 24,
                    //             color: DynamicColor.grayClr),
                    //       ),
                    //     ),
                    //     controller: controller.otherRateController),
                    SizedBox(
                      height: 20,
                    ),
                    SafeArea(
                      bottom: Platform.isIOS ? true : false,
                      child: CustomButton(
                        text: "Continue",
                        borderClr: Colors.transparent,
                        onTap: () {
                          if (eventForm.currentState!.validate()) {
                            if (_authController.imageBytes != null ||
                                ((controller.duplicateValue.value == false) &&
                                    (controller.eventDetail != null) &&
                                    (controller
                                            .eventDetail!.data!.bannerImage !=
                                        null) &&
                                    (controller.eventDetail!.data!.bannerImage!
                                            .mediaPath !=
                                        null))) {
                              if (controller.paymentScheduleValue.value == 4) {
                                controller.paymentSchedule!.value =
                                    controller.otherRateController.text;
                              }
                              controller.checkingTime();
                            } else {
                              bottomToast(text: "Please choose event banner");
                            }
                          }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return MapLocationPicker(
                          //         apiKey: "AIzaSyCPDZxZYp3Su6ReZTh4lHRoie6HAM2P0sU",
                          //         popOnNextButtonTaped: true,
                          //         currentLatLng: const LatLng(29.146727, 76.464895),
                          //     btnOnTap: (){
                          //           Get.toNamed(Routes.hardwareProvidedScreen);
                          //     },
                          //         onNext: (GeocodingResult? result) {
                          //           if (result != null) {
                          //               address = result.formattedAddress ?? "";
                          //           }
                          //         },
                          //         onSuggestionSelected: (PlacesDetailsResponse? result) {
                          //           if (result != null) {
                          //
                          //               autocompletePlace =
                          //                   result.result.formattedAddress ?? "";
                          //      controller.update();
                          //           }
                          //         },
                          //       );
                          //     },
                          //   ),
                          // );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget textFields(
      {theme,
      bool iconShow = false,
      Widget? suffixWidget,
      labelText,
      maxLine = 1,
      String? error,
      bool keyBoardType = false,
      String? hintText,
      TextEditingController? controller}) {
    return CustomTextFields(
      controller: controller,
      suffixWidget: suffixWidget,
      iconShow: iconShow,
      keyBoardType: keyBoardType,
      textClr: theme.primaryColor,
      labelText: labelText ?? "Event Title",
      maxLine: maxLine,
      validationError: error,
      hintText: hintText,
    );
  }
}
