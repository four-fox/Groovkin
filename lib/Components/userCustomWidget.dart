

 import 'package:flutter/material.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';

venueBookingUser({theme,context}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        const Image(image: AssetImage("assets/profileImg.png"),),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Herkimer County Fairgrounds',
                style: poppinsRegularStyle(fontSize: 12,context: context,color: theme.primaryColor,
                    fontWeight: FontWeight.w600),
              ),
              Text('Want to book for an event.',
                style: poppinsRegularStyle(fontSize: 12,context: context,color: DynamicColor.lightRedClr,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    ),
  );
 }