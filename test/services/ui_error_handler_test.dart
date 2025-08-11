import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/services/ui_error_handler.dart';

void main() {
  group('UI Error Handler Tests (2025 Edition)', () {
    setUp(UIErrorHandler.clearErrorHistory);

    group('Public API Tests', () {
      test('initializes without errors', () {
        expect(UIErrorHandler.initialize, returnsNormally);
        expect(UIErrorHandler.initialize,
            returnsNormally); // Should handle multiple calls
      });

      test('manages error history correctly', () {
        // Initially empty
        expect(UIErrorHandler.getRecentErrors(), isEmpty);

        // Clear empty history
        UIErrorHandler.clearErrorHistory();
        expect(UIErrorHandler.getRecentErrors(), isEmpty);
      });
    });

    group('Safe Numeric Operations', () {
      test('safeToStringAsFixed handles null values', () {
        expect(UIErrorHandler.safeToStringAsFixed(null, 2), equals('0.00'));
      });

      test('safeToStringAsFixed handles valid numbers', () {
        expect(UIErrorHandler.safeToStringAsFixed(3.14159, 2), equals('3.14'));
        expect(UIErrorHandler.safeToStringAsFixed(100, 1), equals('100.0'));
      });

      test('safeToStringAsFixed handles invalid values', () {
        expect(
            UIErrorHandler.safeToStringAsFixed('invalid', 2), equals('0.00'));
        expect(
            UIErrorHandler.safeToStringAsFixed(double.nan, 2), equals('0.00'));
        expect(UIErrorHandler.safeToStringAsFixed(double.infinity, 2),
            equals('0.00'));
      });

      test('safeToDouble handles various input types', () {
        expect(UIErrorHandler.safeToDouble(null), equals(0.0));
        expect(UIErrorHandler.safeToDouble(42), equals(42.0));
        expect(UIErrorHandler.safeToDouble(3.14), equals(3.14));
        expect(UIErrorHandler.safeToDouble('123.45'), equals(123.45));
        expect(UIErrorHandler.safeToDouble('invalid', defaultValue: 99.0),
            equals(99.0));
      });

      test('safeToInt handles various input types', () {
        expect(UIErrorHandler.safeToInt(null), equals(0));
        expect(UIErrorHandler.safeToInt(42), equals(42));
        expect(UIErrorHandler.safeToInt(3.14), equals(3));
        expect(UIErrorHandler.safeToInt('123'), equals(123));
        expect(
            UIErrorHandler.safeToInt('invalid', defaultValue: 99), equals(99));
      });
    });

    group('Safe Numeric Operations Edge Cases', () {
      test('handles extreme values safely', () {
        expect(UIErrorHandler.safeToDouble(double.maxFinite),
            equals(double.maxFinite));
        expect(UIErrorHandler.safeToDouble(-double.maxFinite),
            equals(-double.maxFinite));
        expect(UIErrorHandler.safeToInt(9223372036854775807),
            equals(9223372036854775807)); // Max int
      });

      test('handles string conversion edge cases', () {
        expect(UIErrorHandler.safeToDouble(''), equals(0.0));
        expect(UIErrorHandler.safeToDouble('   '), equals(0.0));
        expect(UIErrorHandler.safeToDouble('3.14abc'), equals(0.0));
        expect(UIErrorHandler.safeToInt('42.7'),
            equals(0)); // int.tryParse fails on decimals
      });

      test('provides correct default values', () {
        expect(UIErrorHandler.safeToDouble('invalid', defaultValue: 42.5),
            equals(42.5));
        expect(UIErrorHandler.safeToInt('invalid', defaultValue: 123),
            equals(123));
      });
    });

    group('Real-world Error Prevention', () {
      test('prevents common Flutter UI errors', () {
        // These are the exact operations that were causing red screen errors
        expect(
            () => UIErrorHandler.safeToStringAsFixed(null, 1), returnsNormally);
        expect(() => UIErrorHandler.safeToStringAsFixed('invalid', 2),
            returnsNormally);
        expect(() => UIErrorHandler.safeToDouble(null), returnsNormally);
        expect(() => UIErrorHandler.safeToInt('not a number'), returnsNormally);

        // Verify they return safe fallbacks
        expect(UIErrorHandler.safeToStringAsFixed(null, 1), equals('0.0'));
        expect(
            UIErrorHandler.safeToStringAsFixed('invalid', 2), equals('0.00'));
        expect(UIErrorHandler.safeToDouble(null), equals(0.0));
        expect(UIErrorHandler.safeToInt('not a number'), equals(0));
      });

      test('handles numeric operations that commonly fail in UI', () {
        // Common scenarios from performance analytics and statistics screens
        dynamic nullValue;
        final dynamic invalidString = 'abc123';
        final dynamic objectValue = {'key': 'value'};

        expect(UIErrorHandler.safeToStringAsFixed(nullValue, 1), equals('0.0'));
        expect(UIErrorHandler.safeToStringAsFixed(invalidString, 2),
            equals('0.00'));
        expect(
            UIErrorHandler.safeToStringAsFixed(objectValue, 1), equals('0.0'));

        expect(UIErrorHandler.safeToDouble(nullValue), equals(0.0));
        expect(UIErrorHandler.safeToDouble(invalidString), equals(0.0));
        expect(UIErrorHandler.safeToDouble(objectValue), equals(0.0));
      });
    });

    group('Performance Tests', () {
      test('safe numeric operations perform efficiently', () {
        final stopwatch = Stopwatch()..start();

        // Perform many operations (simulating heavy UI with lots of numeric displays)
        for (int i = 0; i < 1000; i++) {
          UIErrorHandler.safeToStringAsFixed(i.toDouble(), 2);
          UIErrorHandler.safeToDouble(i);
          UIErrorHandler.safeToInt(i.toString());
        }

        stopwatch.stop();

        // CI-friendly threshold: allow generous time on shared runners
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('handles error scenarios without performance impact', () {
        final stopwatch = Stopwatch()..start();

        // Test with error-prone inputs
        for (int i = 0; i < 100; i++) {
          UIErrorHandler.safeToStringAsFixed(null, 2);
          UIErrorHandler.safeToStringAsFixed('invalid$i', 1);
          UIErrorHandler.safeToDouble('not_a_number_$i');
          UIErrorHandler.safeToInt('invalid_int_$i');
        }

        stopwatch.stop();

        // CI-friendly threshold: allow generous time on shared runners
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
      });
    });

    group('Global Error Handler Integration', () {
      test('runAppWithErrorHandling initializes properly', () {
        // Test that the global wrapper function exists and is callable
        expect(runAppWithErrorHandling, isA<Function>());
      });
    });

    group('Error Type Enum', () {
      test('ErrorType enum is accessible', () {
        // Verify all error types are available
        expect(ErrorType.numericOperation, isNotNull);
        expect(ErrorType.nullReference, isNotNull);
        expect(ErrorType.methodNotFound, isNotNull);
        expect(ErrorType.rangeError, isNotNull);
        expect(ErrorType.network, isNotNull);
        expect(ErrorType.general, isNotNull);
      });
    });

    group('Integration with UI Components', () {
      testWidgets('error handler integrates with widget tree',
          (WidgetTester tester) async {
        // Initialize the error handler
        UIErrorHandler.initialize();

        // Create a simple widget that uses safe numeric operations
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  // Use the safe operations in a widget context
                  final safeValue = UIErrorHandler.safeToStringAsFixed(null, 2);
                  final safeDouble = UIErrorHandler.safeToDouble('invalid');
                  final safeInt = UIErrorHandler.safeToInt(null);

                  return Column(
                    children: [
                      Text('Safe Value: $safeValue'),
                      Text('Safe Double: $safeDouble'),
                      Text('Safe Int: $safeInt'),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        // Verify the widgets display the expected safe fallback values
        expect(find.text('Safe Value: 0.00'), findsOneWidget);
        expect(find.text('Safe Double: 0.0'), findsOneWidget);
        expect(find.text('Safe Int: 0'), findsOneWidget);
      });
    });
  });
}
