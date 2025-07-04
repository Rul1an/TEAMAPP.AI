// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../models/annual_planning/season_plan.dart';
import '../../providers/annual_planning_data_provider.dart';
import 'load_monitoring_screen.dart';
import 'weekly_planning_screen.dart';

class AnnualPlanningScreen extends ConsumerWidget {
  const AnnualPlanningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonPlansAsync = ref.watch(seasonPlansProvider);
    final periodizationPlansAsync = ref.watch(periodizationPlansProvider);
    final trainingPeriodsAsync = ref.watch(trainingPeriodsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jaarplanning'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_view_week),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const WeeklyPlanningScreen(),
              ),
            ),
            tooltip: 'Wekelijks Overzicht',
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const LoadMonitoringScreen(),
              ),
            ),
            tooltip: 'Load Monitoring',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Season Overview
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Seizoen Overzicht',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Plan je voetbalseizoen met de Nederlandse KNVB methodiek.\n'
                      'Maak periodiseringsplannen en volg de ontwikkeling van je team.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Access to Weekly Planning
            Card(
              elevation: 4,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const WeeklyPlanningScreen(),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[600]!, Colors.green[400]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.calendar_view_week,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wekelijks Overzicht',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Bekijk trainingen, wedstrijden en vakantieperioden per week',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions Section
            Text(
              '⚡ Snelle Acties',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const LoadMonitoringScreen(),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 32,
                              color: Colors.orange,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Belasting Monitoring',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Morfocycle tracking',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        // Templates screen not implemented yet - show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Templates feature komt binnenkort!'),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.library_books,
                              size: 32,
                              color: Colors.purple,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Templates',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Periodisering modellen',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Season Plans
            Text(
              'Seizoenplannen',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            seasonPlansAsync.when(
              data: (seasons) => Column(
                children: seasons
                    .map(
                      (season) => Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(season.teamName),
                          subtitle: Text(
                            '${season.season} | ${season.seasonStartDate.day}/${season.seasonStartDate.month} - ${season.seasonEndDate.day}/${season.seasonEndDate.month}\n'
                            'Status: ${season.status.name} | Vakantieperioden: ${season.holidayPeriods.length}',
                          ),
                          trailing: Chip(
                            label: Text(season.getCurrentPhase().displayName),
                            backgroundColor:
                                _getPhaseColor(season.getCurrentPhase()),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 16),

            // Periodization Plans
            Text(
              'Periodiseringsplannen',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            periodizationPlansAsync.when(
              data: (plans) => Column(
                children: plans
                    .map(
                      (plan) => Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.fitness_center,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(plan.name),
                          subtitle: Text(
                            '${plan.modelType.name} | Leeftijd: ${plan.targetAgeGroup.name}\n'
                            'Template: ${plan.isTemplate ? "Ja" : "Nee"} | ${plan.description}',
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${plan.totalDurationWeeks}w'),
                              Text('${plan.numberOfPeriods} perioden'),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 16),

            // Training Periods
            Text(
              'Trainingsperioden',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            trainingPeriodsAsync.when(
              data: (periods) => Column(
                children: periods
                    .map(
                      (period) => Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.timeline,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(period.name),
                          subtitle: Text(
                            '${period.type.name} | ${period.durationWeeks} weken\n'
                            'Intensiteit: ${period.intensityPercentage}% | ${period.sessionsPerWeek} sessies/week\n'
                            'Doelen: ${period.keyObjectives.take(2).join(", ")}${period.keyObjectives.length > 2 ? "..." : ""}',
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                period.isActive
                                    ? Icons.play_circle
                                    : Icons.pause_circle,
                                color: period.isActive
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              Text(period.isActive ? 'Actief' : 'Inactief'),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 16),

            // Planning Tips
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Planning Tips',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Effectieve seizoenplanning voor jeugdvoetbal:\n\n'
                      '• Start met lange-termijn doelen voor het seizoen\n'
                      '• Plan vakantieperioden en rustmomenten\n'
                      '• Balanceer techniek, tactiek en fysieke ontwikkeling\n'
                      "• Houd rekening met wedstrijdschema's en toernooien",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPhaseColor(SeasonPhase phase) {
    switch (phase) {
      case SeasonPhase.preseason:
        return Colors.blue.shade100;
      case SeasonPhase.earlySeason:
        return Colors.green.shade100;
      case SeasonPhase.midSeason:
        return Colors.orange.shade100;
      case SeasonPhase.lateSeason:
        return Colors.red.shade100;
      case SeasonPhase.postSeason:
        return Colors.grey.shade100;
    }
  }
}
