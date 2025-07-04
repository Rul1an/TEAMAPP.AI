// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';

class WeeklyCalendarWidget extends StatefulWidget {
  const WeeklyCalendarWidget({super.key});

  @override
  State<WeeklyCalendarWidget> createState() => _WeeklyCalendarWidgetState();
}

class _WeeklyCalendarWidgetState extends State<WeeklyCalendarWidget> {
  DateTime selectedWeek = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final weekDays = _getWeekDays(selectedWeek);
    final today = DateTime.now();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with week navigation
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Deze Week',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedWeek =
                          selectedWeek.subtract(const Duration(days: 7));
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'Vorige week',
                ),
                Text(
                  _getWeekLabel(selectedWeek),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedWeek = selectedWeek.add(const Duration(days: 7));
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'Volgende week',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Week days
            Row(
              children: weekDays.map((day) {
                final isToday = _isSameDay(day, today);
                final hasTraining = _hasTraining(day);
                final hasMatch = _hasMatch(day);

                return Expanded(
                  child: _DayTile(
                    date: day,
                    isToday: isToday,
                    hasTraining: hasTraining,
                    hasMatch: hasMatch,
                    onTap: () => _showDayDetails(day),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const _LegendItem(
                  color: Colors.green,
                  label: 'Training',
                  icon: Icons.fitness_center,
                ),
                const _LegendItem(
                  color: Colors.red,
                  label: 'Wedstrijd',
                  icon: Icons.sports_soccer,
                ),
                _LegendItem(
                  color: Theme.of(context).primaryColor,
                  label: 'Vandaag',
                  icon: Icons.today,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<DateTime> _getWeekDays(DateTime week) {
    final startOfWeek = week.subtract(Duration(days: week.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  String _getWeekLabel(DateTime week) {
    final startOfWeek = week.subtract(Duration(days: week.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    if (startOfWeek.month == endOfWeek.month) {
      return '${startOfWeek.day}-${endOfWeek.day} ${DateFormat.MMM('nl').format(startOfWeek)}';
    } else {
      return '${DateFormat.MMMd('nl').format(startOfWeek)} - ${DateFormat.MMMd('nl').format(endOfWeek)}';
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _hasTraining(DateTime date) =>
      // Mock data: Tuesday and Thursday have training
      date.weekday == DateTime.tuesday || date.weekday == DateTime.thursday;
  bool _hasMatch(DateTime date) =>
      // Mock data: Saturday has matches
      date.weekday == DateTime.saturday;
  void _showDayDetails(DateTime date) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => _DayDetailsSheet(date: date),
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({
    required this.date,
    required this.isToday,
    required this.hasTraining,
    required this.hasMatch,
    required this.onTap,
  });
  final DateTime date;
  final bool isToday;
  final bool hasTraining;
  final bool hasMatch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isToday
                ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                : null,
            color: isToday
                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                : null,
          ),
          child: Column(
            children: [
              // Day name
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  DateFormat.E('nl').format(date),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isToday
                        ? Theme.of(context).primaryColor
                        : Colors.grey[600],
                  ),
                ),
              ),

              // Day number
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday ? Theme.of(context).primaryColor : null,
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.white : null,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Event indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasTraining)
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  if (hasMatch)
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      );
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.icon,
  });
  final Color color;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
}

class _DayDetailsSheet extends StatelessWidget {
  const _DayDetailsSheet({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final hasTraining =
        date.weekday == DateTime.tuesday || date.weekday == DateTime.thursday;
    final hasMatch = date.weekday == DateTime.saturday;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat.yMMMMEEEEd('nl').format(date),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          if (hasTraining) ...[
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.fitness_center, color: Colors.white),
              ),
              title: const Text('Training'),
              subtitle: const Text('18:00 - 20:10\nVeld 1 - VOAB Sportpark'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to training details
                },
              ),
            ),
          ],
          if (hasMatch) ...[
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.sports_soccer, color: Colors.white),
              ),
              title: const Text('Wedstrijd'),
              subtitle:
                  const Text('14:00 - vs Tegenstander\nUitverkiezing om 13:30'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to match details
                },
              ),
            ),
          ],
          if (!hasTraining && !hasMatch) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.event_available, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Geen geplande activiteiten',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Sluiten'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Add event action
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Activiteit Toevoegen'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
