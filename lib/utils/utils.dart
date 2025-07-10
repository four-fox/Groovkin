import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:intl/intl.dart';

class Utils {
  // Todo show Dialog
  // ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 backgroundColor: theme.primaryColor,
  //                 content: Text(
  //                   'Tap back again to exit the app',
  //                   style: TextStyle(
  //                     fontSize: 15,
  //                     color: theme.scaffoldBackgroundColor,
  //                   ),
  //                 ),
  //                 duration: const Duration(seconds: 2),
  //               ),
  //             );
  // static Future onWillPop({required BuildContext context}) async {
  //   return showDialog(
  //     context: context,
  //     builder: (context) => Dialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             colors: [
  //               Color(0xffb77712),
  //               Color(0xffeac15a),
  //             ],
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //           ),
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text(
  //               "Exit Application",
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white,
  //                 fontSize: 20,
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             Text(
  //               "Are You Sure?",
  //               style: Theme.of(context)
  //                   .textTheme
  //                   .labelLarge!
  //                   .copyWith(color: Colors.white),
  //             ),
  //             const SizedBox(height: 24),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 TextButton(
  //                   child: const Text("Yes",
  //                       style: TextStyle(color: Colors.white)),
  //                   onPressed: () {
  //                     SystemNavigator.pop();
  //                   },
  //                 ),
  //                 const SizedBox(width: 8),
  //                 TextButton(
  //                   child:
  //                       const Text("No", style: TextStyle(color: Colors.white)),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
      constraints: const BoxConstraints(
        maxWidth: 150, // Set max width
        minWidth: 100, // Set min width
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(2.0),
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
