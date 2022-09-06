bool urlValidation(String v) {
  String value = v.toLowerCase();
  var urlPattern =
      r"(http(s)?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)";
  var match = new RegExp(urlPattern, caseSensitive: false).firstMatch(value);
  if (match == null) return false;
  return true;
}

bool passwordValidation(String value) {
  var urlPattern =
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])([a-zA-Z0-9#?!@$%^&*]){8,}$";
  var match = new RegExp(urlPattern, caseSensitive: true).firstMatch(value);
  if (match == null) return false;
  return true;
}

bool outputPasswordValidation(String v, int length, int algo) {
  String value = v.substring(0, length);
  var urlPattern =
      r"(?=.*^[a-z])(?=.*[A-Z])(?=.*[0-9])([a-zA-Z0-9#?!@$%^&*]){8,}$";
  var match = new RegExp(urlPattern, caseSensitive: true).firstMatch(value);
  if (match == null) return false;
  if (algo == 1) if (!value.contains("!") &&
      !value.contains("#") &&
      !value.contains("%") &&
      !value.contains("@") &&
      !value.contains("\$") &&
      !value.contains("&")) {
    return false;
  }
  return true;
}

bool passwordLengthValidation(int value) {
  if (value >= 8 && value <= 24) return true;
  return false;
}
