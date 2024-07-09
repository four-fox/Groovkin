
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';

customAppBar({theme,text,TextStyle? style,GestureTapCallback? onTap,List<Widget>? actions,bool imagee = false,backArrow = true,
Widget? container,
}) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        // color:imagee==true?Colors.transparent: DynamicColor.yellowClr,
          image:imagee==false? DecorationImage(
              image: AssetImage("assets/grayClor.png"),
              fit: BoxFit.fill
          ):null,
      ),
    ),
    centerTitle: true,
    leadingWidth: 46,
    leading:backArrow==true? GestureDetector(
        onTap:onTap?? (){
          Get.back();
        },
        child: ImageIcon(AssetImage("assets/backArrow.png"),
        color: theme.primaryColor,
        )):null,
    title:container?? Text(text??"Payment Method",
      style:style?? poppinsMediumStyle(
        fontSize: 17,
        color: theme.primaryColor,
      ),
    ),
    actions: actions,
  );
}
