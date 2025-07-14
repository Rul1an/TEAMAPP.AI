// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/notification_service.dart';

// Project imports:
import 'config/environment.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'widgets/demo_mode_starter.dart';
import 'services/deep_link_service.dart';

void main() async {
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

  // Initialize Firebase & Messaging
  await Firebase.initializeApp();
  await NotificationService.instance.init();

  // Initialize Sentry for crash & performance monitoring
  await SentryFlutter.init(
    (options) {
      options
        ..dsn = dotenv.env['SENTRY_DSN'] ?? ''
        ..tracesSampleRate =
            0.2 // keep within free 100k tx/mo quota
        ..profilesSampleRate =
            0.2 // same as traces for consistency
        // Session Replay is not yet GA for Flutter (SDK >= 9.2) – keep disabled for now.
        ..environment = Environment.current.name;
      // TODO(roel): Add app release / build version automatically
    },
    appRunner: () =>
        runApp(const ProviderScope(child: JO17TacticalManagerApp())),
  );
}

class JO17TacticalManagerApp extends ConsumerWidget {
  const JO17TacticalManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // Init deep link service once router available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeepLinkService.instance.init(router);
    });

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
