import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kg_passgen/controller/boxes.dart';
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

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
      first: Boxes.getGeneral().listenable(),
      second: Boxes.getConfigurations().listenable(),
      builder: (context, generalBox, configurationBox, _) {
        List inits = initializeGeneralConfig(configurationBox, generalBox);
        final configurations = inits[0];
        final generalSettings = inits[1];
        final config = inits[2];
        final general = inits[3];

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
      },
    );
  }
}
