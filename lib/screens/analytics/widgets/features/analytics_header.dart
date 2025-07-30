// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../performance_analytics_controller.dart';

/// Analytics Header Widget - App Bar and Header Content
///
/// Provides the main header for the performance analytics screen including:
/// - Styled title with icon
/// - Refresh action button
/// - Descriptive subtitle text
/// - Loading indicator during refresh
///
/// Features:
/// - Consistent Material Design theming
/// - Refresh state handling
/// - Responsive layout
/// - Accessibility support
///
/// Part of the Clean Architecture refactor from 892 LOC performance_analytics_screen.dart
class AnalyticsHeader extends ConsumerWidget {
  const AnalyticsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(performanceAnalyticsControllerProvider);
    final controller =
        ref.read(performanceAnalyticsControllerProvider.notifier);

    final isRefreshing =
        analyticsState is AnalyticsLoaded && analyticsState.isRefreshing;

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Performance Analytics',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (isRefreshing)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: controller.refreshData,
                    tooltip: 'Ververs Data',
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Analyseer spelerontwikkeling, training effectiviteit en team prestaties. '
              'Realtime data analyse voor betere coaching beslissingen.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// App Bar for Analytics Screen
///
/// Provides a clean app bar specifically for the performance analytics screen.
/// Can be used as the main app bar when the screen is used as a full page.
class AnalyticsAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const AnalyticsAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(performanceAnalyticsControllerProvider);
    final controller =
        ref.read(performanceAnalyticsControllerProvider.notifier);

    final isRefreshing =
        analyticsState is AnalyticsLoaded && analyticsState.isRefreshing;

    return AppBar(
      title: const Text('Performance Analytics'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        if (isRefreshing)
          const Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
            tooltip: 'Ververs Data',
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
