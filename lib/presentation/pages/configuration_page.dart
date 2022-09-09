import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kg_passgen/controller/boxes.dart';
import 'package:kg_passgen/controller/configuration_controller.dart';
import 'package:kg_passgen/controller/general_controller.dart';
import 'package:kg_passgen/model/configuration.dart';
import 'package:kg_passgen/model/general.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final List<Configuration> configurations = [];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Configuration>>(
        valueListenable: Boxes.getConfigurations().listenable(),
        builder: (context, configurationBox, _) {
          final configurations =
              configurationBox.values.toList().cast<Configuration>();

          Configuration config;
          if (configurations.length == 0) {
            log("Empty list, creating configuration");
            config = Configuration();
            ConfigurationController.addConfiguration(config, configurationBox);
          } else {
            config = configurations.first;
          }

          return ValueListenableBuilder<Box<General>>(
              valueListenable: Boxes.getGeneral().listenable(),
              builder: (context, generalBox, _) {
                General general;
                final generalOptions =
                    generalBox.values.toList().cast<General>();
                if (generalOptions.length == 0) {
                  log("Empty list, creating configuration");
                  general = General();
                  GeneralController.addGeneral(general, generalBox);
                } else {
                  config = configurations.first;
                  general = generalOptions.first;
                }
                return Column(
                  children: [
                    Text(config.name),
                    Text(config.createdDate.toString()),
                    Text(config.pwLength.toString()),
                    Text(config.hashingAlgorithm.toString()),
                    Text("Show Guide" + general.showGuide.toString()),
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
                );
              });
        });
  }
}
