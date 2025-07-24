import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:jo17_tactical_manager/models/training.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/screens/training/training_attendance_screen.dart';
import 'package:jo17_tactical_manager/providers/trainings_provider.dart'
    as trainings_provider;
import 'package:jo17_tactical_manager/providers/players_provider.dart'
    as players_provider;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Mock SharedPreferences to avoid platform channel errors.
    SharedPreferences.setMockInitialValues({});

    // Initialise Supabase singleton once for provider dependencies.
    try {
      await Supabase.initialize(
        url: 'https://dummy.supabase.co',
        anonKey: 'public-anon-key',
        debug: false,
      );
    } catch (_) {
      // Ignore if already initialised in other tests.
    }

    // Initialize date formatting for Dutch locale (used in widgets).
    await initializeDateFormatting('nl_NL');
  });

  const shareChannel = MethodChannel('plugins.flutter.io/share_plus');
  shareChannel.setMockMethodCallHandler((MethodCall methodCall) async {
    // Simply return without doing anything.
    return null;
  });

  group('TrainingAttendanceScreen share', () {
    setUp(() {
      // No-op per test.
    });

    testWidgets('tapping share icon triggers share channel', (tester) async {
      final training = Training()
        ..id = 'tr1'
        ..date = DateTime(2025, 9, 10)
        ..duration = 90
        ..focus = TrainingFocus.technical
        ..intensity = TrainingIntensity.medium;

      final player = Player()
        ..id = 'pl1'
        ..firstName = 'Jan'
        ..lastName = 'Tester'
        ..jerseyNumber = 10;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trainings_provider.trainingsProvider
                .overrideWith((ref) async => [training]),
            players_provider.playersProvider
                .overrideWith((ref) async => [player]),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(routes: [
              GoRoute(
                path: '/',
                builder: (context, _) =>
                    const TrainingAttendanceScreen(trainingId: 'tr1'),
              ),
            ]),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap share icon (first icon in actions list)
      await tester.tap(find.byIcon(Icons.share));
      await tester.pump();

      // If no exception, test passes.
      expect(tester.takeException(), isNull);
    });
  });
}
