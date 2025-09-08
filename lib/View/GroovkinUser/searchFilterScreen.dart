// ignore_for_file: prefer_collection_literals


import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:intl/intl.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  late HomeController homeController;
  late CleanCalendarController calendarController;
  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<HomeController>()) {
      homeController = Get.find<HomeController>();
    } else {
      homeController = Get.put(HomeController());
    }
    calendarController = CleanCalendarController(
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 365)),
      initialDateSelected: homeController.firstDate,
      endDateSelected: homeController.secondDate,
      onRangeSelected: (firstDate, secondDate) {
        if (firstDate == secondDate) {
          bottomToast(text: "Same Date not acceptale");
          return;
        }
        homeController.firstDate = firstDate;
        homeController.secondDate = secondDate;
        print(firstDate);
        print(secondDate);
      },
      onDayTapped: (date) {},
      // readOnly: true,
      onPreviousMinDateTapped: (date) {},
      onAfterMaxDateTapped: (date) {},
      weekdayStart: DateTime.monday,
      // initialFocusDate: DateTime(2023, 5),
      // initialDateSelected: DateTime(2022, 3, 15),
      // endDateSelected: DateTime(2022, 3, 20),
    );
  }

  String changeDateFormat(DateTime dateTime) {
    return DateFormat("dd/MM/yyyy").format(dateTime);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Search Filter"),
      body: GetBuilder<HomeController>(builder: (controller) {
        return SingleChildScrollView(
          child: SizedBox(
            height:
                context.height - kBottomNavigationBarHeight - kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Text(
                    //   "Genre",
                    //   style: poppinsRegularStyle(
                    //     fontSize: 16,
                    //     context: context,
                    //     color: theme.primaryColor,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // const DropDownClass(
                    //   hint: "Select your music type",
                    //   // ignore: prefer_const_literals_to_create_immutables
                    //   list: [
                    //     "60 Rock",
                    //     "70 Rock",
                    //     "80 Rock",
                    //     "90 Rock",
                    //     "Blues",
                    //   ],
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Date",
                      style: poppinsRegularStyle(
                        fontSize: 16,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.calenderView);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage("assets/lightBg.png"),
                              fit: BoxFit.fill,
                            ),
                            border: Border.all(
                                color: DynamicColor.grayClr
                                    .withValues(alpha: 0.7))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (homeController.firstDate == null &&
                                homeController.secondDate == null)
                              Text(
                                "DD/MM/YYYY",
                                style: poppinsRegularStyle(
                                  fontSize: 15,
                                  context: context,
                                  color: theme.primaryColor,
                                ),
                              ),
                            if (homeController.firstDate != null &&
                                homeController.secondDate != null)
                              Text(
                                "${changeDateFormat(homeController.firstDate!)} - ${changeDateFormat(homeController.secondDate!)} ",
                                style: poppinsRegularStyle(
                                  fontSize: 15,
                                  context: context,
                                  color: theme.primaryColor,
                                ),
                              ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.calenderView);
                              },
                              child: Icon(
                                Icons.calendar_month,
                                size: 28,
                                color: theme.primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      readOnly: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return MapLocationPicker(
                                onTappp: () {},
                                // onTapShow: true,
                                // hideLocation: true,
                                // lat: double.parse(eventData.latitude.toString()),
                                // long: double.parse(eventData.longitude.toString()),
                                minMaxZoomPreference:
                                    const MinMaxZoomPreference(0, 15),
                                apiKey:
                                    "AIzaSyC_-hLFYGAJC_IBMnFBKZLq2IS1qr7tJgQ",
                                canPopOnNextButtonTaped: true,
                                searchHintText:
                                    homeController.locationController.text !=
                                            "null"
                                        ? homeController.locationController.text
                                        : "Start typing to search",
                                // canPopOnNextButtonTaped: true,
                                latLng: homeController.locationLatLng,
                                initAddress:
                                    homeController.locationController.text,
                                nextPage: () {},
                                onNext: (GeocodingResult? result) async {
                                  if (result != null) {
                                    if (result.formattedAddress != null) {
                                      homeController.locationController.text =
                                          result.formattedAddress!;
                                      List<geo.Location> locations = await geo
                                          .locationFromAddress(homeController
                                              .locationController.text);

                                      double latitude = locations[0].latitude;
                                      double longitude = locations[0].longitude;

                                      LatLng latLng =
                                          LatLng(latitude, longitude);

                                      homeController.locationLatLng = latLng;

                                      homeController.update();
                                      Get.back();
                                    }
                                  }
                                },
                                onSuggestionSelected:
                                    (PlacesDetailsResponse? result) {
                                  if (result != null) {}
                                },
                              );
                            },
                          ),
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Location Required";
                        }
                        return null;
                      },
                      controller: controller.locationController,
                      decoration: InputDecoration(
                        labelText: "Location",
                        labelStyle: poppinsRegularStyle(
                          fontSize: 15,
                          color: theme.primaryColor,
                          context: context,
                        ),
                        suffixIcon: Icon(
                          Icons.location_searching,
                          size: 20,
                          color: theme.primaryColor,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: DynamicColor.grayClr),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: DynamicColor.grayClr),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Distance radius",
                      style: poppinsRegularStyle(
                        fontSize: 16,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 20,
                      child: Slider(
                        value: homeController.currentSliderValue,
                        activeColor: DynamicColor.lightRedClr,
                        secondaryActiveColor: DynamicColor.grayClr,
                        thumbColor: theme.primaryColor,
                        max: 100,
                        min: 1,
                        divisions: 5,
                        label: homeController.currentSliderValue
                            .round()
                            .toString(),
                        onChanged: (double value) {
                          homeController.currentSliderValue = value;
                          homeController.update();
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${homeController.currentSliderValue.round().toInt()} mile",
                          style: poppinsRegularStyle(
                            fontSize: 10,
                            context: context,
                            color: theme.primaryColor,
                          ),
                        ),
                        Text(
                          "${homeController.currentSliderValue.round().toInt()} mile",
                          style: poppinsRegularStyle(
                            fontSize: 10,
                            context: context,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    // const Spacer(),
                    // SafeArea(
                    //   bottom: true,
                    //   child: ShowCustomMap(
                    //     horizontalPadding: 0.0,
                    //     circle: true,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: () async {
            if (homeController.isFiltered == true) {
              homeController.firstDate = null;
              homeController.secondDate = null;
              homeController.locationLatLng = null;
              homeController.currentSliderValue = 20;
              homeController.isFiltered = false;
              homeController.locationController.clear();
              homeController.update();
              await homeController.getEventNearByMe().then((_) {
                homeController.nearbyVal.value = true;
                homeController.update();
                Get.back();
              });
              return;
            } else {
              final validate = _formKey.currentState!.validate();
              if (!validate) {
                return;
              }
              if (homeController.firstDate == null ||
                  homeController.secondDate == null) {
                bottomToast(text: "Selected First and Last Date");
              } else if (homeController.currentSliderValue <= 0) {
                bottomToast(text: "Selected At Least Mile");
              } else {
                // hit api
                await homeController.getEventNearByMe().then((_) {
                  homeController.nearbyVal.value = true;
                  homeController.isFiltered = true;
                  homeController.update();
                  Get.back();
                });
              }
            }
          },
          text: homeController.isFiltered ? "Clear Filter" : "Search",
        ),
      )),
    );
  }
}

class calenderView extends StatefulWidget {
  calenderView({super.key});

  @override
  State<calenderView> createState() => _calenderViewState();
}

class _calenderViewState extends State<calenderView> {
  late HomeController homeController;
  late CleanCalendarController calendarController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<HomeController>()) {
      homeController = Get.find<HomeController>();
    } else {
      homeController = Get.put(HomeController());
    }

    calendarController = CleanCalendarController(
      minDate: DateTime.now(),
      initialDateSelected: homeController.firstDate,
      endDateSelected: homeController.secondDate,
      maxDate: DateTime.now().add(const Duration(days: 365)),
      onRangeSelected: (firstDate, secondDate) {
        if (firstDate == secondDate) {
          bottomToast(text: "Same Date not acceptale");
          return;
        }
        homeController.firstDate = firstDate;
        homeController.secondDate = secondDate;
        homeController.update();
      },
      onDayTapped: (date) {},
      // readOnly: true,
      onPreviousMinDateTapped: (date) {},
      onAfterMaxDateTapped: (date) {},
      weekdayStart: DateTime.monday,

      // initialFocusDate: DateTime(2023, 5),
      // initialDateSelected: DateTime(2022, 3, 15),
      // endDateSelected: DateTime(2022, 3, 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<HomeController>(
      builder: (controller) => Scaffold(
        // backgroundColor: theme.primaryColor,
        backgroundColor: Colors.transparent,
        appBar: customAppBar(theme: theme, text: "Select Date Range", actions: [
          IconButton(
            onPressed: () {
              calendarController.clearSelectedDates();
              controller.firstDate = null;
              controller.secondDate = null;
              controller.update();
            },
            icon: const Icon(Icons.clear),
          )
        ]),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (controller.firstDate != null && controller.secondDate != null)
              FloatingActionButton(
                heroTag: UniqueKey(),
                child: const Icon(Icons.check),
                onPressed: () {
                  Get.back();
                },
              ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              heroTag: UniqueKey(),
              child: const Icon(Icons.arrow_downward),
              onPressed: () {
                calendarController.jumpToMonth(
                    date: DateTime.now().add(const Duration(days: 365)));
              },
            ),
          ],
        ),
        body: ScrollableCleanCalendar(
          calendarController: calendarController,
          layout: Layout.BEAUTY,
          calendarCrossAxisSpacing: 0,
        ),
      ),
    );
  }
}
