// Entry point for Fan & Family flavour
// Run with: flutter run --flavor fan_family -t lib/main_fan.dart

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'config/environment.dart';
import 'config/router_fan.dart';
import 'config/theme_fan.dart';
import 'widgets/demo_mode_starter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (reuse same .env)
  await dotenv.load();
  await initializeDateFormatting('nl');

  await Supabase.initialize(
    url: Environment.current.supabaseUrl,
    anonKey: Environment.current.supabaseAnonKey,
  );

  await SentryFlutter.init(
    (options) {
      options
        ..dsn = dotenv.env['SENTRY_DSN'] ?? ''
        ..tracesSampleRate = 0.2
        ..profilesSampleRate = 0.2
        ..environment = '${Environment.current.name}_fan';
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

    return DemoModeStarter(
      child: MaterialApp.router(
        title: 'TeamApp – Fan & Family',
        theme: FanTheme.lightTheme,
        darkTheme: FanTheme.darkTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}