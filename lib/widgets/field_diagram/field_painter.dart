import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/training_session/field_diagram.dart';

class FieldPainter extends CustomPainter {
  FieldPainter({
    required this.diagram,
    this.selectedElementId,
    required this.showGrid,
    required this.gridSize,
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

    // Draw background
    _drawBackground(canvas, size);

    // Draw grid if enabled
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    // Draw field
    _drawField(canvas, fieldRect);

    // Draw all elements
    _drawElements(canvas, fieldRect);
  }

  Rect _calculateFieldRect(Size size) {
    // Calculate field aspect ratio based on type
    double fieldAspectRatio = 1.5; // Default ratio
    switch (diagram.fieldType) {
      case FieldType.fullField:
        fieldAspectRatio = 105.0 / 68.0; // FIFA standard ratio
        break;
      case FieldType.halfField:
        fieldAspectRatio = 52.5 / 68.0;
        break;
      case FieldType.penaltyArea:
        fieldAspectRatio = 16.5 / 40.3;
        break;
      case FieldType.thirdField:
        fieldAspectRatio = 35.0 / 68.0;
        break;
      case FieldType.quarterField:
        fieldAspectRatio = 26.0 / 34.0;
        break;
      default:
        fieldAspectRatio = diagram.fieldSize.width / diagram.fieldSize.height;
        break;
    }

    // Fit field to canvas with padding
    const padding = 20.0; // Reduced padding to make field larger
    final availableWidth = size.width - (padding * 2);
    final availableHeight = size.height - (padding * 2);

    double fieldWidth, fieldHeight;
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
  void _drawBackground(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.green[100]!,
          Colors.green[50]!,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey[300]!.withValues(alpha: 0.5)
      ..strokeWidth = 0.5;

    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawField(Canvas canvas, Rect fieldRect) {
    // Field background with gradient texture to simulate grass
    final fieldPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.green[600]!,
          Colors.green[700]!,
        ],
      ).createShader(fieldRect);

    canvas.drawRect(fieldRect, fieldPaint);

    // Add grass texture
    _drawGrassTexture(canvas, fieldRect);

    // Field boundary
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    switch (diagram.fieldType) {
      case FieldType.fullField:
        _drawFullField(canvas, fieldRect, linePaint);
        break;
      case FieldType.halfField:
        _drawHalfField(canvas, fieldRect, linePaint);
        break;
      case FieldType.penaltyArea:
        _drawPenaltyArea(canvas, fieldRect, linePaint);
        break;
      case FieldType.thirdField:
        _drawThirdField(canvas, fieldRect, linePaint);
        break;
      case FieldType.quarterField:
        _drawQuarterField(canvas, fieldRect, linePaint);
        break;
      default:
        canvas.drawRect(fieldRect, linePaint);
        break;
    }
  }

  void _drawGrassTexture(Canvas canvas, Rect fieldRect) {
    // Draw subtle grass lines
    final grassPaint = Paint()
      ..color = Colors.green[800]!.withValues(alpha: 0.1)
      ..strokeWidth = 1.0;

    final stripeWidth = fieldRect.width / 20;
    for (double x = fieldRect.left; x < fieldRect.right; x += stripeWidth * 2) {
      canvas.drawRect(
        Rect.fromLTWH(x, fieldRect.top, stripeWidth, fieldRect.height),
        grassPaint,
      );
    }
  }

  void _drawFullField(Canvas canvas, Rect fieldRect, Paint linePaint) {
    // Outer boundary, center line, circle en spot in één cascadeketen
    final centerX = fieldRect.left + fieldRect.width / 2;
    final centerY = fieldRect.top + fieldRect.height / 2;
    final circleRadius = fieldRect.height * 0.135; // Proportional to height

    final spotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas
      ..drawRect(fieldRect, linePaint)
      ..drawLine(
        Offset(centerX, fieldRect.top),
        Offset(centerX, fieldRect.bottom),
        linePaint,
      )
      ..drawCircle(Offset(centerX, centerY), circleRadius, linePaint)
      ..drawCircle(Offset(centerX, centerY), 3, spotPaint);

    // Penalty areas
    _drawPenaltyAreas(canvas, fieldRect, linePaint);

    // Goals
    if (diagram.showGoals) {
      _drawGoals(canvas, fieldRect, linePaint);
    }
  }

  void _drawHalfField(Canvas canvas, Rect fieldRect, Paint linePaint) {
    // Outer boundary and top middle line combined with cascade to reduce receiver duplication
    canvas
      ..drawRect(fieldRect, linePaint)
      ..drawLine(
        Offset(fieldRect.left, fieldRect.top),
        Offset(fieldRect.right, fieldRect.top),
        linePaint,
      );

    // Halve middencirkel bij de middenlijn
    final centerX = fieldRect.left + fieldRect.width / 2;
    final circleRadius = fieldRect.height * 0.135;

    final circlePath = Path()
      ..addArc(
        Rect.fromCircle(
            center: Offset(centerX, fieldRect.top), radius: circleRadius,),
        0,
        math.pi,
      );
    canvas.drawPath(circlePath, linePaint);

    // Middenstip op de middenlijn
    final spotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, fieldRect.top), 3, spotPaint);

    // Strafschopgebied aan de onderkant van het veld
    final penaltyWidth = fieldRect.width * 0.4;
    final penaltyHeight = fieldRect.height * 0.3;
    final penaltyLeft = fieldRect.left + (fieldRect.width - penaltyWidth) / 2;
    final penaltyTop = fieldRect.bottom - penaltyHeight;

    // Strafschop- en doelgebied samengevoegd in één cascade
    final goalAreaWidth = fieldRect.width * 0.2;
    final goalAreaHeight = fieldRect.height * 0.12;
    final goalAreaLeft = fieldRect.left + (fieldRect.width - goalAreaWidth) / 2;
    final goalAreaTop = fieldRect.bottom - goalAreaHeight;

    canvas
      ..drawRect(
        Rect.fromLTWH(penaltyLeft, penaltyTop, penaltyWidth, penaltyHeight),
        linePaint,
      )
      ..drawRect(
        Rect.fromLTWH(goalAreaLeft, goalAreaTop, goalAreaWidth, goalAreaHeight),
        linePaint,
      )
      ..drawCircle(
        Offset(centerX, fieldRect.bottom - penaltyHeight * 0.7),
        3,
        spotPaint,
      );

    // Hoekbogen
    final cornerRadius = fieldRect.height * 0.03;

    // Linkerhoek
    final leftCornerPath = Path()
      ..addArc(
        Rect.fromCircle(
            center: Offset(fieldRect.left, fieldRect.bottom),
            radius: cornerRadius,),
        -math.pi / 2,
        math.pi / 2,
      );
    canvas
      ..drawPath(leftCornerPath, linePaint)
      // Rechterhoek
      ..drawPath(
        (Path()
              ..addArc(
                Rect.fromCircle(
                    center: Offset(fieldRect.right, fieldRect.bottom),
                    radius: cornerRadius,),
                math.pi,
                math.pi / 2,
              )),
        linePaint,
      );

    // Doel
    if (diagram.showGoals) {
      // Teken het doel aan de onderkant van het veld
      final goalWidth = fieldRect.width * 0.12;
      final goalHeight = fieldRect.height * 0.04;

      final goalRect = Rect.fromLTWH(
        fieldRect.left + (fieldRect.width - goalWidth) / 2,
        fieldRect.bottom,
        goalWidth,
        goalHeight,
      );

      final goalPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      canvas.drawRect(goalRect, goalPaint);
    }
  }

  void _drawPenaltyArea(Canvas canvas, Rect fieldRect, Paint linePaint) {
    // Draw field rectangle and goal line in a single cascade chain
    canvas
      ..drawRect(fieldRect, linePaint)
      ..drawLine(
        Offset(fieldRect.left, fieldRect.bottom),
        Offset(fieldRect.right, fieldRect.bottom),
        linePaint,
      );

    // Strafschopgebied - hier gebruiken we officiele proporties
    final penaltyWidth = fieldRect.width * 0.85; // Breedte van strafschopgebied
    final penaltyHeight =
        fieldRect.height * 0.42; // Hoogte van strafschopgebied
    final penaltyLeft = fieldRect.left + (fieldRect.width - penaltyWidth) / 2;
    final penaltyTop = fieldRect.bottom - penaltyHeight;

    // Strafschopgebied
    canvas.drawRect(
      Rect.fromLTWH(penaltyLeft, penaltyTop, penaltyWidth, penaltyHeight),
      linePaint,
    );

    // Doelgebied
    final goalAreaWidth = fieldRect.width * 0.5; // Breedte van doelgebied
    final goalAreaHeight = fieldRect.height * 0.16; // Hoogte van doelgebied
    final goalAreaLeft = fieldRect.left + (fieldRect.width - goalAreaWidth) / 2;
    final goalAreaTop = fieldRect.bottom - goalAreaHeight;

    // Penalty and goal areas in a single cascade chain
    final spotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final centerX = fieldRect.left + fieldRect.width / 2;

    canvas
      ..drawRect(
        Rect.fromLTWH(penaltyLeft, penaltyTop, penaltyWidth, penaltyHeight),
        linePaint,
      )
      ..drawRect(
        Rect.fromLTWH(goalAreaLeft, goalAreaTop, goalAreaWidth, goalAreaHeight),
        linePaint,
      )
      ..drawCircle(
        Offset(centerX, fieldRect.bottom - penaltyHeight * 0.7),
        3,
        spotPaint,
      );

    // Strafschopgebiedboog
    final arcRadius = fieldRect.width * 0.15;
    final arcCenterY = fieldRect.bottom - penaltyHeight;

    final arcPath = Path()
      ..addArc(
        Rect.fromCircle(
          center: Offset(centerX, arcCenterY),
          radius: arcRadius,
        ),
        -math.pi,
        math.pi,
      );
    canvas.drawPath(arcPath, linePaint);

    // Doel
    if (diagram.showGoals) {
      final goalWidth = fieldRect.width * 0.14;
      final goalHeight = fieldRect.height * 0.05;

      final goalRect = Rect.fromLTWH(
        fieldRect.left + (fieldRect.width - goalWidth) / 2,
        fieldRect.bottom,
        goalWidth,
        goalHeight,
      );

      final goalPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      canvas.drawRect(goalRect, goalPaint);
    }
  }

  void _drawPenaltyAreas(Canvas canvas, Rect fieldRect, Paint linePaint) {
    final penaltyWidth = fieldRect.width * 0.157; // 16.5m / 105m
    final penaltyHeight = fieldRect.height * 0.593; // 40.3m / 68m
    final goalAreaWidth = fieldRect.width * 0.052; // 5.5m / 105m
    final goalAreaHeight = fieldRect.height * 0.269; // 18.3m / 68m

    final leftPenaltyTop =
        fieldRect.top + (fieldRect.height - penaltyHeight) / 2;
    final leftGoalAreaTop =
        fieldRect.top + (fieldRect.height - goalAreaHeight) / 2;
    final rightPenaltyLeft = fieldRect.right - penaltyWidth;
    final rightGoalAreaLeft = fieldRect.right - goalAreaWidth;

    // Cascade voor alle rects
    canvas
      ..drawRect(
        Rect.fromLTWH(
            fieldRect.left, leftPenaltyTop, penaltyWidth, penaltyHeight,),
        linePaint,
      )
      ..drawRect(
        Rect.fromLTWH(
            fieldRect.left, leftGoalAreaTop, goalAreaWidth, goalAreaHeight,),
        linePaint,
      )
      ..drawRect(
        Rect.fromLTWH(
            rightPenaltyLeft, leftPenaltyTop, penaltyWidth, penaltyHeight,),
        linePaint,
      )
      ..drawRect(
        Rect.fromLTWH(
            rightGoalAreaLeft, leftGoalAreaTop, goalAreaWidth, goalAreaHeight,),
        linePaint,
      );

    // Penalty spots
    final spotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final penaltySpotDistance = fieldRect.width * 0.105; // 11m / 105m
    final centerY = fieldRect.top + fieldRect.height / 2;

    canvas
      ..drawCircle(
        Offset(fieldRect.left + penaltySpotDistance, centerY),
        3,
        spotPaint,
      )
      ..drawCircle(
        Offset(fieldRect.right - penaltySpotDistance, centerY),
        3,
        spotPaint,
      );
  }

  void _drawSinglePenaltyArea(Canvas canvas, Rect fieldRect, Paint linePaint,
      {double scaleDown = 1.0,}) {
    final penaltyWidth = fieldRect.width * 0.4 * scaleDown;
    final penaltyHeight = fieldRect.height * 0.6 * scaleDown;
    final goalAreaWidth = fieldRect.width * 0.27 * scaleDown;
    final goalAreaHeight = fieldRect.height * 0.4 * scaleDown;

    final penaltyLeft = fieldRect.left + (fieldRect.width - penaltyWidth) / 2;
    final penaltyTop = fieldRect.bottom - penaltyHeight;
    final goalAreaLeft = fieldRect.left + (fieldRect.width - goalAreaWidth) / 2;
    final goalAreaTop = fieldRect.bottom - goalAreaHeight;

    // Penalty and goal areas in a single cascade chain
    canvas
      ..drawRect(
        Rect.fromLTWH(penaltyLeft, penaltyTop, penaltyWidth, penaltyHeight),
        linePaint,
      )
      ..drawRect(
        Rect.fromLTWH(goalAreaLeft, goalAreaTop, goalAreaWidth, goalAreaHeight),
        linePaint,
      );

    // Penalty spot
    final spotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final centerX = fieldRect.left + fieldRect.width / 2;

    canvas.drawCircle(Offset(centerX, fieldRect.bottom - penaltyHeight * 0.67), 3, spotPaint);
  }

  void _drawGoals(Canvas canvas, Rect fieldRect, Paint linePaint) {
    _drawSingleGoal(canvas, fieldRect, linePaint);
    _drawSingleGoal(canvas, fieldRect, linePaint, isLeft: false);
  }

  void _drawSingleGoal(Canvas canvas, Rect fieldRect, Paint linePaint,
      {bool isLeft = true, bool isTop = false,}) {
    final goalWidth = fieldRect.width * 0.15;
    final goalHeight = fieldRect.height * 0.05;

    Rect goalRect;

    if (isTop) {
      // Goal at the top
      goalRect = Rect.fromLTWH(
        fieldRect.right - goalWidth / 2,
        fieldRect.top - goalHeight,
        goalWidth,
        goalHeight,
      );
    } else if (isLeft) {
      // Goal at the left
      goalRect = Rect.fromLTWH(
        fieldRect.left - goalHeight,
        fieldRect.bottom - (fieldRect.height * 0.4 + goalWidth / 2),
        goalHeight,
        goalWidth,
      );
    } else {
      // Goal at the bottom (default)
      goalRect = Rect.fromLTWH(
        fieldRect.left + (fieldRect.width * 0.5 - goalWidth / 2),
        fieldRect.bottom,
        goalWidth,
        goalHeight,
      );
    }

    final goalPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawRect(goalRect, goalPaint);
  }

  void _drawThirdField(Canvas canvas, Rect fieldRect, Paint linePaint) {
    // Outer boundary & 1/3 line in a single cascade to avoid duplicate receiver
    final oneThirdY = fieldRect.top + fieldRect.height / 3;

    canvas
      ..drawRect(fieldRect, linePaint)
      ..drawLine(
        Offset(fieldRect.left, oneThirdY),
        Offset(fieldRect.right, oneThirdY),
        linePaint,
      );

    // Penalty area
    _drawSinglePenaltyArea(canvas, fieldRect, linePaint, scaleDown: 0.9);

    // Goal
    if (diagram.showGoals) {
      _drawSingleGoal(canvas, fieldRect, linePaint);
    }
  }

  void _drawQuarterField(Canvas canvas, Rect fieldRect, Paint linePaint) {
    // Outer boundary + quarter lines combined via cascade
    final oneQuarterX = fieldRect.left + fieldRect.width / 2;
    final oneQuarterY = fieldRect.top + fieldRect.height / 2;

    canvas
      ..drawRect(fieldRect, linePaint)
      ..drawLine(
        Offset(oneQuarterX, fieldRect.top),
        Offset(oneQuarterX, fieldRect.bottom),
        linePaint,
      )
      ..drawLine(
        Offset(fieldRect.left, oneQuarterY),
        Offset(fieldRect.right, oneQuarterY),
        linePaint,
      );

    // Draw corner arc in the upper right
    final cornerRadius = fieldRect.width * 0.1;
    final cornerPath = Path()
      ..addArc(
        Rect.fromCircle(
          center: Offset(fieldRect.right, fieldRect.top),
          radius: cornerRadius,
        ),
        -math.pi / 2,
        math.pi / 2,
      );
    canvas.drawPath(cornerPath, linePaint);

    // Draw small penalty area in the corner
    _drawCornerPenaltyArea(canvas, fieldRect, linePaint);

    // Draw goal if needed
    if (diagram.showGoals) {
      _drawSingleGoal(canvas, fieldRect, linePaint, isTop: true);
    }
  }

  void _drawCornerPenaltyArea(Canvas canvas, Rect fieldRect, Paint linePaint) {
    final penaltyWidth = fieldRect.width * 0.25;
    final penaltyHeight = fieldRect.height * 0.25;

    final penaltyRect = Rect.fromLTWH(
      fieldRect.right - penaltyWidth,
      fieldRect.top,
      penaltyWidth,
      penaltyHeight,
    );

    // Penalty area rect and spot in one cascade
    final spotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas
      ..drawRect(penaltyRect, linePaint)
      ..drawCircle(
        Offset(
          fieldRect.right - penaltyWidth * 0.5,
          fieldRect.top + penaltyHeight * 0.7,
        ),
        3,
        spotPaint,
      );
  }

  void _drawElements(Canvas canvas, Rect fieldRect) {
    // Draw movement lines first (so they appear under other elements)
    for (final movement in diagram.movements) {
      _drawMovementLine(
          canvas, fieldRect, movement, movement.id == selectedElementId,);
    }

    // Draw current line being drawn
    if (isDrawingLine && currentLinePoints.isNotEmpty) {
      _drawCurrentLine(canvas, fieldRect);
    }

    // Draw players
    for (final player in diagram.players) {
      _drawPlayer(canvas, fieldRect, player, player.id == selectedElementId);
    }

    // Draw equipment
    for (final equipment in diagram.equipment) {
      _drawEquipment(
          canvas, fieldRect, equipment, equipment.id == selectedElementId,);
    }

    // Draw text labels
    for (final label in diagram.labels) {
      _drawTextLabel(canvas, fieldRect, label, label.id == selectedElementId);
    }
  }

  void _drawPlayer(
      Canvas canvas, Rect fieldRect, PlayerMarker player, bool isSelected,) {
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

  void _drawEquipment(Canvas canvas, Rect fieldRect, EquipmentMarker equipment,
      bool isSelected,) {
    final position = _fieldToCanvasPosition(equipment.position, fieldRect);
    final paint = Paint()
      ..color = _parseColor(equipment.color)
      ..style = PaintingStyle.fill;

    switch (equipment.type) {
      case EquipmentType.cone:
        _drawCone(canvas, position, paint, isSelected);
        break;
      case EquipmentType.ball:
        _drawBall(canvas, position, paint, isSelected);
        break;
      default:
        _drawGenericEquipment(canvas, position, paint, isSelected);
        break;
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
      Canvas canvas, Offset position, Paint paint, bool isSelected,) {
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
      Canvas canvas, Rect fieldRect, TextLabel label, bool isSelected,) {
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
      Canvas canvas, Rect fieldRect, MovementLine line, bool isSelected,) {
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
        for (int i = 1; i < line.points.length; i++) {
          final point = _fieldToCanvasPosition(line.points[i], fieldRect);
          if (_isValidOffset(point)) {
            path.lineTo(point.dx, point.dy);
          }
        }
        canvas.drawPath(path, paint);
        break;

      case LineType.run:
        // Dashed line
        _drawDashedPath(canvas, line.points, fieldRect, paint);
        break;

      case LineType.dribble:
        // Wavy line
        _drawWavyPath(canvas, line.points, fieldRect, paint);
        break;

      case LineType.shot:
        // Thick solid line
        paint.strokeWidth = line.strokeWidth * 1.5 * (isSelected ? 1.5 : 1.0);
        for (int i = 1; i < line.points.length; i++) {
          final point = _fieldToCanvasPosition(line.points[i], fieldRect);
          if (_isValidOffset(point)) {
            path.lineTo(point.dx, point.dy);
          }
        }
        canvas.drawPath(path, paint);
        break;

      case LineType.defensive:
        // Dotted line
        _drawDottedPath(canvas, line.points, fieldRect, paint);
        break;

      case LineType.ballPath:
        // Thin line
        paint.strokeWidth = line.strokeWidth * 0.7;
        for (int i = 1; i < line.points.length; i++) {
          final point = _fieldToCanvasPosition(line.points[i], fieldRect);
          if (_isValidOffset(point)) {
            path.lineTo(point.dx, point.dy);
          }
        }
        canvas.drawPath(path, paint);
        break;
    }

    // Draw arrow head if needed
    if (line.hasArrowHead && line.points.length >= 2) {
      final lastPoint = _fieldToCanvasPosition(line.points.last, fieldRect);
      final secondLastPoint = _fieldToCanvasPosition(
          line.points[line.points.length - 2], fieldRect,);

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
        for (final p in line.points)
          _fieldToCanvasPosition(p, fieldRect),
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
    final firstPoint = _fieldToCanvasPosition(currentLinePoints.first, fieldRect);

    // Validate first point
    if (!_isValidOffset(firstPoint)) return;
    path.moveTo(firstPoint.dx, firstPoint.dy);

    for (int i = 1; i < currentLinePoints.length; i++) {
      final point = _fieldToCanvasPosition(currentLinePoints[i], fieldRect);
      if (_isValidOffset(point)) {
        path.lineTo(point.dx, point.dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawDashedPath(
      Canvas canvas, List<Position> points, Rect fieldRect, Paint paint,) {
    const dashLength = 10.0;
    const dashSpace = 5.0;
    double distance = 0;

    for (int i = 0; i < points.length - 1; i++) {
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
          final dashStart = Offset(
            start.dx + stepX * j,
            start.dy + stepY * j,
          );
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
      Canvas canvas, List<Position> points, Rect fieldRect, Paint paint,) {
    const dotSpacing = 8.0;

    for (int i = 0; i < points.length - 1; i++) {
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

      for (int j = 0; j <= dots; j++) {
        final t = j / dots;
        final dotCenter = Offset(
          start.dx + dx * t,
          start.dy + dy * t,
        );

        // Validate dot center before drawing
        if (_isValidOffset(dotCenter)) {
          canvas.drawCircle(dotCenter, paint.strokeWidth / 2, paint);
        }
      }
    }
  }

  void _drawWavyPath(
      Canvas canvas, List<Position> points, Rect fieldRect, Paint paint,) {
    if (points.length < 2) return;

    const waveAmplitude = 5.0;
    const waveFrequency = 0.1;

    final path = Path();
    final firstPoint = _fieldToCanvasPosition(points.first, fieldRect);

    // Validate first point
    if (!_isValidOffset(firstPoint)) return;
    path.moveTo(firstPoint.dx, firstPoint.dy);

    for (int i = 0; i < points.length - 1; i++) {
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
      for (int j = 0; j < steps; j++) {
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
    return Offset(
      x.isFinite ? x : 0.0,
      y.isFinite ? y : 0.0,
    );
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
