import 'package:flutter/material.dart';
import 'package:kg_passgen/presentation/widgets/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    bool _showSidebar =
        (screenSize.width >= 800 && orientation == Orientation.landscape)
            ? true
            : false;

    return Scaffold(
        drawer: NavigationDrawer(),
        body: Builder(builder: (scaffoldContext) {
          return SafeArea(
              child: Row(children: [
            if (_showSidebar) NavigationSidebar(),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Row(
                    children: [
                      if (!_showSidebar)
                        IconButton(
                            onPressed: () {
                              Scaffold.of(scaffoldContext).openDrawer();
                            },
                            icon: Icon(Icons.menu)),
                      Text(
                        AppLocalizations.of(context)!.privacyPolicy,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(
                        AppLocalizations.of(context)!.privacyPolicyText),
                  ),
                ],
              ),
            ))
          ]));
        }));
  }
}
