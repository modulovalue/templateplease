import 'dart:html';

import 'package:flutter/material.dart';
import 'package:templateplease/util.dart';
import 'package:templateplease/widget_gist.dart';
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

  String loadedGistOrNull;

  final Map<String, TextEditingController> vars = {};

  @override
  void initState() {
    super.initState();
    loadedGistOrNull = _getGistIDOrNull();
  }

  String _getGistIDOrNull() {
    final uri = Uri.tryParse(window.location.href);
    if (uri == null) {
      return null;
    }
    final id = uri.queryParameters["gist"].toString();
    if (id == null || id == "" || id == null || id == "null") {
      return null;
    }
    return id;
  }

  void setText(String text) {
    setState(() {
      sourceText = text;
      final oldVars = vars.keys.toSet();
      final newVars = findVariableNames(sourceText ?? "");
      final oldDif = oldVars.difference(newVars);
      final newDif = newVars.difference(oldVars);
      oldDif.forEach((str) {
        // TODO dispose
        vars.remove(str);
      });
      newDif.forEach((str) => vars[str] = TextEditingController()
        ..addListener(() {
          setState(() {});
        }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return Center(
          child: ListView(
            padding: const EdgeInsets.all(18.0),
            shrinkWrap: true,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    openSelfWithNewParams((a) => <String, dynamic>{});
                  },
                  child: Text(
                    "Template, Please",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 36.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 18.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: <Widget>[
                      if (loadedGistOrNull != null) //
                        GistInfoWidget(
                          gistID: loadedGistOrNull,
                          setContent: setText,
                        )
                      else if (loadedGistOrNull == null) //
                        paste(fromString: setText),
                      if (sourceText.isNotEmpty) ...[
                        const SizedBox(height: 42.0),
                        placeholders(
                          vars: vars.map((key, value) =>
                              MapEntry(removeBraces(key), value)),
                          source: sourceText,
                          error: error,
                          setError: (err) => setState(() => error = err),
                          setOutput: (output) =>
                              setState(() => targetController.text = output),
                          outputController: targetController,
                          varsRaw: vars.map((key, value) =>
                              MapEntry(removeBraces(key), value.text)),
                        ),
                        const SizedBox(height: 24.0),
                      ],
                      if (sourceText.isNotEmpty) //
                        const SizedBox(height: 14.0),
                      PreviewWidget(targetController.text, targetController),
                    ],
                  ),
                ),
              ),
              footer(),
            ],
          ),
        );
      }),
    );
  }
}

Widget footer() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: <Widget>[
          _verticalCenter(
            GestureDetector(
              onTap: () => openUrl("https://github.com/modulovalue/templateplease/issues"),
              child: Text(
                "Issues?",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          _verticalCenter(const Text("•")),
          _verticalCenter(
            GestureDetector(
              onTap: () => openUrl("https://github.com/modulovalue/templateplease"),
              child: Text(
                "GitHub",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          _verticalCenter(const Text("•")),
          _verticalCenter(
            openLink(
              "https://twitter.com/modulovalue",
              Text(
                "@modulovalue",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          _verticalCenter(const Text("•")),
          _verticalCenter(
            const FlutterLogo(
              size: 50.0,
              style: FlutterLogoStyle.horizontal,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _verticalCenter(Widget child) {
  return SizedBox(
    height: 20,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        child,
      ],
    ),
  );
}
