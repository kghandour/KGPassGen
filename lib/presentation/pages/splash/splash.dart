import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kg_passgen/controller/boxes.dart';
import 'package:kg_passgen/controller/general_controller.dart';
import 'package:kg_passgen/helper/initValues.dart';
import 'package:kg_passgen/model/configuration.dart';
import 'package:kg_passgen/model/general.dart';
import 'package:kg_passgen/presentation/widgets/MultiValueListenableBuilder.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:kg_passgen/presentation/pages/splash/page_template.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnboardingPageState();
  }
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        first: Boxes.getGeneral().listenable(),
        second: Boxes.getConfigurations().listenable(),
        builder: (context, generalBox, configurationBox, _) {
          List inits = initializeGeneralConfig(configurationBox, generalBox);
          final configurations = inits[0] as List<Configuration>;
          final generalSettings = inits[1];
          final config = inits[2] as Configuration;
          final general = inits[3] as General;

          Size screenSize = MediaQuery.of(context).size;
          Orientation orientation = MediaQuery.of(context).orientation;

          bool _wideScreen =
              (screenSize.width >= 800 && orientation == Orientation.landscape)
                  ? true
                  : false;

          return Scaffold(
            body: Container(
              padding: const EdgeInsets.only(bottom: 120),
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == 2;
                  });
                },
                children: [
                  ListView(
                    children: [
                      splashTemplate(
                        context: context,
                        urlImage: 'assets/splash-1.png',
                        color: Colors.indigo,
                        title: AppLocalizations.of(context)!.splash_1_1_title,
                        subtitle:
                            AppLocalizations.of(context)!.splash_1_1_subtitle,
                      ),
                      splashTemplate(
                        context: context,
                        urlImage: 'assets/splash-2.png',
                        color: Colors.indigo,
                        title: AppLocalizations.of(context)!.splash_1_2_title,
                        subtitle:
                            AppLocalizations.of(context)!.splash_1_2_subtitle,
                      ),
                      splashTemplate(
                          context: context,
                          urlImage: 'assets/splash-3.png',
                          color: Colors.indigo,
                          title: AppLocalizations.of(context)!.splash_1_3_title,
                          subtitle: AppLocalizations.of(context)!
                              .splash_1_3_subtitle),
                    ],
                  ),
                  singleSplashTemplate(
                    context: context,
                    urlImage: 'assets/MainInterface.png',
                    color: Colors.indigo,
                    title: AppLocalizations.of(context)!.splash_2_title,
                    subtitle: AppLocalizations.of(context)!.splash_2_subtitle,
                  ),
                  singleSplashTemplate(
                    context: context,
                    urlImage: 'assets/MultiConfig.png',
                    color: Colors.green,
                    title: AppLocalizations.of(context)!.splash_3_title,
                    subtitle: AppLocalizations.of(context)!.splash_3_subtitle,
                  ),
                ],
              ),
            ),
            bottomSheet: isLastPage
                ? TextButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red.shade400,
                        minimumSize: const Size.fromHeight(120)),
                    onPressed: () async {
                      GeneralController.updateShowGuide(general, false);
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    child: Text(
                      AppLocalizations.of(context)!.getStarted,
                    ))
                : InProgress(controller: controller),
          );
        });
  }
}

class InProgress extends StatelessWidget {
  const InProgress({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () => controller.jumpToPage(2),
              child: Text(
                AppLocalizations.of(context)!.skip,
              )),
          Center(
            child: SmoothPageIndicator(
              controller: controller,
              count: 3,
              onDotClicked: (index) => controller.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut),
            ),
          ),
          TextButton(
              onPressed: () => controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut),
              child: Text(
                AppLocalizations.of(context)!.next,
              ))
        ],
      ),
    );
  }
}
