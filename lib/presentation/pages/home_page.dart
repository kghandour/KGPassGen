import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kg_passgen/controller/boxes.dart';
import 'package:kg_passgen/controller/configuration_controller.dart';
import 'package:kg_passgen/controller/general_controller.dart';
import 'package:kg_passgen/controller/home_controller.dart';
import 'package:kg_passgen/helper/hashing.dart';
import 'package:kg_passgen/helper/initValues.dart';
import 'package:kg_passgen/helper/validation.dart';
import 'package:kg_passgen/model/configuration.dart';
import 'package:kg_passgen/model/general.dart';
import 'package:kg_passgen/presentation/widgets/MultiValueListenableBuilder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kg_passgen/presentation/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _masterPasswordController = TextEditingController();
  bool _showPassword = false;
  bool _showButton = true;
  bool _showGenerated = false;
  String _generatedPassword = "";

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
      first: Boxes.getGeneral().listenable(),
      second: Boxes.getConfigurations().listenable(),
      builder: (context, generalBox, configurationBox, _) {
        List inits = initializeGeneralConfig(configurationBox, generalBox);
        final configurations = inits[0] as List<Configuration>;
        final generalSettings = inits[1];
        final config = inits[2] as Configuration;
        final general = inits[3] as General;

        Size screenSize = MediaQuery.of(context).size;
        Orientation orientation = MediaQuery.of(context).orientation;

        bool _showSidebar =
            (screenSize.width >= 800 && orientation == Orientation.landscape)
                ? true
                : false;

        Configuration selectedConfig = config;

        return Scaffold(
          drawer: !_showSidebar ? NavigationDrawer() : null,
          body: Builder(builder: (scaffoldContext) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    if (_showSidebar) NavigationSidebar(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    if (!_showSidebar)
                                      IconButton(
                                        icon: Icon(Icons.menu),
                                        onPressed: () {
                                          Scaffold.of(scaffoldContext)
                                              .openDrawer();
                                        },
                                      ),
                                    DropdownButton<Configuration>(
                                      value: selectedConfig,
                                      items: configurations
                                          .map<DropdownMenuItem<Configuration>>(
                                              (Configuration option) {
                                        return DropdownMenuItem<Configuration>(
                                          value: option,
                                          child: Text(option.name),
                                        );
                                      }).toList(),
                                      onChanged: (Configuration? option) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          _showButton = true;
                                          GeneralController
                                              .updateSelectedConfiguration(
                                                  general, option!.key);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("KGPG"),
                                    Switch(
                                      value: selectedConfig.hashingAlgorithm,
                                      onChanged: (val) {
                                        setState(() {
                                          _showButton = true;
                                          ConfigurationController
                                              .updateHashingAlgorith(
                                                  config, val);
                                        });
                                      },
                                    ),
                                    Text("SGP"),
                                  ],
                                ),
                              ],
                            ),
                            Form(
                              key: _formKey,
                              onChanged: () {
                                setState(() {
                                  _showButton = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(AppLocalizations.of(context)!
                                      .websiteLabel),
                                  TextFormField(
                                    controller: _urlController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: AppLocalizations.of(context)!
                                          .websiteFieldHint,
                                    ),
                                    keyboardType: TextInputType.url,
                                    validator: (url) {
                                      if (url == null || url.isEmpty) {
                                        return AppLocalizations.of(context)!
                                            .fieldValidation;
                                      } else if (!Validation.urlValidation(
                                          url)) {
                                        return AppLocalizations.of(context)!
                                            .urlValidation;
                                      }
                                      return null;
                                    },
                                  ),
                                  Text(AppLocalizations.of(context)!
                                      .masterPasswordLabel),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          controller: _masterPasswordController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .masterPasswordHint,
                                          ),
                                          obscureText: !_showPassword,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          validator: (password) {
                                            if (password == null ||
                                                password.isEmpty) {
                                              return AppLocalizations.of(
                                                      context)!
                                                  .fieldValidation;
                                            } else if (selectedConfig
                                                    .validateInputpw &&
                                                !Validation.passwordValidation(
                                                    password)) {
                                              return AppLocalizations.of(
                                                      context)!
                                                  .passwordValidation;
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: CheckboxListTile(
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .showPassword),
                                          value: _showPassword,
                                          onChanged: (value) => {
                                            setState(() {
                                              _showPassword = value!;
                                            })
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  _showButton
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize:
                                                const Size.fromHeight(80),
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _generatedPassword =
                                                    Hashing.hopPasswordGen(
                                                        _masterPasswordController
                                                            .text,
                                                        _urlController.text,
                                                        selectedConfig);
                                                _showButton = false;
                                              });
                                            }
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .generatePassword))
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: (() {
                                                  setState(() {
                                                    _showGenerated =
                                                        !_showGenerated;
                                                  });
                                                }),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    _showGenerated == true
                                                        ? _generatedPassword
                                                        : '${_generatedPassword.replaceAll(RegExp(r"."), "*")}',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                HomePageController.copyPassword(
                                                    _generatedPassword,
                                                    context);
                                              },
                                              icon: Icon(Icons.copy),
                                              label: Text(
                                                  AppLocalizations.of(context)!
                                                      .copy),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
