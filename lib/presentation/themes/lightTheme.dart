import 'dart:ui';

import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.red,
      textTheme: TextTheme(
        bodyText2: TextStyle(fontSize: 16),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: new TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
