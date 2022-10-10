import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.red,
      primaryColor: Colors.red,
      toggleableActiveColor: Colors.red,
      iconTheme: const IconThemeData(color: Colors.red),
      buttonTheme: const ButtonThemeData(
        padding: EdgeInsets.all(16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      checkboxTheme:
          CheckboxThemeData(fillColor: MaterialStateProperty.all(Colors.red)),
    );
  }
}
