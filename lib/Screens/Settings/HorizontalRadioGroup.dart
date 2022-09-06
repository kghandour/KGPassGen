import 'package:flutter/material.dart';

class HorizontalRadioGroup extends StatelessWidget {
  final String title;
  final String subtitle;

  final String boxKey;
  final int groupValueInt;

  final String radio1;
  final String radio2;

  final dynamic box;

  HorizontalRadioGroup({
    required this.title,
    this.subtitle = "",
    required this.boxKey,
    required this.groupValueInt,
    required this.radio1,
    required this.radio2,
    @required this.box,
  });
  bool notNull(Object o) => o != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyText2,
                )
            ].where(notNull).toList(),
          ),
          Row(children: [
            Radio(
              value: 0,
              groupValue: this.groupValueInt,
              onChanged: (value) {
                box.put(boxKey, value);
              },
            ),
            Text(radio1),
            Radio(
              value: 1,
              groupValue: this.groupValueInt,
              onChanged: (value) {
                box.put(boxKey, value);
              },
            ),
            Text(radio2),
          ]),
        ]),
      ),
    );
  }
}
