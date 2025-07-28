import 'package:flutter/material.dart';
import '../../../models/training_session/training_session.dart';

class BasicInfoStep extends StatelessWidget {
  const BasicInfoStep({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
    required this.trainingType,
    required this.onSelectTrainingType,
  });

  final DateTime selectedDate;
  final VoidCallback onSelectDate;
  final TrainingType trainingType;
  final VoidCallback onSelectTrainingType;

  String _displayTrainingType(TrainingType t) {
    switch (t) {
      case TrainingType.regularTraining:
        return 'Reguliere Training';
      case TrainingType.matchPreparation:
        return 'Match Voorbereiding';
      default:
        return t.name;
    }
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Basis Informatie',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.calendar_today,
                          color: Theme.of(context).primaryColor),
                      title: const Text('Training Datum'),
                      subtitle: Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: onSelectDate,
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.sports_soccer,
                          color: Theme.of(context).primaryColor),
                      title: const Text('Training Type'),
                      subtitle: Text(_displayTrainingType(trainingType)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: onSelectTrainingType,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
