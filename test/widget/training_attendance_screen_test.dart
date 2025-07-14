// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      TestWidgetsFlutterBinding.ensureInitialized();

      // Mock persistent storage used by SupabaseFlutter.
      SharedPreferences.setMockInitialValues({});

      // Initialise Supabase **once** when not already initialised. This guard
      // prevents the "instance already initialised" assertion when the test
      // suite is executed multiple times or in combination with other global
      // setups.
      try {
        Supabase.instance.client;
      } catch (_) {
        await Supabase.initialize(
          url: 'https://dummy.supabase.co',
          anonKey: 'public-anon-key',
          authOptions: const FlutterAuthClientOptions(autoRefreshToken: false),
        );
      }

      await initializeDateFormatting('nl_NL');
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
