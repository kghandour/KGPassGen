import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kg_passgen/controller/boxes.dart';
import 'package:kg_passgen/helper/initValues.dart';
import 'package:kg_passgen/model/configuration.dart';
import 'package:kg_passgen/model/general.dart';
import 'package:kg_passgen/presentation/pages/configuration_page.dart';
import 'package:kg_passgen/presentation/pages/home_page.dart';
import 'package:kg_passgen/presentation/pages/splash/splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kg_passgen/presentation/widgets/MultiValueListenableBuilder.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized;

  await Hive.initFlutter();
  Hive.registerAdapter(ConfigurationAdapter());
  Hive.registerAdapter(GeneralAdapter());

  await Hive.openBox<Configuration>('configurations');

  await Hive.openBox<General>('general');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
      first: Boxes.getGeneral().listenable(),
      second: Boxes.getConfigurations().listenable(),
      builder: (context, generalBox, configurationBox, _) {
        List inits = initializeGeneralConfig(configurationBox, generalBox);
        final config = inits[2] as Configuration;
        final general = inits[3] as General;

        var localeSet = Locale(general.locale);
        if (localeSet == null) localeSet = Locale('en', '');

        var darkMode = general.darkMode;
        if (darkMode == null) darkMode = false;

        return MaterialApp(
          title: 'KG Password Generator',
          localizationsDelegates: [
            AppLocalizations.delegate, // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: localeSet,
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => OnboardingPage(),
            '/home': (context) => HomePage(),
            '/splash': (context) => OnboardingPage(),
            '/configurations': (context) => ConfigurationPage(),
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Locale activeLocale = Localizations.localeOf(context);
    // If our active locale is fr_CA
    debugPrint(activeLocale.languageCode); // => fr
    debugPrint(activeLocale.countryCode); // => CA

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/configurations');
              },
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red.shade400,
                  minimumSize: const Size.fromHeight(120)),
              child: Text(
                'Configurations',
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
