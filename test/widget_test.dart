// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jo17_tactical_manager/config/environment.dart';
import 'package:jo17_tactical_manager/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUpAll(() async {
    // Ensure Flutter bindings are initialized
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // Initialize date formatting for Dutch locale
    await initializeDateFormatting('nl');
    
    // Initialize Supabase for tests
    await Supabase.initialize(
      url: Environment.test.supabaseUrl,
      anonKey: Environment.test.supabaseAnonKey,
    );
  });

  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(
      child: JO17TacticalManagerApp(),
    ),);

    // Wait for any async operations to complete
    await tester.pumpAndSettle();

    // Verify that the app builds successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
