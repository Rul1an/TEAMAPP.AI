import 'package:flutter/material.dart';

import '../../../models/training_session/session_phase.dart';

class ExercisePhaseDialog extends StatelessWidget {
  const ExercisePhaseDialog({
    super.key,
    required this.phase,
    required this.onRemoveExercise,
    required this.onNavigateToLibrary,
  });

  final SessionPhase phase;
  final void Function(String exerciseId) onRemoveExercise;
  final VoidCallback onNavigateToLibrary;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Oefeningen voor fase "${phase.name}"'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (phase.exerciseIds.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Nog geen oefeningen toegevoegd.'),
              )
            else
              ...phase.exerciseIds.map(
                (id) => ListTile(
                  title: Text(
                      'Oefening $id'), // TODO(roel): replace with name lookup
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      onRemoveExercise(id);
                    },
                  ),
                ),
              ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onNavigateToLibrary,
              icon: const Icon(Icons.library_books),
              label: const Text('Open Oefeningenbibliotheek'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Sluiten'),
        ),
      ],
    );
  }
}
