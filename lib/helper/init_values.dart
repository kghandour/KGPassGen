import 'package:hive/hive.dart';
import 'package:kg_passgen/controller/configuration_controller.dart';
import 'package:kg_passgen/controller/general_controller.dart';
import 'package:kg_passgen/model/general.dart';

import '../model/configuration.dart';

List initializeGeneralConfig(Box configurationBox, Box generalBox) {
  final configurations = configurationBox.values.toList().cast<Configuration>();
  final generalOptions = generalBox.values.toList().cast<General>();

  Configuration config;
  General general;
  if (generalOptions.isEmpty) {
    general = General();
    GeneralController.addGeneral(general, generalBox);
  } else {
    general = generalOptions.first;
  }

  if (configurations.isEmpty) {
    config = Configuration();
    config.name = "Default: KGPG";
    ConfigurationController.addConfiguration(config, configurationBox);
    Configuration sgpConfig = Configuration();
    sgpConfig.name = "Default: SGP";
    sgpConfig.hashingAlgorithm = true;
    sgpConfig.pwLength = 10;
    ConfigurationController.addConfiguration(sgpConfig, configurationBox);
  } else {
    config = configurations[0];
    if (general.setConfiguration != 0) {
      config = configurationBox.get(general.setConfiguration);
    }
  }

  return [configurations, generalOptions, config, general];
}
