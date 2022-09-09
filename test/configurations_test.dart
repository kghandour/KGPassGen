import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kg_passgen/controller/boxes.dart';
import 'package:kg_passgen/controller/configuration_controller.dart';
import 'package:kg_passgen/model/configuration.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hive/hive.dart';

import 'configurations_test.mocks.dart';

@GenerateMocks([HiveInterface, Box])
void main() async {
  ConfigurationController configController;
  MockHiveInterface mockHiveInterface;
  MockBox mockBox;

  setUp(() async {
    mockHiveInterface = MockHiveInterface();
    mockBox = MockBox();
    await Hive.initFlutter();
    Hive.registerAdapter(ConfigurationAdapter());
    await Hive.openBox<Configuration>('configurations');
    configController = ConfigurationController();
  });

  test("description", () async {
    final newConfig = Configuration();
    await newConfig.save();
    Box ConfigBox = Boxes.getConfigurations();
    expect(ConfigBox, [newConfig]);
  });
}
