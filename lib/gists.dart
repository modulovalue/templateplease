import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

const String _gistApiUrl = 'https://api.github.com/gists';

final RegExp _gistRegex = RegExp(r'[0-9a-f]+$');

String gistIDFromString(String url) {
  final matches = _gistRegex.allMatches(url);
  if (matches.isNotEmpty) {
    return matches.first.group(0);
  } else {
    return null;
  }
}

/// Load the gist with the given id.
Future<Gist> loadGist({
  @required Client client,
  @required String gistId,
  String gistApiUrl = _gistApiUrl,
}) async {
  // Load the gist using the github gist API:
  // https://developer.github.com/v3/gists/#get-a-single-gist.
  final response = await client.get('$gistApiUrl/$gistId');

  if (response.statusCode == 404) {
    throw const GistLoaderException(GistLoaderFailureType.contentNotFound);
  } else if (response.statusCode == 403) {
    throw const GistLoaderException(GistLoaderFailureType.rateLimitExceeded);
  } else if (response.statusCode != 200) {
    throw const GistLoaderException(GistLoaderFailureType.unknown);
  }

  final gist = Gist.fromMap(json.decode(response.body) as Map);

  return gist;
}

enum GistLoaderFailureType {
  unknown,
  contentNotFound,
  rateLimitExceeded,
  invalidExerciseMetadata,
}

class GistLoaderException implements Exception {
  final String message;
  final GistLoaderFailureType failureType;

  const GistLoaderException(this.failureType, [this.message]);
}

/// A representation of a Github gist.
class Gist {
  final String id;
  final String description;
  final String htmlUrl;
  final String summary;
  final bool public;
  final List<GistFile> files;

  const Gist({
    @required this.id,
    @required this.htmlUrl,
    @required this.summary,
    this.description,
    this.public = true,
    this.files = const [],
  });

  factory Gist.fromMap(Map map) {
    final f = map['files'] as Map<dynamic, dynamic>;
    return Gist(
      id: map['id'] as String,
      description: map['description'] as String,
      public: map['public'] as bool,
      htmlUrl: map['html_url'] as String,
      summary: map['summary'] as String,
      files: f.keys
          .map((dynamic key) => GistFile.fromMap(key as String, f[key] as Map))
          .toList(),
    );
  }

  dynamic operator [](String key) {
    if (key == 'id') return id;
    if (key == 'description') return description;
    if (key == 'html_url') return htmlUrl;
    if (key == 'public') return public;
    if (key == 'summary') return summary;
    for (final GistFile file in files) {
      if (file.name == key) return file.content;
    }
    return null;
  }

  GistFile getFile(String name, {bool ignoreCase = false}) {
    if (ignoreCase) {
      // ignore: parameter_assignments
      name = name.toLowerCase();
      return files.firstWhere((f) => f.name.toLowerCase() == name,
          orElse: () => null);
    } else {
      return files.firstWhere((f) => f.name == name, orElse: () => null);
    }
  }

  bool hasWebContent() {
    return files.any((GistFile file) {
      final bool isWebFile =
          file.name.endsWith('.html') || file.name.endsWith('.css');
      return isWebFile && file.content.trim().isNotEmpty;
    });
  }

  Map toMap() {
    final m = <dynamic, dynamic>{};
    if (id != null) m['id'] = id;
    if (description != null) m['description'] = description;
    if (public != null) m['public'] = public;
    if (summary != null) m['summary'] = summary;
    m['files'] = <dynamic, dynamic>{};
    for (final GistFile file in files) {
      if (file.hasContent) {
        m['files'][file.name] = {'content': file.content};
      }
    }
    return m;
  }

  String toJson() => json.encode(toMap());

  Gist clone() => Gist.fromMap(json.decode(toJson()) as Map);

  @override
  String toString() => id;
}

class GistFile {
  final String name;
  final String content;

  const GistFile({this.name, this.content});

  factory GistFile.fromMap(String name, Map data) {
    return GistFile(
      name: name,
      content: data['content'] as String,
    );
  }

  bool get hasContent => content != null && content.trim().isNotEmpty;

  @override
  String toString() => '[$name, ${content.length} chars]';
}
