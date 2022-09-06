import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.red,
      primaryColor: Colors.red[700],
      accentColor: Colors.red[200],
      textTheme: TextTheme(subtitle2: TextStyle(fontWeight: FontWeight.bold))
          .apply(bodyColor: Colors.red),
      toggleableActiveColor: Colors.red,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
