import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:bird_flutter/bird_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Widget previewWidget(Wave<String> outputWave) {
  return $$ >> (context) {
    final outputText = $(() => outputWave);
    final preview = useState(PreviewType.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (outputText.isNotEmpty) //
          ...[
            verticalSpace(12.0),

            onWrapStartCenter(allSpacing: 8.0) >> [
              _button(
                text: "Text Preview",
                unselected: preview.value != PreviewType.text,
                onTap: () => preview.value = PreviewType.text,
              ),
              _button(
                text: "Markdown Preview",
                unselected: preview.value != PreviewType.markdown,
                onTap: () => preview.value = PreviewType.markdown,
              ),
            ],

            verticalSpace(24.0),

            _previewBody(outputText, preview.value),

            verticalSpace(18.0),

            $$ >> (context) {
              final textController = useTextControllerFromText(outputText);

              return TextField(
                maxLines: 4,
                decoration: const InputDecoration(
                  helperText: "Select all (Ctrl/Cmd + A) > Copy (Ctrl/Cmd + C)",
                  border: OutlineInputBorder(),
                ),
                controller: textController,
              );
            },
          ],
      ],
    );
  };
}

Widget _previewBody(String text, PreviewType preview) {
  switch (preview) {
    case PreviewType.text:
      return Text(text);
    case PreviewType.markdown:
      return MarkdownBody(
        data: text,
        onTapLink: (url) => window.open(url, url),
      );
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
  return height(28.0) > RaisedButton(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28.0),
    ),
    disabledColor: Colors.blue,
    child: Text(
      text,
      style: TextStyle(
        color: unselected ? Colors.black.withOpacity(0.3) : Colors.white,
      ),
    ),
    onPressed: unselected ? onTap : null,
  );
}

// TODO move to bird
TextEditingController useTextControllerFromText(String txt) {
  final textController = useDispose(() {
    return TextEditingController(text: txt);
  }, (TextEditingController a) =>
      a.dispose());

  useMemoized(() {
    textController.text = txt;
  }, [txt]);

  return textController;
}
