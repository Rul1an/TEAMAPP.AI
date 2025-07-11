import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/heat_map_controller.dart';
// ignore: unused_import
import '../../../providers/analytics_repository_provider.dart';
import '../../../utils/heatmap_utils.dart';
import '../../../widgets/async_value_widget.dart';
import '../../../widgets/analytics/heat_map_painter.dart';
import '../../../models/action_category.dart';
import '../../../models/action_event.dart';

class HeatMapCard extends ConsumerStatefulWidget {
  const HeatMapCard({super.key});

  @override
  ConsumerState<HeatMapCard> createState() => _HeatMapCardState();
}

class _HeatMapCardState extends ConsumerState<HeatMapCard> {
  ActionCategory _category = ActionCategory.overall;
  _TimeFrame _frame = _TimeFrame.season;

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(heatMapControllerProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.thermostat, color: Colors.deepOrange),
                const SizedBox(width: 8),
                Text('Heatmap', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                _buildCategoryDropdown(),
                const SizedBox(width: 8),
                _buildFrameDropdown(),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: AsyncValueWidget<List<ActionEvent>>(
                // custom util widget assumed
                value: eventsAsync,
                data: (events) {
                  final matrix = binEvents(events: events);
                  return CustomPaint(
                    painter: HeatMapPainter(matrix),
                    size: Size.infinite,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() => DropdownButton<ActionCategory>(
    value: _category,
    onChanged: (v) {
      if (v == null) return;
      setState(() => _category = v);
      _reload();
    },
    items: ActionCategory.values
        .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
        .toList(),
  );

  Widget _buildFrameDropdown() => DropdownButton<_TimeFrame>(
    value: _frame,
    onChanged: (v) {
      if (v == null) return;
      setState(() => _frame = v);
      _reload();
    },
    items: _TimeFrame.values
        .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
        .toList(),
  );

  void _reload() {
    final now = DateTime.now();
    final params = switch (_frame) {
      _TimeFrame.season => HeatMapParams(
        start: DateTime(now.year, 1, 1),
        end: now,
        category: _category,
      ),
      _TimeFrame.lastFive => HeatMapParams(
        start: now.subtract(const Duration(days: 30)),
        end: now,
        category: _category,
      ),
      _TimeFrame.match => HeatMapParams(
        start: now.subtract(const Duration(hours: 3)),
        end: now,
        category: _category,
      ),
    };
    ref.read(heatMapControllerProvider.notifier).load(params);
  }
}

enum _TimeFrame { season, lastFive, match }

extension on _TimeFrame {
  String get label => switch (this) {
    _TimeFrame.season => 'Seizoen',
    _TimeFrame.lastFive => 'Laatste 5',
    _TimeFrame.match => 'Laatste wedstrijd',
  };
}
