import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ID String Policy: no "int id" fields in lib/models/**', () {
    final projectRoot = Directory.current.path;
    final modelsDir = Directory('$projectRoot/lib/models');
    expect(modelsDir.existsSync(), isTrue);

    final badFiles = <String>[];
    final entities = modelsDir.listSync(recursive: true);
    for (final entity in entities) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final content = entity.readAsStringSync();
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
