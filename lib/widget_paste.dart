import 'dart:html';

import 'package:bird_flutter/bird_flutter.dart';
import 'package:flutter/material.dart';
import 'package:templateplease/util/util.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Widget paste(void Function(String) setGist) {
  return onColumn() >> [
    Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      runAlignment: WrapAlignment.center,
      alignment: WrapAlignment.center,
      children: <Widget>[
        _tutorialButton(),
        _importRecipeButton(setGist),
      ],
    ),
    verticalSpace(12.0),
    Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      runAlignment: WrapAlignment.center,
      alignment: WrapAlignment.center,
      children: <Widget>[
        _exampleButton("Basic GitHub README", () =>
            setGist("980c10cbf436622fcbd179ce56b1b889")),
        _exampleButton("README Social Badges", () =>
            setGist("a366237e9878c47edc1b6280df5a46cb")),
      ],
    ),
  ];
}

Widget _importRecipeButton(void Function(String) setGistID) {
  return Builder(
    builder: (context) {
      return height(28.0) > RaisedButton(
        color: const Color(0xFF333333),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: textSize(12.0)
        & textColor(Colors.white)
            > const Text("Import a recipe from a GitHub Gist"),
        onPressed: () async {
          await showDialog<void>(
            context: context,
            builder: (context) {
              return $$ >> (context) {
                final gistStringOrNull = useState<String>(null);

                return AlertDialog(
                  title: onColumnMinStartCenter() >> [
                    FlatButton(
                      child: const Text("Open GitHub Gist"),
                      onPressed: () => openUrl("https://gist.github.com"),
                    ),
                    verticalSpace(12.0),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "GitHub Gist URL or ID",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () async {
                              final id = gistIDFromString(
                                  gistStringOrNull.value);

                              if (id != null && id != ""
                                  && id != "null") {
                                setGistID(id);
                                Navigator.of(context).pop();
                              } else {
                                await showDialog<void>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "No Gist ID found"),
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
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          )),
                      onChanged: (txt) => gistStringOrNull.value = txt,
                    ),
                  ],
                );
              };
            },
          );
        },
      );
    },
  );
}

Widget _tutorialButton() {
  return Builder(
    builder: (context) {
      return Container(
        height: 28.0,
        child: RaisedButton(
          color: const Color(0xFF333333),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
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
                  content: onColumnMinStartStart() >> [
                    onTap(() =>
                        openUrl("https://gist.github.com/")) > const Text(
                      "1. Go to https://gist.github.com/",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    const Text("2. Create a public Gist"),
                    const Text(
                        "3. Replace text with placeholders that look like this"),
                    const Text("{{placeholdername}}"),
                    const Text("Example: Hello, {{world}}!"),
                    const Text(" "),
                    onTap(() =>
                        openUrl(
                            "https://gist.github.com/a366237e9878c47edc1b6280df5a46cb"))
                        > const Text(
                      "Example Gist",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                  actions: <Widget>[
                    flatButton(() => Navigator.pop(context))
                        > const Text("Close"),
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

Widget _exampleButton(String text, void Function() onTap) {
  return Container(
    height: 28.0,
    child: RaisedButton(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
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
