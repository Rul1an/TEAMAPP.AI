import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/annual_planning/morphocycle.dart';
import '../exercise_library_controller.dart';

/// Banner displaying morphocycle information and intensity distribution.
///
/// Uses [ExerciseLibraryController.toggleMorphocycleBanner] to hide/show the
/// banner and [ExerciseLibraryController.showMorphocycleBanner] to determine
/// visibility.
class MorphocycleBanner extends ConsumerWidget {
  const MorphocycleBanner({
    required this.morphocycle,
    required this.weekNumber,
    super.key,
  });

  final Morphocycle morphocycle;
  final int weekNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.watch(exerciseLibraryControllerProvider);

    if (!ctrl.showMorphocycleBanner) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.science, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Week $weekNumber Morphocycle',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: ctrl.toggleMorphocycleBanner,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Primary Focus: ${morphocycle.primaryGameModelFocus}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            'Secondary Focus: ${morphocycle.secondaryGameModelFocus}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: TrainingIntensity.values
                .where((e) => e != TrainingIntensity.competition)
                .map((intensity) {
                  final pct =
                      morphocycle.intensityDistribution[intensity.name
                          .toLowerCase()] ??
                      0.0;
                  return _buildIntensityChip(intensity, pct);
                })
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIntensityChip(TrainingIntensity intensity, double pct) {
    final color = _getIntensityColor(intensity);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${_intensityLabel(intensity)}\n${pct.toInt()}%',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  static String _intensityLabel(TrainingIntensity intensity) {
    switch (intensity) {
      case TrainingIntensity.recovery:
        return 'Recovery';
      case TrainingIntensity.acquisition:
        return 'Acquisition';
      case TrainingIntensity.development:
        return 'Development';
      case TrainingIntensity.activation:
        return 'Activation';
      case TrainingIntensity.competition:
        return 'Competition';
    }
  }

  Color _getIntensityColor(TrainingIntensity intensity) {
    switch (intensity) {
      case TrainingIntensity.recovery:
        return Colors.green;
      case TrainingIntensity.acquisition:
        return Colors.red;
      case TrainingIntensity.development:
        return Colors.orange;
      case TrainingIntensity.activation:
        return Colors.blue;
      case TrainingIntensity.competition:
        return Colors.purple;
    }
  }
}
