import 'package:flutter/material.dart';

Widget exampleRecipe() {
  return Opacity(
    opacity: 0.5,
    child: Wrap(
      children: <Widget>[
        const Text(
          "Example recipes:",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    ),
  );
}

Widget exampleTitle() {
  return Opacity(
    opacity: 0.5,
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        const Text("Hello "),
        Text(
          "{{who}}",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        Icon(Icons.chevron_right, size: 12.0),
        const Text("'Joe'"),
        Icon(Icons.chevron_right, size: 12.0),
        const Text("Hello Joe"),
      ],
    ),
  );
}

Widget exampleTitle2() {
  return Opacity(
    opacity: 0.5,
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        const Text("README Template"),
        Icon(Icons.chevron_right, size: 12.0),
        Text(
          "{{title}}",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        Icon(Icons.chevron_right, size: 12.0),
        const Text("README!"),
      ],
    ),
  );
}
