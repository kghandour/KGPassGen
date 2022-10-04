import 'package:flutter/material.dart';
import 'package:kg_passgen/controller/whatsNew_controller.dart';
import 'package:kg_passgen/presentation/widgets/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WhatsNewPage extends StatefulWidget {
  const WhatsNewPage({super.key});

  @override
  State<WhatsNewPage> createState() => _WhatsNewPageState();
}

class _WhatsNewPageState extends State<WhatsNewPage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    bool _showSidebar =
        (screenSize.width >= 800 && orientation == Orientation.landscape)
            ? true
            : false;
    int _easterEggHits = 0;

    return Scaffold(
      drawer: !_showSidebar ? NavigationDrawer() : null,
      body: Builder(
        builder: (scaffoldContext) {
          return SafeArea(
            child: Row(
              children: [
                if (_showSidebar) NavigationSidebar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        whatsNewWidget(_showSidebar, scaffoldContext, context),
                        otherDevicesWidget(context),
                        aboutKGWidget(context, _easterEggHits),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Column aboutKGWidget(BuildContext context, int _easterEggHits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.whatsNewAbout,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        GestureDetector(
          onTap: () {
            _easterEggHits += 1;
            if (_easterEggHits < 2)
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    AppLocalizations.of(context)!.whatsNewEasterEggSnackBar),
              ));
            if (_easterEggHits >= 2) {
              setState(() {
                showDialog(
                    context: context, builder: (context) => easterEgg(context));
              });
            }
          },
          child: Card(
            elevation: 5,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(AppLocalizations.of(context)!.whatsNewAboutText),
            ),
          ),
        ),
      ],
    );
  }

  Column otherDevicesWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.getOtherDevices,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                    AppLocalizations.of(context)!.getOtherDevicesText),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      ElevatedButton(
                        onPressed: WhatsNewController.launchWeb,
                        child: Text(
                            AppLocalizations.of(context)!.whatsNewLaunchWeb),
                      ),
                      ElevatedButton(
                        onPressed: WhatsNewController.launchGithub,
                        child: Text(
                            AppLocalizations.of(context)!.whatsNewLaunchGithub),
                      ),
                      ElevatedButton(
                        onPressed: WhatsNewController.launchDownloadLinks,
                        child: Text(AppLocalizations.of(context)!
                            .whatsNewLaunchDownload),
                      ),
                      ElevatedButton(
                        onPressed: WhatsNewController.launchPlaystore,
                        child: Text(AppLocalizations.of(context)!
                            .whatsNewLaunchPlaystore),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column whatsNewWidget(
      bool _showSidebar, BuildContext scaffoldContext, BuildContext context) {
    return Column(
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
              AppLocalizations.of(context)!.whatsNew,
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
        Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SelectableText(AppLocalizations.of(context)!.changeLog),
          ),
        ),
      ],
    );
  }

  AlertDialog easterEgg(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.whatsNewEasterEggTitle),
      content: Text(AppLocalizations.of(context)!.whatsNewEasterEggText),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
          child: Text(AppLocalizations.of(context)!.whatsNewEasterEggButton),
        ),
      ],
    );
  }
}