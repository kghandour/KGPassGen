import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kg_passgen/controller/boxes.dart';
import 'package:kg_passgen/controller/configuration_controller.dart';
import 'package:kg_passgen/helper/initValues.dart';
import 'package:kg_passgen/model/configuration.dart';
import 'package:kg_passgen/model/general.dart';
import 'package:kg_passgen/presentation/widgets/MultiValueListenableBuilder.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final List<Configuration> configurations = [];
  Configuration? selectedConfig;

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

        String hashingAlgo = "KGP";
        selectedConfig ??= config;
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
                  Text(
                    "Settings",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  ListTile(
                    leading: DropdownButton<Configuration>(
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
                          selectedConfig = option!;
                          log(selectedConfig!.name.toString());
                        });
                      },
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        Configuration newConfig = Configuration();
                        newConfig.name =
                            "Configuration " + configurations.length.toString();
                        ConfigurationController.addConfiguration(
                            newConfig, configurationBox);
                      },
                      child: Text("New Configuration"),
                    ),
                  ),
                  Text("Last modified " + selectedConfig!.editDate.toString()),
                  Text(
                    "General Settings",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      children: [
                        SwitchListTile(
                            title: Text("Hashing Algorithm: " + hashingAlgo),
                            subtitle: Text(
                                "Options:\nKGP generates a higher complexity passwords that must contain Uppercase, lowercase, symbols and numbers.\nSGP generates a password that contains Uppercase, lowercase and numbers."),
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
                        Text(selectedConfig!.createdDate.toString()),
                        Text(selectedConfig!.pwLength.toString()),
                        Text(selectedConfig!.hashingAlgorithm.toString()),
                        Text("Show Guide" + general.showGuide.toString()),
                      ],
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
                    child: Text(
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
