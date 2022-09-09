import 'package:hive/hive.dart';
import 'package:kg_passgen/model/general.dart';

class GeneralController {
  static void deleteGeneral(General general) {
    general.delete();
  }

  static void addGeneral(General general, Box box) {
    box.add(general);
  }
}
