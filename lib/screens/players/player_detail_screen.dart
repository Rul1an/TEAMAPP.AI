import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:html' if (dart.library.html) 'dart:html' as html;
import 'package:path_provider/path_provider.dart';
import '../../models/player.dart';
import '../../models/match.dart';
import '../../models/performance_rating.dart';
import '../../models/assessment.dart';
import '../../providers/database_provider.dart';
import '../../services/database_service.dart';
import '../../services/pdf_service.dart';
import '../../utils/colors.dart';
import '../../widgets/common/star_rating.dart';
import '../../widgets/common/performance_badge.dart';

class PlayerDetailScreen extends ConsumerStatefulWidget {
  final String playerId;

  const PlayerDetailScreen({
    super.key,
    required this.playerId,
  });

  @override
  ConsumerState<PlayerDetailScreen> createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends ConsumerState<PlayerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final playersAsync = ref.watch(playersProvider);
    final matchesAsync = ref.watch(matchesProvider);
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speler Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.go('/players/${widget.playerId}/edit');
            },
          ),
        ],
      ),
      body: playersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Fout: $error')),
        data: (players) {
          final player = players.firstWhere(
            (p) => p.id.toString() == widget.playerId,
            orElse: () {
              final newPlayer = Player();
              newPlayer.firstName = 'Onbekend';
              newPlayer.lastName = '';
              return newPlayer;
            },
          );

          if (player.id == 0) {
            return const Center(child: Text('Speler niet gevonden'));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 24 : 16),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : double.infinity),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPlayerHeader(player),
                    const SizedBox(height: 24),
                    if (isDesktop || isTablet)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildStatisticsCards(player),
                                const SizedBox(height: 24),
                                _buildMinutesChart(player),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              children: [
                                _buildRecentMatches(player, matchesAsync),
                                const SizedBox(height: 24),
                                _buildAssessmentSection(player),
                                const SizedBox(height: 24),
                                _buildPersonalInfo(player),
                              ],
                            ),
                          ),
                        ],
                      )
                    else ...[
                      _buildStatisticsCards(player),
                      const SizedBox(height: 24),
                      _buildRatingOverview(player),
                      const SizedBox(height: 24),
                      _buildMinutesChart(player),
                      const SizedBox(height: 24),
                      _buildRatingHistory(player),
                      const SizedBox(height: 24),
                      _buildAssessmentSection(player),
                      const SizedBox(height: 24),
                      _buildRecentMatches(player, matchesAsync),
                      const SizedBox(height: 24),
                      _buildPersonalInfo(player),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerHeader(Player player) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: getPositionColor(player.position),
              child: Text(
                player.jerseyNumber.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Chip(
                        label: Text(_getPositionName(player.position)),
                        backgroundColor: getPositionColor(player.position).withValues(alpha: 0.2),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${player.age} jaar',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(Player player) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getRatingStatistics(player.id.toString()),
      builder: (context, snapshot) {
        final ratingData = snapshot.data ?? {};

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildStatCard(
              'Speelminuten',
              '${player.matchMinutesPercentage.toStringAsFixed(1)}%',
              Icons.timer,
              Colors.blue,
              subtitle: '${player.minutesPlayed} min totaal',
            ),
            _buildStatCard(
              'Wedstrijden',
              '${player.matchesPlayed}',
              Icons.sports_soccer,
              Colors.green,
              subtitle: 'Van ${player.matchesInSelection} selecties',
            ),
            _buildStatCard(
              'Gem. Minuten',
              player.averageMinutesPerMatch.toStringAsFixed(0),
              Icons.av_timer,
              Colors.orange,
              subtitle: 'Per wedstrijd',
            ),
            _buildStatCard(
              'Training',
              '${player.attendancePercentage.toStringAsFixed(0)}%',
              Icons.fitness_center,
              Colors.purple,
              subtitle: '${player.trainingsAttended}/${player.trainingsTotal}',
            ),
            // Nieuwe rating cards
            _buildRatingCard(
              'Gem. Rating',
              ratingData['overallAverage'] ?? 0.0,
              Icons.star,
              Colors.amber,
              subtitle: ratingData['totalRatings'] != null
                ? '${ratingData['totalRatings']} beoordelingen'
                : 'Geen beoordelingen',
            ),
            _buildRatingCard(
              'Laatste 5',
              ratingData['last5Average'] ?? 0.0,
              Icons.trending_up,
              _getTrendColor(ratingData['trend']),
              subtitle: _getTrendText(ratingData['trend']),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard(
    String title,
    double rating,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            if (rating > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.star,
                    color: color,
                    size: 20,
                  ),
                ],
              ),
            ] else ...[
              const Text(
                '-',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMinutesChart(Player player) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Speelminuten Overzicht',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildBarChart(player),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(Player player) {
    // Mock data voor demonstratie - in productie zou dit uit de match history komen
    final data = [
      _BarData('Week 1', 80, 80),
      _BarData('Week 2', 65, 80),
      _BarData('Week 3', 0, 0),
      _BarData('Week 4', 80, 80),
      _BarData('Week 5', 45, 80),
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(0)}%',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < data.length) {
                  return Text(
                    data[value.toInt()].label,
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final percentage = item.maxMinutes > 0
              ? (item.playedMinutes / item.maxMinutes) * 100
              : 0;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: percentage.toDouble(),
                color: percentage >= 75
                    ? Colors.green
                    : percentage >= 50
                        ? Colors.orange
                        : Colors.red,
                width: 20,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentMatches(Player player, AsyncValue<List<Match>> matchesAsync) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recente Wedstrijden',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            matchesAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Fout: $error'),
              data: (matches) {
                final recentMatches = matches
                    .where((m) => m.status == MatchStatus.completed)
                    .take(5)
                    .toList();

                if (recentMatches.isEmpty) {
                  return const Text('Nog geen wedstrijden gespeeld');
                }

                return Column(
                  children: recentMatches.map((match) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: _getResultColor(match.result),
                        child: Text(
                          _getResultLetter(match.result),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(match.opponent),
                      subtitle: Text(
                        DateFormat('d MMM', 'nl_NL').format(match.date),
                      ),
                      trailing: Text(
                        '${match.teamScore ?? 0} - ${match.opponentScore ?? 0}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingOverview(Player player) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getRatingStatistics(player.id.toString()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!;
        if (data['totalRatings'] == 0) {
          return const SizedBox.shrink();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmallScreen = constraints.maxWidth < 300;

                    if (isSmallScreen) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prestatie Overzicht',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: PerformanceBadge(
                              averageRating: data['overallAverage'],
                              trend: data['trend'],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Prestatie Overzicht',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(width: 8),
                    PerformanceBadge(
                      averageRating: data['overallAverage'],
                      trend: data['trend'],
                    ),
                  ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildRatingItem(
                        'Totaal Gemiddelde',
                        data['overallAverage'],
                        Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildRatingItem(
                        'Laatste 5',
                        data['last5Average'],
                        _getTrendColor(data['trend']),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildRatingItem(
                        'Wedstrijden',
                        data['matchAverage'],
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildRatingItem(
                        'Trainingen',
                        data['trainingAverage'],
                        Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingItem(String label, double rating, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          if (rating > 0) ...[
            Row(
              children: [
                Text(
                  rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.star,
                  size: 18,
                  color: color,
                ),
              ],
            ),
          ] else ...[
            const Text(
              '-',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingHistory(Player player) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recente Beoordelingen',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<PerformanceRating>>(
              future: DatabaseService().getPlayerRatings(player.id.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text(
                    'Nog geen beoordelingen',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  );
                }

                final ratings = snapshot.data!.take(10).toList();

                return Column(
                  children: ratings.map((rating) {
                    final isMatch = rating.type == RatingType.match;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: isMatch ? Colors.blue : Colors.green,
                        child: Icon(
                          isMatch ? Icons.sports_soccer : Icons.fitness_center,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              isMatch ? 'Wedstrijd' : 'Training',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          StarRating(
                            rating: rating.overallRating,
                            size: 20,
                          ),
                        ],
                      ),
                      subtitle: Text(
                        DateFormat('d MMM yyyy', 'nl_NL').format(rating.date),
                      ),
                      trailing: rating.notes != null && rating.notes!.isNotEmpty
                          ? const Icon(Icons.note, size: 16)
                          : null,
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAssessmentSection(Player player) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 350;

                if (isSmallScreen) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assessments',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.go('/players/${widget.playerId}/assessment');
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Nieuwe Assessment'),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Assessments',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.go('/players/${widget.playerId}/assessment');
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Nieuwe Assessment'),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<PlayerAssessment>>(
              future: DatabaseService().getPlayerAssessments(player.id.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Column(
                    children: [
                      const Text(
                        'Nog geen assessments',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Start een nieuwe assessment om de ontwikkeling van ${player.firstName} bij te houden.',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }

                final assessments = snapshot.data!.take(5).toList();

                return Column(
                  children: assessments.map((assessment) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: 1,
                      child: InkWell(
                        onTap: () {
                          context.go('/players/${widget.playerId}/assessment/${assessment.id}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: _getAssessmentTypeColor(assessment.type),
                                radius: 20,
                                child: Icon(
                                  _getAssessmentTypeIcon(assessment.type),
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getAssessmentTypeText(assessment.type),
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('d MMM yyyy', 'nl_NL').format(assessment.assessmentDate),
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Gem: ${assessment.overallAverage.toStringAsFixed(1)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.star, size: 14, color: Colors.amber),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.picture_as_pdf),
                                    onPressed: () => _exportAssessmentToPDF(assessment, player),
                                    tooltip: 'Exporteer naar PDF',
                                    iconSize: 20,
                                    color: Colors.red[700],
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey[400],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo(Player player) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Persoonlijke Informatie',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Geboortedatum', DateFormat('d MMMM yyyy', 'nl_NL').format(player.birthDate)),
            _buildInfoRow('Lengte', '${player.height} cm'),
            _buildInfoRow('Gewicht', '${player.weight} kg'),
            _buildInfoRow('Voorkeur voet', player.preferredFoot == PreferredFoot.left ? 'Links' : 'Rechts'),
            if (player.email != null && player.email!.isNotEmpty)
              _buildInfoRow('Email', player.email!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getPositionName(Position position) {
    switch (position) {
      case Position.goalkeeper:
        return 'Keeper';
      case Position.defender:
        return 'Verdediger';
      case Position.midfielder:
        return 'Middenvelder';
      case Position.forward:
        return 'Aanvaller';
    }
  }

  Color _getResultColor(MatchResult? result) {
    switch (result) {
      case MatchResult.win:
        return Colors.green;
      case MatchResult.draw:
        return Colors.orange;
      case MatchResult.loss:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getResultLetter(MatchResult? result) {
    switch (result) {
      case MatchResult.win:
        return 'W';
      case MatchResult.draw:
        return 'G';
      case MatchResult.loss:
        return 'V';
      default:
        return '-';
    }
  }

  Future<Map<String, dynamic>> _getRatingStatistics(String playerId) async {
    final dbService = DatabaseService();
    final allRatings = await dbService.getPlayerRatings(playerId);

    if (allRatings.isEmpty) {
      return {
        'overallAverage': 0.0,
        'last5Average': 0.0,
        'matchAverage': 0.0,
        'trainingAverage': 0.0,
        'totalRatings': 0,
        'trend': PerformanceTrend.stable,
      };
    }

    // Calculate overall average
    final overallAverage = allRatings
        .map((r) => r.overallRating)
        .reduce((a, b) => a + b) / allRatings.length;

    // Calculate last 5 average
    final last5Ratings = allRatings.take(5).toList();
    final last5Average = last5Ratings.isNotEmpty
        ? last5Ratings.map((r) => r.overallRating).reduce((a, b) => a + b) / last5Ratings.length
        : 0.0;

    // Calculate match average
    final matchRatings = allRatings.where((r) => r.type == RatingType.match).toList();
    final matchAverage = matchRatings.isNotEmpty
        ? matchRatings.map((r) => r.overallRating).reduce((a, b) => a + b) / matchRatings.length
        : 0.0;

    // Calculate training average
    final trainingRatings = allRatings.where((r) => r.type == RatingType.training).toList();
    final trainingAverage = trainingRatings.isNotEmpty
        ? trainingRatings.map((r) => r.overallRating).reduce((a, b) => a + b) / trainingRatings.length
        : 0.0;

    // Get trend
    final trend = await dbService.getPlayerPerformanceTrend(playerId);

    return {
      'overallAverage': overallAverage,
      'last5Average': last5Average,
      'matchAverage': matchAverage,
      'trainingAverage': trainingAverage,
      'totalRatings': allRatings.length,
      'trend': trend,
    };
  }

  Color _getTrendColor(PerformanceTrend? trend) {
    switch (trend) {
      case PerformanceTrend.improving:
        return Colors.green;
      case PerformanceTrend.declining:
        return Colors.red;
      case PerformanceTrend.stable:
      default:
        return Colors.orange;
    }
  }

  String _getTrendText(PerformanceTrend? trend) {
    switch (trend) {
      case PerformanceTrend.improving:
        return 'Stijgende vorm';
      case PerformanceTrend.declining:
        return 'Dalende vorm';
      case PerformanceTrend.stable:
      default:
        return 'Stabiele vorm';
    }
  }

  Color _getAssessmentTypeColor(AssessmentType type) {
    switch (type) {
      case AssessmentType.monthly:
        return Colors.blue;
      case AssessmentType.quarterly:
        return Colors.orange;
      case AssessmentType.biannual:
        return Colors.purple;
    }
  }

  IconData _getAssessmentTypeIcon(AssessmentType type) {
    switch (type) {
      case AssessmentType.monthly:
        return Icons.calendar_month;
      case AssessmentType.quarterly:
        return Icons.calendar_view_month;
      case AssessmentType.biannual:
        return Icons.calendar_today;
    }
  }

  String _getAssessmentTypeText(AssessmentType type) {
    switch (type) {
      case AssessmentType.monthly:
        return 'Maandelijkse Assessment';
      case AssessmentType.quarterly:
        return 'Kwartaal Assessment';
      case AssessmentType.biannual:
        return 'Halfjaarlijkse Assessment';
    }
  }

  Future<void> _exportAssessmentToPDF(PlayerAssessment assessment, Player player) async {
    try {
      // Generate PDF
      final pdfData = await PDFService.generateAssessmentReport(player, assessment);

      final fileName = 'assessment_${player.firstName}_${player.lastName}_${DateFormat('yyyy-MM-dd').format(assessment.assessmentDate)}.pdf';

      if (kIsWeb) {
        // Web platform: Trigger browser download
        final blob = html.Blob([pdfData], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = fileName;
        html.document.body!.children.add(anchor);
        anchor.click();
        html.document.body!.children.remove(anchor);
        html.Url.revokeObjectUrl(url);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PDF gedownload: $fileName'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Mobile platform: Save to file system
        final downloadsDir = await getDownloadsDirectory();
        final file = File('${downloadsDir?.path ?? (await getApplicationDocumentsDirectory()).path}/$fileName');
        await file.writeAsBytes(pdfData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PDF rapport opgeslagen: $fileName'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout bij PDF export: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}

class _BarData {
  final String label;
  final double playedMinutes;
  final double maxMinutes;

  _BarData(this.label, this.playedMinutes, this.maxMinutes);
}
