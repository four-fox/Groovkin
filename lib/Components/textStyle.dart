


import 'package:flutter/material.dart';

poppinsMediumStyle(
    {double? fontSize, color, fontWeight, double? latterSpacing,context,bool underline= false}) {
  return TextStyle(
    fontSize: fontSize ?? 20,
    color: color ?? Theme.of(context).buttonTheme.colorScheme!.background,
    fontWeight: fontWeight ?? FontWeight.w500,
    fontFamily: 'poppinsMedium',
    letterSpacing: latterSpacing ?? 0,
    decoration:underline==false?null: TextDecoration.underline,
  );
}

poppinsRegularStyle(
    {double? fontSize, color, fontWeight, double? latterSpacing,context,bool underline= false}) {
  return TextStyle(
    fontSize: fontSize ?? 20,
    color: color ?? Theme.of(context).buttonTheme.colorScheme!.background,
    fontWeight: fontWeight ?? FontWeight.w500,
    fontFamily: 'poppinsRegular',
    letterSpacing: latterSpacing ?? 0,
    decoration:underline==false?null: TextDecoration.underline,
  );
}


validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}