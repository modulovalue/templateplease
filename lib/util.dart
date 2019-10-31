import 'dart:html';

import 'package:flutter/material.dart';

Widget openLink(String link, Widget child) => GestureDetector(
      onTap: () => window.open(link, link),
      child: child);
void openUrl(String link) => window.open(link, link);

void openSelfWithNewParams(
    Map<String, dynamic> Function(Map<String, dynamic>) newQueryParams) {
  final Uri uri = Uri.parse(window.location.href);
  window.open(
      uri
          .replace(
              queryParameters: newQueryParams(
                  Map<String, dynamic>.from(uri.queryParameters)))
          .toString(),
      "templateplease ${newQueryParams.toString()}");
}

Set<String> findVariableNames(String input) {
  return RegExp(mustacheVariableRegex).allMatches(input).map((match) {
    return match.group(0);
  }).toSet();
}

const mustacheVariableRegex = r"{{([\:\/\-\\\,\.a-zA-Z0-9\s])*}}";

String removeBraces(String str) {
  if (str.length >= 4) {
    return str.substring(2, str.length - 2);
  } else {
    return str;
  }
}
