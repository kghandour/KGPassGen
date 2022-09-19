import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kg_passgen/controller/boxes.dart';
import 'package:kg_passgen/controller/configuration_controller.dart';
import 'package:kg_passgen/controller/general_controller.dart';
import 'package:kg_passgen/helper/initValues.dart';
import 'package:kg_passgen/model/configuration.dart';
import 'package:kg_passgen/model/general.dart';
import 'package:kg_passgen/presentation/widgets/MultiValueListenableBuilder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final List<Configuration> configurations = [];
  Configuration? selectedConfig;
  bool? showRenameField;

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

        if (showRenameField == null) showRenameField = false;
        selectedConfig = config;

        final TextEditingController _renameController =
            TextEditingController(text: selectedConfig!.name);

        String hashingAlgo = "KGP";
        if (selectedConfig!.hashingAlgorithm) {
          hashingAlgo = "SGP";
        }

        String hashingFn = "MD5";
        if (selectedConfig!.hashingFunction) {
          hashingFn = "SHA512";
        }

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Page Title
                  Text(
                    AppLocalizations.of(context)!.settings,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  // Configuration tile
                  Row(
                    children: [
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
                            GeneralController.updateSelectedConfiguration(
                                general, option!.key);
                          });
                        },
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Configuration newConfig = Configuration();
                          newConfig.name = "Configuration " +
                              configurations.length.toString();
                          ConfigurationController.addConfiguration(
                              newConfig, configurationBox);
                        },
                        icon: Icon(Icons.add),
                        label: Text(AppLocalizations.of(context)!.newConfig),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          if (configurations.length > 1) {
                            ConfigurationController.deleteConfiguration(
                                selectedConfig!);
                            configurations.remove(selectedConfig);
                            GeneralController.updateSelectedConfiguration(
                                general, configurations[0].key);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "There must exist a single configuration.")));
                          }
                        },
                        icon: Icon(Icons.remove),
                        label: Text(AppLocalizations.of(context)!.delete),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            showRenameField = !showRenameField!;
                          });
                        },
                        icon: Icon(Icons.edit),
                        label: Text(AppLocalizations.of(context)!.rename),
                      ),
                    ],
                  ),
                  if (showRenameField!)
                    Row(
                      children: [
                        Container(
                          width: 280,
                          child: TextField(
                            controller: _renameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText:
                                  AppLocalizations.of(context)!.renameTextField,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            ConfigurationController.updateName(
                                selectedConfig!, _renameController.text);
                            showRenameField = false;
                          },
                          icon: Icon(Icons.save),
                          label: Text(AppLocalizations.of(context)!.save),
                        ),
                      ],
                    ),
                  Text(AppLocalizations.of(context)!.lastModified +
                      " " +
                      selectedConfig!.editDate.toString()),
                  Text(
                    AppLocalizations.of(context)!.generalSettings,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SwitchListTile(
                              title: Text(AppLocalizations.of(context)!
                                      .hashingAlgorithm +
                                  " " +
                                  hashingAlgo),
                              subtitle: Text(AppLocalizations.of(context)!
                                  .hashingAlgorithmDescription),
                              value: selectedConfig!.hashingAlgorithm,
                              onChanged: (bool value) {
                                setState(() {
                                  ConfigurationController.updateHashingAlgorith(
                                      selectedConfig!, value);
                                });
                              }),
                          Divider(),
                          SwitchListTile(
                              title: Text("Hashing Function: " + hashingFn),
                              subtitle: Text("Options:\nMD5 or SHA512."),
                              value: selectedConfig!.hashingFunction,
                              onChanged: (bool value) {
                                setState(() {
                                  ConfigurationController.updateHashingFunction(
                                      selectedConfig!, value);
                                });
                              }),
                          Divider(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Generated Password Length",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () => setState(() {
                                          ConfigurationController
                                              .updatePWLength(selectedConfig!,
                                                  selectedConfig!.pwLength - 1);
                                        }),
                                      ),
                                      Text(selectedConfig!.pwLength.toString()),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () => setState(() {
                                          ConfigurationController
                                              .updatePWLength(selectedConfig!,
                                                  selectedConfig!.pwLength + 1);
                                        }),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Divider(),
                          CheckboxListTile(
                            title: Text("Validate Input Password"),
                            value: selectedConfig!.validateInputpw,
                            onChanged: (value) {
                              log(value.toString());
                              setState(() {
                                ConfigurationController.updateValInputPw(
                                    selectedConfig!, value!);
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Strip subdomain"),
                            value: selectedConfig!.stripSubDomain,
                            onChanged: (value) {
                              log(value.toString());
                              setState(() {
                                ConfigurationController.updateStripSubdomain(
                                    selectedConfig!, value!);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red.shade400,
                        minimumSize: const Size.fromHeight(120)),
                    child: const Text(
                      'Home',
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
