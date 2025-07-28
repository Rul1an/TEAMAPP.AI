// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Project imports:
import 'config/environment.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'widgets/demo_mode_starter.dart';
import 'app_runner.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (contains SENTRY_DSN, etc.)
  await dotenv.load();

  // Initialize date formatting for Dutch locale
  await initializeDateFormatting('nl');

  // Initialize Supabase
  await Supabase.initialize(
    url: Environment.current.supabaseUrl,
    anonKey: Environment.current.supabaseAnonKey,
  );

  // Initialize Firebase (Performance Monitoring) – skip on web until proper
  // firebase_options.dart is generated and configured. Prevents runtime error
  // causing infinite "Loading…" on Netlify.
  if (!kIsWeb) {
    await Firebase.initializeApp();
    await FirebasePerformance.instance
        .setPerformanceCollectionEnabled(!kDebugMode);
  }

  // Run the app inside error boundary & initialise Sentry (handled internally).
  await runAppWithGuards(
    const ProviderScope(child: JO17TacticalManagerApp()),
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
