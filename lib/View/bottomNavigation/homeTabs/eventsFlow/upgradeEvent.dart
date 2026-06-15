// ignore_for_file: prefer_final_fields

import 'dart:io';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class UpGradeEvents extends StatefulWidget {
  const UpGradeEvents({super.key});

  @override
  State<UpGradeEvents> createState() => _UpGradeEventsState();
}

class _UpGradeEventsState extends State<UpGradeEvents> {
  // ─── Constants ────────────────────────────────────────────────────────────
  static final _timeFormat = DateFormat('HH:mm');
  static final _displayDateFormat = DateFormat('dd-MM-yyyy');
  static final _postDateFormat = DateFormat('yyyy-MM-dd');
  static final _displayTimeFormat = DateFormat.jm();
  static final _postTimeFormat = DateFormat('HH:mm a');

  // ─── Controllers ──────────────────────────────────────────────────────────
  final _eventForm = GlobalKey<FormState>();
  late final AuthController _authController;
  late final EventController _eventController;

  // ─── Initial time strings ─────────────────────────────────────────────────
  late final String _initialTime;
  late final String _initialEndTime;

  @override
  void initState() {
    super.initState();

    _authController = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());

    _eventController = Get.isRegistered<EventController>()
        ? Get.find<EventController>()
        : Get.put(EventController());

    final now = DateTime.now();
    _initialTime = _displayTimeFormat.format(
      DateTime(now.year, now.month, now.day, 12),
    );
    _initialEndTime = _displayTimeFormat.format(
      DateTime(now.year, now.month, now.day, 24),
    );

    if (_eventController.proposedTimeWindowsController.text.isEmpty) {
      _eventController.proposedTimeWindowsController.text = _initialTime;
    }
    if (_eventController.endTimeController.text.isEmpty) {
      _eventController.endTimeController.text = _initialEndTime;
    }

    _eventController.postTime = _initialTime;
    _eventController.postEndTime = _initialEndTime;

    if (_eventController.downPaymentController.text.isEmpty) {
      _eventController.downPaymentController.text =
          _eventController.paymentSchedule!.value;
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Validates start/end date-time and returns true if we can proceed.
  bool? _canCreateEvent({
    required String? startDate,
    required String? endDate,
    required String? startTime,
    required String? endTime,
  }) {
    if ((startDate ?? '').isEmpty ||
        (endDate ?? '').isEmpty ||
        (startTime ?? '').isEmpty ||
        (endTime ?? '').isEmpty) {
      bottomToast(text: 'Field Required!');
      return null;
    }

    final fmt = DateFormat('yyyy-MM-dd h:mm a');
    final start =
    fmt.parse('$startDate ${startTime!.replaceAll(RegExp(r'\s+'), ' ').trim()}');
    final end =
    fmt.parse('$endDate ${endTime!.replaceAll(RegExp(r'\s+'), ' ').trim()}');
    final now = DateTime.now();

    if (now.isAfter(start) && now.isBefore(end)) {
      bottomToast(text: 'Event is already running!');
      return false;
    }

    return true;
  }

  void _onBack() {
    _eventController
      ..duplicateValue.value = false
      ..showEditPreviewScreen.value = false
      ..update();
    _authController
      ..imageBytes = null
      ..update();
    Get.back();
  }

  /// Opens a styled date picker and returns the picked [DateTime] or null.
  Future<DateTime?> _pickDate(BuildContext context) =>
      showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2201),
        builder: (ctx, child) => Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.white,
              onPrimary: Colors.black,
              onSecondary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
              secondary: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
            ),
          ),
          child: child!,
        ),
      );

  /// Opens a styled time picker and returns the picked [TimeOfDay] or null.
  Future<TimeOfDay?> _pickTime(BuildContext context) =>
      showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.dial,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
        builder: (ctx, child) => Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ),
          child: child!,
        ),
      );

  void _onContinue(EventController controller) {
    if (!_eventForm.currentState!.validate()) return;

    final hasBanner = _authController.imageBytes != null ||
        (controller.duplicateValue.value == false &&
            controller.eventDetail?.data?.bannerImage?.mediaPath != null);

    if (!hasBanner) {
      bottomToast(text: 'Please choose event banner');
      return;
    }

    if (controller.paymentScheduleValue.value == 4) {
      controller.paymentSchedule!.value = controller.otherRateController.text;
    }

    final start = controller.eventDateController.text.trim();
    final end = controller.eventEndDateController.text.trim();

    if (start.isEmpty || end.isEmpty) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = _displayDateFormat.parse(start);
    final endDate = _displayDateFormat.parse(end);

    if (startDate.isBefore(today) || endDate.isBefore(today)) {
      bottomToast(text: 'Past dates are not allowed');
    } else {
      controller.checkingTime();
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: customAppBar(
        theme: theme,
        text: 'Create Event',
        onTap: _onBack,
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _onBack();
        },
        child: GetBuilder<EventController>(
          builder: (controller) => Form(
            key: _eventForm,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    _BannerPicker(
                      authController: _authController,
                      eventController: controller,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Upload event's banner",
                      style: poppinsRegularStyle(
                        fontSize: 12,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Text fields ─────────────────────────────────────────
                    _buildTextField(
                      theme: theme,
                      controller: controller.eventTitleController,
                      error: 'event title',
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      theme: theme,
                      labelText: 'Featuring',
                      controller: controller.featuringController,
                      error: 'featuring',
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      theme: theme,
                      labelText: 'About',
                      maxLine: 5,
                      controller: controller.aboutController,
                      error: 'about',
                    ),
                    const SizedBox(height: 15),

                    // ── Start date ──────────────────────────────────────────
                    _DateField(
                      controller: controller.eventDateController,
                      label: 'Start Date',
                      validator: (v) =>
                      (v == null || v.isEmpty) ? 'Please enter start date' : null,
                      onPick: () async {
                        final picked = await _pickDate(context);
                        if (picked != null) {
                          controller.eventDateController.text =
                              _displayDateFormat.format(picked);
                          controller.datePost = _postDateFormat.format(picked);
                        }
                      },
                    ),
                    const SizedBox(height: 15),

                    // ── End date ────────────────────────────────────────────
                    _DateField(
                      controller: controller.eventEndDateController,
                      label: 'End Date',
                      validator: (v) =>
                      (v == null || v.isEmpty) ? 'Please enter end date' : null,
                      onPick: () async {
                        final picked = await _pickDate(context);
                        if (picked != null) {
                          controller.eventEndDateController.text =
                              _displayDateFormat.format(picked);
                          controller.endDatePost = _postDateFormat.format(picked);
                        }
                      },
                    ),
                    const SizedBox(height: 15),

                    // ── Start time ──────────────────────────────────────────
                    _TimeField(
                      label: 'Event start time',
                      controller: controller.proposedTimeWindowsController,
                      format: _timeFormat,
                      onPick: () async {
                        final time = await _pickTime(context);
                        if (time != null) {
                          final selected = _timeOfDayToDateTime(time);
                          controller.proposedTimeWindowsController.text =
                              _displayTimeFormat.format(selected);
                          controller.postTime = _postTimeFormat.format(selected);
                        }
                      },
                    ),
                    const SizedBox(height: 15),

                    // ── End time ────────────────────────────────────────────
                    _TimeField(
                      label: 'Event end time',
                      controller: controller.endTimeController,
                      format: _timeFormat,
                      onPick: () async {
                        final time = await _pickTime(context);
                        if (time != null) {
                          final selected = _timeOfDayToDateTime(time);
                          controller.endTimeController.text =
                              _displayTimeFormat.format(selected);
                          controller.postEndTime = _postTimeFormat.format(selected);
                        }
                      },
                    ),

                    // ── Rate type radio ─────────────────────────────────────
                    _RateRadio(
                      theme: theme,
                      controller: controller,
                      context: context,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      theme: theme,
                      labelText:
                      '${controller.rateType!.value.capitalize} Rate',
                      keyBoardType: true,
                      error: '${controller.rateType!.value} rate',
                      controller: controller.hourlyRateController,
                    ),
                    const SizedBox(height: 15),

                    // ── Payment schedule ────────────────────────────────────
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
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 3,
                          child: CustomTextFields(
                            controller: controller.downPaymentController,
                            keyBoardType: true,
                            isOptional: true,
                            labelText: 'Value',
                            hintText: '0',
                            textClr: theme.primaryColor,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              controller.paymentSchedule!.value =
                              value.isEmpty ? '0' : value;
                              controller.update();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          flex: 6,
                          child: Text(
                            '% down payment',
                            style: poppinsRegularStyle(
                              context: context,
                              fontSize: 12,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Continue button ─────────────────────────────────────
                    SafeArea(
                      bottom: true,
                      child: CustomButton(
                        text: 'Continue',
                        borderClr: Colors.transparent,
                        onTap: () => _onContinue(controller),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Widget helpers ────────────────────────────────────────────────────────

  Widget _buildTextField({
    required ThemeData theme,
    bool iconShow = false,
    Widget? suffixWidget,
    String? labelText,
    int maxLine = 1,
    String? error,
    bool keyBoardType = false,
    String? hintText,
    TextEditingController? controller,
  }) {
    return CustomTextFields(
      controller: controller,
      suffixWidget: suffixWidget,
      iconShow: iconShow,
      keyBoardType: keyBoardType,
      textClr: theme.primaryColor,
      labelText: labelText ?? 'Event Title',
      maxLine: maxLine,
      validationError: error,
      hintText: hintText,
    );
  }

  DateTime _timeOfDayToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Banner image picker area.
class _BannerPicker extends StatelessWidget {
  const _BannerPicker({
    required this.authController,
    required this.eventController,
  });

  final AuthController authController;
  final EventController eventController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pictureAlert(
          context,
          cameraFtn: () {
            authController.cameraImage(context, ImageSource.camera,
                type: 'event');
            Get.back();
          },
          galleryFtn: () {
            authController.cameraImage(context, ImageSource.gallery,
                type: 'event');
            Get.back();
          },
        );
      },
      child: Obx(() {
        final hasFile = authController.imageLoaders.value == true &&
            authController.imageBytes != null;

        if (hasFile) {
          return Container(
            height: context.height * 0.50,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: DynamicColor.yellowClr),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Image.file(
                  File(authController.imageBytes!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }

        final networkImage =
        (eventController.duplicateValue.value == false &&
            eventController.eventDetail?.data?.bannerImage?.mediaPath !=
                null)
            ? DecorationImage(
          image: NetworkImage(
            eventController.eventDetail!.data!.bannerImage!
                .mediaPath!,
          ),
        )
            : null;

        return Container(
          height: context.height * 0.40,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: DynamicColor.avatarBgClr,
            image: networkImage,
          ),
          child: (authController.imageBytes != null &&
              eventController.eventDetail?.data?.bannerImage != null)
              ? const SizedBox.shrink()
              : ImageIcon(
            const AssetImage('assets/imageUploadIcon.png'),
            color: DynamicColor.yellowClr,
          ),
        );
      }),
    );
  }
}

/// Reusable read-only date field with a calendar icon.
class _DateField extends StatelessWidget {
  const _DateField({
    required this.controller,
    required this.label,
    required this.validator,
    required this.onPick,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String> validator;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      keyboardType: TextInputType.none,
      validator: validator,
      style: TextStyle(fontSize: 14, color: DynamicColor.whiteClr),
      onTap: onPick,
      decoration: _dateDecoration(label),
    );
  }

  InputDecoration _dateDecoration(String labelText) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:
      BorderSide(color: DynamicColor.grayClr.withValues(alpha: 0.6)),
    );
    return InputDecoration(
      focusedBorder: border,
      border: border,
      hintText: 'Select Date',
      label: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          labelText,
          style: TextStyle(fontSize: 14, color: DynamicColor.whiteClr),
        ),
      ),
      labelStyle: TextStyle(color: DynamicColor.whiteClr),
      hintStyle: const TextStyle(fontFamily: 'Montserrat', fontSize: 13),
      contentPadding: const EdgeInsets.all(5),
      suffixIcon: Icon(Icons.calendar_month, color: DynamicColor.whiteClr),
    );
  }
}

/// Reusable time picker field backed by [DateTimeField].
class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.controller,
    required this.format,
    required this.onPick,
  });

  final String label;
  final TextEditingController controller;
  final DateFormat format;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(width: 1, color: DynamicColor.grayClr),
    );

    return DateTimeField(
      style: TextStyle(color: DynamicColor.whiteClr),
      controller: controller,
      resetIcon: null,
      format: format,
      decoration: InputDecoration(
        focusedBorder: border,
        border: border,
        label: Text(
          label,
          style: TextStyle(color: DynamicColor.whiteClr),
        ),
        labelStyle:
        TextStyle(fontSize: 14, color: DynamicColor.whiteClr),
        suffixIcon: const Icon(Icons.access_time_rounded, color: Colors.white),
      ),
      // onShowPicker is required by DateTimeField but the actual picking is
      // delegated to [onPick] via the suffixIcon / field tap.
      onShowPicker: (_, __) async {
        onPick();
        return null;
      },
    );
  }
}

/// Hourly / flat-fee radio group.
class _RateRadio extends StatelessWidget {
  const _RateRadio({
    required this.theme,
    required this.controller,
    required this.context,
  });

  final ThemeData theme;
  final EventController controller;
  final BuildContext context;

  void _select(String type, int value) {
    controller.rateType!.value = type;
    controller.eventRateHourly.value = value;
    controller.hourlyRateController.clear();
    controller.update();
  }

  @override
  Widget build(BuildContext _) {
    return Column(
      children: [
        _radioRow(label: 'Hourly Rate', value: 0, type: 'hourly', height: 40),
        _radioRow(label: 'Flat Fee', value: 1, type: 'flat', height: 30),
      ],
    );
  }

  Widget _radioRow({
    required String label,
    required int value,
    required String type,
    required double height,
  }) {
    return GestureDetector(
      onTap: () => _select(type, value),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            SizedBox(
              width: 23,
              child: Theme(
                data: ThemeData(unselectedWidgetColor: theme.primaryColor),
                child: Radio<int>(
                  activeColor: DynamicColor.yellowClr,
                  value: value,
                  groupValue: controller.eventRateHourly.value,
                  onChanged: (_) => _select(type, value),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Text(
                label,
                style: poppinsRegularStyle(
                  fontSize: 12,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}