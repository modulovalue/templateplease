import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:templateplease/widget_paste.dart';
import 'package:templateplease/widget_placeholders.dart';
import 'package:templateplease/widget_preview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Template, Please',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Test(),
    );
  }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  // No need to dispose because single page app
  TextEditingController targetController = TextEditingController();

  String sourceText = "";
  String error;

  final Map<String, TextEditingController> vars = {};

  void setText(String text) {
    setState(() {
      sourceText = text;
      final oldVars = vars.keys.toSet();
      final newVars = findVariableNames(sourceText ?? "");
      final oldDif = oldVars.difference(newVars);
      final newDif = newVars.difference(oldVars);
      oldDif.forEach((str) {
        vars.remove(str).dispose();
      });
      newDif.forEach((str) => vars[str] = TextEditingController()
        ..addListener(() {
          setState(() {});
        }));
    });
  }

  @override
  Widget build(BuildContext context) {
    const cardElevation = 1.0;
    const cardSpacing = 24.0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return Center(
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            shrinkWrap: true,
            children: [
              Center(
                child: Text(
                  "Template, Please",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 36.0,
                      fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 2.0),
              Center(
                child: Text(
                  "Visual Templating",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Center(
                child: Card(
                  elevation: cardElevation,
                  child: paste(
                    fromString: (str) async {
                      setText(str);
                    },
                  ),
                ),
              ),
              const SizedBox(height: cardSpacing),
              Center(
                child: Card(
                  elevation: cardElevation,
                  child: placeholders(
                    vars: vars.map(
                        (key, value) => MapEntry(removeBraces(key), value)),
                    source: sourceText,
                    error: error,
                    setError: (err) => setState(() => error = err),
                    setOutput: (output) =>
                        setState(() => targetController.text = output),
                    outputController: targetController,
                    varsRaw: vars.map((key, value) =>
                        MapEntry(removeBraces(key), value.text)),
                  ),
                ),
              ),
              const SizedBox(height: cardSpacing),
              Card(
                elevation: cardElevation,
                child: PreviewWidget(targetController.text, targetController),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: <Widget>[
                    _verticalCenter(
                      GestureDetector(
                        onTap: () => js.context.callMethod("open",
                            <dynamic>["https://twitter.com/modulovalue"]),
                        child: Text(
                          "by @modulovalue",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    _verticalCenter(const Text("•")),
                    _verticalCenter(
                      GestureDetector(
                        onTap: () => js.context.callMethod("open", <dynamic>[
                          "https://github.com/modulovalue/templateplease"
                        ]),
                        child: Text(
                          "Issues?",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    _verticalCenter(const Text("•")),
                    _verticalCenter(
                      GestureDetector(
                          child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            "Made with ",
                          ),
                          const FlutterLogo(
                            size: 70.0,
                            style: FlutterLogoStyle.horizontal,
                          ),
                          const Text(
                            " for web",
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

Widget _verticalCenter(Widget child) {
  return SizedBox(
    height: 50,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        child,
      ],
    ),
  );
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
