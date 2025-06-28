import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/training_session/field_diagram.dart';
import '../../providers/field_diagram_provider.dart';
import 'field_painter.dart';

class FieldCanvas extends ConsumerStatefulWidget {
  const FieldCanvas({
    super.key,
    required this.diagram,
    required this.currentTool,
    this.selectedElementId,
    required this.selectedPlayerType,
    required this.selectedEquipmentType,
    required this.selectedLineType,
    required this.currentLinePoints,
    required this.isDrawingLine,
    required this.onElementSelected,
    required this.onElementMoved,
    required this.onElementAdded,
    required this.onElementRemoved,
  });
  final FieldDiagram diagram;
  final DiagramTool currentTool;
  final String? selectedElementId;
  final PlayerType selectedPlayerType;
  final EquipmentType selectedEquipmentType;
  final LineType selectedLineType;
  final List<Position> currentLinePoints;
  final bool isDrawingLine;
  final Function(String?) onElementSelected;
  final Function(String, Position) onElementMoved;
  final Function(dynamic) onElementAdded;
  final Function(String) onElementRemoved;

  @override
  ConsumerState<FieldCanvas> createState() => _FieldCanvasState();
}

class _FieldCanvasState extends ConsumerState<FieldCanvas> {
  // Transform properties for zoom and pan
  late TransformationController _transformController;

  // Drawing state
  String? _draggedElementId;
  bool _isDragging = false;

  // Grid and snap settings
  bool _showGrid = true;
  bool _snapToGrid = true;
  final double _gridSize = 10;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _buildCanvasControls(),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border.all(color: Colors.green[300]!, width: 2),
              ),
              child: InteractiveViewer(
                transformationController: _transformController,
                minScale: 0.5,
                maxScale: 3,
                panEnabled: widget.currentTool == DiagramTool.select,
                child: GestureDetector(
                  onTapDown: _handleTapDown,
                  onPanStart: _handlePanStart,
                  onPanUpdate: _handlePanUpdate,
                  onPanEnd: _handlePanEnd,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: CustomPaint(
                      painter: FieldPainter(
                        diagram: widget.diagram,
                        selectedElementId: widget.selectedElementId,
                        showGrid: _showGrid,
                        gridSize: _gridSize,
                        currentLinePoints: widget.currentLinePoints,
                        isDrawingLine: widget.isDrawingLine,
                        selectedLineType: widget.selectedLineType,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _buildCanvasControls() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          children: [
            // Zoom controls
            IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: _zoomIn,
              tooltip: 'Inzoomen',
              iconSize: 20,
            ),
            IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: _zoomOut,
              tooltip: 'Uitzoomen',
              iconSize: 20,
            ),
            IconButton(
              icon: const Icon(Icons.center_focus_strong),
              onPressed: _resetZoom,
              tooltip: 'Reset Zoom',
              iconSize: 20,
            ),
            const SizedBox(width: 16),

            // Grid controls
            Row(
              children: [
                Checkbox(
                  value: _showGrid,
                  onChanged: (value) =>
                      setState(() => _showGrid = value ?? true),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const Text('Grid', style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                Checkbox(
                  value: _snapToGrid,
                  onChanged: (value) =>
                      setState(() => _snapToGrid = value ?? true),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const Text('Snap', style: TextStyle(fontSize: 12)),
              ],
            ),

            const Spacer(),

            // Scale indicator
            Text(
              'Zoom: ${(_getCurrentScale() * 100).toInt()}%',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );

  void _handleTapDown(TapDownDetails details) {
    final localPosition = details.localPosition;
    final fieldPosition = _screenToFieldPosition(localPosition);

    switch (widget.currentTool) {
      case DiagramTool.select:
        _handleSelect(fieldPosition);
        break;
      case DiagramTool.player:
        _addPlayer(fieldPosition);
        break;
      case DiagramTool.equipment:
        _addEquipment(fieldPosition);
        break;
      case DiagramTool.line:
        // Line drawing starts with pan gesture
        break;
      case DiagramTool.text:
        _addText(fieldPosition);
        break;
      case DiagramTool.delete:
        _deleteElement(fieldPosition);
        break;
      default:
        break;
    }
  }

  void _handlePanStart(DragStartDetails details) {
    final localPosition = details.localPosition;
    final fieldPosition = _screenToFieldPosition(localPosition);

    if (widget.currentTool == DiagramTool.select) {
      // Find element at position
      final elementId = _findElementAt(fieldPosition);
      if (elementId != null) {
        _draggedElementId = elementId;
        _isDragging = true;
        widget.onElementSelected(elementId);
      }
    } else if (widget.currentTool == DiagramTool.line) {
      // Start drawing a line
      ref.read(fieldDiagramProvider.notifier).startDrawingLine(fieldPosition);
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final localPosition = details.localPosition;
    final fieldPosition = _screenToFieldPosition(localPosition);

    if (_isDragging && _draggedElementId != null) {
      // Moving an element
      final snappedPosition =
          _snapToGrid ? _snapPositionToGrid(fieldPosition) : fieldPosition;
      widget.onElementMoved(_draggedElementId!, snappedPosition);
    } else if (widget.currentTool == DiagramTool.line && widget.isDrawingLine) {
      // Drawing a line - add points
      ref.read(fieldDiagramProvider.notifier).addLinePoint(fieldPosition);
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_isDragging) {
      _isDragging = false;
      _draggedElementId = null;
    } else if (widget.currentTool == DiagramTool.line && widget.isDrawingLine) {
      // Finish drawing the line
      ref.read(fieldDiagramProvider.notifier).finishDrawingLine();
    }
  }

  void _handleSelect(Position fieldPosition) {
    final elementId = _findElementAt(fieldPosition);
    widget.onElementSelected(elementId);
  }

  void _addPlayer(Position fieldPosition) {
    final snappedPosition =
        _snapToGrid ? _snapPositionToGrid(fieldPosition) : fieldPosition;

    // Get color based on player type
    String playerColor;
    switch (widget.selectedPlayerType) {
      case PlayerType.attacking:
        playerColor = '#2196F3'; // Blue
        break;
      case PlayerType.defending:
        playerColor = '#F44336'; // Red
        break;
      case PlayerType.neutral:
        playerColor = '#FFC107'; // Yellow
        break;
      case PlayerType.goalkeeper:
        playerColor = '#4CAF50'; // Green
        break;
    }

    final newPlayer = PlayerMarker(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      position: snappedPosition,
      type: widget.selectedPlayerType,
      label: '${widget.diagram.players.length + 1}',
      color: playerColor,
    );
    widget.onElementAdded(newPlayer);
  }

  void _addEquipment(Position fieldPosition) {
    final snappedPosition =
        _snapToGrid ? _snapPositionToGrid(fieldPosition) : fieldPosition;
    final newEquipment = EquipmentMarker(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      position: snappedPosition,
      type: widget.selectedEquipmentType,
    );
    widget.onElementAdded(newEquipment);
  }

  void _addText(Position fieldPosition) {
    final snappedPosition =
        _snapToGrid ? _snapPositionToGrid(fieldPosition) : fieldPosition;

    // Show text input dialog
    _showTextInputDialog((text) {
      if (text.isNotEmpty) {
        final newText = TextLabel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          position: snappedPosition,
          text: text,
        );
        widget.onElementAdded(newText);
      }
    });
  }

  void _deleteElement(Position fieldPosition) {
    final elementId = _findElementAt(fieldPosition);
    if (elementId != null) {
      widget.onElementRemoved(elementId);
    }
  }

  String? _findElementAt(Position fieldPosition) {
    const tolerance = 20.0; // Hit test tolerance in field units

    // Check players
    for (final player in widget.diagram.players) {
      if (_isPositionNear(fieldPosition, player.position, tolerance)) {
        return player.id;
      }
    }

    // Check equipment
    for (final equipment in widget.diagram.equipment) {
      if (_isPositionNear(fieldPosition, equipment.position, tolerance)) {
        return equipment.id;
      }
    }

    // Check text labels
    for (final label in widget.diagram.labels) {
      if (_isPositionNear(fieldPosition, label.position, tolerance)) {
        return label.id;
      }
    }

    return null;
  }

  bool _isPositionNear(Position pos1, Position pos2, double tolerance) {
    // Calculate distance in normalized coordinates (0-100)
    final dx = pos1.x - pos2.x;
    final dy = pos1.y - pos2.y;
    final distance = dx * dx + dy * dy;

    // Convert tolerance to normalized coordinate tolerance
    final normalizedTolerance = tolerance / 10; // Adjust for 0-100 scale
    return distance <= (normalizedTolerance * normalizedTolerance);
  }

  Position _screenToFieldPosition(Offset screenPosition) {
    // Get the render box to calculate the actual canvas size
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return const Position(0, 0);

    // Calculate field rect similar to FieldPainter
    final canvasSize = renderBox.size;
    final fieldRect = _calculateFieldRect(canvasSize);

    // Check if position is within field bounds
    if (!fieldRect.contains(screenPosition)) {
      return const Position(0, 0);
    }

    // Convert to normalized field coordinates (0-100)
    final relativeX = (screenPosition.dx - fieldRect.left) / fieldRect.width;
    final relativeY = (screenPosition.dy - fieldRect.top) / fieldRect.height;

    return Position(relativeX * 100, relativeY * 100);
  }

  Rect _calculateFieldRect(Size canvasSize) {
    // Calculate field aspect ratio based on field type
    double fieldAspectRatio;
    switch (widget.diagram.fieldType) {
      case FieldType.fullField:
        fieldAspectRatio = 105.0 / 68.0; // FIFA standard
        break;
      case FieldType.halfField:
        fieldAspectRatio = 52.5 / 68.0;
        break;
      case FieldType.penaltyArea:
        fieldAspectRatio = 16.5 / 40.3;
        break;
      default:
        fieldAspectRatio =
            widget.diagram.fieldSize.width / widget.diagram.fieldSize.height;
        break;
    }

    // Fit field to canvas with padding (same as FieldPainter)
    const padding = 40.0;
    final availableWidth = canvasSize.width - (padding * 2);
    final availableHeight = canvasSize.height - (padding * 2);

    double fieldWidth, fieldHeight;
    if (availableWidth / availableHeight > fieldAspectRatio) {
      fieldHeight = availableHeight;
      fieldWidth = fieldHeight * fieldAspectRatio;
    } else {
      fieldWidth = availableWidth;
      fieldHeight = fieldWidth / fieldAspectRatio;
    }

    final left = (canvasSize.width - fieldWidth) / 2;
    final top = (canvasSize.height - fieldHeight) / 2;

    return Rect.fromLTWH(left, top, fieldWidth, fieldHeight);
  }

  Position _snapPositionToGrid(Position position) {
    if (!_snapToGrid) return position;

    // Convert grid size to normalized coordinates
    // Grid size is in pixels, we need to convert to 0-100 scale
    final normalizedGridSize =
        _gridSize / 10; // Rough conversion for field scale

    final snappedX =
        (position.x / normalizedGridSize).round() * normalizedGridSize;
    final snappedY =
        (position.y / normalizedGridSize).round() * normalizedGridSize;

    return Position(
      snappedX.clamp(0, 100),
      snappedY.clamp(0, 100),
    );
  }

  void _showTextInputDialog(Function(String) onTextEntered) {
    String inputText = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tekst Toevoegen'),
        content: TextField(
          onChanged: (value) => inputText = value,
          decoration: const InputDecoration(
            hintText: 'Voer tekst in...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuleren'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onTextEntered(inputText);
            },
            child: const Text('Toevoegen'),
          ),
        ],
      ),
    );
  }

  void _zoomIn() {
    final Matrix4 matrix = _transformController.value.clone();
    matrix.scale(1.2);
    _transformController.value = matrix;
  }

  void _zoomOut() {
    final Matrix4 matrix = _transformController.value.clone();
    matrix.scale(0.8);
    _transformController.value = matrix;
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  double _getCurrentScale() => _transformController.value.getMaxScaleOnAxis();
}
