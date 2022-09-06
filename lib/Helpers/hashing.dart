import 'package:crypto/crypto.dart';
import 'package:kg_passgen/Helpers/hostname.dart';
import 'dart:convert';

import 'package:kg_passgen/Helpers/validation.dart';
import 'package:kg_passgen/constant.dart';

import '../main.dart';

List<int> generateSHA512(String input) {
  var bytes = utf8.encode(input);
  var digest = sha512.convert(bytes);
  return digest.bytes;
}

List<int> generateMD5(String input) {
  var bytes = utf8.encode(input);
  var digest = md5.convert(bytes);
  return digest.bytes;
}

String convertBytesToStringSGP(List<int> bytes) {
  String string = base64Encode(bytes);
  string = string
      .replaceAll(new RegExp(r'\+'), '9')
      .replaceAll(new RegExp(r'\/'), '8')
      .replaceAll(new RegExp(r'='), 'A');
  return string;
}

String convertBytesToStringKG(List<int> bytes) {
  String string = base64Encode(bytes);
  string = string
      .replaceAll(new RegExp(r'\+'), '!')
      .replaceAll(new RegExp(r'\/'), '#')
      .replaceAll(new RegExp(r'='), '%')
      .replaceAll('0', '@')
      .replaceAll('8', '\$')
      .replaceAll('9', '&');
  return string;
}

String hopPasswordGen(String master, String website) {
  int _algo = settingsBox.get(kAlgoKey, defaultValue: kAlgoDef);
  int _loops = (_algo == 0)
      ? settingsBox.get(kSGPHopsKey, defaultValue: kSGPHopsDef)
      : settingsBox.get(kKGHopsKey, defaultValue: kKGHopsDef);
  int _length = (_algo == 0)
      ? settingsBox.get(kSGPLenKey, defaultValue: kSGPLenDef)
      : settingsBox.get(kKGLenKey, defaultValue: kKGLenDef);
  int _hash = (_algo == 0)
      ? settingsBox.get(kSGPHashKey, defaultValue: kSGPHashDef)
      : settingsBox.get(kKGHashKey, defaultValue: kKGHashDef);
  bool _stripDomain = settingsBox.get('stripDomain', defaultValue: true);

  website = website.replaceAll("https://", '');
  website = website.replaceAll("http://", '');
  final uri = _stripDomain ? returnHostname(website) : website;

  String output = master + ":" + uri;
  List<int> bytes;
  for (var i = 0; i < _loops; i++) {
    bytes = (_hash == 0) ? generateMD5(output) : generateSHA512(output);
    output = (_algo == 0)
        ? convertBytesToStringSGP(bytes)
        : convertBytesToStringKG(bytes);
    if (i == _loops - 1 && !outputPasswordValidation(output, _length, _algo)) {
      i -= 1;
    }
  }
  return output.substring(0, _length);
}
