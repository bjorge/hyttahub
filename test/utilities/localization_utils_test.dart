// Copyright (c) 2025 bjorge

import 'package:flutter_test/flutter_test.dart';
import 'package:hyttahub/preferences_cubits/language_cubit.dart';
import 'package:hyttahub/utilities/localization_utils.dart';

void main() {
  group('getLocalizedContent', () {
    test('returns entire content when no delimiters are present', () {
      const content = 'These are the terms of service with no markup.';
      expect(getLocalizedContent(content, AppLanguage.en), content);
      expect(getLocalizedContent(content, AppLanguage.nb), content);
    });

    test('extracts exact matching language block', () {
      const content = '''
### en ###
Terms in English.

### nb ###
Vilkår på norsk.
''';

      expect(getLocalizedContent(content, AppLanguage.en), 'Terms in English.');
      expect(getLocalizedContent(content, AppLanguage.nb), 'Vilkår på norsk.');
    });

    test('is case insensitive and tolerant of spaces inside delimiters', () {
      const content = '''
###   EN   ###
Terms in English.

### Nb ###
Vilkår på norsk.
''';

      expect(getLocalizedContent(content, AppLanguage.en), 'Terms in English.');
      expect(getLocalizedContent(content, AppLanguage.nb), 'Vilkår på norsk.');
    });

    test('falls back to English when direct match is missing', () {
      const content = '''
### en ###
Terms in English.

### nb ###
Vilkår på norsk.
''';

      // AppLanguage.es has no direct block, should fallback to 'en' block.
      expect(getLocalizedContent(content, AppLanguage.es), 'Terms in English.');
    });

    test('falls back to first available language when direct match and English are missing', () {
      const content = '''
### nb ###
Vilkår på norsk.

### es ###
Términos en español.
''';

      // AppLanguage.it has no direct block, and 'en' is also missing.
      // Should fallback to the first block, which is 'nb'.
      expect(getLocalizedContent(content, AppLanguage.it), 'Vilkår på norsk.');
    });
  });
}
