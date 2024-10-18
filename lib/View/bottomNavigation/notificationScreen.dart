// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        appBar: customAppBar(theme: theme, text: "Notification"),
        body: ListView.builder(itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: notificationWidget(theme: theme, context: context),
          );
        }));
  }

  Widget notificationWidget(
      {bool profileImg = true, context, theme, text, subtitle, time}) {
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            image: AssetImage("assets/grayClor.png"), fit: BoxFit.fill),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(groupPlaceholder),
          // child: Image(
          //   image: NetworkImage(groupPlaceholder),
          // ),
        ),
        title: Text(
          text ?? 'Michael Logan',
          style: poppinsMediumStyle(
            fontSize: 14,
            context: context,
            color: theme.primaryColor,
          ),
        ),
        subtitle: Text(
          subtitle ?? 'Title here This Event hold by Venue',
          style: poppinsRegularStyle(
            fontSize: 14,
            context: context,
            color: DynamicColor.grayClr.withOpacity(0.8),
          ),
        ),
        trailing: Text(
          time ?? "1:00 PM",
          style: poppinsRegularStyle(
              fontSize: 12, context: context, color: DynamicColor.lightRedClr),
        ),
      ),
    );
  }
}
