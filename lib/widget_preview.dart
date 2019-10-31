import 'package:flutter/material.dart';
import 'package:templateplease/main.dart';

Widget preview(String text) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Column(
      children: <Widget>[
        ...makeHeader("Preview"),
        Text(text),
      ],
    ),
  );
}
