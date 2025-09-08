import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // Default is system theme
  var themeMode = ThemeMode.system;

  /// Fetch theme for a specific role
  Future<void> fetchUserTheme(String role) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (role == "eventManager") {
      final themeString = prefs.getString("user_theme");
      if (themeString != null) {
        themeMode = themeString == "light"
            ? ThemeMode.light
            : themeString == "dark"
                ? ThemeMode.dark
                : ThemeMode.system;
      } else {
        themeMode = ThemeMode.dark; // default
      }
    } else {
      // All other roles forced to dark
      themeMode = ThemeMode.dark;
    }

    log("Role: $role | Theme: $themeMode");
    update();
  }

  /// Toggle only works for User
  void toggleTheme(String role) async {
    if (role != "eventManager") return;

    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_theme", themeMode.name);

    update();
  }
}
