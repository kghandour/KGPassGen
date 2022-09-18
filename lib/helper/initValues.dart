import 'dart:developer';

import 'package:kg_passgen/controller/configuration_controller.dart';
import 'package:kg_passgen/controller/general_controller.dart';
import 'package:kg_passgen/model/general.dart';

import '../model/configuration.dart';

List initializeGeneralConfig(configurationBox, generalBox) {
  final configurations = configurationBox.values.toList().cast<Configuration>();
  final generalOptions = generalBox.values.toList().cast<General>();

  Configuration config;
  General general;
  if (generalOptions.length == 0) {
    general = General();
    GeneralController.addGeneral(general, generalBox);
  } else {
    general = generalOptions.first;
  }

  if (configurations.length == 0) {
    config = Configuration();
    ConfigurationController.addConfiguration(config, configurationBox);
  } else {
    config = configurations[general.setConfiguration];
  }

  return [configurations, generalOptions, config, general];
}
