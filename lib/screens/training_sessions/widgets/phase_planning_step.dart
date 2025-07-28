import 'package:flutter/material.dart';
import '../../../models/training_session/session_phase.dart';

class PhasePlanningStep extends StatelessWidget {
  const PhasePlanningStep({
    super.key,
    required this.phases,
    required this.onReorder,
    required this.onAddPhase,
    required this.onEditPhase,
    required this.onDeletePhase,
    required this.totalDuration,
  });

  final List<SessionPhase> phases;
  final void Function(int oldIndex, int newIndex) onReorder;
  final VoidCallback onAddPhase;
  final void Function(int index) onEditPhase;
  final void Function(int index) onDeletePhase;
  final int totalDuration;

  String _formatPhaseTime(SessionPhase phase) {
    final start = phase.startTime;
    final end = phase.endTime;
    String _pad(int v) => v.toString().padLeft(2, '0');
    return '${_pad(start.hour)}:${_pad(start.minute)} - ${_pad(end.hour)}:${_pad(end.minute)}';
  }

  Color _phaseColor(PhaseType t) {
    switch (t) {
      case PhaseType.main:
        return Colors.red.shade100;
      case PhaseType.warmup:
        return Colors.green.shade100;
      case PhaseType.technical:
        return Colors.orange.shade100;
      case PhaseType.tactical:
        return Colors.purple.shade100;
      case PhaseType.physical:
        return Colors.pink.shade100;
      case PhaseType.game:
        return Colors.teal.shade100;
      case PhaseType.cooldown:
        return Colors.grey.shade100;
      case PhaseType.discussion:
        return Colors.indigo.shade100;
      case PhaseType.evaluation:
        return Colors.yellow.shade100;
      default:
        return Colors.blue.shade100;
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fase Planning',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: phases.length,
                onReorder: onReorder,
                itemBuilder: (context, index) {
                  final phase = phases[index];
                  return Card(
                    key: ValueKey('phase_$index'),
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _phaseColor(phase.type),
                        child: Text('${index + 1}'),
                      ),
                      title: Text(phase.name,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        '${phase.durationMinutes} min | ${_formatPhaseTime(phase)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Bewerk',
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => onEditPhase(index),
                          ),
                          IconButton(
                            tooltip: 'Verwijder',
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => onDeletePhase(index),
                          ),
                          const Icon(Icons.drag_handle, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAddPhase,
                icon: const Icon(Icons.add),
                label: const Text('Voeg Extra Fase Toe'),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: ListTile(
                leading: Icon(Icons.timer,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('Totale Tijd: $totalDuration minuten'),
              ),
            ),
          ],
        ),
      );
}
