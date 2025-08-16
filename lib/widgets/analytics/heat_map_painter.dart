import 'package:flutter/material.dart';

class HeatMapPainter extends CustomPainter {
  HeatMapPainter(this.matrix, {this.opacity = 1.0});

  final List<List<int>> matrix; // 30x20 grid intensities
  final double opacity; // 0..1

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final cellW = size.width / matrix.length;
    final cellH = size.height / matrix.first.length;
    final max = matrix.expand((e) => e).fold<int>(0, (p, e) => e > p ? e : p);
    for (var i = 0; i < matrix.length; i++) {
      for (var j = 0; j < matrix[i].length; j++) {
        final val = matrix[i][j];
        if (val == 0) continue;
        final intensity = val / max;
        paint.color = Color.lerp(Colors.yellow, Colors.red, intensity)!
            .withOpacity(opacity.clamp(0.0, 1.0));
        final rect = Rect.fromLTWH(i * cellW, j * cellH, cellW, cellH);
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HeatMapPainter oldDelegate) =>
      oldDelegate.matrix != matrix;
}
