import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kg_passgen/controller/boxes.dart';
import 'package:kg_passgen/controller/configuration_controller.dart';
import 'package:kg_passgen/model/configuration.dart';

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
        builder: (context, box, _) {
          final configurations = box.values.toList().cast<Configuration>();
          Configuration config;
          if (configurations.length == 0) {
            log("Empty list, creating configuration");
            config = Configuration();
            ConfigurationController.addConfiguration(config, box);
          } else {
            config = configurations.first;
          }
          return Column(
            children: [
              Text(config.name),
              Text(config.createdDate.toString()),
              Text(config.pwLength.toString()),
              Text(config.hashingAlgorithm.toString()),
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
  }
}
