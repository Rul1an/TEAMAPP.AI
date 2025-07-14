// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// Project imports:
import '../../models/training.dart';
import '../../providers/export_service_provider.dart';
import '../../providers/trainings_provider.dart';
import '../../services/permission_service.dart';
import '../../providers/auth_provider.dart';

class TrainingScreen extends ConsumerStatefulWidget {
  const TrainingScreen({super.key});

  @override
  ConsumerState<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends ConsumerState<TrainingScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<Training>> _selectedTrainings;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedTrainings = ValueNotifier([]);
  }

  @override
  void dispose() {
    _selectedTrainings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trainingsAsync = ref.watch(trainingsNotifierProvider);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainingen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/training/add'),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.download),
            onSelected: (value) async {
              try {
                if (value == 'excel') {
                  await ref
                      .read(exportServiceProvider)
                      .exportTrainingAttendanceToExcel();
                  if (mounted && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Export gestart'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Export mislukt: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'excel',
                child: ListTile(
                  leading: Icon(Icons.table_chart),
                  title: Text('Exporteer aanwezigheid naar Excel'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: trainingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Fout: $error')),
        data: (trainings) => Column(
          children: [
            // Calendar
            Card(
              margin: EdgeInsets.all(isDesktop ? 24 : 16),
              child: TableCalendar<Training>(
                firstDay: DateTime.utc(2020),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                locale: 'nl_NL',
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: (day) => trainings
                    .where((training) => isSameDay(training.date, day))
                    .toList(),
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: TextStyle(color: Colors.grey[600]),
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(titleCentered: true),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  // Navigate to attendance if there's a training on this day
                  final dayTrainings = trainings
                      .where(
                        (training) => isSameDay(training.date, selectedDay),
                      )
                      .toList();

                  if (dayTrainings.isNotEmpty) {
                    context.go('/training/${dayTrainings.first.id}/attendance');
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            // Selected Day Trainings
            Expanded(
              child: ValueListenableBuilder<List<Training>>(
                valueListenable: _selectedTrainings,
                builder: (context, value, _) {
                  if (value.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Geen trainingen op ${DateFormat('d MMMM', 'nl').format(_selectedDay ?? DateTime.now())}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => context.go('/training/add'),
                            icon: const Icon(Icons.add),
                            label: const Text('Plan training'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 24 : 16,
                      vertical: 8,
                    ),
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final training = value[index];
                      return _TrainingCard(
                        training: training,
                        onTap: () => context.go('/training/${training.id}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: PermissionService.isViewOnlyUser(ref.read(userRoleProvider))
          ? null
          : FloatingActionButton(
              onPressed: () => context.go('/training/add'),
              child: const Icon(Icons.add),
            ),
    );
  }
}

class _TrainingCard extends StatelessWidget {
  const _TrainingCard({required this.training, required this.onTap});
  final Training training;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final attendancePercentage =
        training.presentPlayerIds.length /
        (training.presentPlayerIds.length + training.absentPlayerIds.length) *
        100;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Time and Duration
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _getIntensityColor(
                    training.intensity,
                  ).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('HH:mm').format(training.date),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${training.duration} min',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Training Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildFocusBadge(training.focus),
                        const SizedBox(width: 8),
                        _buildIntensityBadge(training.intensity),
                        const SizedBox(width: 8),
                        _buildStatusBadge(training.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      training.location ?? 'Locatie onbekend',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (training.coachNotes != null &&
                        training.coachNotes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        training.coachNotes!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Attendance
              if (training.status == TrainingStatus.completed)
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Icon(Icons.people, color: Colors.grey[600]),
                      const SizedBox(height: 4),
                      Text(
                        '${training.presentPlayerIds.length}/${training.presentPlayerIds.length + training.absentPlayerIds.length}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${attendancePercentage.toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: attendancePercentage >= 80
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFocusBadge(TrainingFocus focus) {
    String text;
    IconData icon;

    switch (focus) {
      case TrainingFocus.technical:
        text = 'Techniek';
        icon = Icons.sports_soccer;
      case TrainingFocus.tactical:
        text = 'Tactiek';
        icon = Icons.psychology;
      case TrainingFocus.physical:
        text = 'Fysiek';
        icon = Icons.fitness_center;
      case TrainingFocus.mental:
        text = 'Mentaal';
        icon = Icons.self_improvement;
      case TrainingFocus.matchPrep:
        text = 'Wedstrijd';
        icon = Icons.stadium;
    }

    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text),
      labelStyle: const TextStyle(fontSize: 12),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildIntensityBadge(TrainingIntensity intensity) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: _getIntensityColor(intensity),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      _getIntensityText(intensity),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _buildStatusBadge(TrainingStatus status) {
    Color color;
    String text;

    switch (status) {
      case TrainingStatus.planned:
        color = Colors.blue;
        text = 'GEPLAND';
      case TrainingStatus.completed:
        color = Colors.green;
        text = 'AFGEROND';
      case TrainingStatus.cancelled:
        color = Colors.red;
        text = 'AFGELAST';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getIntensityColor(TrainingIntensity intensity) {
    switch (intensity) {
      case TrainingIntensity.low:
        return Colors.green;
      case TrainingIntensity.medium:
        return Colors.orange;
      case TrainingIntensity.high:
        return Colors.red;
      case TrainingIntensity.recovery:
        return Colors.blue;
    }
  }

  String _getIntensityText(TrainingIntensity intensity) {
    switch (intensity) {
      case TrainingIntensity.low:
        return 'LAAG';
      case TrainingIntensity.medium:
        return 'GEMIDDELD';
      case TrainingIntensity.high:
        return 'HOOG';
      case TrainingIntensity.recovery:
        return 'HERSTEL';
    }
  }
}
