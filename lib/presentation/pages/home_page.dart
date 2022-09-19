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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _masterPasswordController = TextEditingController();

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

        Configuration selectedConfig = config;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Row(
                        children: [
                          Text("KGPG"),
                          Switch(
                            value: selectedConfig.hashingAlgorithm,
                            onChanged: (val) {
                              setState(() {
                                ConfigurationController.updateHashingAlgorith(
                                    config, val);
                              });
                            },
                          ),
                          Text("SGP"),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/configurations');
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                        ),
                        label: Text(AppLocalizations.of(context)!.settings),
                      )
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text("Website url"),
                        TextFormField(
                          controller: _urlController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter the website URL',
                          ),
                          keyboardType: TextInputType.url,
                          validator: (url) {
                            if (url == null || url.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        Text("Master Password"),
                        TextFormField(
                          controller: _masterPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter the master password',
                          ),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (password) {
                            if (password == null || password.isEmpty) {
                              return 'Please enter a valid password';
                            }
                            return null;
                          },
                        ),
                      ],
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
