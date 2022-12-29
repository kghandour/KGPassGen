import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kg_passgen/controller/boxes.dart';
import 'package:kg_passgen/helper/init_values.dart';
import 'package:kg_passgen/model/configuration.dart';
import 'package:kg_passgen/model/general.dart';
import 'package:kg_passgen/presentation/pages/configuration_page.dart';
import 'package:kg_passgen/presentation/pages/home_page.dart';
import 'package:kg_passgen/presentation/pages/privacy_policy.dart';
import 'package:kg_passgen/presentation/pages/splash/splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kg_passgen/presentation/pages/whats_new.dart';
import 'package:kg_passgen/presentation/themes/dark_theme.dart';
import 'package:kg_passgen/presentation/themes/light_theme.dart';
import 'package:kg_passgen/presentation/widgets/multi_view_listenable_builder.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/foundation.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized;

  await Hive.initFlutter();
  Hive.registerAdapter(ConfigurationAdapter());
  Hive.registerAdapter(GeneralAdapter());

  await Hive.openBox<Configuration>('configurations');

  await Hive.openBox<General>('general');

  if (defaultTargetPlatform == TargetPlatform.isWindows || TargetPlatform.isLinux || TargetPlatform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(600, 500),
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

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
        final general = inits[3] as General;

        var localeSet = Locale(general.locale);

        var darkMode = general.darkMode;

        var showSplash = general.showGuide;

        return MaterialApp(
          title: 'KG Password Generator',
          localizationsDelegates: const [
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
                pageBuilder: (_, __, ___) => const HomePage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              );
            }
            if (settings.name == "/splash") {
              return PageRouteBuilder(
                settings:
                    settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
                pageBuilder: (_, __, ___) => const OnboardingPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              );
            }
            if (settings.name == "/privacy") {
              return PageRouteBuilder(
                settings:
                    settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
                pageBuilder: (_, __, ___) => const PrivacyPolicy(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              );
            }
            if (settings.name == "/configurations") {
              return PageRouteBuilder(
                settings:
                    settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
                pageBuilder: (_, __, ___) => const ConfigurationPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              );
            }
            if (settings.name == "/whatsnew") {
              return PageRouteBuilder(
                settings:
                    settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
                pageBuilder: (_, __, ___) => const WhatsNewPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              );
            }
            // Unknown route
            return MaterialPageRoute(
                builder: (_) =>
                    showSplash ? const OnboardingPage() : const HomePage());
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
