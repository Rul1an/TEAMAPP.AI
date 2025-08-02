// Dart imports:
import 'dart:ui' as ui;

// Flutter imports:
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:file_saver/file_saver.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Project imports:
import '../models/training_session/field_diagram.dart';
import '../widgets/field_diagram/field_painter.dart';

// State class for the field diagram editor
class FieldDiagramEditorState {
  const FieldDiagramEditorState({
    required this.diagram,
    this.currentTool = DiagramTool.select,
    this.selectedElementId,
    this.history = const [],
    this.historyIndex = -1,
    this.isModified = false,
    this.selectedPlayerType = PlayerType.attacking,
    this.selectedEquipmentType = EquipmentType.cone,
    this.selectedLineType = LineType.pass,
    this.currentLinePoints = const [],
    this.isDrawingLine = false,
  });
  final FieldDiagram diagram;
  final DiagramTool currentTool;
  final String? selectedElementId;
  final List<FieldDiagram> history;
  final int historyIndex;
  final bool isModified;
  final PlayerType selectedPlayerType;
  final EquipmentType selectedEquipmentType;
  final LineType selectedLineType;
  final List<Position> currentLinePoints;
  final bool isDrawingLine;

  FieldDiagramEditorState copyWith({
    FieldDiagram? diagram,
    DiagramTool? currentTool,
    String? selectedElementId,
    List<FieldDiagram>? history,
    int? historyIndex,
    bool? isModified,
    PlayerType? selectedPlayerType,
    EquipmentType? selectedEquipmentType,
    LineType? selectedLineType,
    List<Position>? currentLinePoints,
    bool? isDrawingLine,
  }) =>
      FieldDiagramEditorState(
        diagram: diagram ?? this.diagram,
        currentTool: currentTool ?? this.currentTool,
        selectedElementId: selectedElementId,
        history: history ?? this.history,
        historyIndex: historyIndex ?? this.historyIndex,
        isModified: isModified ?? this.isModified,
        selectedPlayerType: selectedPlayerType ?? this.selectedPlayerType,
        selectedEquipmentType:
            selectedEquipmentType ?? this.selectedEquipmentType,
        selectedLineType: selectedLineType ?? this.selectedLineType,
        currentLinePoints: currentLinePoints ?? this.currentLinePoints,
        isDrawingLine: isDrawingLine ?? this.isDrawingLine,
      );

  bool get canUndo => historyIndex > 0;
  bool get canRedo => historyIndex < history.length - 1;
}

// Diagram tools enum
enum DiagramTool {
  select, // Selectie/beweging
  player, // Speler plaatsen
  equipment, // Equipment plaatsen
  line, // Lijnen tekenen
  text, // Text toevoegen
  area, // Gebied markeren
  delete, // Verwijderen
}

// Field diagram editor provider
class FieldDiagramEditorNotifier
    extends StateNotifier<FieldDiagramEditorState> {
  FieldDiagramEditorNotifier()
      : super(
          FieldDiagramEditorState(
            diagram: FieldDiagram.halfField(),
            history: [FieldDiagram.halfField()],
            historyIndex: 0,
          ),
        );

  // Initialize with existing diagram
  void initializeDiagram(FieldDiagram diagram) {
    state = FieldDiagramEditorState(
      diagram: diagram,
      history: [diagram],
      historyIndex: 0,
    );
  }

  // Tool selection
  void selectTool(DiagramTool tool) {
    state = state.copyWith(currentTool: tool);
  }

  // Player type selection
  void selectPlayerType(PlayerType playerType) {
    state = state.copyWith(
      selectedPlayerType: playerType,
      // Only switch to player tool if not already in a drawing/interaction mode
      currentTool: state.currentTool == DiagramTool.line && state.isDrawingLine
          ? state.currentTool
          : DiagramTool.player,
    );
  }

  // Equipment type selection
  void selectEquipmentType(EquipmentType equipmentType) {
    state = state.copyWith(
      selectedEquipmentType: equipmentType,
      // Only switch to equipment tool if not already in a drawing/interaction mode
      currentTool: state.currentTool == DiagramTool.line && state.isDrawingLine
          ? state.currentTool
          : DiagramTool.equipment,
    );
  }

  // Line type selection
  void selectLineType(LineType lineType) {
    state = state.copyWith(
      selectedLineType: lineType,
      // Always switch to line tool for line type changes
      currentTool: DiagramTool.line,
    );
  }

  // Start drawing a line
  void startDrawingLine(Position startPoint) {
    state = state.copyWith(
      isDrawingLine: true,
      currentLinePoints: [startPoint],
      currentTool: DiagramTool.line,
    );
  }

  // Add point to current line
  void addLinePoint(Position point) {
    if (!state.isDrawingLine) return;

    state = state.copyWith(
      currentLinePoints: [...state.currentLinePoints, point],
    );
  }

  // Finish drawing the current line
  void finishDrawingLine() {
    if (!state.isDrawingLine || state.currentLinePoints.length < 2) {
      // Cancel if not enough points
      state = state.copyWith(isDrawingLine: false, currentLinePoints: []);
      return;
    }

    // Create the movement line
    final line = MovementLine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      points: state.currentLinePoints,
      type: state.selectedLineType,
      color: _getLineColor(state.selectedLineType),
      strokeWidth: _getLineStrokeWidth(state.selectedLineType),
      hasArrowHead: _shouldHaveArrowHead(state.selectedLineType),
    );

    // Add to diagram
    addElement(line);

    // Reset drawing state
    state = state.copyWith(isDrawingLine: false, currentLinePoints: []);
  }

  // Cancel current line drawing
  void cancelDrawingLine() {
    state = state.copyWith(isDrawingLine: false, currentLinePoints: []);
  }

  // Helper methods for line styling
  String _getLineColor(LineType type) {
    switch (type) {
      case LineType.pass:
        return '#4CAF50'; // Green
      case LineType.run:
        return '#2196F3'; // Blue
      case LineType.dribble:
        return '#FF9800'; // Orange
      case LineType.shot:
        return '#F44336'; // Red
      case LineType.defensive:
        return '#9C27B0'; // Purple
      case LineType.ballPath:
        return '#795548'; // Brown
    }
  }

  double _getLineStrokeWidth(LineType type) {
    switch (type) {
      case LineType.shot:
        return 4; // Thick for shots
      case LineType.pass:
      case LineType.dribble:
        return 2.5;
      default:
        return 2;
    }
  }

  bool _shouldHaveArrowHead(LineType type) {
    switch (type) {
      case LineType.pass:
      case LineType.shot:
      case LineType.run:
        return true;
      default:
        return false;
    }
  }

  // Element selection
  void selectElement(String? elementId) {
    state = state.copyWith(selectedElementId: elementId);
  }

  // Add element to diagram
  void addElement(dynamic element) {
    FieldDiagram newDiagram;

    if (element is PlayerMarker) {
      newDiagram = state.diagram.copyWith(
        players: [...state.diagram.players, element],
      );
    } else if (element is EquipmentMarker) {
      newDiagram = state.diagram.copyWith(
        equipment: [...state.diagram.equipment, element],
      );
    } else if (element is MovementLine) {
      newDiagram = state.diagram.copyWith(
        movements: [...state.diagram.movements, element],
      );
    } else if (element is AreaMarker) {
      newDiagram = state.diagram.copyWith(
        areas: [...state.diagram.areas, element],
      );
    } else if (element is TextLabel) {
      newDiagram = state.diagram.copyWith(
        labels: [...state.diagram.labels, element],
      );
    } else {
      return; // Unknown element type
    }

    _addToHistory(newDiagram);
  }

  // Remove element from diagram
  void removeElement(String elementId) {
    final newDiagram = state.diagram.copyWith(
      players: state.diagram.players.where((p) => p.id != elementId).toList(),
      equipment:
          state.diagram.equipment.where((e) => e.id != elementId).toList(),
      movements:
          state.diagram.movements.where((m) => m.id != elementId).toList(),
      areas: state.diagram.areas.where((a) => a.id != elementId).toList(),
      labels: state.diagram.labels.where((l) => l.id != elementId).toList(),
    );

    _addToHistory(newDiagram);

    // Clear selection if the selected element was removed
    if (state.selectedElementId == elementId) {
      state = state.copyWith();
    }
  }

  // Move element to new position
  void moveElement(String elementId, Position newPosition) {
    var newDiagram = state.diagram;

    // Find and update the element
    final playerIndex = state.diagram.players.indexWhere(
      (p) => p.id == elementId,
    );
    if (playerIndex != -1) {
      final updatedPlayers = [...state.diagram.players];
      updatedPlayers[playerIndex] = PlayerMarker(
        id: updatedPlayers[playerIndex].id,
        position: newPosition,
        type: updatedPlayers[playerIndex].type,
        label: updatedPlayers[playerIndex].label,
        color: updatedPlayers[playerIndex].color,
      );
      newDiagram = state.diagram.copyWith(players: updatedPlayers);
    }

    final equipmentIndex = state.diagram.equipment.indexWhere(
      (e) => e.id == elementId,
    );
    if (equipmentIndex != -1) {
      final updatedEquipment = [...state.diagram.equipment];
      updatedEquipment[equipmentIndex] = EquipmentMarker(
        id: updatedEquipment[equipmentIndex].id,
        position: newPosition,
        type: updatedEquipment[equipmentIndex].type,
        color: updatedEquipment[equipmentIndex].color,
        size: updatedEquipment[equipmentIndex].size,
      );
      newDiagram = state.diagram.copyWith(equipment: updatedEquipment);
    }

    final labelIndex = state.diagram.labels.indexWhere(
      (l) => l.id == elementId,
    );
    if (labelIndex != -1) {
      final updatedLabels = [...state.diagram.labels];
      updatedLabels[labelIndex] = TextLabel(
        id: updatedLabels[labelIndex].id,
        position: newPosition,
        text: updatedLabels[labelIndex].text,
        color: updatedLabels[labelIndex].color,
        fontSize: updatedLabels[labelIndex].fontSize,
      );
      newDiagram = state.diagram.copyWith(labels: updatedLabels);
    }

    _addToHistory(newDiagram);
  }

  // Change field type
  void changeFieldType(FieldType fieldType) {
    FieldDiagram newDiagram;

    switch (fieldType) {
      case FieldType.fullField:
        newDiagram = FieldDiagram.fullField(id: state.diagram.id);
      case FieldType.halfField:
        newDiagram = FieldDiagram.halfField(id: state.diagram.id);
      case FieldType.penaltyArea:
        newDiagram = FieldDiagram.penaltyArea(id: state.diagram.id);
      default:
        return;
    }

    // Preserve existing elements when changing field type
    newDiagram = newDiagram.copyWith(
      players: state.diagram.players,
      equipment: state.diagram.equipment,
      movements: state.diagram.movements,
      areas: state.diagram.areas,
      labels: state.diagram.labels,
    );

    _addToHistory(newDiagram);
  }

  // History management
  void undo() {
    if (state.canUndo) {
      final newIndex = state.historyIndex - 1;
      state = state.copyWith(
        diagram: state.history[newIndex],
        historyIndex: newIndex,
        isModified: true,
      );
    }
  }

  void redo() {
    if (state.canRedo) {
      final newIndex = state.historyIndex + 1;
      state = state.copyWith(
        diagram: state.history[newIndex],
        historyIndex: newIndex,
        isModified: true,
      );
    }
  }

  void _addToHistory(FieldDiagram diagram) {
    final newHistory = state.history.take(state.historyIndex + 1).toList()
      ..add(diagram);

    // Limit history to 50 items
    if (newHistory.length > 50) {
      newHistory.removeAt(0);
    }

    state = state.copyWith(
      diagram: diagram,
      history: newHistory,
      historyIndex: newHistory.length - 1,
      isModified: true,
    );
  }

  // Save operations
  Future<void> saveDiagramToExercise(
    String exerciseId,
    FieldDiagram diagram,
  ) async {
    // TODO(author): Implement save to exercise
    // This would integrate with the exercise library service
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate API call
  }

  Future<void> saveDiagramTemplate(FieldDiagram diagram, String name) async {
    // TODO(author): Implement save as template
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate API call
  }

  /// 🔧 CASCADE OPERATOR DOCUMENTATION - FIELD DIAGRAM PROVIDER OPERATIONS
  ///
  /// This provider demonstrates complex export and diagram manipulation patterns where
  /// cascade notation (..) could significantly improve readability and maintainability
  /// of tactical field diagram operations in sports applications.
  ///
  /// **CURRENT PATTERN**: object.method() / object.property = value (explicit calls)
  /// **RECOMMENDED**: object..method()..property = value (cascade notation)
  ///
  /// **CASCADE BENEFITS FOR FIELD DIAGRAM PROVIDERS**:
  /// ✅ Eliminates repetitive object references in export operations
  /// ✅ Creates visual grouping of related operations
  /// ✅ Improves readability of complex diagram manipulation
  /// ✅ Follows Flutter/Dart best practices for provider patterns
  /// ✅ Enhances maintainability of tactical diagram systems
  /// ✅ Reduces cognitive load when reviewing export logic
  ///
  /// **FIELD DIAGRAM SPECIFIC ADVANTAGES**:
  /// - PDF export operations with multiple method calls
  /// - File saver configuration with multiple properties
  /// - Diagram object initialization and manipulation
  /// - Canvas and painting operations sequencing
  /// - Consistent with other provider patterns in the app
  ///
  /// **FIELD DIAGRAM TRANSFORMATION EXAMPLE**:
  /// ```dart
  /// // Current (verbose export operations):
  /// await FileSaver.instance.saveFile(
  ///   name: 'field_diagram_${DateTime.now().millisecondsSinceEpoch}',
  ///   bytes: bytes,
  ///   ext: 'png',
  ///   mimeType: MimeType.png,
  /// );
  ///
  /// // With cascade notation (fluent export configuration):
  /// await FileSaver.instance
  ///   ..saveFile(
  ///     name: 'field_diagram_${DateTime.now().millisecondsSinceEpoch}',
  ///     bytes: bytes,
  ///     ext: 'png',
  ///     mimeType: MimeType.png,
  ///   );
  /// ```

  // Export operations
  Future<void> exportDiagramToPNG(
    FieldDiagram diagram, {
    int width = 1920,
  }) async {
    try {
      // Use the canvas to generate a high-resolution PNG
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(width.toDouble(), width * 0.75); // 4:3 aspect ratio

      // Create a field painter and paint to the canvas in one cascaded expression
      FieldPainter(
        diagram: diagram,
        showGrid: false, // No grid in exports
        gridSize: 10,
      ).paint(canvas, size);

      final picture = recorder.endRecording();
      final image = await picture.toImage(width, (width * 0.75).round());
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final bytes = byteData.buffer.asUint8List();
        await FileSaver.instance.saveFile(
          name: 'field_diagram_${DateTime.now().millisecondsSinceEpoch}.png',
          bytes: bytes,
          mimeType: MimeType.png,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> exportDiagramToPDF(FieldDiagram diagram) async {
    try {
      final pdf = pw.Document();

      // First export to image, then embed in PDF
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size(800, 600);

      FieldPainter(
        diagram: diagram,
        showGrid: false,
        gridSize: 10,
      ).paint(canvas, size);

      final picture = recorder.endRecording();
      final image = await picture.toImage(800, 600);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final imageBytes = byteData.buffer.asUint8List();

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Veld Diagram',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Image(pw.MemoryImage(imageBytes)),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Gegenereerd op: ${DateTime.now().toString().substring(0, 16)}',
                ),
                pw.Text('Spelers: ${diagram.players.length}'),
                pw.Text('Equipment: ${diagram.equipment.length}'),
                pw.Text('Bewegingen: ${diagram.movements.length}'),
              ],
            ),
          ),
        );

        final pdfBytes = await pdf.save();
        await FileSaver.instance.saveFile(
          name: 'field_diagram_${DateTime.now().millisecondsSinceEpoch}.pdf',
          bytes: Uint8List.fromList(pdfBytes),
          mimeType: MimeType.pdf,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Export operations (legacy methods updated)
  Future<void> exportDiagram(FieldDiagram diagram, String format) async {
    switch (format.toLowerCase()) {
      case 'png':
        await exportDiagramToPNG(diagram);
      case 'pdf':
        await exportDiagramToPDF(diagram);
      default:
        throw Exception('Unsupported export format: $format');
    }
  }

  // Set diagram from existing data
  void setDiagram(FieldDiagram diagram) {
    state = FieldDiagramEditorState(
      diagram: diagram,
      history: [diagram],
      historyIndex: 0,
    );
  }

  // Set diagram from JSON data
  void setDiagramFromJson(Map<String, dynamic> diagramJson) {
    try {
      final diagram = FieldDiagram.fromJson(diagramJson);
      setDiagram(diagram);
    } catch (e) {
      // Error setting diagram from JSON: $e
    }
  }

  // Load diagram from JSON data
  void loadFromData(Map<String, dynamic> diagramData) {
    try {
      final diagram = FieldDiagram.fromJson(diagramData);
      setDiagram(diagram);
    } catch (e) {
      // Error loading diagram from data: $e
      // Als conversie mislukt, maak een nieuw leeg diagram
      setDiagram(FieldDiagram.halfField());
    }
  }

  // Formation Templates
  void applyFormationTemplate(FormationTemplate template) {
    final newDiagram = _createFormationDiagram(template);
    _addToHistory(newDiagram);
  }

  FieldDiagram _createFormationDiagram(FormationTemplate template) {
    final players = <PlayerMarker>[];

    // Add players based on formation template
    for (var i = 0; i < template.positions.length; i++) {
      final position = template.positions[i];
      players.add(
        PlayerMarker(
          id: 'player_${i + 1}',
          position: position,
          type: PlayerType.attacking,
          label: '${i + 1}',
        ),
      );
    }

    return state.diagram.copyWith(players: players);
  }

  // Predefined formation templates
  static List<FormationTemplate> getFormationTemplates() => [
        const FormationTemplate(
          name: '4-3-3',
          description: 'Klassieke aanvallende opstelling',
          positions: [
            Position(50, 90), // Keeper
            Position(20, 70), // LB
            Position(35, 75), // CB
            Position(65, 75), // CB
            Position(80, 70), // RB
            Position(30, 50), // CM
            Position(50, 45), // CM
            Position(70, 50), // CM
            Position(20, 25), // LW
            Position(50, 20), // ST
            Position(80, 25), // RW
          ],
        ),
        const FormationTemplate(
          name: '4-4-2',
          description: 'Gebalanceerde opstelling',
          positions: [
            Position(50, 90), // Keeper
            Position(20, 70), // LB
            Position(35, 75), // CB
            Position(65, 75), // CB
            Position(80, 70), // RB
            Position(20, 50), // LM
            Position(35, 45), // CM
            Position(65, 45), // CM
            Position(80, 50), // RM
            Position(40, 20), // ST
            Position(60, 20), // ST
          ],
        ),
        const FormationTemplate(
          name: '3-5-2',
          description: 'Moderne opstelling met wingbacks',
          positions: [
            Position(50, 90), // Keeper
            Position(30, 75), // CB
            Position(50, 80), // CB
            Position(70, 75), // CB
            Position(15, 55), // LWB
            Position(35, 45), // CM
            Position(50, 40), // CM
            Position(65, 45), // CM
            Position(85, 55), // RWB
            Position(40, 20), // ST
            Position(60, 20), // ST
          ],
        ),
        const FormationTemplate(
          name: '4-2-3-1',
          description: 'Moderne aanvallende opstelling',
          positions: [
            Position(50, 90), // Keeper
            Position(20, 70), // LB
            Position(35, 75), // CB
            Position(65, 75), // CB
            Position(80, 70), // RB
            Position(35, 55), // CDM
            Position(65, 55), // CDM
            Position(20, 35), // LW
            Position(50, 30), // CAM
            Position(80, 35), // RW
            Position(50, 15), // ST
          ],
        ),
        const FormationTemplate(
          name: 'JO17 Training (7v7)',
          description: 'Aangepaste opstelling voor training',
          positions: [
            Position(50, 85), // Keeper
            Position(25, 65), // LB
            Position(50, 70), // CB
            Position(75, 65), // RB
            Position(35, 45), // CM
            Position(65, 45), // CM
            Position(50, 25), // ST
          ],
        ),
      ];
}

// Formation Template Model
class FormationTemplate {
  const FormationTemplate({
    required this.name,
    required this.description,
    required this.positions,
  });
  final String name;
  final String description;
  final List<Position> positions;
}

// Provider instance
final fieldDiagramProvider =
    StateNotifierProvider<FieldDiagramEditorNotifier, FieldDiagramEditorState>(
  (ref) => FieldDiagramEditorNotifier(),
);
