import 'package:flutter/material.dart';
import 'heat_map_palette.dart';

class HeatMapLegend extends StatelessWidget {
  const HeatMapLegend({super.key, this.palette = HeatMapPalette.classic});

  final HeatMapPalette palette;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Heatmap legenda van laag naar hoog',
      child: Row(
        children: [
          Text('Laag', style: theme.textTheme.bodySmall),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: palette.gradientStops(samples: 6),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('Hoog', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
