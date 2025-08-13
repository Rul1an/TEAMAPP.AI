// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/services/pii_sanitizer.dart';

void main() {
  test('sanitizes emails and bearer tokens in strings', () {
    final input = 'user john.doe@example.com token Bearer abc.def';
    final out = PiiSanitizer.sanitizeString(input);
    expect(out.contains('example.com'), isFalse);
    expect(out.contains(PiiSanitizer.redacted), isTrue);
  });

  test('redacts sensitive keys in maps', () {
    final input = {
      'email': 'john@acme.io',
      'token': 'secret',
      'nested': {
        'authorization': 'Bearer xyz',
        'note': 'hello john@acme.io',
      }
    };
    final out = PiiSanitizer.sanitizeMap(input);
    expect(out['email'], PiiSanitizer.redacted);
    expect(out['token'], PiiSanitizer.redacted);
    final nested = out['nested'] as Map<String, dynamic>;
    expect(nested['authorization'], PiiSanitizer.redacted);
    expect((nested['note'] as String).contains('acme.io'), isFalse);
  });
}
