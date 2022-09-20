import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.red,
      textTheme: TextTheme(
        bodyText2: TextStyle(fontSize: 16),
      ),
    );
  }
}
