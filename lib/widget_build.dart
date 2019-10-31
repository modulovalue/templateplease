import 'package:flutter/material.dart';
import 'package:reflected_mustache/mustache.dart';
import 'package:templateplease/main.dart';

Widget buildWidget({
  @required String source,
  @required String error,
  @required void Function(String) setError,
  @required void Function(String) setOutput,
  @required TextEditingController outputController,
  @required Map<String, String> vars,
}) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ...makeHeader("Create"),
        if (error != null) //
          ...[
          Center(
            child: Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 12.0),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 12.0),
        ],
        Center(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0)),
            color: Colors.yellow[700],
            child: Text("Build", style: TextStyle(color: Colors.black)),
            onPressed: () {
              try {
                final template = Template(source, name: 'template');
                print(vars);
                final output = template.renderString(vars);
                setError(null);
                setOutput(output);
              } catch (e) {
                setError("${e.runtimeType}: " + e.toString());
              }
            },
          ),
        ),
        const SizedBox(height: 18.0),
        TextField(
          decoration: const InputDecoration(
            helperText: "Select all (Ctrl/Cmd + A) • Copy (Ctrl/Cmd + C)",
            border: OutlineInputBorder(),
          ),
          controller: outputController,
        ),
      ],
    ),
  );
}
