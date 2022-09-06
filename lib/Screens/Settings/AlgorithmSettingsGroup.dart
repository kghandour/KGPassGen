import 'package:flutter/material.dart';
import 'package:kg_passgen/Helpers/validation.dart';
import 'package:kg_passgen/Screens/Settings/HorizontalRadioGroup.dart';

class AlgorithmSettingsGroup extends StatelessWidget {
  final String title;
  final dynamic box;
  final int hashingGroupValue;
  final String boxHashKey;
  final String boxLengthKey;
  final int boxLengthDefault;
  final TextEditingController lengthController;
  final FocusNode focusNode;
  final GlobalKey<FormFieldState> formKey;
  final bool tooThin;

  AlgorithmSettingsGroup(
      {required this.title,
      required this.box,
      required this.hashingGroupValue,
      required this.boxHashKey,
      required this.boxLengthKey,
      this.boxLengthDefault = 8,
      required this.lengthController,
      required this.focusNode,
      required this.formKey,
      required this.tooThin});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                tooThin
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hashing Function',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          RadioListTile(
                              title: Text("MD5"),
                              value: 0,
                              groupValue: hashingGroupValue,
                              onChanged: (val) {
                                box.put(boxHashKey, 0);
                              }),
                          RadioListTile(
                              title: Text("SHA512"),
                              value: 1,
                              groupValue: hashingGroupValue,
                              onChanged: (val) {
                                box.put(boxHashKey, 1);
                              }),
                        ],
                      )
                    : HorizontalRadioGroup(
                        title: 'Hashing Function',
                        boxKey: boxHashKey,
                        groupValueInt: hashingGroupValue,
                        radio1: 'MD5',
                        radio2: 'SHA512',
                        box: box),
                Divider(),
                tooThin
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Generated Length',
                              style: Theme.of(context).textTheme.subtitle1),
                          Text('Range 8-24',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .apply(color: Colors.white70)),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              focusNode: focusNode,
                              key: formKey,
                              validator: (value) {
                                if (!passwordLengthValidation(
                                    int.tryParse(value!) ?? 0)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Invalid Length! Length must be 8-24. Length restored to previous value.")));
                                  return "Value must be 8-24";
                                }
                                box.put(boxLengthKey, int.parse(value));
                                return null;
                              },
                              controller: lengthController
                                ..text = '' +
                                    box
                                        .get(boxLengthKey,
                                            defaultValue: boxLengthDefault)
                                        .toString(),
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                counterText: "",
                                isDense: true,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Generated Length',
                                  style: Theme.of(context).textTheme.subtitle1),
                              Text('Range 8-24',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .apply(color: Colors.white70)),
                            ],
                          ),
                          Container(
                            width: 80,
                            child: TextFormField(
                              focusNode: focusNode,
                              key: formKey,
                              validator: (value) {
                                if (!passwordLengthValidation(
                                    int.tryParse(value!) ?? 0)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Invalid Length! Length must be 8-24. Length restored to previous value.")));
                                  return "Value must be 8-24";
                                }
                                box.put(boxLengthKey, int.parse(value));
                                return null;
                              },
                              controller: lengthController
                                ..text = '' +
                                    box
                                        .get(boxLengthKey,
                                            defaultValue: boxLengthDefault)
                                        .toString(),
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                counterText: "",
                                isDense: true,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
