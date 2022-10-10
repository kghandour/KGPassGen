import 'package:hive/hive.dart';
import 'package:kg_passgen/model/configuration.dart';
import 'package:kg_passgen/model/general.dart';

class Boxes {
  static Box<Configuration> getConfigurations() =>
      Hive.box<Configuration>('configurations');

  static Box<General> getGeneral() => Hive.box<General>('general');
}
