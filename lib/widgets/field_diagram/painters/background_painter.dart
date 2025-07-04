import 'package:flutter/material.dart';

/// Paints the pitch background (grass gradient).
class BackgroundPainter {
  const BackgroundPainter._();

  static void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFA5D6A7), // green[100]
          Color(0xFFE8F5E9), // green[50]
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
  }
}
