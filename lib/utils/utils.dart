import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:intl/intl.dart';

class Utils {
  // Todo show Dialog

  Future onWillPop({required BuildContext context}) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Exit Application",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are You Sure?",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
          TextButton(
            child: const Text(
              "No",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // show Bot Toast
  static showToast() async {
    BotToast.showText(
      text: "This Account Is Delete",
      textStyle: poppinsMediumStyle(fontSize: 16, color: Colors.black),
      contentColor: Colors.white,
    );
  }

  // Todo Show FlutterToast
  static showFlutterToast(String message) async {
    await Fluttertoast.showToast(msg: message);
  }

  // Todo Show DateFormat
  static String dateFormat(String date) {
    final DateTime dateFormat =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'").parse(date);
    final DateFormat outputFormatDate = DateFormat("dd-MMM-yy");
    String formattedDate = outputFormatDate.format(dateFormat);

    return formattedDate;
  }

  // Todo Show Time
  static String timeFormat(String date) {
    final DateTime dateFormat =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'").parseUtc(date);
    final DateFormat outputFormatTime = DateFormat("hh:mma");
    String formattedTime = outputFormatTime.format(dateFormat);
    return formattedTime;
  }

  static accountDelete(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 150, // Set max width
        minWidth: 100, // Set min width
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(4)),
      child: Center(
        child: Text(
          "Account Deleted",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
