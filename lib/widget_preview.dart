import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PreviewWidget extends StatefulWidget {
  final String text;
  final TextEditingController outputController;

  const PreviewWidget(this.text, this.outputController);

  @override
  _PreviewWidgetState createState() => _PreviewWidgetState();
}

class _PreviewWidgetState extends State<PreviewWidget> {
  PreviewType preview = PreviewType.text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.text.isNotEmpty) //
          ...[
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              _button(
                text: "Text Preview",
                unselected: preview != PreviewType.text,
                onTap: () => setState(() => preview = PreviewType.text),
              ),
              _button(
                text: "Markdown Preview",
                unselected: preview != PreviewType.markdown,
                onTap: () => setState(() => preview = PreviewType.markdown),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          _previewWidget(() {
            return widget.text;
          }(), preview),
          const SizedBox(height: 18.0),
          TextField(
            maxLines: 4,
            decoration: const InputDecoration(
              helperText: "Select all (Ctrl/Cmd + A) > Copy (Ctrl/Cmd + C)",
              border: OutlineInputBorder(),
            ),
            controller: widget.outputController,
          ),
        ],
      ],
    );
  }
}

Widget _previewWidget(String text, PreviewType preview) {
  switch (preview) {
    case PreviewType.text:
      return Text(text);
    case PreviewType.markdown:
      return MarkdownBody(data: text);
  }
  throw Exception("preview was null");
}

enum PreviewType {
  text,
  markdown,
}

Widget _button({
  @required bool unselected,
  @required String text,
  @required void Function() onTap,
}) {
  return Container(
    height: 28.0,
    child: RaisedButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        disabledColor: Colors.blue,
        child: Text(
          text,
          style: TextStyle(
            color: unselected ? Colors.black.withOpacity(0.3) : Colors.white,
          ),
        ),
        onPressed: unselected ? onTap : null),
  );
}
