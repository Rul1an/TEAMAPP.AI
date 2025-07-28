import 'package:flutter/material.dart';

import '../../../models/training_session/session_phase.dart';

class AddPhaseDialog extends StatefulWidget {
  const AddPhaseDialog({super.key, required this.baseStart});

  final DateTime baseStart;

  @override
  State<AddPhaseDialog> createState() => _AddPhaseDialogState();
}

class _AddPhaseDialogState extends State<AddPhaseDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController(text: '15');
  PhaseType selectedType = PhaseType.technical;

  IconData _icon(PhaseType t) => {
        PhaseType.warmup: Icons.directions_run,
        PhaseType.technical: Icons.sports_soccer,
        PhaseType.tactical: Icons.psychology,
        PhaseType.physical: Icons.fitness_center,
        PhaseType.game: Icons.sports,
        PhaseType.cooldown: Icons.self_improvement,
        PhaseType.preparation: Icons.play_circle,
        PhaseType.main: Icons.star,
        PhaseType.discussion: Icons.forum,
        PhaseType.evaluation: Icons.rate_review,
      }[t]!;

  String _typeName(PhaseType t) => {
        PhaseType.warmup: 'Warming-up',
        PhaseType.technical: 'Technisch',
        PhaseType.tactical: 'Tactisch',
        PhaseType.physical: 'Fysiek',
        PhaseType.game: 'Partij',
        PhaseType.cooldown: 'Cooldown',
        PhaseType.preparation: 'Voorbereiden',
        PhaseType.main: 'Hoofdtraining',
        PhaseType.discussion: 'Bespreking',
        PhaseType.evaluation: 'Evaluatie',
      }[t]!;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Nieuwe Fase Toevoegen'),
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
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Row(children: [
                            Icon(_icon(t), size: 18),
                            const SizedBox(width: 6),
                            Text(_typeName(t)),
                          ]),
                        ))
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
              final dur = int.tryParse(durationController.text) ?? 15;
              final phase = SessionPhase()
                ..name = nameController.text.isEmpty
                    ? _typeName(selectedType)
                    : nameController.text
                ..type = selectedType
                ..orderIndex = 99
                ..startTime = widget.baseStart
                ..endTime = widget.baseStart.add(Duration(minutes: dur))
                ..description = descriptionController.text;
              Navigator.pop(context, phase);
            },
            child: const Text('Toevoegen'),
          ),
        ],
      );
}
