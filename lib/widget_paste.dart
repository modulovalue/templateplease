import 'dart:html';

import 'package:flutter/material.dart';
import 'package:templateplease/gists.dart';
import 'package:templateplease/util.dart';

Widget paste({
  @required void Function(String set) fromString,
}) {
  return Column(
    children: <Widget>[
      Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.center,
        children: <Widget>[
          _tutorial(),
          Builder(
            builder: (context) {
              return Container(
                height: 28.0,
                child: RaisedButton(
                  color: const Color(0xFF333333),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    "Import a recipe from a GitHub Gist",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) {
                        return ImportGISTButton(
                          setText: fromString,
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      const SizedBox(height: 12.0),
      Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.center,
        children: <Widget>[
          _exampleButton("Basic GitHub README", () {
            openSelfWithNewParams((old) => old
              ..addAll(<String, dynamic>{
                "gist": "980c10cbf436622fcbd179ce56b1b889",
              }));
          }),
          _exampleButton("README Social Badges", () {
            openSelfWithNewParams((old) => old
              ..addAll(<String, dynamic>{
                "gist": "a366237e9878c47edc1b6280df5a46cb",
              }));
          }),
        ],
      ),
    ],
  );
}

Widget _tutorial() {
  return Builder(
    builder: (context) {
      return Container(
        height: 28.0,
        child: RaisedButton(
          color: const Color(0xFF333333),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            "Tutorial",
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            await showDialog<void>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Tutorial"),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      openLink(
                        "https://gist.github.com/",
                        const Text(
                          "1. Go to https://gist.github.com/",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const Text("2. Create a public Gist"),
                      const Text(
                        "3. Replace everything you want to type in manually with {{placeholdername}}",
                      ),
                      const Text(" "),
                      openLink(
                        "https://gist.github.com/modulovalue/a366237e9878c47edc1b6280df5a46cb",
                        const Text(
                          "Example Gist",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text("Close"),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                );
              },
            );
          },
        ),
      );
    },
  );
}

class ImportGISTButton extends StatefulWidget {
  final void Function(String) setText;

  @override
  _ImportGISTButtonState createState() => _ImportGISTButtonState();

  const ImportGISTButton({
    @required this.setText,
  });
}

class _ImportGISTButtonState extends State<ImportGISTButton> {
  String gistStringOrNull;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                labelText: "GitHub Gist URL or ID",
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    final id = gistIDFromString(this.gistStringOrNull);

                    if (id != null && id != "" && id != "null") {
                      openSelfWithNewParams((old) => old
                        ..addAll(<String, dynamic>{
                          "gist": id,
                        }));
                    } else {
                      await showDialog<void>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("No Gist ID found"),
                              content: const Text(
                                "Please enter a valid gist URL or ID \n\n"
                                "Example:\n\n"
                                "- https://gist.github.com/modulovalue/a366237e9878c47edc1b6280df5a46cb\n"
                                "- gist.github.com/modulovalue/a366237e9878c47edc1b6280df5a46cb\n"
                                "- a366237e9878c47edc1b6280df5a46cb",
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: const Text("Close"),
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ],
                            );
                          });
                    }
                  },
                )),
            onChanged: (txt) {
              setState(() {
                this.gistStringOrNull = txt;
              });
            },
          ),
        ],
      ),
    );
  }
}

Widget _exampleButton(String text, void Function() onTap) {
  return Container(
    height: 28.0,
    child: RaisedButton(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.black,
        ),
      ),
      onPressed: onTap,
    ),
  );
}
