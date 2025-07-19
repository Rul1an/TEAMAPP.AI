// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/screens/matches/match_detail_screen.dart';

import 'package:jo17_tactical_manager/providers/matches_provider.dart'
    as matches_providers;
import 'package:jo17_tactical_manager/providers/players_provider.dart'
    as players_providers;

void main() {
  group('MatchDetailScreen', () {
    late Match match;
    late List<Player> players;

    setUp(() {
      match = Match()
        ..id = 'm1'
        ..date = DateTime(2025, 7, 2, 19)
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

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      try {
        // Initialize Supabase with a dummy URL/anon key for widget tests so that
        // providers depending on Supabase.instance don’t throw assertion errors.
        await Supabase.initialize(
          url: 'https://dummy.supabase.co',
          anonKey: 'public-anon-key',
          debug: false,
        );
      } catch (_) {
        // Ignore if already initialised by another test group.
      }
    });

    testWidgets('renders basic match information', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            matches_providers.matchesProvider.overrideWith(
              (ref) async => [match],
            ),
            players_providers.playersProvider.overrideWith(
              (ref) async => players,
            ),
          ],
          child: const MaterialApp(home: MatchDetailScreen(matchId: 'm1')),
        ),
      );

      await tester.pumpAndSettle();

      // Basic app bar title present
      expect(find.text('Wedstrijd Details'), findsOneWidget);
    });

    // Additional functional tests can be added here
  });
}
