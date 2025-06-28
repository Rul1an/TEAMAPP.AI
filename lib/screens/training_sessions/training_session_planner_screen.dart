import 'package:flutter/material.dart';
import 'enhanced_exercise_library_screen.dart';

class TrainingSessionPlannerScreen extends StatefulWidget {
  const TrainingSessionPlannerScreen({super.key});

  @override
  State<TrainingSessionPlannerScreen> createState() =>
      _TrainingSessionPlannerScreenState();
}

class _TrainingSessionPlannerScreenState
    extends State<TrainingSessionPlannerScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Training Session Planner'),
          actions: [
            IconButton(
              icon: const Icon(Icons.library_books),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnhancedExerciseLibraryScreen(
                    weekNumber: _getCurrentWeekNumber(),
                  ),
                ),
              ),
              tooltip: 'Exercise Library',
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveSession,
              tooltip: 'Save Session',
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sports_soccer, size: 64, color: Colors.blue[700]),
                const SizedBox(height: 24),
                Text(
                  'Training Sessie Planner',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Voor nu kunt u de Training Session Builder gebruiken',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed('/session-builder'),
                  icon: const Icon(Icons.build),
                  label: const Text('Open Session Builder'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  // Helper method to get current week number
  int _getCurrentWeekNumber() {
    // Get current week from annual planning or default to 1
    final now = DateTime.now();
    final seasonStart =
        DateTime(now.year, 8); // Assume season starts August 1st
    final weeksSinceStart = now.difference(seasonStart).inDays ~/ 7;
    return (weeksSinceStart + 1).clamp(1, 52);
  }

  void _saveSession() {
    // TODO(author): Implement save session functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Save session functionality coming soon')),
    );
  }
}
