// ignore_for_file: unused_element
// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../models/annual_planning/morphocycle.dart';
import '../../models/annual_planning/periodization_plan.dart';
import '../../models/annual_planning/week_schedule.dart';
import '../../providers/annual_planning_provider.dart';
import 'periodization_template_dialog.dart';
import 'training_dialog.dart';
import 'weekly_planning/widgets/season_header.dart';
import 'weekly_planning/widgets/week_selector.dart';
import 'weekly_planning/widgets/weekly_table.dart';

class WeeklyPlanningScreen extends ConsumerStatefulWidget {
  const WeeklyPlanningScreen({super.key});

  @override
  ConsumerState<WeeklyPlanningScreen> createState() =>
      _WeeklyPlanningScreenState();
}

class _WeeklyPlanningScreenState extends ConsumerState<WeeklyPlanningScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planningState = ref.watch(annualPlanningProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🗓️ Jaarplanning'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: _scrollToCurrentWeek,
            tooltip: 'Ga naar huidige week',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEventDialog(context),
            tooltip: 'Voeg evenement toe',
          ),
        ],
      ),
      body: planningState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SeasonHeader(state: planningState),
                WeekSelector(
                  state: planningState,
                  scrollController: _scrollController,
                ),
                Expanded(child: WeeklyTable(state: planningState)),
              ],
            ),
    );
  }

  Widget _buildWeekSelector(AnnualPlanningState state) => Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: state.totalWeeks,
        itemBuilder: (context, index) {
          final weekNumber = index + 1;
          final isSelected = weekNumber == state.selectedWeek;
          final isCurrent = weekNumber == state.currentWeekNumber;
          final weekSchedule = state.weekSchedules
              .where((w) => w.weekNumber == weekNumber)
              .firstOrNull;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: InkWell(
                onTap: () => ref
                    .read(annualPlanningProvider.notifier)
                    .selectWeek(weekNumber),
              child: Container(
                width: 60,
                decoration: BoxDecoration(
                  color: _getWeekColor(weekSchedule, isSelected, isCurrent),
                  borderRadius: BorderRadius.circular(8),
                  border: isCurrent
                      ? Border.all(color: Colors.green, width: 2)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'W$weekNumber',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                      if (weekSchedule?.isVacation ?? false)
                      const Icon(
                        Icons.beach_access,
                        size: 12,
                        color: Colors.orange,
                      )
                      else if (weekSchedule?.hasActivities ?? false)
                      const Icon(
                        Icons.sports_soccer,
                        size: 12,
                        color: Colors.green,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

  Widget _buildWeeklyTable(AnnualPlanningState state) {
    final startWeek = ((state.selectedWeek - 1) ~/ 8) * 8 + 1;
    final endWeek = (startWeek + 7).clamp(1, state.totalWeeks);
    final weeksToShow = state.weekSchedules
        .where((w) => w.weekNumber >= startWeek && w.weekNumber <= endWeek)
        .toList();

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [_buildTableHeader(), ...weeksToShow.map(_buildWeekRow)],
        ),
      ),
    );
  }

  Widget _buildTableHeader() => DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.green[100],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: const Row(
        children: [
          _TableCell('Week', width: 60, isHeader: true),
          _TableCell('Load', width: 50, isHeader: true),
          _TableCell('Training', width: 180, isHeader: true),
          _TableCell('Wedstrijd', width: 150, isHeader: true),
          _TableCell('Datum', width: 100, isHeader: true),
          _TableCell('Locatie', width: 120, isHeader: true),
          _TableCell('Tijd', width: 80, isHeader: true),
          _TableCell('Notities', isHeader: true),
        ],
      ),
    );

  Widget _buildWeekRow(WeekSchedule week) {
    final isVacation = week.isVacation;
    final backgroundColor = isVacation
        ? Colors.orange[50]
        : week.weekNumber == ref.watch(annualPlanningProvider).currentWeekNumber
            ? Colors.green[50]
            : Colors.white;

    if (isVacation) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          children: [
            _TableCell('${week.weekNumber}', width: 60),
            const _TableCell('', width: 50), // Load column
            _TableCell(week.vacationDescription ?? 'Vakantie', width: 180),
            const _TableCell('', width: 150),
            _TableCell(_formatWeekDate(week.weekStartDate), width: 100),
            const _TableCell('', width: 120),
            const _TableCell('', width: 80),
            _TableCell(
              week.notes ?? 'VAKANTIE',
              style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    // Training + Match row
    final hasTraining = week.trainingSessions.isNotEmpty;
    final hasMatch = week.matches.isNotEmpty;

    if (hasTraining && hasMatch) {
      return Column(
        children: [
          // Training row
          _buildActivityRow(
            week: week,
            backgroundColor: backgroundColor,
            training: week.trainingSessions.first,
            isFirstRow: true,
          ),
          // Match row
          _buildActivityRow(
            week: week,
            backgroundColor: backgroundColor,
            match: week.matches.first,
            showWeekNumber: false,
          ),
        ],
      );
    } else if (hasTraining) {
      return _buildActivityRow(
        week: week,
        backgroundColor: backgroundColor,
        training: week.trainingSessions.first,
        isFirstRow: true,
      );
    } else if (hasMatch) {
      return _buildActivityRow(
        week: week,
        backgroundColor: backgroundColor,
        match: week.matches.first,
        isFirstRow: true,
      );
    } else {
      // Empty week
      return DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          children: [
            _TableCell('${week.weekNumber}', width: 60),
            const _TableCell('', width: 50), // Load column
            const _TableCell('', width: 180),
            const _TableCell('', width: 150),
            _TableCell(_formatWeekDate(week.weekStartDate), width: 100),
            const _TableCell('', width: 120),
            const _TableCell('', width: 80),
            _TableCell(week.notes ?? ''),
          ],
        ),
      );
    }
  }

  Widget _buildActivityRow({
    required WeekSchedule week,
    Color? backgroundColor,
    WeeklyTraining? training,
    WeeklyMatch? match,
    bool showWeekNumber = true,
    bool isFirstRow = false,
  }) {
    final state = ref.watch(annualPlanningProvider);
    final morphocycle = state.getMorphocycleForWeek(week.weekNumber);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          _TableCell(
            showWeekNumber ? '${week.weekNumber}' : '',
            width: 60,
            style: showWeekNumber
                ? const TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
          _MorphocycleLoadCell(
            morphocycle: morphocycle,
            training: training,
            showLoad: isFirstRow,
            width: 50,
          ),
          _TableCell(
            training?.name ?? '',
            width: 180,
            style: training != null ? _getTrainingStyle(training) : null,
          ),
          _TableCell(
            match?.opponent ?? '',
            width: 150,
            style: match != null
                ? const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  )
                : null,
          ),
          _TableCell(
            training != null
                ? '${training.dayName} ${_formatDate(training.dateTime)}'
                : match != null
                    ? '${match.dayName} ${_formatDate(match.dateTime)}'
                    : '',
            width: 100,
          ),
          _TableCell(
            training?.location ?? match?.locationDisplay ?? '',
            width: 120,
          ),
          _TableCell(
            training?.timeString ?? match?.timeString ?? '',
            width: 80,
          ),
          _TableCell(
            isFirstRow ? _getWeekNotesWithMorphocycle(week, morphocycle) : '',
          ),
        ],
      ),
    );
  }

  TextStyle _getTrainingStyle(WeeklyTraining training) {
    if (training.intensity != null) {
      switch (training.intensity!) {
        case TrainingIntensity.recovery:
          return const TextStyle(color: Colors.green);
        case TrainingIntensity.activation:
          return const TextStyle(color: Colors.blue);
        case TrainingIntensity.development:
          return const TextStyle(color: Colors.orange);
        case TrainingIntensity.acquisition:
          return const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
          );
        case TrainingIntensity.competition:
          return const TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          );
      }
    }
    return const TextStyle(color: Colors.blue);
  }

  String _getWeekNotesWithMorphocycle(
    WeekSchedule week,
    Morphocycle? morphocycle,
  ) {
    if (morphocycle != null) {
      final loadDescription = _getLoadDescription(morphocycle.weeklyLoad);
      final adaptationPercent = morphocycle.expectedAdaptation.toInt();
      return '$loadDescription | Adaptatie: $adaptationPercent% | Focus: ${morphocycle.primaryGameModelFocus}';
    }
    return week.notes ?? '';
  }

  String _getLoadDescription(double weeklyLoad) {
    if (weeklyLoad < 1000) return 'Lichte Week';
    if (weeklyLoad < 1500) return 'Matige Week';
    if (weeklyLoad < 2000) return 'Intensieve Week';
    return 'Zeer Intensief';
  }

  Color _getWeekColor(WeekSchedule? week, bool isSelected, bool isCurrent) {
    if (isSelected) return Colors.green[600]!;
    if (week?.isVacation ?? false) return Colors.orange[200]!;
    if (isCurrent) return Colors.green[100]!;
    if (week?.hasActivities ?? false) return Colors.blue[50]!;
    return Colors.grey[100]!;
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}';

  String _formatWeekDate(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    return '${weekStart.day}/${weekStart.month}-${weekEnd.day}/${weekEnd.month}';
  }

  void _scrollToCurrentWeek() {
    final currentWeek = ref.read(annualPlanningProvider).currentWeekNumber;
    ref.read(annualPlanningProvider.notifier).selectWeek(currentWeek);

    // Scroll to current week in the horizontal selector
    final targetPosition = (currentWeek - 1) * 64.0;
    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _showAddEventDialog(BuildContext context) {
    final currentWeek = ref.read(annualPlanningProvider).selectedWeekSchedule;
    if (currentWeek == null) return;

    showDialog<void>(
      context: context,
      builder: (context) => _WeekCustomizationDialog(
        weekSchedule: currentWeek,
        onSave: _updateWeekSchedule,
      ),
    );
  }

  void _updateWeekSchedule(WeekSchedule updatedWeek) {
    // Update the entire week schedule
    ref.read(annualPlanningProvider.notifier).updateWeekSchedule(updatedWeek);
  }

  Future<void> _showPeriodizationTemplateDialog(BuildContext context) async {
    final currentState = ref.read(annualPlanningProvider);
    final selectedTemplate = await showDialog<PeriodizationPlan?>(
      context: context,
      builder: (context) => PeriodizationTemplateDialog(
        currentTemplate: currentState.selectedPeriodizationPlan,
      ),
    );

    if (selectedTemplate != null) {
      ref
          .read(annualPlanningProvider.notifier)
          .applyPeriodizationTemplate(selectedTemplate);

      // Show success message
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Template "${selectedTemplate.name}" succesvol toegepast!',
            ),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell(this.text, {this.width, this.isHeader = false, this.style});
  final String text;
  final double? width;
  final bool isHeader;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Container(
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Text(
        text,
          style: style ??
              TextStyle(
          fontSize: isHeader ? 12 : 11,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.green[800] : Colors.black87,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: isHeader ? 1 : 2,
      ),
    );
}

class _MorphocycleLoadCell extends StatelessWidget {
  const _MorphocycleLoadCell({
    required this.showLoad,
    required this.width,
    this.morphocycle,
    this.training,
  });
  final Morphocycle? morphocycle;
  final WeeklyTraining? training;
  final bool showLoad;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (!showLoad || morphocycle == null) {
      return _TableCell('', width: width);
    }

    // Get load color based on intensity
    Color loadColor;
    if (morphocycle!.weeklyLoad < 1000) {
      loadColor = Colors.green;
    } else if (morphocycle!.weeklyLoad < 1500) {
      loadColor = Colors.orange;
    } else if (morphocycle!.weeklyLoad < 2000) {
      loadColor = Colors.red;
    } else {
      loadColor = Colors.purple;
    }

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        children: [
          // Load indicator
          Container(
            width: 32,
            height: 16,
            decoration: BoxDecoration(
              color: loadColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${(morphocycle!.weeklyLoad / 100).round()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          // ACWR indicator
          if (morphocycle!.acuteChronicRatio > 1.3)
            const Icon(Icons.warning, color: Colors.red, size: 12)
          else if (morphocycle!.acuteChronicRatio < 0.8)
            const Icon(Icons.trending_down, color: Colors.orange, size: 12)
          else
            const Icon(Icons.check_circle, color: Colors.green, size: 12),
        ],
      ),
    );
  }
}

class _WeekCustomizationDialog extends StatefulWidget {
  const _WeekCustomizationDialog({
    required this.weekSchedule,
    required this.onSave,
  });
  final WeekSchedule weekSchedule;
  final void Function(WeekSchedule) onSave;

  @override
  State<_WeekCustomizationDialog> createState() =>
      _WeekCustomizationDialogState();
}

class _WeekCustomizationDialogState extends State<_WeekCustomizationDialog> {
  late List<WeeklyTraining> _trainingSessions;
  late List<WeeklyMatch> _matches;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _trainingSessions = List.from(widget.weekSchedule.trainingSessions);
    _matches = List.from(widget.weekSchedule.matches);
    _notesController.text = widget.weekSchedule.notes ?? '';
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
      title: Text(
        'Week ${widget.weekSchedule.weekNumber} Bewerken',
        style: TextStyle(color: Colors.green[800]),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Week info
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.green[600]),
                      const SizedBox(width: 8),
                      Text(
                        '${_formatWeekDate(widget.weekSchedule.weekStartDate)} • ${widget.weekSchedule.monthName}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Training Sessions
              Row(
                children: [
                  Icon(Icons.sports_soccer, color: Colors.blue[600]),
                  const SizedBox(width: 8),
                  const Text(
                    'Trainingen',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: _addTraining,
                    tooltip: 'Training toevoegen',
                  ),
                ],
              ),
              if (_trainingSessions.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Geen trainingen gepland',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ..._trainingSessions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final training = entry.value;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                        leading: const Icon(
                          Icons.fitness_center,
                          color: Colors.blue,
                        ),
                      title: Text(training.name),
                      subtitle: Text(
                        '${training.dayName} ${training.timeString} • ${training.location}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => _editTraining(index),
                          ),
                          IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                            onPressed: () => _removeTraining(index),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 16),

              // Matches
              Row(
                children: [
                  Icon(Icons.sports, color: Colors.green[600]),
                  const SizedBox(width: 8),
                  const Text(
                    'Wedstrijden',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: _addMatch,
                    tooltip: 'Wedstrijd toevoegen',
                  ),
                ],
              ),
              if (_matches.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Geen wedstrijden gepland',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ..._matches.asMap().entries.map((entry) {
                  final index = entry.key;
                  final match = entry.value;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        match.isHomeMatch ? Icons.home : Icons.directions_run,
                        color: Colors.green,
                      ),
                      title: Text(match.opponent),
                      subtitle: Text(
                        '${match.dayName} ${match.timeString} • ${match.locationDisplay} • ${match.type.displayName}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => _editMatch(index),
                          ),
                          IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                            onPressed: () => _removeMatch(index),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 16),

              // Notes
              Row(
                children: [
                  Icon(Icons.note, color: Colors.orange[600]),
                  const SizedBox(width: 8),
                  const Text(
                    'Notities',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Week notities (optioneel)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuleren'),
        ),
        ElevatedButton(
          onPressed: _saveWeek,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            foregroundColor: Colors.white,
          ),
          child: const Text('Opslaan'),
        ),
      ],
    );

  void _addTraining() {
    showDialog<void>(
      context: context,
      builder: (context) => TrainingDialog(
        weekStartDate: widget.weekSchedule.weekStartDate,
        onSave: (training) {
          setState(() {
            _trainingSessions.add(training);
          });
        },
      ),
    );
  }

  void _editTraining(int index) {
    showDialog<void>(
      context: context,
      builder: (context) => TrainingDialog(
        existingTraining: _trainingSessions[index],
        weekStartDate: widget.weekSchedule.weekStartDate,
        onSave: (training) {
          setState(() {
            _trainingSessions[index] = training;
          });
        },
      ),
    );
  }

  void _removeTraining(int index) {
    setState(() {
      _trainingSessions.removeAt(index);
    });
  }

  void _addMatch() {
    final match = WeeklyMatch(
      opponent: 'Nieuwe Tegenstander',
      dateTime: widget.weekSchedule.weekStartDate.add(const Duration(days: 5)),
      location: 'Thuis',
    );

    setState(() {
      _matches.add(match);
    });
  }

  void _editMatch(int index) {
    // For now, just show a simple dialog
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wedstrijd Bewerken'),
        content: const Text('Wedstrijd bewerking komt binnenkort beschikbaar'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Sluiten'),
          ),
        ],
      ),
    );
  }

  void _removeMatch(int index) {
    setState(() {
      _matches.removeAt(index);
    });
  }

  void _saveWeek() {
    final updatedWeek = WeekSchedule(
      weekNumber: widget.weekSchedule.weekNumber,
      weekStartDate: widget.weekSchedule.weekStartDate,
      trainingSessions: _trainingSessions,
      matches: _matches,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      isVacation: widget.weekSchedule.isVacation,
      vacationDescription: widget.weekSchedule.vacationDescription,
    );

    widget.onSave(updatedWeek);
    Navigator.of(context).pop();
  }

  String _formatWeekDate(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    return '${weekStart.day}/${weekStart.month}-${weekEnd.day}/${weekEnd.month}';
  }
}
