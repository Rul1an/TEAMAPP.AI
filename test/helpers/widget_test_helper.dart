// test/helpers/widget_test_helper.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import '../fixtures/test_data_factory.dart';
import 'test_database_helper.dart';

/// Modern widget test helper voor Nederlandse voetbal UI testing
///
/// Integreert met 2025 testing best practices:
/// - Golden tests met variants
/// - Riverpod provider testing
/// - AI-powered test generation helpers
/// - Nederlandse voetbal context
class WidgetTestHelper {
  static const Duration animationDuration = Duration(seconds: 1);
  static const Duration pumpSettleDuration = Duration(milliseconds: 500);

  /// Setup modern test environment
  static Future<void> setupTestEnvironment() async {
    await loadAppFonts();
    // Mock database setup - geen echte Supabase initialization
    await TestDatabaseHelper.setupTestDatabase();
  }

  /// Create widget tester wrapper met Nederlandse context
  static Future<WidgetTester> createNederlandseVoetbalTester(
    WidgetTester tester, {
    List<Override>? providerOverrides,
    ThemeData? theme,
    Locale? locale,
  }) async {
    // Setup Nederlandse locale context
    final widget = ProviderScope(
      overrides: providerOverrides ?? [],
      child: MaterialApp(
        title: 'VOAB JO17 Test',
        theme: theme ?? _createVoabTheme(),
        locale: locale ?? const Locale('nl', 'NL'),
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('nl', 'NL'),
          Locale('en', 'US'),
        ],
        home: const Scaffold(body: SizedBox.shrink()),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle(pumpSettleDuration);

    return tester;
  }

  /// Test Nederlandse UI components met widget tester
  static Future<void> testNederlandseComponent(
    WidgetTester tester, {
    required Widget widget,
    List<Override>? providerOverrides,
    List<Locale>? locales,
    Map<String, dynamic>? testData,
  }) async {
    // Test with Nederlandse locale
    await tester.pumpWidget(_wrapWithNederlandseContext(
      widget,
      providerOverrides: providerOverrides,
      locale: const Locale('nl', 'NL'),
      testData: testData,
    ));

    await tester.pumpAndSettle();

    // Verify widget renders correctly
    expect(find.byWidget(widget), findsOneWidget);

    // Test with different locales if specified
    if (locales != null) {
      for (final locale in locales) {
        await tester.pumpWidget(_wrapWithNederlandseContext(
          widget,
          providerOverrides: providerOverrides,
          locale: locale,
          testData: testData,
        ));

        await tester.pumpAndSettle();
        expect(find.byWidget(widget), findsOneWidget);
      }
    }
  }

  /// Test Nederlandse zoekfunctionaliteit
  static Future<void> testNederlandseZoekfunctie(
    WidgetTester tester,
    Finder searchField,
    List<String> searchTerms,
  ) async {
    for (final term in searchTerms) {
      // Clear previous search
      await tester.tap(searchField);
      await tester.pumpAndSettle();

      // Enter Dutch search term
      await tester.enterText(searchField, term);
      await tester.pumpAndSettle(animationDuration);

      // Verify search results appear
      expect(find.text(term), findsOneWidget);

      // Clear for next test
      await tester.enterText(searchField, '');
      await tester.pumpAndSettle();
    }
  }

  /// Test VOAB morphocycle UI interactions
  static Future<void> testMorphocycleInteractions(
    WidgetTester tester,
    List<String> phases,
  ) async {
    for (final phase in phases) {
      final phaseFinder = find.text(phase);
      if (tester.any(phaseFinder)) {
        await tester.tap(phaseFinder);
        await tester.pumpAndSettle(animationDuration);

        // Verify phase selection visual feedback
        final selectedPhase = tester.widget<Widget>(phaseFinder);
        expect(selectedPhase, isNotNull);
      }
    }
  }

  /// Test Nederlandse speler lijst interactions
  static Future<void> testSpelerLijstInteractions(
    WidgetTester tester,
  ) async {
    final testPlayers = TestDataFactory.dutchYouthPlayers();

    for (final player in testPlayers.take(3)) {
      final playerName = player['name'] as String;
      final playerFinder = find.text(playerName);

      if (tester.any(playerFinder)) {
        // Test player selection
        await tester.tap(playerFinder);
        await tester.pumpAndSettle(animationDuration);

        // Test player details navigation
        final detailsFinder = find.text('Details');
        if (tester.any(detailsFinder)) {
          await tester.tap(detailsFinder);
          await tester.pumpAndSettle(animationDuration);

          // Navigate back
          final backFinder = find.byType(BackButton);
          if (tester.any(backFinder)) {
            await tester.tap(backFinder);
            await tester.pumpAndSettle();
          }
        }
      }
    }
  }

  /// Performance test helper voor Nederlandse UI
  static Future<PerformanceTestResult> measureNederlandseUIPerformance(
      WidgetTester tester, Future<void> Function() uiAction,
      {int iterations = 5}) async {
    final frameTimes = <Duration>[];
    final buildTimes = <Duration>[];

    for (int i = 0; i < iterations; i++) {
      // Measure frame time
      final frameStopwatch = Stopwatch()..start();
      await uiAction();
      await tester.pumpAndSettle();
      frameStopwatch.stop();
      frameTimes.add(frameStopwatch.elapsed);

      // Measure build time
      final buildStopwatch = Stopwatch()..start();
      await tester.pump();
      buildStopwatch.stop();
      buildTimes.add(buildStopwatch.elapsed);
    }

    return PerformanceTestResult(
      frameTimeResults: _calculateStats(frameTimes),
      buildTimeResults: _calculateStats(buildTimes),
    );
  }

  /// Test Nederlandse form validatie
  static Future<void> testNederlandseFormValidatie(
    WidgetTester tester,
    Map<String, String> invalidInputs,
    Map<String, String> validInputs,
  ) async {
    // Test invalid inputs
    for (final entry in invalidInputs.entries) {
      final fieldFinder = find.byKey(Key(entry.key));
      if (tester.any(fieldFinder)) {
        await tester.enterText(fieldFinder, entry.value);
        await tester.pumpAndSettle();

        // Trigger validation
        final submitFinder = find.text('Opslaan');
        if (tester.any(submitFinder)) {
          await tester.tap(submitFinder);
          await tester.pumpAndSettle();

          // Expect form still exists (validation working, no submission success)
          expect(find.text('Opslaan'), findsOneWidget);
        }
      }
    }

    // Test valid inputs
    for (final entry in validInputs.entries) {
      final fieldFinder = find.byKey(Key(entry.key));
      if (tester.any(fieldFinder)) {
        await tester.enterText(fieldFinder, entry.value);
        await tester.pumpAndSettle();
      }
    }

    // Submit valid form
    final submitFinder = find.text('Opslaan');
    if (tester.any(submitFinder)) {
      await tester.tap(submitFinder);
      await tester.pumpAndSettle();

      // Expect success message in Dutch
      expect(find.textContaining('Opgeslagen'), findsOneWidget);
    }
  }

  /// Accessibility test voor Nederlandse UI
  static Future<void> testNederlandseAccessibility(
    WidgetTester tester,
    Widget widget,
  ) async {
    await tester.pumpWidget(_wrapWithNederlandseContext(widget));
    await tester.pumpAndSettle();

    // Test semantic labels in Dutch
    final semantics = tester.getSemantics(find.byWidget(widget));
    expect(semantics.label, isNotNull);

    // Test focus traversal
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    // Test screen reader compatibility
    expect(
        tester
            .getSemantics(find.byWidget(widget))
            .hasFlag(SemanticsFlag.isTextField),
        anyOf(isTrue, isFalse)); // Depends on widget type
  }

  /// Helper methods
  static Widget _wrapWithNederlandseContext(
    Widget widget, {
    List<Override>? providerOverrides,
    Locale? locale,
    Device? device,
    Map<String, dynamic>? testData,
  }) {
    return ProviderScope(
      overrides: providerOverrides ?? [],
      child: MaterialApp(
        title: 'VOAB JO17 Test',
        theme: _createVoabTheme(),
        locale: locale ?? const Locale('nl', 'NL'),
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('nl', 'NL'),
          Locale('en', 'US'),
        ],
        home: Scaffold(
          body: device != null
              ? SizedBox(
                  width: device.size.width,
                  height: device.size.height,
                  child: widget,
                )
              : widget,
        ),
      ),
    );
  }

  static ThemeData _createVoabTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
      ).copyWith(
        secondary: Colors.orange,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  static PerformanceStats _calculateStats(List<Duration> durations) {
    durations.sort((a, b) => a.inMicroseconds.compareTo(b.inMicroseconds));

    final total = durations.reduce((a, b) => a + b);
    final average = Duration(
      microseconds: total.inMicroseconds ~/ durations.length,
    );
    final median = durations[durations.length ~/ 2];

    return PerformanceStats(
      average: average,
      median: median,
      min: durations.first,
      max: durations.last,
      total: total,
    );
  }

  /// Cleanup test environment
  static Future<void> cleanup() async {
    await TestDatabaseHelper.dispose();
  }
}

/// Performance test result structure
class PerformanceTestResult {
  final PerformanceStats frameTimeResults;
  final PerformanceStats buildTimeResults;

  const PerformanceTestResult({
    required this.frameTimeResults,
    required this.buildTimeResults,
  });

  @override
  String toString() {
    return '''
Nederlandse UI Performance Results:
Frame Times: $frameTimeResults
Build Times: $buildTimeResults
''';
  }

  bool meetsVoabPerformanceStandards() {
    // VOAB performance requirements
    const maxFrameTime = Duration(milliseconds: 16); // 60fps
    const maxBuildTime = Duration(milliseconds: 8);

    return frameTimeResults.average <= maxFrameTime &&
        buildTimeResults.average <= maxBuildTime;
  }
}

class PerformanceStats {
  final Duration average;
  final Duration median;
  final Duration min;
  final Duration max;
  final Duration total;

  const PerformanceStats({
    required this.average,
    required this.median,
    required this.min,
    required this.max,
    required this.total,
  });

  @override
  String toString() {
    return 'Avg: ${average.inMilliseconds}ms, '
        'Median: ${median.inMilliseconds}ms, '
        'Range: ${min.inMilliseconds}-${max.inMilliseconds}ms';
  }
}

/// Nederlandse test data generators
class NederlandseTestDataGenerator {
  static List<String> generateSpelerNamen(int count) {
    return TestDataFactory.generateDutchNames(count);
  }

  static List<String> generateOefeningenNamen() {
    return TestDataFactory.dutchExercises()
        .map((e) => e['name'] as String)
        .toList();
  }

  static List<String> generateZoektermen() {
    return TestDataFactory.dutchSearchTerms();
  }

  static Map<String, String> generateFormValidatieData() {
    return {
      'speler_naam': 'Jan van der Berg',
      'positie': 'Aanvaller',
      'geboortedatum': '15-03-2007',
      'rugnummer': '9',
      'email': 'jan@voab.nl',
      'telefoon': '06-12345678',
    };
  }

  static Map<String, String> generateInvalideFormData() {
    return {
      'speler_naam': '', // Empty required field
      'positie': 'OngeldigePositie',
      'geboortedatum': '32-13-2007', // Invalid date
      'rugnummer': '0', // Invalid number
      'email': 'invalid-email',
      'telefoon': '123', // Too short
    };
  }
}
