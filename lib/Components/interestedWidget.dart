


import 'package:flutter/material.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';

interestedWidget({theme,context,text,double? height}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 6),
    child: Container(
      height:height?? 25,
      width: 160,
      // padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
      decoration: BoxDecoration(
        color:DynamicColor.lightBlackClr.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(text,
          style: poppinsRegularStyle(fontSize: 13,color: theme.primaryColor,context: context),
        ),
      ),
    ),
  );
}