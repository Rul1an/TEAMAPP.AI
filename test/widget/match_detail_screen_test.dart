import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/providers/database_provider.dart' as db_providers;
import 'package:jo17_tactical_manager/screens/matches/match_detail_screen.dart';

void main() {
  group('MatchDetailScreen', () {
    late Match match;
    late List<Player> players;

    setUp(() {
      match = Match()
        ..id = 'm1'
        ..date = DateTime(2025, 7, 2, 19, 0)
        ..opponent = 'FC Example'
        ..location = Location.home
        ..competition = Competition.league
        ..status = MatchStatus.scheduled;

      final player = Player()
        ..id = 'p1'
        ..firstName = 'Piet'
        ..lastName = 'Ploeg'
        ..jerseyNumber = 5
        ..birthDate = DateTime(2005, 2, 2)
        ..position = Position.defender
        ..preferredFoot = PreferredFoot.left
        ..height = 178
        ..weight = 68;
      players = [player];
    });

    testWidgets('renders basic match information', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            db_providers.matchesProvider.overrideWith((ref) async => [match]),
            db_providers.playersProvider.overrideWith((ref) async => players),
          ],
          child: const MaterialApp(
            home: MatchDetailScreen(matchId: 'm1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Basic app bar title present
      expect(find.text('Wedstrijd Details'), findsOneWidget);
    });

    // Additional functional tests can be added here
  });
}
