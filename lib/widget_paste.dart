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
        Builder(
          builder: (context) {
            return RaisedButton(
              color: const Color(0xFF333333),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                "Import a recipe from GitHub Gist",
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
            );
          },
        ),
        const SizedBox(height: 12.0),
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
  bool isLoading = false;
  Gist gist;

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
                    print("aaaaaaaaaaaaa");
                    final id = gistIDFromString(this.gistStringOrNull);
                    if (id != null) {
                      setState(() => isLoading = true);
                      final gist = await loadGist(
                        client: http.Client(),
                        gistId: gistIDFromString(this.gistStringOrNull),
                      );
                      setState(() {
                        this.gist = gist;
                        isLoading = false;
                      });
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
          if (!isLoading && gist != null) //
            ...[
            const SizedBox(height: 24.0),
            Text("${gist.description}"),
            const SizedBox(height: 8.0),
            const Text(
              "Please select a file",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (isLoading)
              const SizedBox(height: 4.0, child: LinearProgressIndicator()),
            if (!isLoading && gist != null) //
              ...gist.files.where((a) => a.hasContent).map(
                (file) {
                  return ListTile(
                    title: Text(file.name),
                    onTap: () {
                      widget.setText(file.content);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
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
