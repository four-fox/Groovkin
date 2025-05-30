// ignore_for_file: prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/dropDown.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/showCustomMap.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  double _currentSliderValue = 20;

  final calendarController = CleanCalendarController(
    minDate: DateTime.now(),
    maxDate: DateTime.now().add(const Duration(days: 365)),
    onRangeSelected: (firstDate, secondDate) {},
    onDayTapped: (date) {},
    // readOnly: true,
    onPreviousMinDateTapped: (date) {},
    onAfterMaxDateTapped: (date) {},
    weekdayStart: DateTime.monday,
    // initialFocusDate: DateTime(2023, 5),
    // initialDateSelected: DateTime(2022, 3, 15),
    // endDateSelected: DateTime(2022, 3, 20),
  );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Search Filter"),
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.height - kBottomNavigationBarHeight - kToolbarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Genre",
                  style: poppinsRegularStyle(
                    fontSize: 16,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const DropDownClass(
                  hint: "Select your music type",
                  // ignore: prefer_const_literals_to_create_immutables
                  list: [
                    "60 Rock",
                    "70 Rock",
                    "80 Rock",
                    "90 Rock",
                    "Blues",
                  ],
                ),
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage("assets/lightBg.png"),
                        fit: BoxFit.fill,
                      ),
                      border: Border.all(
                          color: DynamicColor.grayClr.withOpacity(0.7))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "DD/MM/YYYY",
                        style: poppinsRegularStyle(
                          fontSize: 15,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(calenderView());
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
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  readOnly: true,
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
                    value: _currentSliderValue,
                    activeColor: DynamicColor.lightRedClr,
                    secondaryActiveColor: DynamicColor.grayClr,
                    thumbColor: theme.primaryColor,
                    max: 100,
                    divisions: 5,
                    label: _currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "1 mile",
                      style: poppinsRegularStyle(
                        fontSize: 10,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                    Text(
                      "100 mile",
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
                const Spacer(),
                SafeArea(
                  bottom: true,
                  child: ShowCustomMap(
                    horizontalPadding: 0.0,
                    circle: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class calenderView extends StatelessWidget {
  final calendarController = CleanCalendarController(
    minDate: DateTime.now(),
    maxDate: DateTime.now().add(const Duration(days: 365)),
    onRangeSelected: (firstDate, secondDate) {},
    onDayTapped: (date) {},
    // readOnly: true,
    onPreviousMinDateTapped: (date) {},
    onAfterMaxDateTapped: (date) {},
    weekdayStart: DateTime.monday,
    // initialFocusDate: DateTime(2023, 5),
    // initialDateSelected: DateTime(2022, 3, 15),
    // endDateSelected: DateTime(2022, 3, 20),
  );

  calenderView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      // backgroundColor: theme.primaryColor,
      backgroundColor: Colors.transparent,
      appBar: customAppBar(theme: theme, text: "Select Date Range", actions: [
        IconButton(
          onPressed: () {
            calendarController.clearSelectedDates();
          },
          icon: const Icon(Icons.clear),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_downward),
        onPressed: () {
          calendarController.jumpToMonth(date: DateTime(2022, 8));
        },
      ),
      body: ScrollableCleanCalendar(
        calendarController: calendarController,
        layout: Layout.BEAUTY,
        calendarCrossAxisSpacing: 0,
      ),
    );
  }
}
