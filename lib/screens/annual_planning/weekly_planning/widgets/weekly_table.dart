// ignore_for_file: always_put_required_named_parameters_first
// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../../models/annual_planning/morphocycle.dart';
import '../../../../models/annual_planning/week_schedule.dart';
import '../../../../providers/annual_planning_provider.dart';

class WeeklyTable extends ConsumerWidget {
  const WeeklyTable({
    required this.state,
    super.key,
  });

  final AnnualPlanningState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          children: [
            _buildHeader(),
            ...weeksToShow.map((w) => _WeekRow(weekSchedule: w)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => DecoratedBox(
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
}

class _WeekRow extends ConsumerWidget {
  const _WeekRow({required this.weekSchedule});

  final WeekSchedule weekSchedule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(annualPlanningProvider);
    final isVacation = weekSchedule.isVacation;
    final isCurrent = weekSchedule.weekNumber == state.currentWeekNumber;

    final backgroundColor = isVacation
        ? Colors.orange[50]
        : isCurrent
            ? Colors.green[50]
            : Colors.white;

    if (isVacation) {
      return _VacationRow(weekSchedule: weekSchedule, bg: backgroundColor);
    }

    final hasTraining = weekSchedule.trainingSessions.isNotEmpty;
    final hasMatch = weekSchedule.matches.isNotEmpty;

    if (hasTraining && hasMatch) {
      return Column(
        children: [
          _ActivityRow(
            week: weekSchedule,
            training: weekSchedule.trainingSessions.first,
            backgroundColor: backgroundColor,
            isFirstRow: true,
          ),
          _ActivityRow(
            week: weekSchedule,
            match: weekSchedule.matches.first,
            backgroundColor: backgroundColor,
          ),
        ],
      );
    }

    if (hasTraining) {
      return _ActivityRow(
        week: weekSchedule,
        training: weekSchedule.trainingSessions.first,
        backgroundColor: backgroundColor,
        isFirstRow: true,
      );
    }
    if (hasMatch) {
      return _ActivityRow(
        week: weekSchedule,
        match: weekSchedule.matches.first,
        backgroundColor: backgroundColor,
        isFirstRow: true,
      );
    }
    // empty week
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          _TableCell('${weekSchedule.weekNumber}', width: 60),
          const _TableCell('', width: 50),
          const _TableCell('', width: 180),
          const _TableCell('', width: 150),
          _TableCell(_formatWeekDate(weekSchedule.weekStartDate), width: 100),
          const _TableCell('', width: 120),
          const _TableCell('', width: 80),
          _TableCell(weekSchedule.notes ?? ''),
        ],
      ),
    );
  }
}

class _VacationRow extends StatelessWidget {
  const _VacationRow({
    required this.weekSchedule,
    required this.bg,
  });
  final WeekSchedule weekSchedule;
  final Color? bg;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          children: [
            _TableCell('${weekSchedule.weekNumber}', width: 60),
            const _TableCell('', width: 50),
            _TableCell(
              weekSchedule.vacationDescription ?? 'Vakantie',
              width: 180,
            ),
            const _TableCell('', width: 150),
            _TableCell(_formatWeekDate(weekSchedule.weekStartDate), width: 100),
            const _TableCell('', width: 120),
            const _TableCell('', width: 80),
            const _TableCell(
              'VAKANTIE',
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}

class _ActivityRow extends ConsumerWidget {
  const _ActivityRow({
    required this.week,
    this.training,
    this.match,
    this.backgroundColor,
    this.isFirstRow = false,
  });

  final WeekSchedule week;
  final WeeklyTraining? training;
  final WeeklyMatch? match;
  final Color? backgroundColor;
  final bool isFirstRow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            '${week.weekNumber}',
            width: 60,
            style: isFirstRow
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
            style: training != null ? _trainingStyle(training!) : null,
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
                ? '${training!.dayName} ${_formatDate(training!.dateTime)}'
                : match != null
                    ? '${match!.dayName} ${_formatDate(match!.dateTime)}'
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
            isFirstRow ? _notesWithMorphocycle(week, morphocycle) : '',
          ),
        ],
      ),
    );
  }

  TextStyle _trainingStyle(WeeklyTraining t) {
    if (t.intensity != null) {
      switch (t.intensity!) {
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

  String _notesWithMorphocycle(WeekSchedule w, Morphocycle? m) {
    if (m != null) {
      final loadDesc = _loadDescription(m.weeklyLoad);
      final adapt = m.expectedAdaptation.toInt();
      return '$loadDesc | Adaptatie: $adapt% | Focus: ${m.primaryGameModelFocus}';
    }
    return w.notes ?? '';
  }

  String _loadDescription(double weeklyLoad) {
    if (weeklyLoad < 1000) return 'Lichte Week';
    if (weeklyLoad < 1500) return 'Matige Week';
    if (weeklyLoad < 2000) return 'Intensieve Week';
    return 'Zeer Intensief';
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell(
    this.text, {
    this.width,
    this.isHeader = false,
    this.style,
  });
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

// Utility functions
String _formatDate(DateTime date) => '${date.day}/${date.month}';

String _formatWeekDate(DateTime weekStart) {
  final weekEnd = weekStart.add(const Duration(days: 6));
  return '${weekStart.day}/${weekStart.month}-${weekEnd.day}/${weekEnd.month}';
}
