import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/core/result.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('should create success result with data', () {
        const data = 'test data';
        final result = Result.success(data);

        expect(result.isSuccess, true);
        expect(result.isFailure, false);
        expect(result.dataOrNull, data);
        expect(result.value, data);
        expect(result.errorOrNull, null);
      });

      test('when should call success callback', () {
        const data = 'test data';
        final result = Result.success(data);

        final output = result.when(
          success: (data) => 'success: $data',
          failure: (error) => 'failure: ${error.message}',
        );

        expect(output, 'success: $data');
      });

      test('fold should call onSuccess callback', () {
        const data = 'test data';
        final result = Result.success(data);

        final output = result.fold(
          (error) => 'error: ${error.toString()}',
          (data) => 'success: $data',
        );

        expect(output, 'success: $data');
      });
    });

    group('Failure', () {
      test('should create failure result with error', () {
        final error = Exception('test error');
        final result = Result.failure<String>(error);

        expect(result.isSuccess, false);
        expect(result.isFailure, true);
        expect(result.dataOrNull, null);
        expect(result.errorOrNull, isA<GenericFailure>());
        expect(result.errorOrNull?.message, 'Exception: test error');
      });

      test('when should call failure callback', () {
        final error = Exception('test error');
        final result = Result.failure<String>(error);

        final output = result.when(
          success: (data) => 'success: $data',
          failure: (error) => 'failure: ${error.message}',
        );

        expect(output, 'failure: Exception: test error');
      });

      test('fold should call onFailure callback', () {
        final error = Exception('test error');
        final result = Result.failure<String>(error);

        final output = result.fold(
          (error) => 'error: ${error.toString()}',
          (data) => 'success: $data',
        );

        expect(output, 'error: Exception: Exception: test error');
      });

      test('value should throw exception on failure', () {
        final result = Result.failure<String>(Exception('test error'));

        expect(() => result.value, throwsException);
      });
    });

    group('AppFailure types', () {
      test('GenericFailure should store message', () {
        const message = 'generic error';
        const failure = GenericFailure(message);

        expect(failure.message, message);
        expect(failure.toString(), 'AppFailure($message)');
      });

      test('GenericFailure.generic constructor should work', () {
        const message = 'generic error';
        const failure = GenericFailure.generic(message);

        expect(failure.message, message);
      });

      test('NetworkFailure should store message', () {
        const message = 'network error';
        const failure = NetworkFailure(message);

        expect(failure.message, message);
        expect(failure.toString(), 'AppFailure($message)');
      });

      test('CacheFailure should store message', () {
        const message = 'cache error';
        const failure = CacheFailure(message);

        expect(failure.message, message);
        expect(failure.toString(), 'AppFailure($message)');
      });

      test('UnauthorizedFailure should have default message', () {
        const failure = UnauthorizedFailure();

        expect(failure.message, 'Unauthorized');
        expect(failure.toString(), 'AppFailure(Unauthorized)');
      });
    });

    group('Complex scenarios', () {
      test('should handle different data types', () {
        final intResult = Result.success(42);
        final listResult = Result.success<List<String>>(['a', 'b', 'c']);
        final mapResult = Result.success<Map<String, int>>({'key': 123});

        expect(intResult.value, 42);
        expect(listResult.value, ['a', 'b', 'c']);
        expect(mapResult.value, {'key': 123});
      });

      test('should handle null data', () {
        final result = Result.success<String?>(null);

        expect(result.isSuccess, true);
        expect(result.value, null);
        expect(result.dataOrNull, null);
      });

      test('should chain operations with when', () {
        final result = Result.success(10);

        final doubled = result.when(
          success: (value) => Result.success(value * 2),
          failure: (error) => Result.failure<int>(Exception(error.message)),
        );

        expect(doubled.value, 20);
      });
    });
  });
}
