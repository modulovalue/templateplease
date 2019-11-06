import 'dart:html';

import 'package:dart_pad/sharing/gists.dart';
import 'package:bird_flutter/bird_flutter.dart';
import 'package:templateplease/util/util.dart';

// ignore_for_file: close_sinks
class MainPageBloc extends HookBloc {
  final Signal<String> _sourceText = HookBloc.disposeSink(Signal(""));
  final Signal<String> _error = HookBloc.disposeSink(Signal(""));
  final Signal<String> _outputText = HookBloc.disposeSink(Signal(""));
  final Signal<Map<String, String>> _vars = HookBloc.disposeSink(Signal({}));
  final Signal<String> _loadedGistOrNull = HookBloc.disposeSink(Signal(null));

  /// Waves for accessing the blocs data.
  Wave<String> sourceText;
  Wave<String> error;
  Wave<String> loadedGistOrNull;
  Wave<String> outputText;
  Wave<Map<String, String>> vars;

  MainPageBloc() {
    sourceText = _sourceText.wave;
    error = _error.wave;
    loadedGistOrNull = _loadedGistOrNull.wave;
    vars = _vars.wave;
    outputText = _outputText.wave;
  }

  /// Sets a new value for the placeholder at [key]
  void setValueFor(String key, String newVal) {
    _vars.add(Map.from(_vars.value)
      ..["{{$key}}"] = newVal);
  }

  /// Sets an error in case something didn't work as expected.
  void setError(String err) {
    _error.add(err);
  }

  /// Sets the output text that the user can then copy and paste
  void setOutput(String str) {
    _outputText.add(str);
  }

  /// Sets the source text that is then parsed for placeholder variables
  void setSourceText(String text) {
    _sourceText.add(text);
    final oldVars = _vars.value.keys.toSet();
    final newVars = findVariableNames(_sourceText.value ?? "");
    final oldDif = oldVars.difference(newVars);
    final newDif = newVars.difference(oldVars);
    final _varss = _vars.value;
    oldDif.forEach((str) => _varss.remove(str));
    newDif.forEach((str) => _varss[str] = "");
    _vars.add(_varss);
  }

  /// Sets a new gist ID.
  void setGistID(String gistID) {
    if (isLegalGistId(gistID)) {
      _loadedGistOrNull.add(gistID);
      setSourceText("");
      final uri = Uri.parse(window.location.href);
      final newurl = uri
          .replace(
          queryParameters: Map<String, dynamic>.from(uri.queryParameters)
            ..["gist"] = gistID)
          ?.toString();
      window.history.pushState({"path": newurl}, '', newurl);
    }
  }
}
