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
import 'package:kg_passgen/presentation/pages/privacyPolicy.dart';
import 'package:kg_passgen/presentation/pages/splash/splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kg_passgen/presentation/pages/whatsNew.dart';
import 'package:kg_passgen/presentation/themes/darkTheme.dart';
import 'package:kg_passgen/presentation/themes/lightTheme.dart';
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

        var showSplash = general.showGuide;
        if (showSplash == null) general.showGuide = true;

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
          darkTheme: DarkTheme.darkTheme,
          theme: LightTheme.lightTheme,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            if (settings.name == "/home") {
              return PageRouteBuilder(
                settings:
                    settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
                pageBuilder: (_, __, ___) => HomePage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              );
            }
            if (settings.name == "/splash") {
              return PageRouteBuilder(
                settings:
                    settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
                pageBuilder: (_, __, ___) => OnboardingPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              );
            }
            if (settings.name == "/privacy") {
              return PageRouteBuilder(
                settings:
                    settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
                pageBuilder: (_, __, ___) => PrivacyPolicy(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              );
            }
            if (settings.name == "/configurations") {
              return PageRouteBuilder(
                settings:
                    settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
                pageBuilder: (_, __, ___) => ConfigurationPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              );
            }
            if (settings.name == "/whatsnew") {
              return PageRouteBuilder(
                settings:
                    settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
                pageBuilder: (_, __, ___) => WhatsNewPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              );
            }
            // Unknown route
            return MaterialPageRoute(
                builder: (_) => showSplash ? OnboardingPage() : HomePage());
          },
          // routes: {
          //   '/': (context) => showSplash ? OnboardingPage() : HomePage(),
          //   '/home': (context) => HomePage(),
          //   '/splash': (context) => OnboardingPage(),
          //   '/configurations': (context) => ConfigurationPage(),
          //   '/privacy': (context) => PrivacyPolicy(),
          // },
        );
      },
    );
  }
}
