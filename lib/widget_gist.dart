import 'dart:async';
import 'dart:html';

import 'package:bird_flutter/bird_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:templateplease/util/util.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:dart_pad/sharing/gists.dart';

Widget gistInfoWidget(String gistID, void Function(String) setContent,
    void Function(String) setError) {
  return $$ >> (context) {
    final isLoading = useState(false);
    final gist = useState<Gist>(null);
    final selectedFile = useState<String>(null);
    final reload = useState(false);

    useMemoized(() {
      isLoading.value = true;
      GistLoader(client: http.Client())
          .loadGist(gistIDFromString(gistID))
          .then((_gist) {
        gist.value = _gist;
        isLoading.value = false;
      }).catchError((dynamic err, StackTrace st) {
        setError(
            "There was a problem while loading your gist. Please try a different gist.");
        isLoading.value = false;
      });
    }, [gistID, reload.value]);

    if (isLoading.value) {
      return height(4.0) > const LinearProgressIndicator();
    } else {
      return singleChildScrollView()
          > onColumnCenter()
              >> [
                padding(all: 8.0) > onWrapStartCenter() >> [
                  onTap(() => openUrl("https://gist.github.com/${gistID}"))
                  & textColor(Colors.blue)
                      > Text(gistID),

                  const Text(" • "),

                  onTap(() => reload.value = !reload.value)
                  & textColor(Colors.blue)
                      > const Text("Reload Gist"),
                ],

                if (gist.value == null) ...[
                  const Text(
                      "The gist was not found. Please provide a valid GitHub gist."),
                ] else
                  ...[
                    opacity(0.7)
                    & padding(all: 16.0)
                        > MarkdownBody(
                      data: gist.value.description ?? "No Description",
                      onTapLink: (url) => window.open(url, url),
                    ),

                    padding(all: 8.0)
                    & opacity(0.5)
                        > const Text("Select a file"),

                    if (isLoading.value)
                      height(4.0) > const LinearProgressIndicator(),

                    if (!isLoading.value && gist != null)
                      padding(all: 8.0) > onWrapCenterCenter(allSpacing: 8.0)
                          >> gist.value.files.where((a) => a.hasContent).map((
                              file) {
                            return height(28.0) > FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.0),
                              ),
                              color: Colors.white,
                              child: Text(file.name),
                              onPressed: () {
                                selectedFile.value = file.name;
                                setContent(file.content);
                              },
                            );
                          }),
                  ],
              ];
    }
  };
}