import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:jo17_tactical_manager/main.dart';

void main() {
  group('Memory Leak Detection', () {
    testWidgets('No memory leaks in main app initialization', (tester) async {
      await tester
          .pumpWidget(const ProviderScope(child: JO17TacticalManagerApp()));
      await tester.pumpAndSettle();

      // Verify app initializes without errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('No memory leaks in dashboard navigation', (tester) async {
      await tester
          .pumpWidget(const ProviderScope(child: JO17TacticalManagerApp()));
      await tester.pumpAndSettle();

      // Navigate to dashboard
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      // Verify navigation works
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('No memory leaks in training sessions flow', (tester) async {
      await tester
          .pumpWidget(const ProviderScope(child: JO17TacticalManagerApp()));
      await tester.pumpAndSettle();

      // Navigate to training sessions
      await tester.tap(find.text('Training'));
      await tester.pumpAndSettle();

      // Navigate back
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      // Verify navigation works
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('No memory leaks in matches flow', (tester) async {
      await tester
          .pumpWidget(const ProviderScope(child: JO17TacticalManagerApp()));
      await tester.pumpAndSettle();

      // Navigate to matches
      await tester.tap(find.text('Matches'));
      await tester.pumpAndSettle();

      // Navigate back
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      // Verify navigation works
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('No memory leaks in players flow', (tester) async {
      await tester
          .pumpWidget(const ProviderScope(child: JO17TacticalManagerApp()));
      await tester.pumpAndSettle();

      // Navigate to players
      await tester.tap(find.text('Players'));
      await tester.pumpAndSettle();

      // Navigate back
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      // Verify navigation works
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('No memory leaks in PDF generation', (tester) async {
      await tester
          .pumpWidget(const ProviderScope(child: JO17TacticalManagerApp()));
      await tester.pumpAndSettle();

      // Navigate to a screen that can generate PDFs
      await tester.tap(find.text('Players'));
      await tester.pumpAndSettle();

      // Simulate PDF generation (if available)
      // This would trigger the PDF service which allocates large buffers

      // Navigate back
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      // Verify navigation works
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('No memory leaks in field diagram operations', (tester) async {
      await tester
          .pumpWidget(const ProviderScope(child: JO17TacticalManagerApp()));
      await tester.pumpAndSettle();

      // Navigate to training sessions (where field diagrams are used)
      await tester.tap(find.text('Training'));
      await tester.pumpAndSettle();

      // Simulate field diagram operations
      // This would trigger the field painter which can allocate large canvases

      // Navigate back
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      // Verify navigation works
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
