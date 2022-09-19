import 'package:hive/hive.dart';
import 'package:kg_passgen/model/general.dart';

class GeneralController {
  static void deleteGeneral(General general) {
    general.delete();
  }

  static void addGeneral(General general, Box box) {
    box.add(general);
  }

  static void updateSelectedConfiguration(General general, int selectedConfig) {
    general.setConfiguration = selectedConfig;
    general.save();
  }

  static void updateShowGuide(General general, bool showGuide) {
    general.showGuide = showGuide;
    general.save();
  }

  static void updateShowChangelog(General general, bool showChangelog) {
    general.showChangelog = showChangelog;
    general.save();
  }

  static void updateAppLocale(General general, String locale) {
    general.locale = locale;
    general.save();
  }
}
