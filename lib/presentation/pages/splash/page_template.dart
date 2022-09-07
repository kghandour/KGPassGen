import 'package:flutter/material.dart';

Widget splashTemplate({
  required Color color,
  required String title,
  required String subtitle,
  required BuildContext context,
  String? urlImage,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Container(
    color: Colors.white70,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (urlImage != null)
          Image.asset(
            urlImage,
            height: 0.4 * screenHeight,
          ),
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    ),
  );
}
