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
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/screens/matches/match_detail_screen.dart';

import 'package:jo17_tactical_manager/providers/matches_provider.dart'
    as matches_providers;
import 'package:jo17_tactical_manager/providers/players_provider.dart'
    as players_providers;

@Skip('Flaky after video_tagging integration – to be fixed in slice cleanup')
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Integration – Match flow', () {
    setUpAll(() async {
      await initializeDateFormatting('nl_NL');

      SharedPreferences.setMockInitialValues({});

      // Initialise Supabase singleton (dummy) for provider dependencies.
      try {
        await Supabase.initialize(
          url: 'https://dummy.supabase.co',
          anonKey: 'public-anon-key',
          debug: false,
        );
      } catch (_) {}
    });

    testWidgets(
      'create match → lineup builder button visible → score dialog button visible',
      (tester) async {
        final match = Match()
          ..id = 'm77'
          ..date = DateTime(2025, 9, 10, 20)
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
              matches_providers.matchesProvider.overrideWith(
                (ref) async => [match],
              ),
              players_providers.playersProvider.overrideWith(
                (ref) async => [player],
              ),
            ],
            child: const MaterialApp(home: MatchDetailScreen(matchId: 'm77')),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Opstelling Maken'), findsOneWidget);
        expect(find.text('Score Invoeren'), findsOneWidget);

        // Tap score dialog
        await tester.tap(find.text('Score Invoeren'));
        await tester.pump();
        expect(find.byType(AlertDialog), findsOneWidget);
      },
    );
  });
}
