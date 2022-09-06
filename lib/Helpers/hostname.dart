import 'package:kg_passgen/Helpers/ccTLD.dart';

String returnHostname(String hostname) {
  List<String> urlSplit = hostname.split('.');
  if (urlSplit.length <= 2) return hostname;
  var matchedTld = ccTldList.firstWhere((element) => hostname.endsWith(element),
      orElse: () => '');
  if (matchedTld.isNotEmpty) {
    int matchedLength = matchedTld.split('.').length + 1;
    return urlSplit.sublist(urlSplit.length - matchedLength).join('.');
  }
  return urlSplit.sublist(urlSplit.length - 2).join('.');
}
