import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/environment.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'widgets/demo_mode_starter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (contains SENTRY_DSN, etc.)
  await dotenv.load(fileName: '.env');

  // Initialize date formatting for Dutch locale
  await initializeDateFormatting('nl');

  // Initialize Supabase
  await Supabase.initialize(
    url: Environment.current.supabaseUrl,
    anonKey: Environment.current.supabaseAnonKey,
  );

  // Initialize Sentry for crash & performance monitoring
  await SentryFlutter.init(
    (options) {
      options
        ..dsn = dotenv.env['SENTRY_DSN'] ?? ''
        ..tracesSampleRate = 0.2 // keep within free 100k tx/mo quota
        ..profilesSampleRate = 0.2 // same as traces for consistency
        // Session Replay is not yet GA for Flutter (SDK >= 9.2) – keep disabled for now.
        ..environment = Environment.current.name;
      // TODO(roel): Add app release / build version automatically
    },
    appRunner: () => runApp(
      const ProviderScope(
        child: JO17TacticalManagerApp(),
      ),
    ),
  );
}

class JO17TacticalManagerApp extends ConsumerWidget {
  const JO17TacticalManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return DemoModeStarter(
      child: MaterialApp.router(
        title: 'JO17 Tactical Manager',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: router,
        // TODO(roel): Once Flutter exposes navigatorObservers on MaterialApp.router,
        // integrate SentryNavigatorObserver via GoRouter observers
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
