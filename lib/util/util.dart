import 'dart:html';

import 'package:bird_flutter/bird_flutter.dart';
import 'package:flutter/material.dart';

final RegExp _gistRegex = RegExp(r'[0-9a-f]+$');

String gistIDFromString(String url) {
  final matches = _gistRegex.allMatches(url);
  if (matches.isNotEmpty) {
    return matches.first.group(0);
  } else {
    return null;
  }
}

void openUrl(String link) => window.open(link, link);

Set<String> findVariableNames(String input) {
  return RegExp(_mustacheVariableRegex).allMatches(input).map((match) {
    return match.group(0);
  }).toSet();
}

const _mustacheVariableRegex = r"{{([\:\/\-\\\,\.a-zA-Z0-9\s])*}}";

String removeBraces(String str) {
  if (str.length >= 4) {
    return str.substring(2, str.length - 2);
  } else {
    return str;
  }
}

// TODO move to bird
Applicator fluidByMarginH2(double width,
    {Applicator Function(double difference) whenActive}) {
  return onBuilder((context, child) {
    final mediaSize = MediaQuery
        .of(context)
        .size;

    double dif;

    if (mediaSize.width <= width) {
      dif = 0.0;
    } else {
      final _dif = mediaSize.width - width;
      dif = _dif / 2;
    }

    return padding(left: dif, right: dif) > child;
  });
}