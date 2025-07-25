import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/utils/validators/training_validators.dart';

void main() {
  group('validateDuration', () {
    test('null or empty', () {
      expect(validateDuration(null), isNotNull);
      expect(validateDuration(''), isNotNull);
    });

    test('non numeric', () {
      expect(validateDuration('abc'), isNotNull);
    });

    test('below minimum', () {
      expect(validateDuration('10'), isNotNull);
    });

    test('above maximum', () {
      expect(validateDuration('300'), isNotNull);
    });

    test('within range', () {
      expect(validateDuration('60'), isNull);
    });
  });

  group('validateRequired', () {
    test('null value returns error', () {
      expect(validateRequired(null, 'Focus'), isNotNull);
    });

    test('non-null passes', () {
      expect(validateRequired('value', 'Field'), isNull);
    });
  });

  group('validateDate', () {
    test('null date', () {
      expect(validateDate(null), isNotNull);
    });

    test('far future date', () {
      final future = DateTime.now().add(const Duration(days: 400));
      expect(validateDate(future), isNotNull);
    });

    test('valid date', () {
      final date = DateTime.now().add(const Duration(days: 10));
      expect(validateDate(date), isNull);
    });
  });
}
