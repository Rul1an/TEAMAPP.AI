import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/providers/database_provider.dart' as db_providers;
import 'package:jo17_tactical_manager/screens/matches/match_detail_screen.dart';
import 'package:test_utils/surface_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Integration – Match flow', () {
    setUpAll(() async {
      await initializeDateFormatting('nl_NL', null);
    });

    testWidgets('create match → lineup builder button visible → score dialog button visible', (tester) async {
      final match = Match()
        ..id = 'm77'
        ..date = DateTime(2025, 9, 10, 20, 0)
        ..opponent = 'FC Test'
        ..location = Location.home
        ..competition = Competition.league
        ..status = MatchStatus.scheduled
        ..startingLineupIds = []
        ..substituteIds = [];

      final player = Player()
        ..id = 'p1'
        ..firstName = 'Sara'
        ..lastName = 'Skill'
        ..jerseyNumber = 7
        ..birthDate = DateTime(2004, 4, 4)
        ..position = Position.forward
        ..preferredFoot = PreferredFoot.right
        ..height = 170
        ..weight = 60;

      setScreenSize(tester, const Size(800, 1000));
      addTearDown(() => resetScreenSize(tester));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            db_providers.matchesProvider.overrideWith((ref) async => [match]),
            db_providers.playersProvider.overrideWith((ref) async => [player]),
          ],
          child: const MaterialApp(
            home: MatchDetailScreen(matchId: 'm77'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Opstelling Maken'), findsOneWidget);
      expect(find.text('Score Invoeren'), findsOneWidget);

      // Tap score dialog
      await tester.tap(find.text('Score Invoeren'));
      await tester.pump();
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}
