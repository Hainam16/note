import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color orangeClr = Color(0xCFFF8746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
    primaryColor: primaryClr,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.orangeAccent.withOpacity(0.15),
      )

  );
  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    backgroundColor: darkGreyClr,
    brightness: Brightness.dark,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.cyanAccent.withOpacity(0.7),
    )
  );
}
TextStyle get titleStyle {
  return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.white : Colors.black,
  );
}
TextStyle get hourStyle {
  return TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: Get.isDarkMode ? Colors.white : Colors.black54,
  );
}