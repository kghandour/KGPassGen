import 'package:hive/hive.dart';
import 'package:kg_passgen/model/configuration.dart';

class ConfigurationController {
  static void editConfiguration(
    Configuration config,
    String name,
    DateTime editDate,
    bool hashingAlgorithm, // KGPassGen / SuperGenPass

    bool hashingFunction, // MD5 / SHA512

    int pwLength,
    bool validateInputpw,
    bool stripSubDomain,
  ) {
    config.name = name;
    config.editDate = DateTime.now();
    config.hashingAlgorithm = hashingAlgorithm;
    config.hashingFunction = hashingFunction;
    config.pwLength = pwLength;
    config.validateInputpw = validateInputpw;
    config.stripSubDomain = stripSubDomain;

    config.save();
  }

  static void updateHashingAlgorith(Configuration config, bool hashingAlgo) {
    config.editDate = DateTime.now();

    config.hashingAlgorithm = hashingAlgo;
    config.save();
  }

  static void updateHashingFunction(Configuration config, bool hashingFn) {
    config.editDate = DateTime.now();

    config.hashingFunction = hashingFn;
    config.save();
  }

  static void updatePWLength(Configuration config, int pwLength) {
    config.editDate = DateTime.now();

    config.pwLength = pwLength;
    config.save();
  }

  static void updateValInputPw(Configuration config, bool valInputPw) {
    config.editDate = DateTime.now();

    config.validateInputpw = valInputPw;
    config.save();
  }

  static void updateStripSubdomain(Configuration config, bool stripSubdom) {
    config.editDate = DateTime.now();

    config.stripSubDomain = stripSubdom;
    config.save();
  }

  static void deleteConfiguration(Configuration configuration) {
    configuration.delete();
  }

  static void addConfiguration(Configuration configuration, Box box) {
    box.add(configuration);
  }
}
