import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'config/theme.dart';
import 'config/router.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize locale data for date formatting
  await initializeDateFormatting('nl_NL', null);
  await initializeDateFormatting('en_US', null);

  // Initialize database
  await DatabaseService().initialize();

  runApp(
    const ProviderScope(
      child: JO17TacticalManagerApp(),
    ),
  );
}

class JO17TacticalManagerApp extends StatelessWidget {
  const JO17TacticalManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'JO17 Tactical Manager',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
