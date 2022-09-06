import 'package:flutter/material.dart';

Widget splashTemplate({
  required Color color,
  required String title,
  required String subtitle,
  String? urlImage,
}) =>
    Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.teal.shade700,
                fontSize: 32,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: Text(
              subtitle,
              style: TextStyle(
                color: Colors.teal.shade400,
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        ],
      ),
    );
