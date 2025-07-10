// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../models/training_session/field_diagram.dart';
import '../../providers/field_diagram_provider.dart';
import '../../widgets/field_diagram/field_canvas.dart';
import '../../widgets/field_diagram/field_diagram_toolbar.dart';

class FieldDiagramEditorScreen extends ConsumerStatefulWidget {
  const FieldDiagramEditorScreen({
    super.key,
    this.exerciseId,
    this.initialDiagram,
  });
  final String? exerciseId;
  final FieldDiagram? initialDiagram;

  @override
  ConsumerState<FieldDiagramEditorScreen> createState() =>
      _FieldDiagramEditorScreenState();
}

class _FieldDiagramEditorScreenState
    extends ConsumerState<FieldDiagramEditorScreen> {
  @override
  void initState() {
    super.initState();

    // Initialize the provider with the diagram if provided
    if (widget.initialDiagram != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(fieldDiagramProvider.notifier)
            .initializeDiagram(widget.initialDiagram!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final diagramState = ref.watch(fieldDiagramProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Veld Diagram Editor'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: diagramState.canUndo
                ? () => ref.read(fieldDiagramProvider.notifier).undo()
                : null,
            tooltip: 'Ongedaan maken',
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: diagramState.canRedo
                ? () => ref.read(fieldDiagramProvider.notifier).redo()
                : null,
            tooltip: 'Opnieuw',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDiagram,
            tooltip: 'Opslaan',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.share),
            tooltip: 'Exporteren',
            onSelected: _exportDiagram,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'png',
                child: Row(
                  children: [
                    Icon(Icons.image, size: 20),
                    SizedBox(width: 8),
                    Text('Exporteer als PNG'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, size: 20),
                    SizedBox(width: 8),
                    Text('Exporteer als PDF'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: FieldDiagramToolbar(
              selectedTool: diagramState.currentTool,
              onToolSelected: (tool) =>
                  ref.read(fieldDiagramProvider.notifier).selectTool(tool),
            ),
          ),
          // Canvas
          Expanded(
            child: Container(
              color: Colors.green[50],
              child: FieldCanvas(
                diagram: diagramState.diagram,
                currentTool: diagramState.currentTool,
                selectedElementId: diagramState.selectedElementId,
                selectedPlayerType: diagramState.selectedPlayerType,
                selectedEquipmentType: diagramState.selectedEquipmentType,
                selectedLineType: diagramState.selectedLineType,
                currentLinePoints: diagramState.currentLinePoints,
                isDrawingLine: diagramState.isDrawingLine,
                onElementSelected: (elementId) => ref
                    .read(fieldDiagramProvider.notifier)
                    .selectElement(elementId),
                onElementMoved: (elementId, newPosition) => ref
                    .read(fieldDiagramProvider.notifier)
                    .moveElement(elementId, newPosition),
                onElementAdded: (element) =>
                    ref.read(fieldDiagramProvider.notifier).addElement(element),
                onElementRemoved: (elementId) => ref
                    .read(fieldDiagramProvider.notifier)
                    .removeElement(elementId),
              ),
            ),
          ),
          // Bottom info bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Text(
                  'Veld: ${_getFieldTypeText(diagramState.diagram.fieldType)}',
                ),
                const Spacer(),
                Text('Spelers: ${diagramState.diagram.players.length}'),
                const SizedBox(width: 16),
                Text('Equipment: ${diagramState.diagram.equipment.length}'),
                const SizedBox(width: 16),
                Text('Bewegingen: ${diagramState.diagram.movements.length}'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFieldTypeSelector,
        backgroundColor: Colors.green[700],
        tooltip: 'Veld instellingen',
        child: const Icon(Icons.settings, color: Colors.white),
      ),
    );
  }

  String _getFieldTypeText(FieldType type) {
    switch (type) {
      case FieldType.fullField:
        return 'Volledig veld';
      case FieldType.halfField:
        return 'Half veld';
      case FieldType.penaltyArea:
        return 'Strafschopgebied';
      case FieldType.thirdField:
        return '1/3 veld';
      case FieldType.quarterField:
        return '1/4 veld';
      case FieldType.customGrid:
        return 'Custom';
    }
  }

  Future<void> _exportDiagram(String format) async {
    final diagramState = ref.read(fieldDiagramProvider);

    try {
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exporteren als ${format.toUpperCase()}...'),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      await ref
          .read(fieldDiagramProvider.notifier)
          .exportDiagram(diagramState.diagram, format);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Diagram succesvol geëxporteerd als ${format.toUpperCase()}!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout bij exporteren: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveDiagram() async {
    final diagramState = ref.read(fieldDiagramProvider);

    try {
      if (widget.exerciseId != null) {
        await ref
            .read(fieldDiagramProvider.notifier)
            .saveDiagramToExercise(widget.exerciseId!, diagramState.diagram);
      } else {
        await ref
            .read(fieldDiagramProvider.notifier)
            .saveDiagramTemplate(
              diagramState.diagram,
              'Nieuwe diagram ${DateTime.now().toString().substring(0, 16)}',
            );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Diagram succesvol opgeslagen!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout bij opslaan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showFieldTypeSelector() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Veld Type Selecteren'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: FieldType.values
              .map(
                (type) => ListTile(
                  title: Text(_getFieldTypeText(type)),
                  onTap: () {
                    ref
                        .read(fieldDiagramProvider.notifier)
                        .changeFieldType(type);
                    Navigator.of(context).pop();
                  },
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuleren'),
          ),
        ],
      ),
    );
  }
}
