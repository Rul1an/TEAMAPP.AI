import 'package:flutter/material.dart';

class HeatMapLegend extends StatelessWidget {
  const HeatMapLegend({super.key});

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
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.yellow, Colors.red],
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
