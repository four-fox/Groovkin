import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:intl/intl.dart';

const String groupPlaceholder =
    "https://thumbs.dreamstime.com/b/person-gray-photo-placeholder-man-shirt-white-background-person-gray-photo-placeholder-man-132818487.jpg";

var sp = GetStorage();

class DynamicColor {
  static Color yellowClr = const Color(0xffd6a331);
  static Color darkYellowClr = const Color(0xffFF9900);
  static Color lightYellowClr = const Color(0xffFFF3A6);
  static Color grayClr = const Color(0xff9DA3B5);
  static Color lightRedClr = const Color(0xffFF9669);
  static Color avatarBgClr = const Color(0xff363537);
  static Color darkGrayClr = const Color(0xff252525);
  static Color blackClr = Colors.black;
  static Color lightGrayClr = Colors.grey;
  static Color pinkClr = const Color(0xffFC1F54);
  static Color whiteClr = Colors.white;
  static Color greenClr = const Color(0xff40B143);
  static Color redClr = const Color(0xffFF0000);
  static Color darkBlueClr = const Color(0xff1E1F33);
  static Color lightBlackClr = const Color(0xff454447);
  static Color lightWhite = const Color(0xff878787);
  static Color secondaryClr = const Color(0xffd39e2e);
  static Color dropDownClr = const Color(0xffbb7b17);
  static Color finishedTextClr = const Color(0xff770113);
  static Color disabledColor = Colors.grey.withValues(alpha: 0.6);
}

getformattedTime(TimeOfDay time) {
  return '${time.hour}:${time.minute} ${time.period.toString().split('.')[1]}';
}

bottomToast({
  String? text,
  Color? bgClr,
  Color? textClr,
}) {
  return BotToast.showText(
      contentColor: bgClr ?? Colors.white,
      textStyle:
          poppinsMediumStyle(fontSize: 16, color: textClr ?? Colors.black),
      text: text ?? "Please select survey");
}

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> no Data
noData({context, theme}) {
  return Center(
    child: Text(
      "No Data",
      style: poppinsMediumStyle(
        fontSize: 16,
        context: context,
        color: theme.primaryColor,
      ),
    ),
  );
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

getTimeMethod(String dateTime) {
  dateTime = dateTime.toString().replaceAll("T", " ");
  DateTime b = DateTime.now();
  String? today;
  String? times;
  DateTime a = DateTime.parse(dateTime).toLocal();
  var d = DateTime.utc(a.year, a.month, a.day, a.hour, a.minute, a.second);
  var date = DateTime.utc(b.year, b.month, b.day, b.hour, b.minute, b.second);

  final DateFormat formatter = DateFormat('yy/MM/dd');
  final DateFormat timeFormatter = DateFormat('hh:mm aa');

  var difference = DateOnlyCompare(date).isSameDate(d);
  if (difference == false) {
    var time = d.difference(date).inDays;
    var min = d.difference(date).inMinutes;
    if (time == 0) {
      times = timeFormatter.format(DateTime.parse(dateTime).toUtc());
      if (min < 0) {
        min = min * -1;
      }
      if (min > 59) {
        int m = (min / 60).floor();
        if (m < 2) {
          return "$m Hour ago";
        } else {
          return "$m Hours ago";
        }
      } else {
        if (min <= 1) {
          return "Just Now";
        }
        return "$min Mins ago";
      }
    } else if (time <= -1 && time > -364) {
      time = time * -1;
      times = timeFormatter.format(DateTime.parse(dateTime).toUtc());
      if (time == 1) {
        today = "$time day ago";
      } else {
        today = "$time days ago";
      }
      return today;
    } else if (time < -364) {
      times = timeFormatter.format(DateTime.parse(dateTime).toUtc());
      today = formatter.format(DateTime.parse(dateTime).toUtc());

      return today;
    } else {
      if (min > 59) {
        int m = (min / 60).floor();
        if (m < 2) {
          return "$m Hour ago";
        } else {
          return "$m Hours ago";
        }
      } else {
        if (min <= 1) {
          return "Just Now";
        }
        return "$min Mins ago";
      }
    }
  } else {
    print(d);
    print(date);

    var start =
        DateTime.utc(d.year, d.month, d.day, d.hour, d.minute, d.second);
    var end = DateTime.utc(
        date.year, date.month, date.day, date.hour, date.minute, date.second);
    var min = end.difference(start).inMinutes;
    times = timeFormatter.format(DateTime.parse(dateTime).toUtc());
    today = times;
    if (min < 1) {
      return "Just Now";
    } else if (min <= 59) {
      return "$min Mins ago";
    } else if (min > 59) {
      int m = (min / 60).floor();
      if (m < 2) {
        return "$m Hour ago";
      } else {
        return "$m Hours ago";
      }
    }
    return today;
  }
}
