import 'package:flutter/material.dart';
import 'package:kg_passgen/controller/whats_new_controller.dart';
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
    bool showSidebar =
        (screenSize.width >= 800 && orientation == Orientation.landscape)
            ? true
            : false;
    int easterEggHits = 0;

    return Scaffold(
      drawer: !showSidebar ? const NavigationDrawer() : null,
      body: Builder(
        builder: (scaffoldContext) {
          return SafeArea(
            child: Row(
              children: [
                if (showSidebar) const NavigationSidebar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        whatsNewWidget(showSidebar, scaffoldContext, context),
                        otherDevicesWidget(context),
                        aboutKGWidget(context, easterEggHits),
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

  Column aboutKGWidget(BuildContext context, int easterEggHits) {
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
            easterEggHits += 1;
            if (easterEggHits < 2) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    AppLocalizations.of(context)!.whatsNewEasterEggSnackBar),
              ));
            }
            if (easterEggHits >= 2) {
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
      bool showSidebar, BuildContext scaffoldContext, BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (!showSidebar)
              IconButton(
                  onPressed: () {
                    Scaffold.of(scaffoldContext).openDrawer();
                  },
                  icon: const Icon(Icons.menu)),
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
