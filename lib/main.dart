import 'package:flutter/material.dart';
import 'package:templateplease/widget_build.dart';
import 'package:templateplease/widget_example.dart';
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

List<Widget> makeHeader(String number, {List<Widget> more}) {
  return [
    Row(
      children: <Widget>[
        Text(number, style: TextStyle(fontWeight: FontWeight.w500)),
        ...more ?? [],
      ],
    ),
    const SizedBox(height: 14.0),
  ];
}

class _TestState extends State<Test> {
  // No need to dispose because single page app
  TextEditingController sourceController = TextEditingController();

  // No need to dispose because single page app
  TextEditingController targetController = TextEditingController();

  String sourceText = "";
  String error;

  final Map<String, TextEditingController> vars = {};

  @override
  void initState() {
    super.initState();
    sourceController.addListener(() {
      setState(() {
        sourceText = sourceController.text;
        final oldVars = vars.keys.toSet();
        final newVars = findVariableNames(sourceText ?? "");
        final oldDif = oldVars.difference(newVars);
        final newDif = newVars.difference(oldVars);
        oldDif.forEach((str) {
          final a = vars.remove(str);
          a.dispose();
        });
        newDif.forEach((str) => vars[str] = TextEditingController()
          ..addListener(() {
            setState(() {});
          }));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const cardElevation = 5.0;
    const cardSpacing = 38.0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
                  fontStyle: FontStyle.italic
                ),
              ),
            ),
            const SizedBox(height: 4.0),
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
            const SizedBox(height: 18.0),
            Center(child: exampleRecipe()),
            Center(child: exampleTitle()),
            Center(child: exampleTitle2()),
            const SizedBox(height: 24.0),
            Center(
              child: Card(
                elevation: cardElevation,
                child: paste(
                  sourceController: sourceController,
                ),
              ),
            ),
            const SizedBox(height: cardSpacing),
            Center(
              child: Card(
                elevation: cardElevation,
                child: placeholders(vars: vars),
              ),
            ),
            const SizedBox(height: cardSpacing),
            Center(
              child: Card(
                  elevation: cardElevation,
                  child: buildWidget(
                    source: sourceText,
                    error: error,
                    setError: (err) => setState(() => error = err),
                    setOutput: (output) =>
                        setState(() => targetController.text = output),
                    outputController: targetController,
                    vars: vars.map((a, b) => MapEntry(a.substring(2, a.length-2), b.text)),
                  )),
            ),
            const SizedBox(height: cardSpacing),
            Card(
              elevation: cardElevation,
              child: preview(targetController.text),
            ),
          ],
        ),
      ),
    );
  }
}

Set<String> findVariableNames(String input) {
  return RegExp(mustacheVariableRegex).allMatches(input).map((match) {
    return match.group(0);
  }).toSet();
}

const mustacheVariableRegex = r"{{([\:\/\-\\\,\.a-zA-Z0-9\s])*}}";
