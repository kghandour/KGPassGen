import 'cc_tld.dart';

String returnHostname(String hostname) {
  List<String> urlSplit = hostname.split('.');
  List<String> portSplit = urlSplit.last.split(':');
  if (portSplit.length > 1) {
    urlSplit[urlSplit.length - 1] = portSplit[0];
  }
  // Check IP Address First
  if (urlSplit.length == 4) {
    if (urlSplit.every((element) {
      int? range = int.tryParse(element);
      if (range != null && range >= 0 && range <= 255) return true;
      return false;
    })) return urlSplit.join('.');
  }

  if (urlSplit.length <= 2) {
    return urlSplit.join('.');
  }
  var matchedTld = ccTldList.firstWhere(
      (element) => urlSplit.join('.').endsWith(element),
      orElse: () => '');
  if (matchedTld.isNotEmpty) {
    int matchedLength = matchedTld.split('.').length + 1;
    return urlSplit.sublist(urlSplit.length - matchedLength).join('.');
  }
  return urlSplit.sublist(urlSplit.length - 2).join('.');
}
