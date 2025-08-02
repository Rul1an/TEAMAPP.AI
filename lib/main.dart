// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
// kIsWeb accessible via existing flutter/foundation.dart import above

// Project imports:
import 'config/environment.dart';
import 'config/supabase_config.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'services/runtime_security_service.dart';
import 'widgets/demo_mode_starter.dart';
import 'app_runner.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Environment configuration handled by Environment class
  // No .env file dependency - uses build-time environment detection
  if (kDebugMode) {
    debugPrint('🌍 Environment: ${Environment.current.name}');
    debugPrint('🔧 Debug features: ${Environment.current.enableDebugFeatures}');
  }

  // Initialize date formatting for Dutch locale
  await initializeDateFormatting('nl');

  // Initialize security first (DAG 1 - Critical Security Implementation)
  try {
    await RuntimeSecurityService.initializeSecurity(
      level:
          Environment.isProduction ? SecurityLevel.high : SecurityLevel.medium,
    );

    if (kDebugMode) {
      debugPrint('🔒 Runtime security initialized successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('⚠️ Security initialization warning: $e');
      debugPrint('🔒 App will continue with reduced security features');
    }
    // Don't crash on security init failure - graceful degradation
  }

  // Initialize Supabase with error handling
  try {
    await Supabase.initialize(
      url: Environment.current.supabaseUrl,
      anonKey: Environment.current.supabaseAnonKey,
    );

    // CRITICAL FIX: Initialize SupabaseConfig after Supabase.initialize()
    // This prevents the null check operator error
    await SupabaseConfig.initialize();
  } catch (e) {
    // Log error but don't crash - app can work offline
    if (kDebugMode) {
      debugPrint('⚠️ Supabase initialization failed: $e');
      debugPrint('📱 App will run in offline mode');
    }
  }

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
