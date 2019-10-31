import 'package:flutter/material.dart';
import 'package:reflected_mustache/mustache.dart';
import 'package:templateplease/main.dart';

Widget placeholders({
  @required Map<String, TextEditingController> vars,
  @required String source,
  @required String error,
  @required void Function(String) setError,
  @required void Function(String) setOutput,
  @required TextEditingController outputController,
  @required Map<String, String> varsRaw,
}) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ...() {
          if (vars.isEmpty) {
            return [
              const Opacity(opacity: 0.2, child: Text("No placeholders found")),
            ];
          } else {
            return [
              ...vars.entries.map((entry) {
                return TextField(
                  key: Key(entry.key),
                  controller: entry.value,
                  decoration: InputDecoration(
                    labelText: entry.key,
                    errorText:
                        entry.value.text.isEmpty ? "Shouldn't be empty" : null,
                  ),
                );
              }).toList(),
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
          const SizedBox(height: 12.0),
        Center(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0)),
            color: Colors.blue,
            child: Text("Build", style: TextStyle(color: Colors.white)),
            onPressed: () {
              try {
                final template = Template(source, name: 'template');
                final output = template.renderString(varsRaw);
                setError(null);
                setOutput(output);
              } catch (e) {
                setError("${e.runtimeType}: " + e.toString());
              }
            },
          ),
        ),
      ],
    ),
  );
}
