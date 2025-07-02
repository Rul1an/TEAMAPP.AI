import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/training_session/field_diagram.dart';
import 'package:jo17_tactical_manager/providers/field_diagram_provider.dart';

void main() {
  group('FieldDiagramProvider basic state transitions', () {
    late ProviderContainer container;
    late FieldDiagramEditorNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
      notifier = container.read(fieldDiagramProvider.notifier);
    });

    test('Initial state is select tool & half field', () {
      final state = container.read(fieldDiagramProvider);
      expect(state.currentTool, DiagramTool.select);
      expect(state.diagram.fieldType, FieldType.halfField);
      expect(state.canUndo, isFalse);
      expect(state.canRedo, isFalse);
    });

    test('Selecting line type switches tool to line', () {
      notifier.selectLineType(LineType.shot);
      final state = container.read(fieldDiagramProvider);
      expect(state.currentTool, DiagramTool.line);
      expect(state.selectedLineType, LineType.shot);
    });

    test('Change field type adds to history and supports undo/redo', () {
      notifier.changeFieldType(FieldType.fullField);
      FieldDiagramEditorState state = container.read(fieldDiagramProvider);
      expect(state.diagram.fieldType, FieldType.fullField);
      expect(state.canUndo, isTrue);
      notifier.undo();
      state = container.read(fieldDiagramProvider);
      expect(state.diagram.fieldType, FieldType.halfField);
      expect(state.canRedo, isTrue);
      notifier.redo();
      state = container.read(fieldDiagramProvider);
      expect(state.diagram.fieldType, FieldType.fullField);
    });
  });
}
