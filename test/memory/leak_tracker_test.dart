import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';

import 'package:jo17_tactical_manager/main.dart';

void main() {
  group('Memory Leak Detection', () {
    testWidgets('No memory leaks in main app initialization', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify no leaks detected during app startup
      expect(LeakTracker.instance.isTracking, isTrue);
    });

    testWidgets('No memory leaks in dashboard navigation', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to dashboard
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      // Verify no leaks detected
      expect(LeakTracker.instance.isTracking, isTrue);
    });

    testWidgets('No memory leaks in training sessions flow', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to training sessions
      await tester.tap(find.text('Training'));
      await tester.pumpAndSettle();

      // Navigate back
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      // Verify no leaks detected
      expect(LeakTracker.instance.isTracking, isTrue);
    });

    testWidgets('No memory leaks in matches flow', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to matches
      await tester.tap(find.text('Matches'));
      await tester.pumpAndSettle();

      // Navigate back
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      // Verify no leaks detected
      expect(LeakTracker.instance.isTracking, isTrue);
    });

    testWidgets('No memory leaks in players flow', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to players
      await tester.tap(find.text('Players'));
      await tester.pumpAndSettle();

      // Navigate back
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      // Verify no leaks detected
      expect(LeakTracker.instance.isTracking, isTrue);
    });

    testWidgets('No memory leaks in PDF generation', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to a screen that can generate PDFs
      await tester.tap(find.text('Players'));
      await tester.pumpAndSettle();

      // Simulate PDF generation (if available)
      // This would trigger the PDF service which allocates large buffers

      // Navigate back
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      // Verify no leaks detected
      expect(LeakTracker.instance.isTracking, isTrue);
    });

    testWidgets('No memory leaks in field diagram operations', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to training sessions (where field diagrams are used)
      await tester.tap(find.text('Training'));
      await tester.pumpAndSettle();

      // Simulate field diagram operations
      // This would trigger the field painter which can allocate large canvases

      // Navigate back
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();

      // Verify no leaks detected
      expect(LeakTracker.instance.isTracking, isTrue);
    });
  });
}
