import 'package:flutter/material.dart';

typedef BottomBarMatuIconBuilder = Widget;

class BottomBarItem {
  final IconData? iconData;
  final ImageIcon? imageIconData;
  final double iconSize;
  final String? label;
  final TextStyle? labelTextStyle;
  final double labelMarginTop;
  final BottomBarMatuIconBuilder? iconBuilder;

  BottomBarItem({
    this.iconData,
    this.imageIconData,
    this.iconSize = 30,
    this.label,
    this.iconBuilder,
    this.labelMarginTop = 0,
    this.labelTextStyle,
  }) : assert(iconData != null || iconBuilder != null);
}
