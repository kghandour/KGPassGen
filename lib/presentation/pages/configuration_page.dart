import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kg_passgen/controller/boxes.dart';
import 'package:kg_passgen/controller/configuration_controller.dart';
import 'package:kg_passgen/controller/general_controller.dart';
import 'package:kg_passgen/helper/init_values.dart';
import 'package:kg_passgen/model/configuration.dart';
import 'package:kg_passgen/model/general.dart';
import 'package:kg_passgen/presentation/widgets/multi_view_listenable_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kg_passgen/presentation/widgets/drawer.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  ConfigurationPageState createState() => ConfigurationPageState();
}

class ConfigurationPageState extends State<ConfigurationPage> {
  final List<Configuration> configurations = [];
  Configuration? selectedConfig;
  bool? showRenameField;

  @override
  void dispose() {
    super.dispose();
  }

  void resetToDefaults(Box configurationBox, Box generalBox) {
    setState(() {
      Configuration config = Configuration();
      config.name = "Default: KGPG";
      ConfigurationController.addConfiguration(config, configurationBox);
      Configuration sgpConfig = Configuration();
      sgpConfig.name = "Default: SGP";
      sgpConfig.hashingAlgorithm = true;
      sgpConfig.pwLength = 10;
      ConfigurationController.addConfiguration(sgpConfig, configurationBox);
      General general = General();
      GeneralController.addGeneral(general, generalBox);

      List inits = initializeGeneralConfig(configurationBox, generalBox);
      final configurations = inits[0] as List<Configuration>;
      final generalSettings = inits[1] as List<General>;

      for (int i = 0; i < configurations.length - 2; i++) {
        ConfigurationController.deleteConfiguration(configurations[i]);
      }

      for (int i = 0; i < generalSettings.length - 1; i++) {
        GeneralController.deleteGeneral(generalSettings[i]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
      first: Boxes.getGeneral().listenable(),
      second: Boxes.getConfigurations().listenable(),
      builder: (context, generalBox, configurationBox, _) {
        List inits = initializeGeneralConfig(configurationBox, generalBox);
        final configurations = inits[0] as List<Configuration>;
        final config = inits[2] as Configuration;
        final general = inits[3] as General;

        showRenameField ??= false;
        selectedConfig = config;

        final TextEditingController renameController =
            TextEditingController(text: selectedConfig!.name);

        Size screenSize = MediaQuery.of(context).size;
        Orientation orientation = MediaQuery.of(context).orientation;

        bool showSidebar =
            (screenSize.width >= 800 && orientation == Orientation.landscape)
                ? true
                : false;

        String hashingAlgo = "KGPG";
        if (selectedConfig!.hashingAlgorithm) {
          hashingAlgo = "SGP";
        }

        String hashingFn = "MD5";
        if (selectedConfig!.hashingFunction) {
          hashingFn = "SHA512";
        }

        return Scaffold(
          drawer: !showSidebar ? const NavigationDrawer() : null,
          body: Builder(builder: (scaffoldContext) {
            return SafeArea(
              child: Row(
                children: [
                  if (showSidebar) const NavigationSidebar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          // Page Title
                          Row(
                            children: [
                              if (!showSidebar)
                                IconButton(
                                    onPressed: () {
                                      Scaffold.of(scaffoldContext).openDrawer();
                                    },
                                    icon: const Icon(Icons.menu)),
                              Text(
                                AppLocalizations.of(context)!.settings,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
                          ),
                          // Configuration tile
                          upperBarWidget(configurations, general, context,
                              configurationBox, showSidebar),
                          if (showRenameField!)
                            Row(
                              children: [
                                Text(
                                    "${AppLocalizations.of(context)!.rename}: "),
                                SizedBox(
                                  width: 280,
                                  child: TextField(
                                    controller: renameController,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: AppLocalizations.of(context)!
                                          .renameTextField,
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    ConfigurationController.updateName(
                                        selectedConfig!, renameController.text);
                                    showRenameField = false;
                                  },
                                  icon: const Icon(Icons.save),
                                  label:
                                      Text(AppLocalizations.of(context)!.save),
                                ),
                              ],
                            ),

                          configurationSettingsWidget(
                              context, hashingAlgo, hashingFn),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                                "${AppLocalizations.of(context)!.lastModified} ${selectedConfig!.editDate}"),
                          ),
                          generalSettingsWidget(context, general),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.restore),
                            onPressed: () {
                              setState(() {
                                resetToDefaults(configurationBox, generalBox);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                minimumSize: const Size.fromHeight(60)),
                            label: Text(
                              AppLocalizations.of(context)!.resetToDefaults,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Column generalSettingsWidget(BuildContext context, General general) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.generalSettings,
          style: Theme.of(context).textTheme.headline6,
        ),
        Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListTile(
                  leading: Text(
                    AppLocalizations.of(context)!.appLanguage,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  trailing: DropdownButton<Locale>(
                    value: AppLocalizations.supportedLocales.firstWhere(
                        (Locale element) =>
                            element.languageCode == general.locale),
                    items: AppLocalizations.supportedLocales
                        .map<DropdownMenuItem<Locale>>((Locale option) {
                      String languageOption = "English";
                      if (option.languageCode == "en") {
                        languageOption = "English";
                      }
                      if (option.languageCode == "ar") {
                        languageOption = "العربية";
                      }
                      return DropdownMenuItem<Locale>(
                        value: option,
                        child: Text(languageOption),
                      );
                    }).toList(),
                    onChanged: (Locale? option) {
                      // This is called when the user selects an item.
                      setState(() {
                        GeneralController.updateAppLocale(
                            general, option!.languageCode);
                      });
                    },
                  ),
                ),
                CheckboxListTile(
                    title: Text(AppLocalizations.of(context)!.darkMode),
                    value: general.darkMode,
                    onChanged: (value) {
                      setState(() {
                        GeneralController.updateDarkMode(general, value!);
                      });
                    })
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column configurationSettingsWidget(
      BuildContext context, String hashingAlgo, String hashingFn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.configurationSettings,
          style: Theme.of(context).textTheme.headline6,
        ),
        Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SwitchListTile(
                    title: Text(
                        "${AppLocalizations.of(context)!.hashingAlgorithm} $hashingAlgo"),
                    subtitle: Text(AppLocalizations.of(context)!
                        .hashingAlgorithmDescription),
                    value: selectedConfig!.hashingAlgorithm,
                    onChanged: (bool value) {
                      setState(() {
                        ConfigurationController.updateHashingAlgorith(
                            selectedConfig!, value);
                      });
                    }),
                const Divider(),
                SwitchListTile(
                    title: Text(
                        "${AppLocalizations.of(context)!.hashingFunction} $hashingFn"),
                    subtitle: Text(AppLocalizations.of(context)!
                        .hashingFunctionDescription),
                    value: selectedConfig!.hashingFunction,
                    onChanged: (bool value) {
                      setState(() {
                        ConfigurationController.updateHashingFunction(
                            selectedConfig!, value);
                      });
                    }),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.generatedPWLength,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Row(
                          children: [
                            if (selectedConfig!.pwLength > 8)
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => setState(() {
                                  ConfigurationController.updatePWLength(
                                      selectedConfig!,
                                      selectedConfig!.pwLength - 1);
                                }),
                              ),
                            Text(selectedConfig!.pwLength.toString()),
                            if (selectedConfig!.pwLength < 24)
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => setState(() {
                                  ConfigurationController.updatePWLength(
                                      selectedConfig!,
                                      selectedConfig!.pwLength + 1);
                                }),
                              ),
                          ],
                        ),
                      ]),
                ),
                const Divider(),
                CheckboxListTile(
                  title: Text(AppLocalizations.of(context)!.validatePassword),
                  subtitle: Text(
                      AppLocalizations.of(context)!.validatePasswordSubtitle),
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
                  title: Text(AppLocalizations.of(context)!.stripSubdomain),
                  subtitle: Text(
                      AppLocalizations.of(context)!.stripSubdomainSubtitle),
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
      ],
    );
  }

  Row upperBarWidget(
      List<Configuration> configurations,
      General general,
      BuildContext context,
      Box<Configuration> configurationBox,
      bool largeSize) {
    return Row(
      children: [
        DropdownButton<Configuration>(
          value: selectedConfig,
          items: configurations
              .map<DropdownMenuItem<Configuration>>((Configuration option) {
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
            setState(() {
              showRenameField = !showRenameField!;
            });
          },
          icon: const Icon(Icons.edit),
          label: Text(AppLocalizations.of(context)!.rename),
        ),
        largeSize
            ? TextButton.icon(
                onPressed: () {
                  setState(() {
                    Configuration newConfig = Configuration();
                    newConfig.name = "Configuration ${configurations.length}";
                    ConfigurationController.addConfiguration(
                        newConfig, configurationBox);
                    GeneralController.updateSelectedConfiguration(
                        general, newConfig.key);
                  });
                },
                icon: const Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.newConfig),
              )
            : IconButton(
                onPressed: () {
                  setState(() {
                    Configuration newConfig = Configuration();
                    newConfig.name = "Configuration ${configurations.length}";
                    ConfigurationController.addConfiguration(
                        newConfig, configurationBox);
                    GeneralController.updateSelectedConfiguration(
                        general, newConfig.key);
                  });
                },
                icon: const Icon(Icons.add)),
        largeSize
            ? TextButton.icon(
                onPressed: () {
                  if (configurations.length > 1) {
                    ConfigurationController.deleteConfiguration(
                        selectedConfig!);
                    configurations.remove(selectedConfig);
                    GeneralController.updateSelectedConfiguration(
                        general, configurations[0].key);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.deleteError)));
                  }
                },
                icon: const Icon(Icons.remove),
                label: Text(AppLocalizations.of(context)!.delete),
              )
            : IconButton(
                onPressed: () {
                  if (configurations.length > 1) {
                    ConfigurationController.deleteConfiguration(
                        selectedConfig!);
                    configurations.remove(selectedConfig);
                    GeneralController.updateSelectedConfiguration(
                        general, configurations[0].key);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.deleteError)));
                  }
                },
                icon: const Icon(Icons.delete)),
      ],
    );
  }
}
