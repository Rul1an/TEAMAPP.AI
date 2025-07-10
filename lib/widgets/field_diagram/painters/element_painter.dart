// ignore_for_file: unnecessary_breaks, require_trailing_commas, unnecessary_parenthesis, omit_local_variable_types, avoid_positional_boolean_parameters

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../models/training_session/field_diagram.dart';

/// Paints all interactive elements on top of the pitch: players, equipment,
/// text labels and movement lines. Extracted from FieldPainter to keep files
/// small (<300 LOC) and unit-testable.
class ElementPainter {
  const ElementPainter._();

  static void paint(
    Canvas canvas,
    Rect fieldRect,
    FieldDiagram diagram,
    String? selectedElementId,
    bool isDrawingLine,
    List<Position> currentLinePoints,
    LineType selectedLineType,
  ) {
    // Movement lines first (rendered below other items)
    for (final movement in diagram.movements) {
      _drawMovementLine(
        canvas,
        fieldRect,
        movement,
        movement.id == selectedElementId,
      );
    }

    // Current line being drawn (preview)
    if (isDrawingLine && currentLinePoints.isNotEmpty) {
      _drawCurrentLine(canvas, fieldRect, currentLinePoints, selectedLineType);
    }

    // Players
    for (final player in diagram.players) {
      _drawPlayer(canvas, fieldRect, player, player.id == selectedElementId);
    }

    // Equipment
    for (final equipment in diagram.equipment) {
      _drawEquipment(
        canvas,
        fieldRect,
        equipment,
        equipment.id == selectedElementId,
      );
    }

    // Text labels
    for (final label in diagram.labels) {
      _drawTextLabel(canvas, fieldRect, label, label.id == selectedElementId);
    }
  }

  // --------------------------------------------------------------------------
  // Players
  // --------------------------------------------------------------------------

  static void _drawPlayer(
    Canvas canvas,
    Rect fieldRect,
    PlayerMarker player,
    bool isSelected,
  ) {
    final position = _fieldToCanvasPosition(player.position, fieldRect);
    final radius = isSelected ? 18.0 : 15.0;

    // Fill
    final playerPaint = Paint()
      ..color = _parseColor(player.color)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, radius, playerPaint);

    // Border
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(position, radius, borderPaint);

    // Selection ring
    if (isSelected) {
      final selPaint = Paint()
        ..color = Colors.orange
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(position, radius + 5, selPaint);
    }

    // Number / label
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
      )..layout();
      textPainter.paint(
        canvas,
        position - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  // --------------------------------------------------------------------------
  // Equipment
  // --------------------------------------------------------------------------

  static void _drawEquipment(
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
        _drawGeneric(canvas, position, paint, isSelected);
    }
  }

  static void _drawCone(
    Canvas canvas,
    Offset pos,
    Paint paint,
    bool isSelected,
  ) {
    final size = isSelected ? 14.0 : 12.0;
    final path = Path()
      ..addPolygon([
        Offset(pos.dx, pos.dy - size),
        Offset(pos.dx - size / 2, pos.dy + size / 2),
        Offset(pos.dx + size / 2, pos.dy + size / 2),
      ], true);

    final border = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas
      ..drawPath(path, paint)
      ..drawPath(path, border);

    if (isSelected) {
      final sel = Paint()
        ..color = Colors.orange
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(pos, size + 3, sel);
    }
  }

  static void _drawBall(
    Canvas canvas,
    Offset pos,
    Paint paint,
    bool isSelected,
  ) {
    final radius = isSelected ? 8.0 : 6.0;

    final stroke = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas
      ..drawCircle(pos, radius, paint)
      ..drawCircle(pos, radius, stroke)
      ..drawLine(
        Offset(pos.dx - radius * 0.7, pos.dy),
        Offset(pos.dx + radius * 0.7, pos.dy),
        stroke,
      );

    if (isSelected) {
      final sel = Paint()
        ..color = Colors.orange
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(pos, radius + 4, sel);
    }
  }

  static void _drawGeneric(
    Canvas canvas,
    Offset pos,
    Paint paint,
    bool isSelected,
  ) {
    final size = isSelected ? 12.0 : 10.0;
    if (isSelected) {
      final sel = Paint()
        ..color = Colors.orange
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas
        ..drawRect(
          Rect.fromCenter(center: pos, width: size, height: size),
          paint,
        )
        ..drawRect(
          Rect.fromCenter(center: pos, width: size + 4, height: size + 4),
          sel,
        );
    } else {
      canvas.drawRect(
        Rect.fromCenter(center: pos, width: size, height: size),
        paint,
      );
    }
  }

  // --------------------------------------------------------------------------
  // Text label
  // --------------------------------------------------------------------------

  static void _drawTextLabel(
    Canvas canvas,
    Rect fieldRect,
    TextLabel label,
    bool isSelected,
  ) {
    final pos = _fieldToCanvasPosition(label.position, fieldRect);
    final tp = TextPainter(
      text: TextSpan(
        text: label.text,
        style: TextStyle(
          color: _parseColor(label.color),
          fontSize: label.fontSize,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
  }

  // --------------------------------------------------------------------------
  // Movement lines
  // --------------------------------------------------------------------------

  static void _drawMovementLine(
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

    final path = Path();
    final first = _fieldToCanvasPosition(line.points.first, fieldRect);
    if (!_isValidOffset(first)) return;
    path.moveTo(first.dx, first.dy);

    switch (line.type) {
      case LineType.pass:
        for (var i = 1; i < line.points.length; i++) {
          final p = _fieldToCanvasPosition(line.points[i], fieldRect);
          if (_isValidOffset(p)) path.lineTo(p.dx, p.dy);
        }
        canvas.drawPath(path, paint);
        break;
      case LineType.run:
        _drawDashedPath(canvas, line.points, fieldRect, paint);
        break;
      case LineType.dribble:
        _drawWavyPath(canvas, line.points, fieldRect, paint);
        break;
      case LineType.shot:
        paint.strokeWidth = line.strokeWidth * 1.5 * (isSelected ? 1.5 : 1.0);
        for (var i = 1; i < line.points.length; i++) {
          final p = _fieldToCanvasPosition(line.points[i], fieldRect);
          if (_isValidOffset(p)) path.lineTo(p.dx, p.dy);
        }
        canvas.drawPath(path, paint);
        break;
      case LineType.defensive:
        _drawDottedPath(canvas, line.points, fieldRect, paint);
        break;
      case LineType.ballPath:
        paint.strokeWidth = line.strokeWidth * 0.7;
        for (var i = 1; i < line.points.length; i++) {
          final p = _fieldToCanvasPosition(line.points[i], fieldRect);
          if (_isValidOffset(p)) path.lineTo(p.dx, p.dy);
        }
        canvas.drawPath(path, paint);
        break;
    }

    // Arrow head
    if (line.hasArrowHead && line.points.length >= 2) {
      final last = _fieldToCanvasPosition(line.points.last, fieldRect);
      final beforeLast = _fieldToCanvasPosition(
        line.points[line.points.length - 2],
        fieldRect,
      );
      if (_isValidOffset(last) && _isValidOffset(beforeLast)) {
        _drawArrowHead(canvas, beforeLast, last, paint);
      }
    }

    // Selection outline
    if (isSelected) {
      final selPaint = Paint()
        ..color = Colors.orange.withAlpha(77)
        ..strokeWidth = line.strokeWidth + 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final selPath = Path();
      final pts = [
        for (final p in line.points) _fieldToCanvasPosition(p, fieldRect),
      ].where(_isValidOffset).toList();
      if (pts.length >= 2) {
        selPath.addPolygon(pts, false);
        canvas.drawPath(selPath, selPaint);
      }
    }
  }

  static void _drawCurrentLine(
    Canvas canvas,
    Rect fieldRect,
    List<Position> currentPoints,
    LineType selectedType,
  ) {
    if (currentPoints.length < 2) return;
    final paint = Paint()
      ..color = _getLineTypeColor(selectedType)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    final first = _fieldToCanvasPosition(currentPoints.first, fieldRect);
    if (!_isValidOffset(first)) return;
    path.moveTo(first.dx, first.dy);
    for (var i = 1; i < currentPoints.length; i++) {
      final p = _fieldToCanvasPosition(currentPoints[i], fieldRect);
      if (_isValidOffset(p)) path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, paint);
  }

  // --------------------------------------------------------------------------
  // Paths helpers
  // --------------------------------------------------------------------------

  static void _drawDashedPath(
    Canvas canvas,
    List<Position> points,
    Rect fieldRect,
    Paint paint,
  ) {
    const dashLength = 10.0;
    const dashSpace = 5.0;
    for (var i = 0; i < points.length - 1; i++) {
      final start = _fieldToCanvasPosition(points[i], fieldRect);
      final end = _fieldToCanvasPosition(points[i + 1], fieldRect);
      if (!_isValidOffset(start) || !_isValidOffset(end)) continue;
      final total = (end - start).distance;
      if (total <= 0 || total.isNaN) continue;
      final dir = (end - start) / total;
      double drawn = 0;
      while (drawn < total) {
        final seg = math.min(dashLength, total - drawn);
        final p1 = start + dir * drawn;
        final p2 = start + dir * (drawn + seg);
        canvas.drawLine(p1, p2, paint);
        drawn += dashLength + dashSpace;
      }
    }
  }

  static void _drawDottedPath(
    Canvas canvas,
    List<Position> points,
    Rect fieldRect,
    Paint paint,
  ) {
    const spacing = 8.0;
    for (var i = 0; i < points.length - 1; i++) {
      final start = _fieldToCanvasPosition(points[i], fieldRect);
      final end = _fieldToCanvasPosition(points[i + 1], fieldRect);
      if (!_isValidOffset(start) || !_isValidOffset(end)) continue;
      final total = (end - start).distance;
      if (total <= 0 || total.isNaN) continue;
      final dir = (end - start) / total;
      for (double d = 0; d <= total; d += spacing) {
        final center = start + dir * d;
        canvas.drawCircle(center, paint.strokeWidth / 2, paint);
      }
    }
  }

  static void _drawWavyPath(
    Canvas canvas,
    List<Position> points,
    Rect fieldRect,
    Paint paint,
  ) {
    if (points.length < 2) return;
    const amplitude = 5.0;
    const frequency = 0.1;
    final path = Path();
    final first = _fieldToCanvasPosition(points.first, fieldRect);
    if (!_isValidOffset(first)) return;
    path.moveTo(first.dx, first.dy);

    for (var i = 0; i < points.length - 1; i++) {
      final start = _fieldToCanvasPosition(points[i], fieldRect);
      final end = _fieldToCanvasPosition(points[i + 1], fieldRect);
      if (!_isValidOffset(start) || !_isValidOffset(end)) continue;
      final segment = (end - start);
      final length = segment.distance;
      if (length <= 0 || length.isNaN) continue;
      final dir = segment / length;
      final normal = Offset(-dir.dy, dir.dx);
      const steps = 20;
      for (var j = 0; j <= steps; j++) {
        final t = j / steps;
        final wave = math.sin(t * math.pi * 2 * frequency * length) * amplitude;
        final point = start + dir * (length * t) + normal * wave;
        if (j == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
    }
    canvas.drawPath(path, paint);
  }

  static void _drawArrowHead(
    Canvas canvas,
    Offset from,
    Offset to,
    Paint paint,
  ) {
    const length = 12.0;
    const angle = math.pi / 6;
    final dir = (from - to).direction;
    final p1 =
        to + Offset(math.cos(dir + angle), math.sin(dir + angle)) * length;
    final p2 =
        to + Offset(math.cos(dir - angle), math.sin(dir - angle)) * length;
    canvas
      ..drawLine(to, p1, paint)
      ..drawLine(to, p2, paint);
  }

  // --------------------------------------------------------------------------
  // Utilities
  // --------------------------------------------------------------------------

  static Offset _fieldToCanvasPosition(Position pos, Rect rect) {
    final x = rect.left + (pos.x / 100) * rect.width;
    final y = rect.top + (pos.y / 100) * rect.height;
    return Offset(x.isFinite ? x : 0, y.isFinite ? y : 0);
  }

  static bool _isValidOffset(Offset o) => o.dx.isFinite && o.dy.isFinite;

  static Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.grey;
    }
  }

  static Color _getLineTypeColor(LineType t) {
    switch (t) {
      case LineType.pass:
        return const Color(0xFF4CAF50);
      case LineType.run:
        return const Color(0xFF2196F3);
      case LineType.dribble:
        return const Color(0xFFFF9800);
      case LineType.shot:
        return const Color(0xFFF44336);
      case LineType.defensive:
        return const Color(0xFF9C27B0);
      case LineType.ballPath:
        return const Color(0xFF795548);
    }
  }
}
