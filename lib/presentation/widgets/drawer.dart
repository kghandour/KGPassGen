import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(child: DrawerList());
  }
}

class NavigationSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DrawerList(),
      width: 285,
    );
  }
}

class DrawerList extends StatelessWidget {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Text("Sidebar"),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(AppLocalizations.of(context)!.homePage),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.settings),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/configurations');
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text(AppLocalizations.of(context)!.privacyPolicy),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/privacy');
              },
            ),
          ],
        ),
      ),
    );
  }
}
