import 'package:hive/hive.dart';

part 'general.g.dart';

@HiveType(typeId: 1)
class General extends HiveObject {
  @HiveField(0)
  late bool showGuide = true;

  @HiveField(1)
  late bool showChangelog = true;

  @HiveField(2)
  late int setConfiguration = 0;

  @HiveField(3)
  late String locale = "en";

  @HiveField(4)
  late bool darkMode = false;
}
