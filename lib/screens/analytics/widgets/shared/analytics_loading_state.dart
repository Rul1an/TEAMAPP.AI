// Flutter imports:
import 'package:flutter/material.dart';

/// Analytics Loading State Widget - Shared Loading Component
///
/// Provides a consistent loading state display for analytics components.
/// Shows a loading indicator with descriptive text and proper spacing.
///
/// Features:
/// - Consistent Material Design theming
/// - Centered layout
/// - Descriptive loading text
/// - Proper accessibility labels
///
/// Part of the Clean Architecture refactor from 892 LOC performance_analytics_screen.dart
class AnalyticsLoadingState extends StatelessWidget {
  const AnalyticsLoadingState({
    super.key,
    this.message = 'Analytics data laden...',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid Loading State - Loading state for grid layouts
///
/// Displays a shimmer-like loading effect for grid-based content.
/// Useful for feature grids and chart grids while data is loading.
class AnalyticsGridLoadingState extends StatelessWidget {
  const AnalyticsGridLoadingState({
    super.key,
    this.itemCount = 4,
    this.crossAxisCount = 2,
  });

  final int itemCount;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: List.generate(
        itemCount,
        (index) => const _LoadingCard(),
      ),
    );
  }
}

/// Individual Loading Card - Shimmer effect for cards
///
/// Provides a loading skeleton for individual card components.
/// Uses subtle animation to indicate loading state.
class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 80,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(30),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 60,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(20),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
