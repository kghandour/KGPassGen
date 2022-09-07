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
              context: context,
              urlImage: 'assets/splash-1.png',
              color: Colors.white70,
              title: 'One password to rule them all',
              subtitle:
                  'Now you only need to know one (master) password and KG Pass Generator will create a unique password for each website that you would like to visit.',
            ),
            splashTemplate(
              context: context,
              urlImage: 'assets/splash-2.png',
              color: Colors.indigo,
              title: 'More security for you',
              subtitle:
                  'Even if one website you use gets hacked, your other accounts are still secure. Never use the same password for more than one website.',
            ),
            splashTemplate(
              context: context,
              urlImage: 'assets/splash-3.png',
              color: Colors.green,
              title: 'Everything is on your device.',
              subtitle:
                  'Fully Open-source. Completely free.  Nothing is transmitted.',
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
