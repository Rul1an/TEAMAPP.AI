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

  group('Integration – Training flow', () {
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
    });

    testWidgets('create training → mark attendance', (tester) async {
      // Stub data
      final training = Training()
        ..id = 't99'
        ..date = DateTime(2025, 8)
        ..duration = 90
        ..focus = TrainingFocus.tactical
        ..intensity = TrainingIntensity.low
        ..status = TrainingStatus.planned
        ..trainingNumber = 1;

      final player = Player()
        ..id = 'p1'
        ..firstName = 'Leo'
        ..lastName = 'Messi'
        ..jerseyNumber = 30
        ..birthDate = DateTime(2005, 5, 5)
        ..position = Position.forward
        ..preferredFoot = PreferredFoot.left
        ..height = 170
        ..weight = 68;

      // Set canvas size for mobile layout
      setScreenSize(tester, const Size(700, 1000));
      addTearDown(() => resetScreenSize(tester));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trainings_providers.trainingsProvider.overrideWith(
              (ref) async => [training],
            ),
            players_providers.playersProvider.overrideWith(
              (ref) async => [player],
            ),
          ],
          child: const MaterialApp(
            home: TrainingAttendanceScreen(trainingId: 't99'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on player card to toggle attendance status → present (green)
      final avatarFinder = find.text('30');
      expect(avatarFinder, findsOneWidget);
      await tester.tap(avatarFinder);
      await tester.pumpAndSettle();

      // Verify status chip changed to "Aanwezig"
      expect(find.text('Aanwezig'), findsWidgets);

      // Tap save icon in AppBar
      await tester.tap(find.byIcon(Icons.save));
      await tester.pump(); // show snackbar maybe

      // For now just ensure no exceptions and Scaffold still present
      expect(find.byType(Scaffold), findsOneWidget);

      // Screen size reset handled by addTearDown above
    });
  });
}
