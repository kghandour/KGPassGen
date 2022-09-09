import 'package:hive/hive.dart';
import 'package:kg_passgen/model/configuration.dart';

class Boxes {
  static Box<Configuration> getConfigurations() =>
      Hive.box<Configuration>('configurations');
}
