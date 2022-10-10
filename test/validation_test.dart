import 'package:flutter_test/flutter_test.dart';
import 'package:kg_passgen/helper/validation.dart';

void main() {
  group('Valid URLs', () {
    test('http://www.google.com', () {
      expect(Validation.urlValidation("http://www.google.com"), true);
    });

    test('http://google.com', () {
      expect(Validation.urlValidation("http://google.com"), true);
    });

    test('google.com', () {
      expect(Validation.urlValidation("google.com"), true);
    });
    test('google.com:80', () {
      expect(Validation.urlValidation("google.com:80"), true);
    });

    test('https://google.com:80', () {
      expect(Validation.urlValidation("https://google.com:80"), true);
    });

    test('https://google.com/directory/hi/ok.html', () {
      expect(
          Validation.urlValidation("https://google.com/directory/hi/ok.html"),
          true);
    });
  });

  group("Invalid URLs", () {
    test('.google.com', () {
      expect(Validation.urlValidation(".google.com"), false);
    });

    test('google', () {
      expect(Validation.urlValidation("google"), false);
    });
  });

  group("Validated Input Passwords", () {
    test("Ae123456", () {
      expect(Validation.passwordValidation("Ae123456"), true);
    });
    test("qwerty123Q", () {
      expect(Validation.passwordValidation("qwerty123Q"), true);
    });
    test("w!sA4213A", () {
      expect(Validation.passwordValidation("w!sA4213A"), true);
    });
  });

  group("Invalidated Input Passwords", () {
    test("12345678", () {
      expect(Validation.passwordValidation("12345678"), false);
    });
    test("Ae12345", () {
      expect(Validation.passwordValidation("Ae12345"), false);
    });

    test("asdfghji", () {
      expect(Validation.passwordValidation("asdfghji"), false);
    });

    test("asdfgh12345", () {
      expect(Validation.passwordValidation("asdfgh12345"), false);
    });
  });

  group("Invalidated Input Passwords", () {
    test("12345678", () {
      expect(Validation.passwordValidation("12345678"), false);
    });
    test("Ae12345", () {
      expect(Validation.passwordValidation("Ae12345"), false);
    });

    test("asdfghji", () {
      expect(Validation.passwordValidation("asdfghji"), false);
    });

    test("asdfgh12345", () {
      expect(Validation.passwordValidation("asdfgh12345"), false);
    });
  });

  test("KG Valid Output password: sAg!&12341!", () {
    expect(Validation.outputPasswordValidation("sAg!&12341", 8, false), true);
  });

  test("KG invalid Output password: Asg!&12341", () {
    expect(Validation.outputPasswordValidation("Asg!&12341", 8, false), false);
  });

  test("KG invalid Output password: sdfg1234", () {
    expect(Validation.outputPasswordValidation("sdfg1234", 8, false), false);
  });

  test("SGP valid Output password: sdfg1234", () {
    expect(Validation.outputPasswordValidation("sdfg1234", 8, true), false);
  });
}
