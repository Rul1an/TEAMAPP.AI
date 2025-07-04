import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/player.dart';

class PlayerSelectorList extends ConsumerWidget {
  const PlayerSelectorList({required this.players, super.key});

  final List<Player> players;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: players.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final player = players[index];
        return ListTile(
          title: Text(player.name),
          onTap: () {
            // TODO(roelschuurkes): implement selection handling in controller
          },
        );
      },
    );
  }
}
