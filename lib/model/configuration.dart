import 'package:hive/hive.dart';

part 'configuration.g.dart';

@HiveType(typeId: 0)
class Configuration extends HiveObject {
  @HiveField(0)
  late String name = "Default";

  @HiveField(1)
  late DateTime createdDate = DateTime.now();

  @HiveField(2)
  late DateTime editDate = DateTime.now();

  @HiveField(3)
  late bool hashingAlgorithm = false; // KGPassGen / SuperGenPass

  @HiveField(4)
  late bool hashingFunction = false; // MD5 / SHA512

  @HiveField(5)
  late int pwLength = 15;

  @HiveField(6)
  late bool validateInputpw = false;

  @HiveField(7)
  late bool stripSubDomain = false;
}
