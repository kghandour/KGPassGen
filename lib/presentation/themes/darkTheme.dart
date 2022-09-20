import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.red,
      primaryColor: Colors.red,
      toggleableActiveColor: Colors.red,
      textTheme: TextTheme(
        bodyText2: TextStyle(fontSize: 16),
      ),
      buttonTheme: ButtonThemeData(
        padding: EdgeInsets.all(16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16),
        ),
      ),
      checkboxTheme:
          CheckboxThemeData(fillColor: MaterialStateProperty.all(Colors.red)),
    );
  }
}
