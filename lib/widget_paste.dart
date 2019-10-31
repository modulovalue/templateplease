import 'package:flutter/material.dart';
import 'package:templateplease/gists.dart';
import 'package:http/http.dart' as http;

Widget paste({
  @required void Function(String set) fromString,
}) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Column(
      children: <Widget>[
        _importGistButton("Import a recipe from GitHub Gist", fromString),
        const SizedBox(height: 10.0),
        const SizedBox(height: 8.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: <Widget>[
                _exampleButton("Hello, World!", () {
                  fromString("Hello, {{World}}!");
                }),
                _exampleButton("README Social Badges", () {
                  fromString(
                      "[![Twitter Follow](https://img.shields.io/twitter/follow/{{Twitter}}?style=social&logo=twitter)](https://twitter.com/{{Twitter}}) [![GitHub Follow](https://img.shields.io/github/followers/{{GitHub}}?style=social&logo=github)](https://github.com/{{GitHub}})");
                }),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _importGistButton(String text, void Function(String) setText) {
  return Builder(builder: (context) {
    return RaisedButton(
      color: const Color(0xFF333333),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.white,
        ),
      ),
      onPressed: () async {
        final Gist a = await loadGist(
          client: http.Client(),
          gistId: "b4792af7f592c171a901d1a21560e6c0",
        );
        await showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Please select a file"),
                  const SizedBox(height: 12.0),
                  Text("Description: ${a.description}",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ...a.files.where((a) => a.hasContent).map(
                      (file) {
                        return ListTile(
                          title: Text(file.name),
                          onTap: () {
                            setText(file.content);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  });
}

Widget _exampleButton(String text, void Function() onTap) {
  return SizedBox(
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
