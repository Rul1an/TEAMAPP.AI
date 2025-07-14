// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/models/training.dart';
import 'package:jo17_tactical_manager/screens/training/training_attendance_screen.dart';

import 'package:jo17_tactical_manager/providers/players_provider.dart'
    as players_providers;
import 'package:jo17_tactical_manager/providers/trainings_provider.dart'
    as trainings_providers;

void main() {
  group('TrainingAttendanceScreen', () {
    late Training training;
    late List<Player> players;

    setUp(() {
      training = Training()
        ..id = 't1'
        ..date = DateTime(2025, 7)
        ..duration = 90
        ..focus = TrainingFocus.technical
        ..intensity = TrainingIntensity.medium
        ..status = TrainingStatus.planned;

      final player = Player()
        ..id = 'p1'
        ..firstName = 'Jan'
        ..lastName = 'Jansen'
        ..jerseyNumber = 10
        ..birthDate = DateTime(2005)
        ..position = Position.forward
        ..preferredFoot = PreferredFoot.right
        ..height = 180
        ..weight = 70;

      players = [player];
    });

    setUpAll(() async {
      await initializeDateFormatting('nl_NL');

      SharedPreferences.setMockInitialValues({});

      // Ensure Supabase singleton is initialised to avoid provider assertion.
      try {
        await Supabase.initialize(
          url: 'https://dummy.supabase.co',
          anonKey: 'public-anon-key',
          debug: false,
        );
      } catch (_) {
        // ignore if already initialized
      }
    });

    tearDownAll(() async {
      // Sign out and clear caches so other tests start from a clean slate.
      try {
        await Supabase.instance.client.auth.signOut();
      } catch (_) {/* ignore if not initialised */}
    });

    testWidgets('renders basic UI with stubbed data', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trainings_providers.trainingsProvider.overrideWith(
              (ref) async => [training],
            ),
            players_providers.playersProvider.overrideWith(
              (ref) async => players,
            ),
          ],
          child: const MaterialApp(
            home: TrainingAttendanceScreen(trainingId: 't1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the title and a player avatar are present.
      expect(find.text('Training Aanwezigheid'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsWidgets);
    });
  });
}
