// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
// kIsWeb accessible via existing flutter/foundation.dart import above
import 'package:sentry_flutter/sentry_flutter.dart';

// Project imports:
import 'config/environment.dart';
import 'config/supabase_config.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'services/runtime_security_service.dart';
import 'services/ui_error_handler.dart';
import 'services/monitoring_service.dart';
import 'services/telemetry_service.dart';
import 'widgets/demo_mode_starter.dart';

Future<void> main() async {
  // CRITICAL ZONE FIX: Initialize bindings in same zone where runApp will be called
  // This prevents Zone mismatch errors by ensuring consistent zone usage
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await _initializeApp();

      // Initialize UI Error Handler within the same zone
      UIErrorHandler.initialize();

      // Run app in the same zone where bindings were initialized
      runApp(const ProviderScope(child: JO17TacticalManagerApp()));
    },
    (error, stackTrace) {
      // Catch any initialization errors
      if (kDebugMode) {
        print('🚨 App Initialization Error: $error');
        print('Stack: $stackTrace');
      }
    },
  );
}

Future<void> _initializeApp() async {
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

  // Initialize Sentry monitoring early in app startup
  try {
    await MonitoringService.initialize();
  } catch (e) {
    if (kDebugMode) {
      debugPrint('⚠️ Sentry initialization failed: $e');
    }
  }

  // Optional: send a one-time Sentry ping if enabled via dart-define
  const bool sentryPing =
      bool.fromEnvironment('SENTRY_PING', defaultValue: false);
  const String sentryPingMessage = String.fromEnvironment(
    'SENTRY_PING_MESSAGE',
    defaultValue: 'SaaS Sentry ping: app startup OK',
  );
  if (sentryPing) {
    try {
      await Sentry.captureMessage(sentryPingMessage, level: SentryLevel.info);
      if (kDebugMode) {
        debugPrint('📨 Sentry ping sent: $sentryPingMessage');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Failed to send Sentry ping: $e');
      }
    }
  }

  // Initialize OpenTelemetry if configured
  try {
    await TelemetryService().init();
  } catch (e) {
    if (kDebugMode) {
      debugPrint('⚠️ Telemetry initialization failed: $e');
    }
  }

  // Initialize Supabase with error handling - FIXED: No double initialization
  try {
    // Try to access Supabase - if it fails, we need to initialize
    try {
      // ignore: unnecessary_statements
      Supabase.instance.client;
      // If we get here, Supabase is already initialized
    } catch (_) {
      // Supabase not initialized yet
      await Supabase.initialize(
        url: Environment.current.supabaseUrl,
        anonKey: Environment.current.supabaseAnonKey,
      );

      if (kDebugMode) {
        debugPrint(
            'supabase.supabase_flutter: INFO: ***** Supabase init completed ***** ');
      }
    }

    // Initialize our SupabaseConfig wrapper (safe - no duplicate Supabase.initialize)
    await SupabaseConfig.initializeClient();
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
        builder: (context, child) {
          final media = MediaQuery.of(context);
          // Clamp text scale between 0.9 and 1.3 to preserve layout while respecting user preference
          final clampedTextScale = media.textScaleFactor.clamp(0.9, 1.3);
          // Respect reduced motion for animations (used by widgets that read MediaQuery)
          final disableAnimations =
              MediaQuery.maybeOf(context)?.disableAnimations ?? false;
          return MediaQuery(
            data: media.copyWith(
              textScaler: TextScaler.linear(clampedTextScale.toDouble()),
              disableAnimations: disableAnimations,
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
        routerConfig: router,
        // TODO(roel): Once Flutter exposes navigatorObservers on MaterialApp.router,
        // integrate SentryNavigatorObserver via GoRouter observers
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
