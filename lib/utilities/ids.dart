// Copyright (c) 2025 bjorge

import 'dart:math';

String generateSiteId() {
  final random = Random();
  const validChars = '123456789ABCDE';
  const allValidChars = '123456789ABCDEFG';

  // Generate the first character ensuring it is not 'F' or 'G'
  // reserve these site ids for friend snapshots
  final firstChar = validChars[random.nextInt(validChars.length)];

  // Generate the remaining 7 characters
  final remainingChars = List.generate(
    7,
    (index) => allValidChars[random.nextInt(allValidChars.length)],
  );

  // Combine the first character with the remaining characters
  return firstChar + remainingChars.join();
}
