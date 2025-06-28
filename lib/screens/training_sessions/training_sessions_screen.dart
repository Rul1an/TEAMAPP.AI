import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/training_session/training_session.dart';
import '../../services/database_service.dart';

final trainingSessionsProvider = FutureProvider<List<TrainingSession>>((ref) async {
  final db = DatabaseService();
  return db.getAllTrainingSessions();
});

class TrainingSessionsScreen extends ConsumerWidget {
  const TrainingSessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingSessionsAsync = ref.watch(trainingSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainingen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/session-builder'),
        icon: const Icon(Icons.add),
        label: const Text('Nieuwe Sessie'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Actions Section
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.sports_soccer, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Training Tools',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Primary Actions Row - Core Functions
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/session-builder'),
                            icon: const Icon(Icons.add_circle),
                            label: const Text('Nieuwe Training'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/exercise-library'),
                            icon: const Icon(Icons.library_books),
                            label: const Text('Oefeningen Bibliotheek'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.orange[600],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Secondary Actions Row - Quick Tools
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.push('/exercise-designer'),
                            icon: const Icon(Icons.sports_soccer),
                            label: const Text('Nieuwe Oefening'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.orange[600]!),
                              foregroundColor: Colors.orange[700],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.push('/field-diagram-editor'),
                            icon: const Icon(Icons.edit),
                            label: const Text('Veld Tekenen'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.green[600]!),
                              foregroundColor: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Smart Coaching Actions
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[600]!, Colors.blue[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Coaching Tip',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getSmartCoachingTip(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            // Training Sessions List
            trainingSessionsAsync.when(
              data: (sessions) => sessions.isEmpty
                ? Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(Icons.schedule, color: Theme.of(context).primaryColor, size: 48),
                          const SizedBox(height: 16),
                          const Text(
                            'Start met je eerste training!',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Maak professionele trainingsplannen met de VOAB methodiek.\n'
                            'Plan fasen, selecteer oefeningen en exporteer naar PDF.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => context.push('/session-builder'),
                            icon: const Icon(Icons.add),
                            label: const Text('Maak Training Plan'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: sessions.map((session) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.sports_soccer, color: Theme.of(context).primaryColor),
                        ),
                        title: Text('Training ${session.trainingNumber}'),
                        subtitle: Text(
                          '${session.date.day}/${session.date.month} | ${_getTrainingTypeDisplayName(session.type)}\n'
                          'Duur: ${_getTotalDuration(session)} min | Status: ${_getStatusDisplayName(session.status)}\n'
                          '${session.sessionObjective ?? "Geen doel ingesteld"}',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Chip(
                              label: Text(
                                session.teamFunction ?? 'Algemeen',
                                style: const TextStyle(fontSize: 11),
                              ),
                              backgroundColor: Colors.blue.shade100,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${session.phases.length} fasen',
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        onTap: () => context.push('/session-builder?sessionId=${session.id}'),
                      ),
                    ),).toList(),
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTrainingTypeDisplayName(TrainingType type) {
    switch (type) {
      case TrainingType.regularTraining:
        return 'Reguliere Training';
      case TrainingType.matchPreparation:
        return 'Wedstrijd Voorbereiding';
      case TrainingType.tacticalSession:
        return 'Tactische Sessie';
      case TrainingType.technicalSession:
        return 'Technische Sessie';
      case TrainingType.fitnessSession:
        return 'Fitness Sessie';
      case TrainingType.recoverySession:
        return 'Herstel Sessie';
      case TrainingType.teamBuilding:
        return 'Teambuilding';
    }
  }

  String _getStatusDisplayName(SessionStatus status) {
    switch (status) {
      case SessionStatus.planned:
        return 'Gepland';
      case SessionStatus.inProgress:
        return 'Bezig';
      case SessionStatus.completed:
        return 'Voltooid';
      case SessionStatus.cancelled:
        return 'Geannuleerd';
      case SessionStatus.postponed:
        return 'Uitgesteld';
    }
  }

  int _getTotalDuration(TrainingSession session) => session.phases.fold(0, (sum, phase) => sum + phase.durationMinutes);

  String _getSmartCoachingTip() {
    final now = DateTime.now();
    final hour = now.hour;
    final weekday = now.weekday;

    // Time-based suggestions
    if (hour >= 17 && hour <= 20) {
      // Training time (17:00-20:00)
      if (weekday == 2 || weekday == 4) { // Tuesday or Thursday
        return '🏃‍♂️ Training tijd! Gebruik de Session Builder voor gestructureerde VOAB-plannen. Start met warming-up, focus op techniek/tactiek, eindig met cooling-down.';
      }
    }

    // Match preparation (Friday/Saturday)
    if (weekday == 5) {
      return '⚽ Wedstrijdvoorbereiding! Maak een tactical session met positiespel oefeningen. Gebruik de Exercise Library voor finishing en set pieces.';
    }

    if (weekday == 6) {
      return '🥅 Wedstrijddag! Korte activatie training (30-45 min). Focus op passing, shooting en team shape. Gebruik low-intensity oefeningen.';
    }

    // Recovery day (Sunday/Monday)
    if (weekday == 7 || weekday == 1) {
      return '💆‍♂️ Hersteldag! Perfecte tijd om trainingsplannen voor te bereiden. Verken de Exercise Library en maak templates voor volgende week.';
    }

    // Wednesday - Technical focus
    if (weekday == 3) {
      return '🎯 Midden van de week! Ideaal voor technische ontwikkeling. Gebruik de Field Diagram Editor om passing patterns en 1v1 situaties te visualiseren.';
    }

    // Default suggestion
    return "📚 Bouw je exercise library op! Gebruik de Exercise Designer om aangepaste oefeningen te maken die passen bij jouw team's ontwikkeling.";
  }
}
