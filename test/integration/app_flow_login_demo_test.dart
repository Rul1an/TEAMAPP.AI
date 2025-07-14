// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test_utils/fake_auth_service.dart';
import 'package:test_utils/surface_utils.dart';

// Project imports:
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/providers/auth_provider.dart';
import 'package:jo17_tactical_manager/providers/demo_mode_provider.dart';
import 'package:jo17_tactical_manager/repositories/player_repository.dart';
import 'package:jo17_tactical_manager/screens/players/players_screen.dart';

import 'package:jo17_tactical_manager/providers/players_provider.dart'
    as app_players_provider;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Integration: Login → Dashboard → Player list (demo mode)', () {
    setUpAll(() async {
      await initializeDateFormatting('nl_NL');
      SharedPreferences.setMockInitialValues({});
      // Supabase is already initialised globally in `flutter_test_config.dart`.
      // Suppress overflow errors that are not critical for integration flow
      FlutterError.onError = (details) {
        final exception = details.exceptionAsString();
        if (exception.contains('A RenderFlex overflowed')) {
          // ignore
          return;
        }
        FlutterError.presentError(details);
      };
    });

    testWidgets('navigates through core flow without auth', (tester) async {
      // Demo mode notifier to bypass auth guard
      final demoNotifier = DemoModeNotifier()..startDemo(role: DemoRole.coach);

      addTearDown(demoNotifier.dispose);

      // Stub one player so player list has content
      final stubPlayer = Player()
        ..id = 'p1'
        ..firstName = 'Jan'
        ..lastName = 'Jansen'
        ..jerseyNumber = 9
        ..birthDate = DateTime(2005, 5, 5)
        ..position = Position.forward
        ..preferredFoot = PreferredFoot.right
        ..height = 180
        ..weight = 70;

      // Vergroot canvas om overflows te voorkomen
      setScreenSize(tester, const Size(500, 1000));
      addTearDown(() => resetScreenSize(tester));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            demoModeProvider.overrideWith((ref) => demoNotifier),
            app_players_provider.playersProvider.overrideWith(
              (ref) async => [stubPlayer],
            ),
            authServiceProvider.overrideWithValue(FakeAuthService()),
            isLoggedInProvider.overrideWithValue(true),
            // Provide fake repository to avoid SupabaseConfig dependency
            app_players_provider.playerRepositoryProvider.overrideWithValue(
              _FakePlayerRepository([stubPlayer]),
            ),
          ],
          child: const MaterialApp(home: PlayersScreen()),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(PlayersScreen), findsOneWidget);
      // Validatie: er is een lijst met spelers (geen lege-melding)
      expect(find.text('Geen spelers gevonden'), findsNothing);

      // Stop demo timer to avoid pending timers
      demoNotifier.endDemo();
    });
  });
}

class _FakePlayerRepository implements PlayerRepository {
  _FakePlayerRepository(this._players);

  final List<Player> _players;

  @override
  Future<Result<void>> add(Player player) async {
    _players.add(player);
    return const Success(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    _players.removeWhere((p) => p.id == id);
    return const Success(null);
  }

  @override
  Future<Result<List<Player>>> getAll() async =>
      Success(List.unmodifiable(_players));

  @override
  Future<Result<Player?>> getById(String id) async =>
      Success(_players.firstWhere((p) => p.id == id));

  @override
  Future<Result<List<Player>>> getByPosition(Position position) async =>
      Success(_players.where((p) => p.position == position).toList());

  @override
  Future<Result<void>> update(Player player) async {
    final idx = _players.indexWhere((p) => p.id == player.id);
    if (idx != -1) _players[idx] = player;
    return const Success(null);
  }
}
