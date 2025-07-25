// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/core/result.dart';

void main() {
  group('Result', () {
    test('success returns data', () {
      const result = Success<int>(42);
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, 42);
      expect(result.errorOrNull, isNull);
    });

    test('failure returns error', () {
      const result = Failure<int>(NetworkFailure('no internet'));
      expect(result.isSuccess, isFalse);
      expect(result.dataOrNull, isNull);
      expect(result.errorOrNull, isA<NetworkFailure>());
    });

    test('when helper works', () {
      const result = Success<String>('ok');
      final msg = result.when(
        success: (d) => 'data=$d',
        failure: (_) => 'error',
      );
      expect(msg, 'data=ok');
    });
  });
}
