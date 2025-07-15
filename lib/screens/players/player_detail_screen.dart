// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../models/player.dart';
import '../../providers/players_provider.dart';
import '../../providers/pdf/pdf_generators_providers.dart';
import '../../utils/share_pdf_utils.dart';
import '../../models/assessment.dart';

class PlayerDetailScreen extends ConsumerWidget {
  const PlayerDetailScreen({required this.playerId, super.key});
  final String playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(playersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speler Details'),
        actions: [
          IconButton(
            tooltip: 'Export PDF',
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportPdf(ref, context),
          ),
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
            orElse: () => Player()
              ..id = 'unknown'
              ..firstName = 'Onbekend'
              ..lastName = '',
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
                        Text(
                          'Trainingen bijgewoond: ${player.trainingsAttended}/${player.trainingsTotal}',
                        ),
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

  Future<void> _exportPdf(WidgetRef ref, BuildContext context) async {
    final playersAsync = ref.read(playersProvider);
    playersAsync.whenData((players) async {
      final player = players.firstWhere(
        (p) => p.id == playerId,
        orElse: Player.new,
      );

      // Placeholder minimal assessment for demo
      final assessmentGenerator = ref.read(
        playerAssessmentPdfGeneratorProvider,
      );
      final assessment = PlayerAssessment()
        ..playerId = player.id
        ..assessorId = 'auto'
        ..type = AssessmentType.monthly;

      final bytes = await assessmentGenerator.generate(assessment);
      final filename = 'assessment_${player.id}.pdf';
      await SharePdfUtils.sharePdf(bytes, filename, context);
    });
  }
}
