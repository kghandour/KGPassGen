import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePageController {
  static void copyPassword(String _generatedPassword, BuildContext context) {
    Clipboard.setData(ClipboardData(text: _generatedPassword));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Generated Password copied to clipboard")));
  }
}
