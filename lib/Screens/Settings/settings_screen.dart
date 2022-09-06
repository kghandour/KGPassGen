import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kg_passgen/Screens/Settings/AlgorithmSettingsGroup.dart';
import 'package:kg_passgen/constant.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({required Key key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final sgpLength = TextEditingController();
  final kgLength = TextEditingController();

  final _sgpFormFieldKey = GlobalKey<FormFieldState>();
  final _kgFormFieldKey = GlobalKey<FormFieldState>();

  FocusNode? sgpLenFocus;
  FocusNode? kgLenFocus;

  @override
  void initState() {
    super.initState();
    sgpLenFocus = new FocusNode();
    kgLenFocus = new FocusNode();

    sgpLenFocus?.addListener(() {
      if (!sgpLenFocus!.hasFocus) {
        _sgpFormFieldKey.currentState?.validate();
      }
    });

    kgLenFocus?.addListener(() {
      if (!kgLenFocus!.hasFocus) {
        _kgFormFieldKey.currentState?.validate();
      }
    });
  }

  bool tooThin = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width <= 375)
      setState(() {
        tooThin = true;
      });
    else {
      setState(() {
        tooThin = false;
      });
    }

    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, box, widget) {
          int _algorithm = box.get(kAlgoKey, defaultValue: kAlgoDef);
          int _sgpHash = box.get(kSGPHashKey, defaultValue: kSGPHashDef);
          int _kgHash = box.get(kKGHashKey, defaultValue: kKGHashDef);

          bool _validatePass = box.get('validate', defaultValue: false);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  'Hashing Algorithm',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: tooThin
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RadioListTile(
                                  title: Text("Supergenpass"),
                                  value: 0,
                                  groupValue: _algorithm,
                                  onChanged: (val) {
                                    box.put(kAlgoKey, 0);
                                  }),
                              RadioListTile(
                                  title: Text("KGPassGen"),
                                  value: 1,
                                  groupValue: _algorithm,
                                  onChanged: (val) {
                                    box.put(kAlgoKey, 1);
                                  }),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('SupergenPass'),
                              Switch(
                                  value: _algorithm == 0 ? false : true,
                                  onChanged: (val) {
                                    box.put(kAlgoKey, val ? 1 : 0);
                                  }),
                              Text('KGPassGen')
                            ],
                          ),
                  ),
                ),
                AlgorithmSettingsGroup(
                  title: 'SuperGenPass Settings',
                  box: box,
                  hashingGroupValue: _sgpHash,
                  boxHashKey: kSGPHashKey,
                  boxLengthKey: kSGPLenKey,
                  boxLengthDefault: kSGPLenDef,
                  lengthController: sgpLength,
                  focusNode: sgpLenFocus!,
                  formKey: _sgpFormFieldKey,
                  tooThin: tooThin,
                ),
                AlgorithmSettingsGroup(
                  title: 'KGPassGen Settings',
                  box: box,
                  hashingGroupValue: _kgHash,
                  boxHashKey: kKGHashKey,
                  boxLengthKey: kKGLenKey,
                  boxLengthDefault: kKGLenDef,
                  lengthController: kgLength,
                  focusNode: kgLenFocus!,
                  formKey: _kgFormFieldKey,
                  tooThin: tooThin,
                ),
                Text(
                  'General Settings',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Card(
                    child: Column(
                  children: [
                    CheckboxListTile(
                        title: Text('Validate input password'),
                        subtitle: Text(
                            'Recommended. Validates your master password to make sure it is secure and not easy to guess.'),
                        value: _validatePass,
                        onChanged: (bool? value) {
                          box.put('validate', value);
                        }),
                    Divider(),
                    SwitchListTile(
                        value: box.get('stripDomain', defaultValue: true),
                        title: Text('Strip subdomains'),
                        subtitle: Text(
                            'Uses the original domain. Example: images.google.com => google.com'),
                        onChanged: (value) {
                          box.put('stripDomain', value);
                        }),
                  ],
                )),
                ElevatedButton.icon(
                    label: Text("Restore defaults"),
                    icon: Icon(Icons.restore_outlined),
                    onPressed: () => {restoreDefaults(box)}),
              ],
            ),
          );
        });
  }

  void restoreDefaults(Box box) {
    box.put(kAlgoKey, kAlgoDef);
    box.put(kSGPLenKey, kSGPLenDef);
    box.put(kSGPHashKey, kSGPHashDef);
    box.put(kKGLenKey, kKGLenDef);
    box.put(kKGHashKey, kKGHashDef);
  }
}
