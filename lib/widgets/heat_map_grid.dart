// Flutter imports:
import 'package:flutter/material.dart';

class HeatMapGrid extends StatelessWidget {
  const HeatMapGrid({
    required this.matrix,
    super.key,
  });

  final List<List<int>> matrix;

  @override
  Widget build(BuildContext context) {
    if (matrix.isEmpty || matrix.first.isEmpty) {
      return const Center(child: Text('No data'));
    }

    final maxValue = matrix
        .expand((row) => row)
        .fold<int>(0, (prev, val) => val > prev ? val : prev);

    return LayoutBuilder(
      builder: (context, constraints) {
        final rows = matrix.length;
        final cols = matrix.first.length;
        final cellSize = (constraints.maxWidth / cols).floorToDouble();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: matrix.map((row) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: row.map((value) {
                final intensity = maxValue == 0 ? 0.0 : value / maxValue;
                final color = Color.lerp(Colors.white, Colors.red, intensity)!;
                return Container(
                  width: cellSize,
                  height: cellSize,
                  color: color,
                );
              }).toList(),
            );
          }).toList(),
        );
      },
    );
  }
}