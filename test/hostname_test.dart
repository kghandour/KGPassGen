import 'package:flutter_test/flutter_test.dart';
import 'package:kg_passgen/helper/hostname.dart';

void main() {
  group("Valid Hostname stripping", () {
    test("google.com", () {
      expect(returnHostname("google.com"), "google.com");
    });

    test("www.google.com", () {
      expect(returnHostname("www.google.com"), "google.com");
    });

    test("google.co.uk", () {
      expect(returnHostname("google.co.uk"), "google.co.uk");
    });
    test("google.co.uk:9000", () {
      expect(returnHostname("google.co.uk:9000"), "google.co.uk");
    });

    test("https://www.google.co.uk:9000", () {
      expect(returnHostname("google.co.uk:9000"), "google.co.uk");
    });

    test("https://google.co.uk:9000", () {
      expect(returnHostname("google.co.uk:9000"), "google.co.uk");
    });
  });
}
