import 'package:url_launcher/url_launcher.dart';

class WhatsNewController {
  static Future<void> launchWeb() async {
    if (!await launchUrl(Uri.parse('https://www.kghandour.com/KGPassGen/'))) {
      throw 'Could not launch the website';
    }
  }

  static Future<void> launchGithub() async {
    if (!await launchUrl(Uri.parse('https://github.com/kghandour/KGPassGen'))) {
      throw 'Could not launch the website';
    }
  }

  static Future<void> launchPlaystore() async {
    if (!await launchUrl(Uri.parse(
        'https://play.google.com/store/apps/details?id=com.kghandour.kg_password_generator&ref=apkcombo.com'))) {
      throw 'Could not launch the website';
    }
  }

  static Future<void> launchDownloadLinks() async {
    if (!await launchUrl(
        Uri.parse('https://github.com/kghandour/KGPassGen/tags'))) {
      throw 'Could not launch the website';
    }
  }
}
