

import 'package:intl/intl.dart';

///Time ago
timeAgoSinceDate(String dateTime) {
  DateTime date = DateTime.now();
  String? today;
  String? times;
  final DateFormat formatter = DateFormat('yy/MM/dd');
  final DateFormat timeFormatter = DateFormat('hh:mm aa');
  DateTime d = DateTime.parse(dateTime).toLocal();
  var difference = DateOnlyCompare(d).isSameDate(date);
  if (difference == false) {
    var time = d.difference(date).inDays;
    var min = d.difference(date).inMinutes;
    if (time == 0) {
      times = timeFormatter.format(DateTime.parse(dateTime).toLocal());
      if (min < 0) {
        min = min * -1;
      }
      if (min > 59) {
        int m = (min / 60).floor();
        if (m < 2) {
          return "${m}h";
        } else {
          return "${m}h";
        }
      } else {
        if (min <= 1) {
          return "Just Now";
        }
        return "$min Mins ago";
      }
    } else if (time <= -1 && time > -364) {
      time = time * -1;
      times = timeFormatter.format(DateTime.parse(dateTime).toLocal());
      if (time == 1) {
        today = "$time day";
      } else {
        today = "$time days";
      }
      return today;
    } else if (time < -364) {
      times = timeFormatter.format(DateTime.parse(dateTime).toLocal());
      today = formatter.format(DateTime.parse(dateTime).toLocal());

      return today;
    } else {
      if (min > 59) {
        int m = (min / 60).floor();
        if (m < 2) {
          return "${m}h";
        } else {
          return "${m}h";
        }
      } else {
        if (min <= 1) {
          return "Just Now";
        }
        return "${min}m";
      }
    }
  } else {
    var min = date.difference(d).inMinutes;
    times = timeFormatter.format(DateTime.parse(dateTime).toLocal());
    today = times.toString();
    if (min < 1) {
      return "Just Now";
    } else if (min <= 59) {
      return "${min}m";
    } else if (min > 59) {
      int m = (min / 60).floor();
      if (m < 2) {
        return "${m}h";
      } else {
        return "${m}h";
      }
    }
    return today;
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}


String formatShortMonth(String dateTime) {
  DateTime parsedDate = DateTime.parse(dateTime);
  String formattedDate = DateFormat('MMM').format(parsedDate); // 'MMM' gives short month format
  return formattedDate;
}