import 'package:crypto/crypto.dart';
import 'package:kg_passgen/helper/hostname.dart';
import 'package:kg_passgen/helper/validation.dart';
import 'dart:convert';

import 'package:kg_passgen/model/configuration.dart';

class Hashing {
  static List<int> generateSHA512(String input) {
    var bytes = utf8.encode(input);
    var digest = sha512.convert(bytes);
    return digest.bytes;
  }

  static List<int> generateMD5(String input) {
    var bytes = utf8.encode(input);
    var digest = md5.convert(bytes);
    return digest.bytes;
  }

  static String convertBytesToStringSGP(List<int> bytes) {
    String string = base64Encode(bytes);
    string = string
        .replaceAll(RegExp(r'\+'), '9')
        .replaceAll(RegExp(r'\/'), '8')
        .replaceAll(RegExp(r'='), 'A');
    return string;
  }

  static String convertBytesToStringKG(List<int> bytes) {
    String string = base64Encode(bytes);
    string = string
        .replaceAll(RegExp(r'\+'), '!')
        .replaceAll(RegExp(r'\/'), '#')
        .replaceAll(RegExp(r'='), '%')
        .replaceAll('0', '@')
        .replaceAll('8', '\$')
        .replaceAll('9', '&');
    return string;
  }

  static String hopPasswordGen(
      String master, String website, Configuration configuration) {
    website = website.replaceAll("https://", '');
    website = website.replaceAll("http://", '');
    final uri =
        configuration.stripSubDomain ? returnHostname(website) : website;
    String output = "$master:$uri";
    List<int> bytes;
    int loops = 15;
    if (configuration.hashingAlgorithm) loops = 10;
    for (var i = 0; i < loops; i++) {
      bytes = (configuration.hashingFunction)
          ? generateSHA512(output)
            : generateMD5(output);
      output = (configuration.hashingAlgorithm)
          ? convertBytesToStringSGP(bytes)
          : convertBytesToStringKG(bytes);
      if (i == loops - 1 &&
          !Validation.outputPasswordValidation(
              output, configuration.pwLength, configuration.hashingAlgorithm)) {
        i -= 1;
      }
    }
    return output.substring(0, configuration.pwLength);
  }
}
