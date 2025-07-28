import 'package:flutter/material.dart';

class ObjectivesStep extends StatelessWidget {
  const ObjectivesStep({
    super.key,
    required this.objectiveController,
    required this.teamFunctionController,
    required this.coachingAccentController,
  });

  final TextEditingController objectiveController;
  final TextEditingController teamFunctionController;
  final TextEditingController coachingAccentController;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doelstellingen & Focus',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: objectiveController,
                      decoration:
                          const InputDecoration(labelText: 'Trainingsdoel'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: teamFunctionController,
                      decoration:
                          const InputDecoration(labelText: 'Teamfunctie'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: coachingAccentController,
                      decoration:
                          const InputDecoration(labelText: 'Coachingaccent'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
