import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lineup_builder_controller.dart';

class BenchPlayerList extends ConsumerWidget {
  const BenchPlayerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.watch(lineupBuilderControllerProvider);
    if (ctrl.benchPlayers.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListView.separated(
      shrinkWrap: true,
      itemCount: ctrl.benchPlayers.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final player = ctrl.benchPlayers[index];
        return ListTile(
          title: Text(player.name),
          onTap: () {
            // select position later; for demo remove from bench
            ref.read(lineupBuilderControllerProvider).removeBenchPlayer(player);
          },
        );
      },
    );
  }
}
