import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:templateplease/gists.dart';
import 'package:templateplease/util.dart';

class GistInfoWidget extends StatefulWidget {
  final String gistID;
  final void Function(String) setContent;

  const GistInfoWidget({
    @required this.gistID,
    @required this.setContent,
  });

  @override
  _GistInfoWidgetState createState() => _GistInfoWidgetState();
}

class _GistInfoWidgetState extends State<GistInfoWidget> {
  bool isLoading = false;
  Gist gist;
  String selectedFile;

  @override
  void initState() {
    super.initState();
    updateGist(widget.gistID);
  }

  @override
  void didUpdateWidget(GistInfoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gistID != widget.gistID) {
      updateGist(widget.gistID);
    }
  }

  void updateGist(String gistID) {
    setState(() => isLoading = true);
    loadGist(
      client: http.Client(),
      gistId: gistIDFromString(widget.gistID),
    ).catchError((dynamic err) {
      setState(() {
        this.gist = gist;
        isLoading = false;
      });
    }).then((gist) {
      setState(() {
        this.gist = gist;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 4.0,
        child: const LinearProgressIndicator(),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (gist == null) ...[
              const Text("Error loading gist"),
            ] else ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    openLink(
                      "https://gist.github.com/modulovalue/${widget.gistID}",
                      Text(
                        widget.gistID,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                    const Text(" • "),
                    GestureDetector(
                      child: const Text(
                        "Reload Gist",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () => updateGist(widget.gistID),
                    ),
                  ],
                ),
              ),
              Opacity(
                opacity: 0.7,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MarkdownBody(
                    data: gist.description ?? "No Description",
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Opacity(
                  opacity: 0.5,
                  child: Text(
                    "Please select a file",
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              if (isLoading)
                const SizedBox(height: 4.0, child: LinearProgressIndicator()),
              if (!isLoading && gist != null) //
                ...gist.files.where((a) => a.hasContent).map(
                  (file) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(),
                        color: file.name == selectedFile
                            ? Colors.grey.withOpacity(0.1)
                            : null,
                      ),
                      child: ListTile(
                        title: Text(file.name),
                        onTap: () {
                          setState(() {
                            selectedFile = file.name;
                            widget.setContent(file.content);
                          });
                        },
                      ),
                    );
                  },
                ),
            ],
          ],
        ),
      );
    }
  }
}
