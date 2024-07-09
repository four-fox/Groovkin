
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
  AddVenueScreen({Key? key}) : super(key: key);

  final venueForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Add Venue"),
      body: GetBuilder<ManagerController>(
        builder: (controller) {
          return Form(
            key: venueForm,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text("Add about your property!",
                    style: poppinsMediumStyle(
                      fontSize: 18,
                      color: theme.primaryColor,
                      context: context
                    ),
                    ),
                    Text('Please fill this form carefully.',
                    style: poppinsRegularStyle(
                      fontSize: 12,
                      context: context,
                      color: DynamicColor.lightRedClr
                    ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextFields(
                      labelText: "Max Occupancy",
                      controller: controller.maxOccupancyController,
                      validationError: "max occupancy",
                      keyBoardType: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextFields(
                      labelText: "Max seating",
                      controller: controller.maxSeatingController,
                      validationError: "max seating",
                      keyBoardType: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextFields(
                      labelText: "Max hour",
                      controller: controller.maxHourController,
                      validationError: "max hour",
                      keyBoardType: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DateTimeField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius
                                .circular(8),
                            borderSide: BorderSide(
                                color: DynamicColor.grayClr.withOpacity(0.6))),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius
                                .circular(8),
                            borderSide: BorderSide(
                                color: DynamicColor.grayClr.withOpacity(0.6))),
                        // border: InputBorder.none,
                        label: Text('Opening hours',
                        style: poppinsRegularStyle(
                            context: context,
                            fontSize: 14,
                            color: DynamicColor.grayClr
                        ),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: DynamicColor.whiteClr,
                        ),
                        suffixIcon: Icon(
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
                          color: DynamicColor.grayClr
                      ),
                      resetIcon: null,
                      onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                          initialEntryMode:
                          TimePickerEntryMode.dial,
                          builder: (context, child) {
                            return Theme(
                                data: Theme.of(context)
                                    .copyWith(
                                  colorScheme: ColorScheme
                                      .light(
                                    primary: DynamicColor.secondaryClr,
                                    // <-- SEE HERE
                                    onPrimary: DynamicColor
                                        .whiteClr,
                                    // <-- SEE HERE
                                    onSurface:
                                    Colors
                                        .black, // <-- SEE HERE
                                  ),
                                ),
                                child: child!);
                          },
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              DateTime.now()),
                        );
                        if(time != null){
                          DateTime selectedDateTime = DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            time.hour,
                            time.minute,
                          );
                          controller.openingHoursController.text = DateFormat.jm().format(selectedDateTime);
                        }
                        return;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DateTimeField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius
                                .circular(8),
                            borderSide: BorderSide(
                                color: DynamicColor.grayClr.withOpacity(0.6))),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius
                                .circular(8),
                            borderSide: BorderSide(
                                color: DynamicColor.grayClr.withOpacity(0.6))),
                        // border: InputBorder.none,
                        label: Text('Closing hours',
                          style: poppinsRegularStyle(
                              context: context,
                              fontSize: 14,
                              color: DynamicColor.grayClr
                          ),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: DynamicColor.whiteClr,
                        ),
                        suffixIcon: Icon(
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
                          color: DynamicColor.grayClr
                      ),
                      resetIcon: null,
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          initialEntryMode:
                          TimePickerEntryMode.dial,
                          builder: (context, child) {
                            return Theme(
                                data: Theme.of(context)
                                    .copyWith(
                                  colorScheme: ColorScheme
                                      .light(
                                    primary: DynamicColor.secondaryClr,
                                    // <-- SEE HERE
                                    onPrimary: DynamicColor
                                        .whiteClr,
                                    // <-- SEE HERE
                                    onSurface:
                                    Colors
                                        .black, // <-- SEE HERE
                                  ),
                                ),
                                child: child!);
                          },
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              DateTime.now()),
                        );
                        if(time != null){
                          DateTime selectedDateTime = DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            time.hour,
                            time.minute,
                          );
                          controller.closedHoursController.text = DateFormat.jm().format(selectedDateTime);
                          controller.update();
                        }
                        return;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: (){
            if(venueForm.currentState!.validate()){
              Get.toNamed(Routes.addVenueDetailsScreen);
            }
          },
          text: "Next",
        ),
      ),
    );
  }
}
