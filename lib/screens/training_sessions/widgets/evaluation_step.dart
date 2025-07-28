import 'package:flutter/material.dart';
import '../../../models/training_session/training_session.dart';

class EvaluationStep extends StatelessWidget {
  const EvaluationStep({
    super.key,
    required this.selectedDate,
    required this.trainingType,
    required this.objective,
    required this.totalDuration,
    required this.phaseCount,
    required this.notesController,
    required this.onExportPdf,
    required this.onSave,
  });

  final DateTime selectedDate;
  final TrainingType trainingType;
  final String objective;
  final int totalDuration;
  final int phaseCount;
  final TextEditingController notesController;
  final VoidCallback onExportPdf;
  final VoidCallback onSave;

  String _displayTrainingType(TrainingType t) {
    switch (t) {
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
      default:
        return t.name;
    }
  }

  Widget _summaryRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text('$label:',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Review & Opslaan',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sessie Overzicht',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _summaryRow('Datum',
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                    _summaryRow('Type', _displayTrainingType(trainingType)),
                    _summaryRow('Duur', '$totalDuration minuten'),
                    _summaryRow('Fasen', '$phaseCount fasen'),
                    _summaryRow('Doelstelling',
                        objective.isEmpty ? 'Niet ingevuld' : objective),
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
                    Text('Extra Notities',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        hintText: 'Voeg extra notities toe...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onExportPdf,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('PDF Export'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.save),
                    label: const Text('Opslaan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
