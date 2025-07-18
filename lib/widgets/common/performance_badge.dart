// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../models/performance_rating.dart';
import 'star_rating.dart';

class PerformanceBadge extends StatelessWidget {
  const PerformanceBadge({
    super.key,
    this.averageRating,
    this.trend,
    this.compact = false,
  });
  final double? averageRating;
  final PerformanceTrend? trend;
  final bool compact;

  String _getTrendEmoji(PerformanceTrend trend) {
    switch (trend) {
      case PerformanceTrend.improving:
        return '↗️';
      case PerformanceTrend.declining:
        return '↘️';
      case PerformanceTrend.stable:
        return '→';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (averageRating == null && trend == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(compact ? 12 : 16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (averageRating != null) ...[
            StarRating(
              rating: averageRating!.round(),
              size: compact ? 16 : 20,
              color: theme.colorScheme.primary,
            ),
            if (!compact) ...[
              const SizedBox(width: 4),
              Text(
                averageRating!.toStringAsFixed(1),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ],
          if (trend != null) ...[
            if (averageRating != null) const SizedBox(width: 8),
            Text(
              _getTrendEmoji(trend!),
              style: TextStyle(fontSize: compact ? 16 : 20),
            ),
          ],
        ],
      ),
    );
  }
}

class PerformanceTrendIndicator extends StatelessWidget {
  const PerformanceTrendIndicator({
    required this.trend,
    super.key,
    this.size = 24,
  });
  final PerformanceTrend trend;
  final double size;

  String _getTrendEmoji(PerformanceTrend trend) {
    switch (trend) {
      case PerformanceTrend.improving:
        return '↗️';
      case PerformanceTrend.declining:
        return '↘️';
      case PerformanceTrend.stable:
        return '→';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color getColor() {
      switch (trend) {
        case PerformanceTrend.improving:
          return Colors.green;
        case PerformanceTrend.declining:
          return Colors.orange;
        case PerformanceTrend.stable:
          return theme.colorScheme.onSurfaceVariant;
      }
    }

    return Container(
      width: size * 1.5,
      height: size * 1.5,
      decoration: BoxDecoration(
        color: getColor().withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(_getTrendEmoji(trend), style: TextStyle(fontSize: size)),
      ),
    );
  }
}
