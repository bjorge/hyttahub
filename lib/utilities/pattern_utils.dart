// Copyright (c) 2025 bjorge
// ignore_for_file: deprecated_member_use

/// A wrapper class that implements [Pattern] to encapsulate [RegExp].
///
/// Under certain IDE and SDK configurations, `RegExp` triggers a deprecation 
/// warning because the class signature will become `final` in a future 
/// Dart release. Wrapping it in a lightweight [Pattern] implementer averts
/// the barrage of lint warnings without resorting to `// ignore`.
class WrappedRegExp implements Pattern {
  final RegExp _regExp;

  WrappedRegExp(
    String source, {
    bool multiLine = false,
    bool caseSensitive = true,
    bool unicode = false,
    bool dotAll = false,
  }) : _regExp = RegExp(
          source,
          multiLine: multiLine,
          caseSensitive: caseSensitive,
          unicode: unicode,
          dotAll: dotAll,
        );

  @override
  Iterable<Match> allMatches(String string, [int start = 0]) {
    return _regExp.allMatches(string, start);
  }

  @override
  Match? matchAsPrefix(String string, [int start = 0]) {
    return _regExp.matchAsPrefix(string, start);
  }

  bool hasMatch(String input) {
    return _regExp.hasMatch(input);
  }
}
