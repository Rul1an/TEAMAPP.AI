import 'package:flutter/material.dart';

class GridPainter {
  const GridPainter._();

  static void paint(Canvas canvas, Size size, double gridSize) {
    final paint = Paint()
      ..color = Colors.grey[300]!.withAlpha(128)
      ..strokeWidth = 0.5;

    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
}
