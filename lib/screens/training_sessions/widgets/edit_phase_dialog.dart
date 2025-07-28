import 'package:flutter/material.dart';

import '../../../models/training_session/session_phase.dart';

class EditPhaseDialog extends StatefulWidget {
  const EditPhaseDialog({
    super.key,
    required this.phase,
  });

  final SessionPhase phase;

  @override
  State<EditPhaseDialog> createState() => _EditPhaseDialogState();
}

class _EditPhaseDialogState extends State<EditPhaseDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController durationController;
  late PhaseType selectedType;

  @override
  void initState() {
    super.initState();
    final p = widget.phase;
    nameController = TextEditingController(text: p.name);
    descriptionController = TextEditingController(text: p.description);
    durationController =
        TextEditingController(text: p.durationMinutes.toString());
    selectedType = p.type;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    super.dispose();
  }

  IconData _phaseIcon(PhaseType type) {
    switch (type) {
      case PhaseType.preparation:
        return Icons.play_circle;
      case PhaseType.warmup:
        return Icons.directions_run;
      case PhaseType.technical:
        return Icons.sports_soccer;
      case PhaseType.tactical:
        return Icons.psychology;
      case PhaseType.physical:
        return Icons.fitness_center;
      case PhaseType.main:
        return Icons.star;
      case PhaseType.game:
        return Icons.sports;
      case PhaseType.discussion:
        return Icons.forum;
      case PhaseType.evaluation:
        return Icons.rate_review;
      case PhaseType.cooldown:
        return Icons.self_improvement;
    }
  }

  String _phaseTypeName(PhaseType t) {
    switch (t) {
      case PhaseType.warmup:
        return 'Warming-up';
      case PhaseType.technical:
        return 'Technisch';
      case PhaseType.tactical:
        return 'Tactisch';
      case PhaseType.physical:
        return 'Fysiek';
      case PhaseType.game:
        return 'Partij';
      case PhaseType.cooldown:
        return 'Cooldown';
      case PhaseType.preparation:
        return 'Voorbereiden';
      case PhaseType.main:
        return 'Hoofdtraining';
      case PhaseType.discussion:
        return 'Bespreking';
      case PhaseType.evaluation:
        return 'Evaluatie';
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Bewerk Fase'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Naam',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<PhaseType>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: PhaseType.values
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Row(
                          children: [
                            Icon(_phaseIcon(t), size: 18),
                            const SizedBox(width: 6),
                            Text(_phaseTypeName(t)),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => selectedType = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: 'Duur (min)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Beschrijving',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuleren'),
          ),
          ElevatedButton(
            onPressed: () {
              final dur = int.tryParse(durationController.text) ??
                  widget.phase.durationMinutes;
              final updated = widget.phase.copyWith(
                name: nameController.text,
                description: descriptionController.text,
                type: selectedType,
                endTime: widget.phase.startTime.add(Duration(minutes: dur)),
              );
              Navigator.pop(context, updated);
            },
            child: const Text('Opslaan'),
          ),
        ],
      );
}
