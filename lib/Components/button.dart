



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';

class CustomButton extends StatelessWidget {
  CustomButton({super.key,this.onTap,this.text,this.color1,this.color2,this.style,
  this.textClr,
    this.heights,
    this.widths,
    this.borderClr,
    this.backgroundClr = true,
    this.fontSized,
    this.bgImage,
    this.borderRadius=8,
  });

  final GestureTapCallback? onTap;
  String? text;
  var color1 ;
  var color2;
  final TextStyle? style;
  Color? textClr;
  double? heights;
  double? widths;
  Color ? borderClr;
  bool backgroundClr = true;
  double? fontSized;
  String? bgImage;
  double borderRadius=8;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height:heights?? 48,
        width:widths?? Get.width,
        decoration: BoxDecoration(
          // color: DynamicColor.yellowClr,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderClr??DynamicColor.yellowClr),
            image:backgroundClr==true? DecorationImage(
              image: AssetImage(bgImage??"assets/buttonBg.png"),
              fit: BoxFit.fill
            ):null,
          gradient:backgroundClr==false? LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              color1??  Color(0xffd8a735),
             color2?? Color(0xffb77712).withOpacity(0.7),
            ],
          ):null
        ),
        child: Center(
          child: Text(text??'Get Started',
            style:style?? poppinsMediumStyle(context: context,
                color:textClr?? Theme.of(context).primaryColor,
                fontSize:fontSized?? 15,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtonWithIcon extends StatelessWidget {
  CustomButtonWithIcon({super.key,this.onTap,this.text,this.color1,this.color2,this.style,
  this.textClr,
    this.iconss,
    this.iconValue = false,
    this.imageIconn,
    this.iconsClr,
    this.width,
    this.height,
    this.fontSize,
    this.borderRadius=12,
    this.iconRightSide = false,
    this.iconSize,
    this.bgColor,
    this.gradientClr = false,
  });

  final GestureTapCallback? onTap;
  String? text;
  var color1 ;
  var color2;
  final TextStyle? style;
  Color? textClr;
  IconData? iconss;
  bool iconValue = false;
  ImageIcon? imageIconn;
  Color? iconsClr;
  double? width;
  double? height;
  double? fontSize;
  double borderRadius=12;
  bool iconRightSide = false;
  final double? iconSize;
  Color? bgColor;
  bool gradientClr = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height??48,
        width:width?? Get.width,
        decoration: BoxDecoration(
          // color: DynamicColor.yellowClr,
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: gradientClr == false ? null: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                color1??  Color(0xffd8a735),
               color2?? Color(0xffb77712).withOpacity(0.7),
              ],
            ),
          color: bgColor == null?Colors.transparent:DynamicColor.secondaryClr
        ),
        child:iconRightSide==false? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconValue==false? Icon(iconss,
            color: iconsClr,
            ):imageIconn!,
            SizedBox(
              width: 10,
            ),
            Text(text??'Get Started',
              style:style?? poppinsMediumStyle(context: context,
                color:textClr?? Theme.of(context).primaryColor,
                fontSize: fontSize ?? 15,
              ),
            ),
          ],
        ): Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text??'Get Started',
              style:style?? poppinsMediumStyle(context: context,
                color:textClr?? Theme.of(context).primaryColor,
                fontSize: fontSize ?? 15,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            iconValue==false? Icon(iconss,
              color: iconsClr,
              size: iconSize,
            ):imageIconn!,
          ],
        ),
      ),
    );
  }
}
