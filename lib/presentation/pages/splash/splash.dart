import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:kg_passgen/presentation/pages/splash/page_template.dart';

class OnboardingPageState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnboardingPageState();
  }
}

class _OnboardingPageState extends State<OnboardingPageState> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 120),
        child: PageView(
          controller: controller,
          children: [
            splashTemplate(
              color: Colors.red,
              title: 'No need to memorize multiple passwords',
              subtitle:
                  'Now you only need to know one (master) password. The generator will handle the rest for you',
            ),
            splashTemplate(
              color: Colors.indigo,
              title: 'More security for you',
              subtitle:
                  'Create unique passwords for each website that you are using. That way you are more secure!',
            ),
            splashTemplate(
              color: Colors.green,
              title: 'Zero data transmitted. Completely free.',
              subtitle:
                  'No backend, no database, no tracking. Completely open-source.',
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () => controller.jumpToPage(2),
                child: const Text('Skip')),
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
                child: const Text('Next'))
          ],
        ),
      ),
    );
  }
}
