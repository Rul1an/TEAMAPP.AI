// ignore_for_file: omit_local_variable_types

import 'package:flutter/material.dart';

import '../../../models/training_session/field_diagram.dart';

/// Paints the football pitch lines, grass texture and field variants.
class PitchPainter {
  const PitchPainter._();

  static void paint(Canvas canvas, Rect fieldRect, FieldDiagram diagram) {
    _drawGrassTexture(canvas, fieldRect);

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    switch (diagram.fieldType) {
      case FieldType.fullField:
        _drawFullField(canvas, fieldRect, linePaint);
      case FieldType.halfField:
        _drawHalfField(canvas, fieldRect, linePaint);
      case FieldType.penaltyArea:
        _drawPenaltyArea(canvas, fieldRect, linePaint);
      case FieldType.thirdField:
        _drawThirdField(canvas, fieldRect, linePaint);
      case FieldType.quarterField:
        _drawQuarterField(canvas, fieldRect, linePaint);
      default:
        canvas.drawRect(fieldRect, linePaint);
    }
  }

  static void _drawGrassTexture(Canvas canvas, Rect rect) {
    final grassPaint = Paint()
      ..color = const Color(0xFF1B5E20).withAlpha(25)
      ..strokeWidth = 1;
    final stripeWidth = rect.width / 20;
    for (double x = rect.left; x <= rect.right; x += stripeWidth * 2) {
      canvas.drawRect(
        Rect.fromLTWH(x, rect.top, stripeWidth, rect.height),
        grassPaint,
      );
    }
  }

  // ---- Specific field drawings ------------------------------------------------

  static void _drawFullField(Canvas canvas, Rect r, Paint p) {
    // Boundary
    canvas.drawRect(r, p);
    // Midline
    canvas.drawLine(
      Offset(r.center.dx, r.top),
      Offset(r.center.dx, r.bottom),
      p,
    );
    // Center circle
    canvas.drawCircle(r.center, r.width * 0.1, p);
  }

  static void _drawHalfField(Canvas canvas, Rect r, Paint p) {
    canvas.drawRect(r, p);
    canvas.drawCircle(
      Offset(r.right - r.width * 0.1, r.center.dy),
      r.width * 0.1,
      p,
    );
  }

  static void _drawPenaltyArea(Canvas canvas, Rect r, Paint p) {
    final areaWidth = r.width * 0.5;
    final areaRect = Rect.fromLTWH(r.left, r.top, areaWidth, r.height);
    canvas.drawRect(areaRect, p);
  }

  static void _drawThirdField(Canvas canvas, Rect r, Paint p) {
    final thirdWidth = r.width / 3;
    final zoneRect = Rect.fromLTWH(r.left, r.top, thirdWidth, r.height);
    canvas.drawRect(zoneRect, p);
  }

  static void _drawQuarterField(Canvas canvas, Rect r, Paint p) {
    final qRect = Rect.fromLTWH(r.left, r.top, r.width / 2, r.height / 2);
    canvas.drawRect(qRect, p);
  }
}
