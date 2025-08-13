import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ID String Policy: no "int id" fields in lib/models/**', () async {
    final projectRoot = Directory.current.path;
    final modelsDir = Directory('$projectRoot/lib/models');
    expect(await modelsDir.exists(), isTrue);

    final badFiles = <String>[];
    await for (final entity in modelsDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final content = await entity.readAsString();
        // Simple heuristic: forbid `int id` and `int? id` declarations.
        if (RegExp(r'\bint\??\s+id\b').hasMatch(content)) {
          badFiles.add(entity.path);
        }
      }
    }

    if (badFiles.isNotEmpty) {
      fail('Found non-String id fields in: \n${badFiles.join('\n')}');
    }
  });
}
