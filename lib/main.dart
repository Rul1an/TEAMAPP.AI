import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/environment.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'widgets/demo_mode_starter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Dutch locale
  await initializeDateFormatting('nl');

  // Initialize Supabase
  await Supabase.initialize(
    url: Environment.current.supabaseUrl,
    anonKey: Environment.current.supabaseAnonKey,
  );

  runApp(
    const ProviderScope(
      child: JO17TacticalManagerApp(),
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
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
