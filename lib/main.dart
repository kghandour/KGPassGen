import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:kg_passgen/Screens/Home/home_screen.dart';
import 'package:kg_passgen/Screens/Settings/settings_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kg_passgen/Screens/Tips/tips_screen.dart';
import 'package:kg_passgen/CustomTheme.dart';
import 'package:url_launcher/url_launcher.dart';

var settingsBox;

void main() async {
  await Hive.initFlutter();
  settingsBox = await Hive.openBox('settings');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KG Password Generator',
      theme: CustomTheme.darkTheme,
      home: AppManager(title: 'KG Password Generator'),
    );
  }
}

class AppManager extends StatefulWidget {
  AppManager({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  AppManagerState createState() => AppManagerState();
}

class AppManagerState extends State<AppManager> {
  int _selectedIndex = 0;
  GlobalKey<HomePageState> _myKey = GlobalKey();
  GlobalKey<SettingsPageState> _settingsKey = GlobalKey();

  Future<void> _showAboutDialog() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About this application'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'KG Password Generator provides a method of generating secure passwords that matches today\'s standards of security. Users can choose between two modes, SGP (SupergenPass - an older version) and KGPassGen (improved version of the SGP algorithm)'),
              ],
            ),
          ),
          actions: <Widget>[
            Text("v" + packageInfo.version + "+" + packageInfo.buildNumber),
            // TextButton(
            //   child: Text('Approve'),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
          ],
        );
      },
    );
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _settingsKey.currentState?.kgLenFocus?.unfocus();
      _settingsKey.currentState?.sgpLenFocus?.unfocus();
      if (index == 0) {
        _myKey.currentState?.forceShowButton();
      }
    });
  }

  bool _isTooShort = false;
  bool _isTooWide = false;

  Widget appContent() {
    return Container(
      child: Center(
        child: IndexedStack(
          children: <Widget>[
            HomePage(
              key: _myKey,
            ),
            SettingsPage(
              key: _settingsKey,
            ),
            TipsPage()
          ],
          index: _selectedIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (height <= 380)
      setState(() => _isTooShort = true);
    else
      setState(() => _isTooShort = false);

    if (width >= 800)
      setState(() {
        _isTooWide = true;
      });
    else
      setState(() {
        _isTooWide = false;
      });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
              itemBuilder: (_) => <PopupMenuItem<String>>[
                    if (_isTooShort)
                      new PopupMenuItem<String>(
                          child: TextButton.icon(
                        onPressed: () => _onItemTapped(0),
                        icon: const Icon(Icons.home),
                        label: Text(
                          "Home",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )),
                    if (_isTooShort)
                      new PopupMenuItem<String>(
                          child: TextButton.icon(
                        onPressed: () => _onItemTapped(1),
                        icon: Icon(Icons.settings),
                        label: Text(
                          "Settings",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )),
                    if (_isTooShort)
                      new PopupMenuItem<String>(
                          child: TextButton.icon(
                        onPressed: () => _onItemTapped(2),
                        icon: Icon(Icons.help),
                        label: Text(
                          "Tips",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )),
                    new PopupMenuItem<String>(
                        child: TextButton.icon(
                      onPressed: () => launch('mailto:feedback@kghandour.com'),
                      icon: Icon(Icons.mail),
                      label: Text(
                        "Send Feedback",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )),
                    new PopupMenuItem<String>(
                        child: TextButton.icon(
                      onPressed: () => launch('https://kghandour.com'),
                      icon: Icon(Icons.link),
                      label: Text(
                        "Visit KGhandour Website",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )),
                    new PopupMenuItem<String>(
                        child: TextButton.icon(
                      onPressed: () => launch('https://supergenpass.com'),
                      icon: Icon(Icons.link),
                      label: Text(
                        "Visit SGP Website",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )),
                    new PopupMenuItem<String>(
                        child: TextButton.icon(
                      onPressed: () => _showAboutDialog(),
                      icon: Icon(Icons.info),
                      label: Text(
                        "About",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )),
                  ])
        ],
      ),
      body: _isTooWide
          ? Center(
              child: SizedBox(
                width: 800,
                child: appContent(),
              ),
            )
          : appContent(),
      bottomNavigationBar: _isTooShort
          ? null
          : BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.help),
                  label: 'Tips',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.red,
              onTap: _onItemTapped,
            ),
    );
  }
}
