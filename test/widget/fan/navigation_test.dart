// ignore_for_file: cascade_invocations

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/config/router_fan.dart';
import 'package:jo17_tactical_manager/providers/demo_mode_provider.dart';
import 'package:jo17_tactical_manager/widgets/demo_mode_starter.dart';

void main() {
  Future<void> _pumpFanApp(WidgetTester tester) async {
    // Activate demo mode so router skips auth redirect.
    final demo = DemoModeNotifier()..startDemo(role: DemoRole.player);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [demoModeProvider.overrideWith((ref) => demo)],
        child: Consumer(
          builder: (context, ref, _) => MaterialApp.router(
            routerConfig: ref.watch(routerFanProvider),
            builder: (context, child) => DemoModeStarter(child: child!),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Navigate to Training, Matches, Players, Stats within ≤ 3 taps', (
    tester,
  ) async {
    await _pumpFanApp(tester);

    // Mapping of card label → finder expecting on destination screen.
    final destinations = <String, Finder>{
      'Trainingen': find.text('Trainingen'),
      'Wedstrijden': find.text('Wedstrijden'),
      'Spelers': find.text('Spelers'),
      'Mijn Statistieken': find.text('Mijn Statistieken'),
    };

    for (final entry in destinations.entries) {
      // Ensure we are on home screen
      expect(find.text('Home'), findsOneWidget);

      // Tap card (by label)
      await tester.tap(find.text(entry.key));
      await tester.pumpAndSettle();

      // Destination should appear within single navigation stack push (≤ 3 taps implicitly)
      expect(entry.value, findsOneWidget);

      // Navigate back to home for next iteration
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  });
}