import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/models/training.dart';
import 'package:jo17_tactical_manager/providers/players_provider.dart'
    as players_providers;
import 'package:jo17_tactical_manager/providers/trainings_provider.dart'
    as trainings_providers;
import 'package:jo17_tactical_manager/screens/training/training_attendance_screen.dart';

void main() {
  group('TrainingAttendanceScreen', () {
    late Training training;
    late List<Player> players;

    setUp(() {
      training = Training()
        ..id = 't1'
        ..date = DateTime(2025, 7, 1)
        ..duration = 90
        ..focus = TrainingFocus.technical
        ..intensity = TrainingIntensity.medium
        ..status = TrainingStatus.planned;

      final player = Player()
        ..id = 'p1'
        ..firstName = 'Jan'
        ..lastName = 'Jansen'
        ..jerseyNumber = 10
        ..birthDate = DateTime(2005, 1, 1)
        ..position = Position.forward
        ..preferredFoot = PreferredFoot.right
        ..height = 180
        ..weight = 70;

      players = [player];
    });

    setUpAll(() async {
      await initializeDateFormatting('nl_NL', null);
    });

    testWidgets('renders basic UI with stubbed data', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trainings_providers.trainingsProvider
                .overrideWith((ref) async => [training]),
            players_providers.playersProvider.overrideWith((ref) async => players),
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
