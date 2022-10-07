class Validation {
  static bool urlValidation(String url) {
    String value = url.toLowerCase();
    var urlPattern =
        r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?|^((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(:[0-9]{1,5})?(\/.*)?$";
    var match = RegExp(urlPattern, caseSensitive: false).firstMatch(value);
    if (match == null) return false;
    return true;
  }

  static bool passwordValidation(String value) {
    var urlPattern =
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])([a-zA-Z0-9#?!@$%^&*]){8,}$";
    var match = RegExp(urlPattern, caseSensitive: true).firstMatch(value);
    if (match == null) return false;
    if (value.length < 8) return false;
    return true;
  }

  static bool passwordLengthValidation(int value) {
    if (value >= 8 && value <= 24) return true;
    return false;
  }

  static bool outputPasswordValidation(String v, int length, bool algo) {
    String value = v.substring(0, length);
    var urlPattern =
        r"(?=.*^[a-z])(?=.*[A-Z])(?=.*[0-9])([a-zA-Z0-9#?!@$%^&*]){8,}$";
    var match = RegExp(urlPattern, caseSensitive: true).firstMatch(value);
    if (match == null) return false;
    if (algo == false) {
      if (!value.contains("!") &&
          !value.contains("#") &&
          !value.contains("%") &&
          !value.contains("@") &&
          !value.contains("\$") &&
          !value.contains("&")) {
        return false;
      }
    }
    return true;
  }
}
