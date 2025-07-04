// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test_utils/surface_utils.dart';

// Project imports:
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/screens/matches/match_detail_screen.dart';

import 'package:jo17_tactical_manager/providers/matches_provider.dart'
    as matches_providers;
import 'package:jo17_tactical_manager/providers/players_provider.dart'
    as players_providers;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MatchDetailScreen widget tests', () {
    late Match match;
    late List<Player> players;

    setUpAll(() async {
      await initializeDateFormatting('nl_NL');

      match = Match()
        ..id = 'm1'
        ..date = DateTime(2025, 7, 15, 19, 30)
        ..opponent = 'RKVV'
        ..location = Location.home
        ..competition = Competition.league
        ..status = MatchStatus.scheduled
        ..startingLineupIds = []
        ..substituteIds = [];

      final player = Player()
        ..id = 'p1'
        ..firstName = 'Piet'
        ..lastName = 'Ploeg'
        ..jerseyNumber = 4
        ..birthDate = DateTime(2004, 2, 2)
        ..position = Position.defender
        ..preferredFoot = PreferredFoot.right
        ..height = 182
        ..weight = 75;

      players = [player];
    });

    const testSize = Size(800, 1000);

    testWidgets('renders basic match information', (tester) async {
      setScreenSize(tester, testSize);
      addTearDown(() => resetScreenSize(tester));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            matches_providers.matchesProvider
                .overrideWith((ref) async => [match]),
            players_providers.playersProvider
                .overrideWith((ref) async => players),
          ],
          child: const MaterialApp(
            home: MatchDetailScreen(matchId: 'm1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Wedstrijd Details'), findsOneWidget);
      expect(find.text('RKVV'), findsWidgets);
    });
  });
}
