import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/notification_service.dart';
import 'services/deep_link_service.dart';
import 'services/analytics_service.dart';

// Project imports:
import 'config/environment.dart';
import 'config/router_fan.dart';
import 'config/theme_fan.dart';
import 'widgets/demo_mode_starter.dart';

/// Entry-point for the **Fan & Family** flavour.
///
/// Mirrors [`main.dart`] but wires in a flavour-specific router & theme so we
/// can progressively prune staff-only screens without touching the shared
/// coach_suite entry-point.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (contains SENTRY_DSN, etc.)
  await dotenv.load();

  // Initialise date formatting for Dutch locale
  await initializeDateFormatting('nl');

  // Initialise Supabase
  await Supabase.initialize(
    url: Environment.current.supabaseUrl,
    anonKey: Environment.current.supabaseAnonKey,
  );
  // Initialise Firebase & Messaging
  await Firebase.initializeApp();
  await NotificationService.instance.init();
  await AnalyticsService.instance.logEvent('app_open');

  // Initialise Sentry for crash & performance monitoring
  await SentryFlutter.init(
    (options) {
      options
        ..dsn = dotenv.env['SENTRY_DSN'] ?? ''
        ..tracesSampleRate = 0.2
        ..profilesSampleRate = 0.2
        ..environment = '${Environment.current.name}-fan_family';
    },
    appRunner: () => runApp(
      const ProviderScope(child: FanFamilyApp()),
    ),
  );
}

class FanFamilyApp extends ConsumerWidget {
  const FanFamilyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerFanProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeepLinkService.instance.init(router);
    });

    return DemoModeStarter(
      child: MaterialApp.router(
        title: 'JO17 Fan & Family',
        theme: FanTheme.lightTheme,
        darkTheme: FanTheme.darkTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}