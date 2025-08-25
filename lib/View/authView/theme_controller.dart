import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';

class ThemeController extends GetxController {
  // Default is system theme
  var themeMode = ThemeMode.system.obs;

  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    log("theme mode :: ${themeMode.value}");
    API().sp.write("apptheme", themeMode.value.name);
  }

  void setTheme(ThemeMode mode) {
    themeMode.value = mode;

    log("theme mode :: ${themeMode.value}");
    update();
  }
}
