import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lineup_builder_controller.dart';

class FieldPositionsWidget extends ConsumerWidget {
  const FieldPositionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.watch(lineupBuilderControllerProvider);
    final positions = ctrl.fieldPositions;
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: positions.entries.map((e) {
        final posKey = e.key;
        final player = e.value;
        return GestureDetector(
          onTap: () {
            if (player != null) {
              ref
                  .read(lineupBuilderControllerProvider)
                  .moveFieldPlayerToBench(posKey);
            } else if (ctrl.benchPlayers.isNotEmpty) {
              // Simple pick first bench player for demo purposes
              final benchPlayer = ctrl.benchPlayers.first;
              ref
                  .read(lineupBuilderControllerProvider)
                  .assignPlayerToPosition(benchPlayer, posKey);
            }
          },
          child: Card(
            color: player == null ? Colors.grey[200] : Colors.green[200],
            child: Center(
              child: Text(player?.name ?? posKey),
            ),
          ),
        );
      }).toList(),
    );
  }
}
