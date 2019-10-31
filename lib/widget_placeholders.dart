import 'package:flutter/material.dart';
import 'package:reflected_mustache/mustache.dart';

Widget placeholders({
  @required Map<String, TextEditingController> vars,
  @required String source,
  @required String error,
  @required void Function(String) setError,
  @required void Function(String) setOutput,
  @required TextEditingController outputController,
  @required Map<String, String> varsRaw,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      ...() {
        if (source.isEmpty) {
          return <Widget>[];
        } else if (vars.isEmpty) {
          return [
            const Center(
              child: Opacity(
                opacity: 0.3,
                child: Text(
                  "No placeholders found. \nThat's a placeholder: {{placeholder}}",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ];
        } else {
          return [
            ...vars.entries.map((entry) {
              return TextField(
                key: Key(entry.key),
                controller: entry.value,
                decoration: InputDecoration(
                  labelText: entry.key,
                  errorStyle: const TextStyle(fontSize: 0.0),
                  errorText: entry.value.text.isEmpty ? "" : null,
                ),
              );
            }).toList(),
            const SizedBox(height: 24.0),
            Center(
              child: Container(
                height: 28.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0)),
                  color: Colors.blue,
                  child: Text("Build", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    try {
                      final template = Template(
                          source,
                        name: 'template',
                        htmlEscapeValues: false,
                      );
                      final output = template.renderString(varsRaw);
                      setError(null);
                      setOutput(output);
                    } catch (e) {
                      setError("${e.runtimeType}: " + e.toString());
                    }
                  },
                ),
              ),
            ),
          ];
        }
      }(),
      if (error != null) //
        ...[
        const SizedBox(height: 8.0),
        Center(
          child: Text(
            error,
            style: TextStyle(color: Colors.red, fontSize: 12.0),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    ],
  );
}
