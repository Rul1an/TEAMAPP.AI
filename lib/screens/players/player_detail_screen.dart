import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/player.dart';
import '../../providers/database_provider.dart';

class PlayerDetailScreen extends ConsumerWidget {

  const PlayerDetailScreen({
    super.key,
    required this.playerId,
  });
  final String playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(playersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speler Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.go('/players/$playerId/edit');
            },
          ),
        ],
      ),
      body: playersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Fout: $error')),
        data: (players) {
          final player = players.firstWhere(
            (p) => p.id == playerId,
            orElse: () {
              final newPlayer = Player()
                ..id = 'unknown'
                ..firstName = 'Onbekend'
                ..lastName = '';
              return newPlayer;
            },
          );

          if (player.id == 'unknown') {
            return const Center(child: Text('Speler niet gevonden'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text('Rugnummer: ${player.jerseyNumber}'),
                        Text('Leeftijd: ${player.age} jaar'),
                        Text('Positie: ${_getPositionName(player.position)}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Statistieken',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text('Wedstrijden gespeeld: ${player.matchesPlayed}'),
                        Text('Doelpunten: ${player.goals}'),
                        Text('Assists: ${player.assists}'),
                        Text('Trainingen bijgewoond: ${player.trainingsAttended}/${player.trainingsTotal}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getPositionName(Position position) {
    switch (position) {
      case Position.goalkeeper:
        return 'Keeper';
      case Position.defender:
        return 'Verdediger';
      case Position.midfielder:
        return 'Middenvelder';
      case Position.forward:
        return 'Aanvaller';
    }
  }
}
