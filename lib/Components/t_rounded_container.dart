import 'package:flutter/material.dart';
import 'package:groovkin/Components/colors.dart';

class TRoundedContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final bool showBorder;
  Color? borderColor = DynamicColor.yellowClr;
  final Widget? child;

  TRoundedContainer({
    super.key,
    this.width,
    this.height,
    this.radius = 16.0,
    this.padding,
    this.margin,
    this.backgroundColor = Colors.white,
    this.showBorder = false,
    this.borderColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        border: showBorder ? Border.all(color: borderColor!) : null,
        borderRadius: BorderRadius.circular(radius!),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
