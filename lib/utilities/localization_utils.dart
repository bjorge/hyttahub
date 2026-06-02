// Copyright (c) 2025 bjorge

import 'package:hyttahub/preferences_cubits/language_cubit.dart';

/// Parses multiline text with language delimiters (e.g. `### en ###`) and
/// extracts the block matching the current [language].
///
/// **Fallback Strategy:**
/// 1. Finds direct language match (e.g., `es`).
/// 2. If missing, falls back to English (`en`).
/// 3. If English is also missing, falls back to the first language defined in the text.
/// 4. If no delimiters are detected at all, returns the entire string (ensures backward compatibility).
String getLocalizedContent(String content, AppLanguage language) {
  // Regex matches "### en ###", "### en-US ###", "### nb ###", case-insensitively.
  // Using multiLine: true lets ^ match at the beginning of any line.
  final pattern = RegExp(r'^###\s*([a-zA-Z-]+)\s*###', multiLine: true);
  final matches = pattern.allMatches(content).toList();

  // Backward compatibility: if no markup is found, return the whole text.
  if (matches.isEmpty) {
    return content;
  }

  final sections = <String, String>{};

  for (int i = 0; i < matches.length; i++) {
    final match = matches[i];
    final langCode = match.group(1)!.trim().toLowerCase();

    final start = match.end;
    final end = (i + 1 < matches.length) ? matches[i + 1].start : content.length;

    sections[langCode] = content.substring(start, end).trim();
  }

  // 1. Direct Match
  final targetLang = language.name.toLowerCase();
  if (sections.containsKey(targetLang)) {
    return sections[targetLang]!;
  }

  // 2. English Fallback
  if (sections.containsKey('en')) {
    return sections['en']!;
  }

  // 3. First available language block
  if (sections.isNotEmpty) {
    return sections.values.first;
  }

  return content;
}
