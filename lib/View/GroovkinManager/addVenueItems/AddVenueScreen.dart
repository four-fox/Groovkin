import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:intl/intl.dart';

class AddVenueScreen extends StatelessWidget {
  AddVenueScreen({super.key});

  final venueForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final DateFormat timeFormat = DateFormat('hh:mm a');
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Add Venue"),
      body: GetBuilder<ManagerController>(builder: (controller) {
        print(
            controller.venueDetails!.data!.venueProperty!.closingHours!.trim());
        return Form(
            key: venueForm,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Add Info about this Propery!",
                      style: poppinsMediumStyle(
                          fontSize: 18,
                          color: theme.primaryColor,
                          context: context),
                    ),
                    Text(
                      'Please fill this form carefully.',
                      style: poppinsRegularStyle(
                          fontSize: 12,
                          context: context,
                          color: DynamicColor.lightRedClr),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFields(
                      labelText: "Max Occupancy",
                      controller: controller.maxOccupancyController,
                      validationError: "max occupancy",
                      keyBoardType: true,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFields(
                      labelText: "Max seating",
                      controller: controller.maxSeatingController,
                      validationError: "max seating",
                      keyBoardType: true,
                    ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // CustomTextFields(
                    //   labelText: "Max hour",
                    //   controller: controller.maxHourController,
                    //   validationError: "max hour",
                    //   keyBoardType: true,
                    // ),

                    const SizedBox(
                      height: 15,
                    ),
                    DateTimeField(
                      validator: (value) {
                        if (value == null) {
                          return "opening hours is required";
                        }
                        return null;
                      },
                      initialValue: DateFormat('hh:mm')
                          .parse(controller.openingHoursController.text),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: DynamicColor.grayClr
                                    .withValues(alpha: 0.6))),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: DynamicColor.grayClr
                                    .withValues(alpha: 0.6))),
                        // border: InputBorder.none,
                        label: Text(
                          'Opening hours',
                          style: poppinsRegularStyle(
                              context: context,
                              fontSize: 14,
                              color: DynamicColor.grayClr),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: DynamicColor.whiteClr,
                        ),
                        suffixIcon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: DynamicColor.whiteClr,
                        ),
                      ),
                      controller: controller.openingHoursController,
                      format: controller.format,
                      style: poppinsRegularStyle(
                          context: context,
                          fontSize: 14,
                          color: DynamicColor.grayClr),
                      resetIcon: null,
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          initialEntryMode: TimePickerEntryMode.dial,
                          builder: (context, child) {
                            return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: DynamicColor.secondaryClr,
                                    // <-- SEE HERE
                                    onPrimary: DynamicColor.whiteClr,
                                    // <-- SEE HERE
                                    onSurface: Colors.black, // <-- SEE HERE
                                  ),
                                ),
                                child: child!);
                          },
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                        );
                        if (time != null) {
                          DateTime selectedDateTime = DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            time.hour,
                            time.minute,
                          );
                          controller.openingHoursController.text =
                              DateFormat.jm().format(selectedDateTime);
                        }
                        return;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    DateTimeField(
                      validator: (value) {
                        if (value == null) {
                          return "Closing hours is required";
                        }
                        return null;
                      },
                      // initialValue: DateTime.now(),
                      initialValue: DateFormat('hh:mm')
                          .parse(controller.closedHoursController.text),
                      // controller.closedHoursController.text.isNotEmpty
                      //     ? timeFormat.parse(
                      //         controller.closedHoursController.toString())
                      //     : null,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: DynamicColor.grayClr
                                    .withValues(alpha: 0.6))),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: DynamicColor.grayClr
                                    .withValues(alpha: 0.6))),
                        // border: InputBorder.none,
                        label: Text(
                          'Closing hours',
                          style: poppinsRegularStyle(
                              context: context,
                              fontSize: 14,
                              color: DynamicColor.grayClr),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: DynamicColor.whiteClr,
                        ),
                        suffixIcon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: DynamicColor.whiteClr,
                        ),
                      ),
                      controller: controller.closedHoursController,
                      format: controller.format,
                      style: poppinsRegularStyle(
                          context: context,
                          fontSize: 14,
                          color: DynamicColor.grayClr),
                      resetIcon: null,
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          initialEntryMode: TimePickerEntryMode.dial,
                          builder: (context, child) {
                            return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: DynamicColor.secondaryClr,
                                    // <-- SEE HERE
                                    onPrimary: DynamicColor.whiteClr,
                                    // <-- SEE HERE
                                    onSurface: Colors.black, // <-- SEE HERE
                                  ),
                                ),
                                child: child!);
                          },
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                        );
                        if (time != null) {
                          DateTime selectedDateTime = DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            time.hour,
                            time.minute,
                          );
                          controller.closedHoursController.text =
                              DateFormat.jm().format(selectedDateTime);
                          controller.update();
                        }
                        return;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       'Select Days of the Week Open',
                    //       style: poppinsRegularStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.bold,
                    //         context: context,
                    //         color: theme.primaryColor,
                    //       ),
                    //     ),
                    //     const SizedBox(height: 10),
                    // Wrap(
                    //   runSpacing: 5,
                    //   spacing: 5,
                    //   children: [
                    //     ...controller.weekDays.asMap().entries.map((entry) {
                    //       int index = entry.key; // Index of the week day
                    //       String data = entry.value; // Day name
                    //       return GestureDetector(
                    //         onTap: () {
                    //           controller.selectedWeekDays[index] =
                    //               controller.selectedWeekDays[index] == true
                    //                   ? false
                    //                   : true;
                    //           controller
                    //               .update(); // Notify the controller to update the UI
                    //         },
                    //         child: Row(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Checkbox(
                    //               activeColor: DynamicColor.yellowClr,
                    //               checkColor: Colors.white,
                    //               value: controller.selectedWeekDays[index],
                    //               onChanged: (value) {
                    //                 controller.selectedWeekDays[index] =
                    //                     value!;
                    //                 controller
                    //                     .update(); // Notify the controller to update the UI
                    //               },
                    //               materialTapTargetSize:
                    //                   MaterialTapTargetSize.shrinkWrap,
                    //             ),
                    //             Text(
                    //               data,
                    //               style: poppinsRegularStyle(
                    //                   context: context,
                    //                   fontSize: 12,
                    //                   color: DynamicColor.whiteClr),
                    //             ),
                    //           ],
                    //         ),
                    //       );
                    //     })
                    //   ],
                    // ),
                    //   ],
                    // )
                  ],
                ),
              ),
            ));
      }),
      bottomNavigationBar: GetBuilder<ManagerController>(builder: (controller) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: CustomButton(
              borderClr: Colors.transparent,
              onTap: () {
                if (venueForm.currentState!.validate()) {
                  Get.toNamed(Routes.addVenueDetailsScreen);
                }
              },
              text: "Next",
            ),
          ),
        );
      }),
    );
  }
}
