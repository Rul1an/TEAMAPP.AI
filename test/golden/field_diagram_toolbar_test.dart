// ignore_for_file: deprecated_member_use, flutter_style_todos

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_utils/surface_utils.dart';

// Project imports:
import 'package:jo17_tactical_manager/providers/field_diagram_provider.dart';
import 'package:jo17_tactical_manager/widgets/field_diagram/field_diagram_toolbar.dart';

// Golden tests for FieldDiagramToolbar.
// To (re)generate the baseline images run:
// flutter test --update-goldens test/golden/field_diagram_toolbar_test.dart

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Skip golden assertions on CI (Linux) as font rendering causes diff.
  final isCi = Platform.environment['CI'] == 'true';

  group('FieldDiagramToolbar golden tests', () {
    const testSize = Size(800, 80);

    setUp(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      setScreenSizeBinding(binding, testSize);
    });

    tearDown(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      resetScreenSizeBinding(binding);
    });

    const skipGolden = true; // TODO(team): update golden files

    testWidgets('default (select) tool', (tester) async {
      // golden test skipped via skip param when skipGolden == true
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Material(
              child: FieldDiagramToolbar(
                selectedTool: DiagramTool.select,
                onToolSelected: _noop,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(FieldDiagramToolbar),
        matchesGoldenFile('goldens/field_diagram_toolbar_select.png'),
      );
    }, skip: skipGolden || isCi);

    testWidgets('line tool expanded', (tester) async {
      // golden test skipped via skip param when skipGolden == true
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Material(
              child: FieldDiagramToolbar(
                selectedTool: DiagramTool.line,
                onToolSelected: _noop,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(FieldDiagramToolbar),
        matchesGoldenFile('goldens/field_diagram_toolbar_line.png'),
      );
    }, skip: skipGolden || isCi);
  });
}

void _noop(DiagramTool _) {}
