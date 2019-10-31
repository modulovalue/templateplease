import 'package:flutter/material.dart';
import 'package:templateplease/main.dart';

Widget placeholders({
  @required Map<String, TextEditingController> vars,
}) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ...makeHeader("Placeholders"),
        ...() {
          if (vars.isEmpty) {
            return [
              const Opacity(opacity: 0.2, child: Text("No placeholders found")),
            ];
          } else {
            return [
              ...vars.entries.map((entry) {
                return TextField(
                  controller: entry.value,
                  decoration: InputDecoration(
                    helperText: entry.key,
                  ),
                );
              }).toList(),
            ];
          }
        }(),
      ],
    ),
  );
}
