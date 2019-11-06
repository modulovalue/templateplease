import 'package:bird_flutter/bird_flutter.dart';
import 'package:flutter/material.dart';
import 'package:reflected_mustache/mustache.dart';

Widget editPlaceholders({
  @required Map<String, String> vars,
  @required String source,
  @required String error,
  @required void Function(String, String) setValueFor,
  @required void Function(String) setError,
  @required void Function(String) setOutput,
}) {
  return onColumnMaxStartCenter() >> [
    ...() {
      if (source.isEmpty) {
        return <Widget>[];
      } else if (vars.isEmpty) {
        return [
          center() & opacity(0.3) > const Text(
            "No placeholders found. \nThat's a placeholder: {{placeholder}}",
            textAlign: TextAlign.center,
          ),
        ];
      } else {
        return [
          ...vars.entries.map((entry) {
            return TextField(
              key: Key(entry.key),
              onChanged: (newStr) => setValueFor(entry.key, newStr),
              decoration: InputDecoration(
                labelText: entry.key,
                errorStyle: const TextStyle(fontSize: 0.0),
                errorText: entry.value.isEmpty ? "" : null,
              ),
            );
          }).toList(),
          verticalSpace(24.0),
          center() & height(28.0) > RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0)),
            color: Colors.blue,
            child: Text("Build", style: TextStyle(color: Colors.white)),
            onPressed: () {
              try {
                final template = Template(
                  source,
                  name: 'template',
                  htmlEscapeValues: false,
                );
                final output = template.renderString(
                    vars.map((a, b) => MapEntry(a, b)));
                setError(null);
                setOutput(output);
              } catch (e) {
                setError("${e.runtimeType}: " + e?.toString());
              }
            },
          ),
          verticalSpace(18.0),
        ];
      }
    }(),
    if (error != null) //
      ...[
        verticalSpace(8.0),
        center() > Text(
          error,
          style: TextStyle(color: Colors.red, fontSize: 12.0),
          textAlign: TextAlign.left,
        ),
        verticalSpace(12.0),
      ],
  ];
}
