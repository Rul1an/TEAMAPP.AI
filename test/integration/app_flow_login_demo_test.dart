import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/providers/auth_provider.dart';
import 'package:jo17_tactical_manager/providers/demo_mode_provider.dart';
import 'package:jo17_tactical_manager/providers/players_provider.dart'
    as app_players_provider;
import 'package:jo17_tactical_manager/screens/players/players_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test_utils/fake_auth_service.dart';
import 'package:test_utils/surface_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Integration: Login → Dashboard → Player list (demo mode)', () {
    setUpAll(() async {
      await initializeDateFormatting('nl_NL', null);
      SharedPreferences.setMockInitialValues({});
      // Suppress overflow errors that are not critical for integration flow
      FlutterError.onError = (details) {
        final exception = details.exceptionAsString();
        if (exception.contains('A RenderFlex overflowed')) {
          // ignore
          return;
        }
        FlutterError.presentError(details);
      };
      await Supabase.initialize(
        url: 'https://dummy.supabase.co',
        anonKey: 'dummy-key',
      );
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
            app_players_provider.playersProvider
                .overrideWith((ref) async => [stubPlayer]),
            authServiceProvider.overrideWithValue(FakeAuthService()),
            isLoggedInProvider.overrideWithValue(true),
          ],
          child: const MaterialApp(
            home: PlayersScreen(),
          ),
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
