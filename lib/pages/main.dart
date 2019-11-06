import 'dart:html';

import 'package:flutter/material.dart';
import 'package:bird_flutter/bird_flutter.dart';
import 'package:templateplease/util/util.dart';
import 'package:templateplease/widget_paste.dart';
import 'package:templateplease/widget_placeholders.dart';
import 'package:templateplease/widget_preview.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../widget_gist.dart';
import 'main_bloc.dart';

Widget mainPage() {
  return $$ >> (context) {
    final bloc = $$$(() => MainPageBloc());

    useMemoized(() {
      String _getGistIDOrNull() {
        final uri = Uri.tryParse(window.location.href);
        if (uri == null) {
          return null;
        }
        final id = uri.queryParameters["gist"]?.toString();
        if (id == null || id == "" || id == null || id == "null") {
          return null;
        }
        return id;
      }
      bloc.setGistID(_getGistIDOrNull());
    });

    final sourceText = $(() => bloc.sourceText);
    final error = $(() => bloc.error);
    final loadedGistOrNull = $(() => bloc.loadedGistOrNull);
    final vars = $(() => bloc.vars);

    return apply
    & villainFadeIn(curve: Curves.easeOutCubic).inTimeMS(800)
    & villainTranslateY(from: 20.0, curve: Curves.easeOutQuart).inTimeMS(800)
    & fluidByMarginH2(800)
    & scaffold(color: Colors.white)
    & center()
        > onListView(
          padding: const EdgeInsets.all(18.0),
          shrinkWrap: true,
        ) >> [
          villainScale(from: 1.2, curve: Curves.bounceOut).inTimeMS(400)
          & padding(bottom: 12.0)
              > _templatePleaseTitle(),

          card() & padding(all: 18.0) > onColumn() >> [
            paste(bloc.setGistID),

            if (loadedGistOrNull != null)
              padding(top: 24.0) > gistInfoWidget(
                loadedGistOrNull,
                bloc.setSourceText,
                bloc.setError
              ),

            if (sourceText.isNotEmpty)
              ...[
                padding(vertical: 12.0) > editPlaceholders(
                  vars: vars.map((key, value) {
                    return MapEntry(removeBraces(key), value);
                  }),
                  source: sourceText,
                  error: error,
                  setError: bloc.setError,
                  setOutput: bloc.setOutput,
                  setValueFor: bloc.setValueFor,
                ),
                previewWidget(bloc.outputText),
              ],
          ],

          _footer(),
        ];
  };
}

Widget _templatePleaseTitle() {
  return center()
  & onTap(() {
    window.open(Uri.parse(window.location.href).replace(
        queryParameters: <String, dynamic>{})?.toString(), "");
  })
  & textProperties(
    size: 36.0,
    align: TextAlign.center,
    weight: FontWeight.w900,
  ) > const Text("Template, Please");
}

Widget _footer() {
  Applicator _verticalCenter() {
    return apply((child) => height(20.0) > onRowMinCenterCenter() >> [child]);
  }

  final tracker = ChoreographyDelayTracker(ms200);

  Widget divider() =>
      apply
      & villainFadeIn().delay(tracker.getPreMS(70))
      & _verticalCenter() > const Text("•");

  return center() & padding(horizontal: 4.0, vertical: 8.0) > Wrap(
    spacing: 8.0,
    runSpacing: 8.0,
    children: <Widget>[
      apply
      & villainFadeIn().delay(tracker.getPreMS(70))
      & _verticalCenter()
      & onTap(() =>
          openUrl(
              "https://github.com/modulovalue/templateplease/issues"))
          > Text(
        "Issues?",
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.grey,
        ),
      ),

      divider(),

      apply
      & villainFadeIn().delay(tracker.getPreMS(70))
      & _verticalCenter()
      & onTap(() => openUrl("https://github.com/modulovalue/templateplease"))
          > Text(
        "GitHub",
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.grey,
        ),
      ),

      divider(),

      apply
      & villainFadeIn().delay(tracker.getPreMS(70))
      & _verticalCenter()
      & onTap(() => openUrl("https://twitter.com/modulovalue"))
          > Text(
        "@modulovalue",
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.grey,
        ),
      ),

      divider(),

      apply
      & villainFadeIn().delay(tracker.getPreMS(70))
      & _verticalCenter() >
          const FlutterLogo(
            size: 50.0,
            style: FlutterLogoStyle.horizontal,
          ),
    ],
  );
}