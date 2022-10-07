import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(child: DrawerList());
  }
}

class NavigationSidebar extends StatelessWidget {
  const NavigationSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      width: 285,
      child: const DrawerList(),
    );
  }
}

class DrawerList extends StatelessWidget {
  const DrawerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text(AppLocalizations.of(context)!.homePage),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(AppLocalizations.of(context)!.settings),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/configurations');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bookmark),
                  title: Text(AppLocalizations.of(context)!.whatsNew),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/whatsnew');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: Text(AppLocalizations.of(context)!.privacyPolicy),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/privacy');
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: Text(AppLocalizations.of(context)!.splashTitle),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/splash');
              },
            ),
          ],
        ),
      ),
    );
  }
}
