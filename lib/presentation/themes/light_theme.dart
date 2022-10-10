import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.red,
      iconTheme: const IconThemeData(color: Colors.red),
      // textTheme: TextTheme(
      //   bodyText2: TextStyle(fontSize: 16),
      // ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
