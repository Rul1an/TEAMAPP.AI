import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/player.dart';
import '../../config/theme.dart';
import '../../services/database_service.dart';
import '../common/performance_badge.dart';

class PlayerCard extends ConsumerWidget {
  final Player player;
  final VoidCallback? onTap;

  const PlayerCard({
    super.key,
    required this.player,
    this.onTap,
  });

  Future<Map<String, dynamic>> _getPerformanceData(String playerId) async {
    final dbService = DatabaseService();
    final averageRating = await dbService.getPlayerAverageRating(playerId, lastNRatings: 5);
    final trend = await dbService.getPlayerPerformanceTrend(playerId);

    return {
      'averageRating': averageRating > 0 ? averageRating : null,
      'trend': trend,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Jersey number
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.getPositionColor(player.position.displayName),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        player.jerseyNumber.toString(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name and position
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                player.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            // Performance Badge
                            FutureBuilder<Map<String, dynamic>>(
                              future: _getPerformanceData(player.id.toString()),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final data = snapshot.data!;
                                  return PerformanceBadge(
                                    averageRating: data['averageRating'],
                                    trend: data['trend'],
                                    compact: true,
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          player.position.displayName,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  // Age
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${player.age} jaar',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        player.preferredFoot.displayName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Performance indicators
              Row(
                children: [
                  _PerformanceIndicator(
                    label: 'Aanwezig',
                    value: player.attendancePercentage,
                    icon: Icons.check_circle_outline,
                  ),
                  const SizedBox(width: 16),
                  _StatIndicator(
                    label: 'Goals',
                    value: player.goals.toString(),
                    icon: Icons.sports_soccer,
                  ),
                  const SizedBox(width: 16),
                  _StatIndicator(
                    label: 'Assists',
                    value: player.assists.toString(),
                    icon: Icons.assistant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PerformanceIndicator extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;

  const _PerformanceIndicator({
    required this.label,
    required this.value,
    required this.icon,
  });

  Color _getPerformanceColor(double value) {
    if (value >= 80) return AppTheme.successColor;
    if (value >= 60) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getPerformanceColor(value).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: _getPerformanceColor(value),
          ),
          const SizedBox(width: 4),
          Text(
            '${value.toInt()}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getPerformanceColor(value),
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatIndicator extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatIndicator({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[700],
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
