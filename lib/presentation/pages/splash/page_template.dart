import 'package:flutter/material.dart';

Widget splashTemplate({
  required Color color,
  required String title,
  required String subtitle,
  required BuildContext context,
  required String urlImage,
}) {
  final screenHeight = MediaQuery.of(context).size.height;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Image.asset(
          urlImage,
          height: 0.22 * screenHeight,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget singleSplashTemplate({
  required Color color,
  required String title,
  required String subtitle,
  required BuildContext context,
  required String urlImage,
}) {
  final screenHeight = MediaQuery.of(context).size.height;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          urlImage,
          height: 0.5 * screenHeight,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ],
    ),
  );
}
