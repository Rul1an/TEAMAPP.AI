// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test_utils/surface_utils.dart';
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
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TrainingAttendanceScreen golden tests', () {
    late Training training;
    late List<Player> players;

    setUpAll(() async {
      await initializeDateFormatting('nl_NL');

      SharedPreferences.setMockInitialValues({});

      try {
        await Supabase.initialize(
          url: 'https://dummy.supabase.co',
          anonKey: 'public-anon-key',
          debug: false,
        );
      } catch (_) {}

      training = Training()
        ..id = 't1'
        ..date = DateTime(2025, 7)
        ..duration = 90
        ..focus = TrainingFocus.technical
        ..intensity = TrainingIntensity.medium
        ..status = TrainingStatus.planned
        ..trainingNumber = 1;

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

    const testSize = Size(700, 800);

    testWidgets('mobile light mode', (tester) async {
      setScreenSize(tester, testSize);
      addTearDown(() => resetScreenSize(tester));

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
            themeMode: ThemeMode.light,
            home: TrainingAttendanceScreen(trainingId: 't1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsWidgets);
    });

    testWidgets('mobile dark mode', (tester) async {
      setScreenSize(tester, testSize);
      addTearDown(() => resetScreenSize(tester));

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
          child: MaterialApp(
            themeMode: ThemeMode.dark,
            darkTheme: ThemeData.dark(useMaterial3: true),
            home: const TrainingAttendanceScreen(trainingId: 't1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsWidgets);
    });
  });
}
