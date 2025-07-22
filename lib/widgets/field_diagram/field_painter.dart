// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../models/training_session/field_diagram.dart';
import 'painters/background_painter.dart';
import 'painters/grid_painter.dart';
import 'painters/pitch_painter.dart';
import 'painters/element_painter.dart';

// ignore_for_file: unused_element

class FieldPainter extends CustomPainter {
  FieldPainter({
    required this.diagram,
    required this.showGrid,
    required this.gridSize,
    this.selectedElementId,
    this.currentLinePoints = const [],
    this.isDrawingLine = false,
    this.selectedLineType = LineType.pass,
  });
  final FieldDiagram diagram;
  final String? selectedElementId;
  final bool showGrid;
  final double gridSize;
  final List<Position> currentLinePoints;
  final bool isDrawingLine;
  final LineType selectedLineType;

  @override
  void paint(Canvas canvas, Size size) {
    final fieldRect = _calculateFieldRect(size);

    // Draw background & grid via dedicated painters
    BackgroundPainter.paint(canvas, size);

    if (showGrid) {
      GridPainter.paint(canvas, size, gridSize);
    }

    // Draw field lines & grass
    PitchPainter.paint(canvas, fieldRect, diagram);

    // Draw all elements
    _drawElements(canvas, fieldRect);
  }

  Rect _calculateFieldRect(Size size) {
    // Calculate field aspect ratio based on type
    var fieldAspectRatio = 1.5; // Default ratio
    switch (diagram.fieldType) {
      case FieldType.fullField:
        fieldAspectRatio = 105.0 / 68.0; // FIFA standard ratio
      case FieldType.halfField:
        fieldAspectRatio = 52.5 / 68.0;
      case FieldType.penaltyArea:
        fieldAspectRatio = 16.5 / 40.3;
      case FieldType.thirdField:
        fieldAspectRatio = 35.0 / 68.0;
      case FieldType.quarterField:
        fieldAspectRatio = 26.0 / 34.0;
      default:
        fieldAspectRatio = diagram.fieldSize.width / diagram.fieldSize.height;
    }

    // Fit field to canvas with padding
    const padding = 20.0; // Reduced padding to make field larger
    final availableWidth = size.width - (padding * 2);
    final availableHeight = size.height - (padding * 2);

    double fieldWidth;
    double fieldHeight;
    if (availableWidth / availableHeight > fieldAspectRatio) {
      // Available space is wider than needed, constrain by height
      fieldHeight = availableHeight;
      fieldWidth = fieldHeight * fieldAspectRatio;
    } else {
      // Available space is taller than needed, constrain by width
      fieldWidth = availableWidth;
      fieldHeight = fieldWidth / fieldAspectRatio;
    }

    // Center the field in the available space
    final left = (size.width - fieldWidth) / 2;
    final top = (size.height - fieldHeight) / 2;

    return Rect.fromLTWH(left, top, fieldWidth, fieldHeight);
  }

  /// 🔧 CASCADE OPERATOR DOCUMENTATION - CUSTOM PAINTING CONFIGURATION
  ///
  /// This custom painter demonstrates Paint object configuration patterns where
  /// cascade notation (..) could significantly improve readability and maintainability
  /// of Flutter custom painting implementations.
  ///
  /// **CURRENT PATTERN**: paint.property = value (explicit assignments)
  /// **RECOMMENDED**: paint..property = value (cascade notation)
  ///
  /// **CASCADE BENEFITS FOR CUSTOM PAINTING**:
  /// ✅ Eliminates 20+ repetitive "paint." references
  /// ✅ Creates visual grouping of paint configuration
  /// ✅ Improves readability of complex drawing operations
  /// ✅ Follows Flutter/Dart best practices for object configuration
  /// ✅ Enhances maintainability of custom painting widgets
  /// ✅ Reduces cognitive load when reviewing paint setups
  ///
  /// **CUSTOM PAINTING SPECIFIC ADVANTAGES**:
  /// - Paint object configuration with multiple properties
  /// - Shader, color, and stroke width assignments
  /// - Complex gradient and texture paint setups
  /// - Multiple paint objects with different configurations
  /// - Consistent with Flutter custom painting patterns
  ///
  /// **PAINT CONFIGURATION TRANSFORMATION EXAMPLE**:
  /// ```dart
  /// // Current (verbose paint configuration):
  /// final paint = Paint();
  /// paint.color = Colors.white;
  /// paint.strokeWidth = 2.0;
  /// paint.style = PaintingStyle.stroke;
  ///
  /// // With cascade notation (fluent paint configuration):
  /// final paint = Paint()
  ///   ..color = Colors.white
  ///   ..strokeWidth = 2.0
  ///   ..style = PaintingStyle.stroke;
  /// ```
  void _drawElements(Canvas canvas, Rect fieldRect) {
    ElementPainter.paint(
      canvas,
      fieldRect,
      diagram,
      selectedElementId,
      isDrawingLine,
      currentLinePoints,
      selectedLineType,
    );
  }

  void _drawPlayer(
    Canvas canvas,
    Rect fieldRect,
    PlayerMarker player,
    bool isSelected,
  ) {
    final position = _fieldToCanvasPosition(player.position, fieldRect);
    final radius = isSelected ? 18.0 : 15.0;

    // Player circle
    final playerPaint = Paint()
      ..color = _parseColor(player.color)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, radius, playerPaint);

    // Player border
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(position, radius, borderPaint);

    // Selection ring
    if (isSelected) {
      final selectionPaint = Paint()
        ..color = Colors.orange
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(position, radius + 5, selectionPaint);
    }

    // Player label
    if (player.label != null && player.label!.isNotEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: player.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter
        ..layout()
        ..paint(
          canvas,
          position - Offset(textPainter.width / 2, textPainter.height / 2),
        );
    }

    // Highlight for selected player circle is already handled by outer ring.
  }

  void _drawEquipment(
    Canvas canvas,
    Rect fieldRect,
    EquipmentMarker equipment,
    bool isSelected,
  ) {
    final position = _fieldToCanvasPosition(equipment.position, fieldRect);
    final paint = Paint()
      ..color = _parseColor(equipment.color)
      ..style = PaintingStyle.fill;

    switch (equipment.type) {
      case EquipmentType.cone:
        _drawCone(canvas, position, paint, isSelected);
      case EquipmentType.ball:
        _drawBall(canvas, position, paint, isSelected);
      default:
        _drawGenericEquipment(canvas, position, paint, isSelected);
    }
  }

  void _drawCone(Canvas canvas, Offset position, Paint paint, bool isSelected) {
    final size = isSelected ? 14.0 : 12.0;
    final path = Path()
      ..addPolygon(
        [
          Offset(position.dx, position.dy - size),
          Offset(position.dx - size / 2, position.dy + size / 2),
          Offset(position.dx + size / 2, position.dy + size / 2),
        ],
        true,
      );

    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Fill and border in one cascade
    canvas
      ..drawPath(path, paint)
      ..drawPath(path, borderPaint);

    if (isSelected) {
      final selectionPaint = Paint()
        ..color = Colors.orange
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(position, size + 3, selectionPaint);
    }
  }

  void _drawBall(Canvas canvas, Offset position, Paint paint, bool isSelected) {
    final radius = isSelected ? 8.0 : 6.0;

    // Ball fill, outline, and stripe via cascade
    final patternPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas
      ..drawCircle(position, radius, paint)
      ..drawCircle(position, radius, patternPaint)
      ..drawLine(
        Offset(position.dx - radius * 0.7, position.dy),
        Offset(position.dx + radius * 0.7, position.dy),
        patternPaint,
      );

    if (isSelected) {
      final selectionPaint = Paint()
        ..color = Colors.orange
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(position, radius + 4, selectionPaint);
    }
  }

  void _drawGenericEquipment(
    Canvas canvas,
    Offset position,
    Paint paint,
    bool isSelected,
  ) {
    final size = isSelected ? 12.0 : 10.0;
    if (isSelected) {
      final selectionPaint = Paint()
        ..color = Colors.orange
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas
        ..drawRect(
          Rect.fromCenter(center: position, width: size, height: size),
          paint,
        )
        ..drawRect(
          Rect.fromCenter(center: position, width: size + 4, height: size + 4),
          selectionPaint,
        );
    } else {
      // Only the equipment rectangle when not selected
      canvas.drawRect(
        Rect.fromCenter(center: position, width: size, height: size),
        paint,
      );
    }
  }

  void _drawTextLabel(
    Canvas canvas,
    Rect fieldRect,
    TextLabel label,
    bool isSelected,
  ) {
    final position = _fieldToCanvasPosition(label.position, fieldRect);

    final textPainter = TextPainter(
      text: TextSpan(
        text: label.text,
        style: TextStyle(
          color: _parseColor(label.color),
          fontSize: label.fontSize,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter
      ..layout()
      ..paint(
        canvas,
        position - Offset(textPainter.width / 2, textPainter.height / 2),
      );
  }

  void _drawMovementLine(
    Canvas canvas,
    Rect fieldRect,
    MovementLine line,
    bool isSelected,
  ) {
    if (line.points.length < 2) return;

    final paint = Paint()
      ..color = _parseColor(line.color)
      ..strokeWidth = line.strokeWidth * (isSelected ? 1.5 : 1.0)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Apply line style based on type
    final path = Path();
    final firstPoint = _fieldToCanvasPosition(line.points.first, fieldRect);

    // Validate first point
    if (!_isValidOffset(firstPoint)) return;
    path.moveTo(firstPoint.dx, firstPoint.dy);

    switch (line.type) {
      case LineType.pass:
        // Solid line
        for (var i = 1; i < line.points.length; i++) {
          final point = _fieldToCanvasPosition(line.points[i], fieldRect);
          if (_isValidOffset(point)) {
            path.lineTo(point.dx, point.dy);
          }
        }
        canvas.drawPath(path, paint);

      case LineType.run:
        // Dashed line
        _drawDashedPath(canvas, line.points, fieldRect, paint);

      case LineType.dribble:
        // Wavy line
        _drawWavyPath(canvas, line.points, fieldRect, paint);

      case LineType.shot:
        // Thick solid line
        paint.strokeWidth = line.strokeWidth * 1.5 * (isSelected ? 1.5 : 1.0);
        for (var i = 1; i < line.points.length; i++) {
          final point = _fieldToCanvasPosition(line.points[i], fieldRect);
          if (_isValidOffset(point)) {
            path.lineTo(point.dx, point.dy);
          }
        }
        canvas.drawPath(path, paint);

      case LineType.defensive:
        // Dotted line
        _drawDottedPath(canvas, line.points, fieldRect, paint);

      case LineType.ballPath:
        // Thin line
        paint.strokeWidth = line.strokeWidth * 0.7;
        for (var i = 1; i < line.points.length; i++) {
          final point = _fieldToCanvasPosition(line.points[i], fieldRect);
          if (_isValidOffset(point)) {
            path.lineTo(point.dx, point.dy);
          }
        }
        canvas.drawPath(path, paint);
    }

    // Draw arrow head if needed
    if (line.hasArrowHead && line.points.length >= 2) {
      final lastPoint = _fieldToCanvasPosition(line.points.last, fieldRect);
      final secondLastPoint = _fieldToCanvasPosition(
        line.points[line.points.length - 2],
        fieldRect,
      );

      // Validate arrow head points
      if (_isValidOffset(lastPoint) && _isValidOffset(secondLastPoint)) {
        _drawArrowHead(canvas, secondLastPoint, lastPoint, paint);
      }
    }

    // Draw selection indicator
    if (isSelected) {
      final selectionPaint = Paint()
        ..color = Colors.orange.withValues(alpha: 0.3)
        ..strokeWidth = line.strokeWidth + 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final selectionPath = Path();

      // Collect all valid points for the selection polygon
      final selectionPoints = [
        for (final p in line.points) _fieldToCanvasPosition(p, fieldRect),
      ].where(_isValidOffset).toList();

      if (selectionPoints.length >= 2) {
        selectionPath.addPolygon(selectionPoints, false);
        canvas.drawPath(selectionPath, selectionPaint);
      }
    }
  }

  void _drawCurrentLine(Canvas canvas, Rect fieldRect) {
    if (currentLinePoints.length < 2) return;

    final paint = Paint()
      ..color = _getLineTypeColor(selectedLineType)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final firstPoint = _fieldToCanvasPosition(
      currentLinePoints.first,
      fieldRect,
    );

    // Validate first point
    if (!_isValidOffset(firstPoint)) return;
    path.moveTo(firstPoint.dx, firstPoint.dy);

    for (var i = 1; i < currentLinePoints.length; i++) {
      final point = _fieldToCanvasPosition(currentLinePoints[i], fieldRect);
      if (_isValidOffset(point)) {
        path.lineTo(point.dx, point.dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawDashedPath(
    Canvas canvas,
    List<Position> points,
    Rect fieldRect,
    Paint paint,
  ) {
    const dashLength = 10.0;
    const dashSpace = 5.0;
    double distance = 0;

    for (var i = 0; i < points.length - 1; i++) {
      final start = _fieldToCanvasPosition(points[i], fieldRect);
      final end = _fieldToCanvasPosition(points[i + 1], fieldRect);

      // Validate positions
      if (!_isValidOffset(start) || !_isValidOffset(end)) continue;

      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;
      final length = math.sqrt(dx * dx + dy * dy);

      // Skip if length is invalid or too small
      if (length.isNaN || length <= 0 || length < (dashLength + dashSpace)) {
        continue;
      }

      final steps = length / (dashLength + dashSpace);
      if (steps.isNaN || steps <= 0) continue;

      final stepX = dx / steps;
      final stepY = dy / steps;

      for (double j = 0; j < steps; j++) {
        if (distance % (dashLength + dashSpace) < dashLength) {
          final dashStart = Offset(start.dx + stepX * j, start.dy + stepY * j);
          final dashEnd = Offset(
            start.dx + stepX * (j + dashLength / (dashLength + dashSpace)),
            start.dy + stepY * (j + dashLength / (dashLength + dashSpace)),
          );

          // Validate dash points before drawing
          if (_isValidOffset(dashStart) && _isValidOffset(dashEnd)) {
            canvas.drawLine(dashStart, dashEnd, paint);
          }
        }
        distance += dashLength + dashSpace;
      }
    }
  }

  void _drawDottedPath(
    Canvas canvas,
    List<Position> points,
    Rect fieldRect,
    Paint paint,
  ) {
    const dotSpacing = 8.0;

    for (var i = 0; i < points.length - 1; i++) {
      final start = _fieldToCanvasPosition(points[i], fieldRect);
      final end = _fieldToCanvasPosition(points[i + 1], fieldRect);

      // Validate positions
      if (!_isValidOffset(start) || !_isValidOffset(end)) continue;

      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;
      final length = math.sqrt(dx * dx + dy * dy);

      // Skip if length is too small or invalid
      if (length.isNaN || length <= 0 || length < dotSpacing) continue;

      final dots = (length / dotSpacing).floor();
      if (dots <= 0) continue;

      for (var j = 0; j <= dots; j++) {
        final t = j / dots;
        final dotCenter = Offset(start.dx + dx * t, start.dy + dy * t);

        // Validate dot center before drawing
        if (_isValidOffset(dotCenter)) {
          canvas.drawCircle(dotCenter, paint.strokeWidth / 2, paint);
        }
      }
    }
  }

  void _drawWavyPath(
    Canvas canvas,
    List<Position> points,
    Rect fieldRect,
    Paint paint,
  ) {
    if (points.length < 2) return;

    const waveAmplitude = 5.0;
    const waveFrequency = 0.1;

    final path = Path();
    final firstPoint = _fieldToCanvasPosition(points.first, fieldRect);

    // Validate first point
    if (!_isValidOffset(firstPoint)) return;
    path.moveTo(firstPoint.dx, firstPoint.dy);

    for (var i = 0; i < points.length - 1; i++) {
      final start = _fieldToCanvasPosition(points[i], fieldRect);
      final end = _fieldToCanvasPosition(points[i + 1], fieldRect);

      // Validate positions
      if (!_isValidOffset(start) || !_isValidOffset(end)) continue;

      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;
      final length = math.sqrt(dx * dx + dy * dy);

      // Skip if length is invalid
      if (length.isNaN || length <= 0) continue;

      // Normal vector (perpendicular to line direction)
      final nx = -dy / length;
      final ny = dx / length;

      // Validate normal vector
      if (nx.isNaN || ny.isNaN) continue;

      // Create wavy path using quadratic bezier curves
      const steps = 20;
      for (var j = 0; j < steps; j++) {
        final t = j / steps;
        final wave =
            math.sin(t * math.pi * 2 * waveFrequency * length) * waveAmplitude;

        final x = start.dx + dx * t + nx * wave;
        final y = start.dy + dy * t + ny * wave;

        // Validate calculated position
        if (x.isFinite && y.isFinite) {
          if (j == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
      }

      // Validate end point before adding
      if (_isValidOffset(end)) {
        path.lineTo(end.dx, end.dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawArrowHead(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;
    final angle = math.atan2(dy, dx);

    const arrowLength = 12.0;
    const arrowAngle = math.pi / 6; // 30 degrees

    final arrowPoint1 = Offset(
      to.dx - arrowLength * math.cos(angle - arrowAngle),
      to.dy - arrowLength * math.sin(angle - arrowAngle),
    );

    final arrowPoint2 = Offset(
      to.dx - arrowLength * math.cos(angle + arrowAngle),
      to.dy - arrowLength * math.sin(angle + arrowAngle),
    );

    final arrowPath = Path()
      ..moveTo(to.dx, to.dy)
      ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..moveTo(to.dx, to.dy)
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy);

    canvas.drawPath(arrowPath, paint);
  }

  Color _getLineTypeColor(LineType type) {
    switch (type) {
      case LineType.pass:
        return const Color(0xFF4CAF50); // Green
      case LineType.run:
        return const Color(0xFF2196F3); // Blue
      case LineType.dribble:
        return const Color(0xFFFF9800); // Orange
      case LineType.shot:
        return const Color(0xFFF44336); // Red
      case LineType.defensive:
        return const Color(0xFF9C27B0); // Purple
      case LineType.ballPath:
        return const Color(0xFF795548); // Brown
    }
  }

  Offset _fieldToCanvasPosition(Position fieldPos, Rect fieldRect) {
    // Convert normalized field coordinates (0-100) to canvas coordinates
    final x = fieldRect.left + (fieldPos.x / 100) * fieldRect.width;
    final y = fieldRect.top + (fieldPos.y / 100) * fieldRect.height;

    // Return safe values if calculation results in NaN or infinite
    return Offset(x.isFinite ? x : 0.0, y.isFinite ? y : 0.0);
  }

  bool _isValidOffset(Offset offset) =>
      offset.dx.isFinite && offset.dy.isFinite;

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  bool shouldRepaint(FieldPainter oldDelegate) =>
      diagram != oldDelegate.diagram ||
      selectedElementId != oldDelegate.selectedElementId ||
      showGrid != oldDelegate.showGrid ||
      gridSize != oldDelegate.gridSize ||
      currentLinePoints != oldDelegate.currentLinePoints ||
      isDrawingLine != oldDelegate.isDrawingLine ||
      selectedLineType != oldDelegate.selectedLineType;
}
