import 'package:flutter/material.dart';

class Constants {
  
  static String appName = "Bluu";
  static String initialAccent ="Yellow";
  //Colors for theme
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Color(0xff313131);
  static Color lightAccent = Colors.blue;
  static Color darkAccent = Colors.lightBlue;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color badgeColor = Colors.red;

  static ThemeData lightTheme(accent) {
    return ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: accent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    canvasColor: Colors.white,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline1: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
  }

  static ThemeData darkTheme(accent) {
    return ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: accent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    canvasColor: Colors.black,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline1: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
  }
}
