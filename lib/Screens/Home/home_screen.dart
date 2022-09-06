import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kg_passgen/Helpers/hashing.dart';
import 'package:kg_passgen/Helpers/validation.dart';
import 'package:kg_passgen/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final websiteController = TextEditingController();
  final masterController = TextEditingController();
  final _websiteFocus = FocusNode();
  final _masterFocus = FocusNode();

  bool _showGenerated = false;
  bool _showButton = true;

  bool _showPassword = false;
  String _generatedPassword = "";

  bool fieldsFilled() {
    if (websiteController.text.length == 0 || masterController.text.length == 0)
      return false;
    return true;
  }

  void forceShowButton() {
    _showButton = true;
  }

  @override
  void initState() {
    super.initState();
    _websiteFocus.addListener(() {
      if (_websiteFocus.hasFocus)
        setState(() {
          _showButton = true;
        });
    });
    _masterFocus.addListener(() {
      if (_masterFocus.hasFocus)
        setState(() {
          _showButton = true;
        });
    });
  }

  @override
  void dispose() {
    _websiteFocus.dispose();
    _masterFocus.dispose();
    super.dispose();
  }

  generatePassword() {
    setState(() {
      if (fieldsFilled()) {
        // String toBeEncrypted =
        //     masterController.text + ":" + websiteController.text;
        _generatedPassword =
            hopPasswordGen(masterController.text, websiteController.text);
        _websiteFocus.unfocus();
        _masterFocus.unfocus();
        _showButton = false;
      }
    });
  }

  void _copyPassword() {
    Clipboard.setData(ClipboardData(text: _generatedPassword));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Generated Password copied to clipboard")));
  }

  bool _tooThin = false;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    double width = MediaQuery.of(context).size.width;
    if (width <= 375)
      setState(() {
        _tooThin = true;
      });
    else {
      setState(() {
        _tooThin = false;
      });
    }
    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, box, widget) {
          int _algorithm = box.get(kAlgoKey, defaultValue: kAlgoDef);
          bool _validate = box.get('validate', defaultValue: false);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tooThin ? Text('SGP') : Text('Supergenpass'),
                    Switch(
                        value: _algorithm == 0 ? false : true,
                        onChanged: (val) {
                          box.put(kAlgoKey, val ? 1 : 0);
                          generatePassword();
                        }),
                    _tooThin ? Text('KGPG') : Text('KGPassGen')
                  ],
                ),
                Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Text("Website"),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          focusNode: _websiteFocus,
                          controller: websiteController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.url,
                          onEditingComplete: () => _masterFocus.requestFocus(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a URL';
                            } else if (!urlValidation(value))
                              return 'Please enter a valid URL';
                            return null;
                          },
                        ),
                      ),
                      Text("Master Password"),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                focusNode: _masterFocus,
                                controller: masterController,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                onEditingComplete: () => node.unfocus(),
                                obscureText: !_showPassword,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a password';
                                  } else if (!passwordValidation(value))
                                    return 'Password must contain at least 8 characters, a lowercase letter, an uppercase letter and a number';
                                  return null;
                                },
                              ),
                            ),
                            Checkbox(
                              value: _showPassword,
                              onChanged: (value) => {
                                setState(() {
                                  _showPassword = value!;
                                })
                              },
                            ),
                            Text("Show password"),
                          ],
                        ),
                      ),
                      _showButton
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (!_validate ||
                                        _formKey.currentState!.validate()) {
                                      generatePassword();
                                    }
                                  },
                                  child: Text("Generate Password")),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text("Generated Password "),
                                      ),
                                      OutlinedButton(
                                        onPressed: (() {
                                          setState(() {
                                            _showGenerated = !_showGenerated;
                                          });
                                        }),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            _showGenerated == true
                                                ? _generatedPassword
                                                : '${_generatedPassword.replaceAll(RegExp(r"."), "*")}',
                                            style: kBiggerFont,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SizedBox(
                                    height: 55,
                                    child: ElevatedButton.icon(
                                      onPressed: _copyPassword,
                                      icon: Icon(Icons.copy),
                                      label: Text("Copy"),
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'KGPassGen is a slightly modified version of SGP with additional security measures. You can read more about it in the Tips page.',
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runAlignment: WrapAlignment.center,
                          runSpacing: 8,
                          spacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => launch('https://kghandour.com'),
                              icon: Icon(Icons.double_arrow_rounded),
                              label: Text("KGhandour Website"),
                            ),
                            _tooThin
                                ? OutlinedButton.icon(
                                    onPressed: () => launch(
                                        'https://chriszarate.github.io/supergenpass/'),
                                    icon: Icon(Icons.double_arrow_rounded),
                                    label: Text("SGP website"),
                                  )
                                : OutlinedButton.icon(
                                    onPressed: () => launch(
                                        'https://chriszarate.github.io/supergenpass/'),
                                    icon: Icon(Icons.double_arrow_rounded),
                                    label: Text("SuperGenPass website"),
                                  ),
                            _tooThin
                                ? OutlinedButton.icon(
                                    onPressed: () => launch(
                                        'https://github.com/chriszarate/supergenpass'),
                                    icon: Icon(Icons.double_arrow_rounded),
                                    label: Text("SGP Repo"),
                                  )
                                : OutlinedButton.icon(
                                    onPressed: () => launch(
                                        'https://github.com/chriszarate/supergenpass'),
                                    icon: Icon(Icons.double_arrow_rounded),
                                    label: Text("SuperGenPass Repository"),
                                  )
                          ],
                        ),
                      ]),
                )
              ],
            ),
          );
        });
  }
}
