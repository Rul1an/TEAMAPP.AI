// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class QuickActionsWidget extends ConsumerWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current time for context-aware suggestions
    final now = DateTime.now();
    final isTrainingDay = _isTrainingDay(now);
    final isMatchDay = _isMatchDay(now);
    final timeOfDay = _getTimeOfDay(now);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flash_on, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Snelle Acties',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (isTrainingDay || isMatchDay) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isMatchDay
                          ? Colors.red.withValues(alpha: 0.1)
                          : Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isMatchDay ? 'WEDSTRIJD' : 'TRAINING',
                      style: TextStyle(
                        color: isMatchDay ? Colors.red : Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // Context-aware actions grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: _getContextualActions(
                context,
                timeOfDay,
                isTrainingDay,
                isMatchDay,
              ),
            ),

            const SizedBox(height: 16),

            // Smart suggestions
            _buildSmartSuggestions(
              context,
              timeOfDay,
              isTrainingDay,
              isMatchDay,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getContextualActions(
    BuildContext context,
    TimeOfDay timeOfDay,
    bool isTrainingDay,
    bool isMatchDay,
  ) {
    final actions = <_QuickAction>[];

    // Priority actions based on context
    if (isMatchDay) {
      actions.addAll([
        _QuickAction(
          icon: Icons.sports_soccer,
          label: 'Opstelling',
          color: Colors.red,
          onTap: () => context.push('/lineup'),
        ),
        _QuickAction(
          icon: Icons.assessment,
          label: 'Match Analysis',
          color: Colors.orange,
          onTap: () => context.push('/matches'),
        ),
      ]);
    } else if (isTrainingDay) {
      actions.addAll([
        _QuickAction(
          icon: Icons.add_circle,
          label: 'Nieuwe Sessie',
          color: Colors.green,
          onTap: () => context.push('/session-builder'),
        ),
        _QuickAction(
          icon: Icons.library_books,
          label: 'Oefeningen',
          color: Colors.blue,
          onTap: () => context.push('/exercise-library'),
        ),
      ]);
    }

    // Common actions based on time of day
    if (timeOfDay == TimeOfDay.morning) {
      actions.addAll([
        _QuickAction(
          icon: Icons.calendar_today,
          label: 'Seizoen Plan',
          color: Colors.purple,
          onTap: () => context.push('/annual-planning'),
        ),
        _QuickAction(
          icon: Icons.people,
          label: 'Spelers',
          color: Colors.teal,
          onTap: () => context.push('/players'),
        ),
      ]);
    } else if (timeOfDay == TimeOfDay.afternoon) {
      actions.addAll([
        _QuickAction(
          icon: Icons.fitness_center,
          label: 'Training Prep',
          color: Colors.indigo,
          onTap: () => context.push('/training-sessions'),
        ),
        _QuickAction(
          icon: Icons.schedule,
          label: 'Trainingen',
          color: Colors.orange,
          onTap: () => context.push('/training'),
        ),
      ]);
    } else {
      // evening
      actions.addAll([
        _QuickAction(
          icon: Icons.analytics,
          label: 'Evaluatie',
          color: Colors.deepPurple,
          onTap: () => context.push('/matches'),
        ),
        _QuickAction(
          icon: Icons.note_add,
          label: 'Notities',
          color: Colors.brown,
          onTap: () => _showNotesDialog(context),
        ),
      ]);
    }

    // Ensure we have exactly 4 actions, fill with defaults if needed
    while (actions.length < 4) {
      actions.add(
        _QuickAction(
          icon: Icons.dashboard,
          label: 'Dashboard',
          color: Colors.grey,
          onTap: () => context.go('/dashboard'),
        ),
      );
    }

    return actions
        .take(4)
        .map((action) => _QuickActionTile(action: action))
        .toList();
  }

  Widget _buildSmartSuggestions(
    BuildContext context,
    TimeOfDay timeOfDay,
    bool isTrainingDay,
    bool isMatchDay,
  ) {
    var suggestion = '';
    var suggestionIcon = Icons.lightbulb;
    Color suggestionColor = Colors.blue;

    if (isMatchDay) {
      suggestion =
          'Vergeet niet de opstelling klaar te maken en speler statistieken te checken!';
      suggestionIcon = Icons.sports_soccer;
      suggestionColor = Colors.red;
    } else if (isTrainingDay && timeOfDay == TimeOfDay.afternoon) {
      suggestion =
          'Training vandaag! Plan je sessie en check beschikbaarheid spelers.';
      suggestionIcon = Icons.fitness_center;
      suggestionColor = Colors.green;
    } else if (timeOfDay == TimeOfDay.morning) {
      suggestion =
          'Goedemorgen! Perfect moment om het seizoensplan door te nemen.';
      suggestionIcon = Icons.wb_sunny;
      suggestionColor = Colors.orange;
    } else {
      suggestion = 'Tip: Bekijk de nieuwe Exercise Library voor inspiratie!';
      suggestionIcon = Icons.library_books;
      suggestionColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            suggestionColor.withValues(alpha: 0.1),
            suggestionColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: suggestionColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(suggestionIcon, color: suggestionColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              suggestion,
              style: TextStyle(
                color: suggestionColor.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isTrainingDay(DateTime date) =>
      // Assume Tuesday and Thursday are training days
      date.weekday == DateTime.tuesday || date.weekday == DateTime.thursday;

  bool _isMatchDay(DateTime date) =>
      // Assume Saturday is match day
      date.weekday == DateTime.saturday;
  TimeOfDay _getTimeOfDay(DateTime date) {
    final hour = date.hour;
    if (hour < 12) return TimeOfDay.morning;
    if (hour < 18) return TimeOfDay.afternoon;
    return TimeOfDay.evening;
  }

  void _showNotesDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Trainer Notities'),
        content: const TextField(
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Voeg je notities toe...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuleren'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Opslaan'),
          ),
        ],
      ),
    );
  }
}

enum TimeOfDay { morning, afternoon, evening }

class _QuickAction {
  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});
  final _QuickAction action;

  @override
  Widget build(BuildContext context) => Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  action.color.withValues(alpha: 0.1),
                  action.color.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: action.color,
                    child: Icon(action.icon, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      action.label,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: action.color,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
