import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/heat_map_controller.dart';
import '../../../utils/heatmap_utils.dart';
import '../../../widgets/async_value_widget.dart';
import '../../../widgets/analytics/heat_map_painter.dart';
import '../../../models/action_category.dart';
import '../../../models/action_event.dart';
import '../../../services/analytics_service.dart';
import '../../../services/prediction_service.dart';
import '../../../widgets/analytics/heat_map_legend.dart';
import '../../../widgets/analytics/heat_map_palette.dart';
import '../../../providers/heat_map_settings_provider.dart';
import '../../../services/heatmap_privacy_service.dart';
import '../../../utils/heatmap_utils.dart'
    show aggregateEvents, matrixFromEntries;

class HeatMapCard extends ConsumerStatefulWidget {
  const HeatMapCard({super.key});

  @override
  ConsumerState<HeatMapCard> createState() => _HeatMapCardState();
}

class _HeatMapCardState extends ConsumerState<HeatMapCard> {
  ActionCategory _category = ActionCategory.overall;
  _TimeFrame _frame = _TimeFrame.season;
  bool _showPredictions = false;

  @override
  void initState() {
    super.initState();
    // Log screen view for analytics.
    AnalyticsService.instance.logScreenView('HeatMap');
  }

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
                Row(
                  children: [
                    const Text('Pred.'),
                    Switch(
                      value: _showPredictions,
                      onChanged: (v) => setState(() => _showPredictions = v),
                    ),
                    const SizedBox(width: 8),
                    _buildPaletteMenu(context),
                    const SizedBox(width: 8),
                    _buildMinCountMenu(context),
                  ],
                ),
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
                  final settings = ref.watch(heatMapSettingsProvider);
                  if (_showPredictions) {
                    const PredictionService svc = PredictionService();
                    final danger = svc.shotDangerGrid(events: events);
                    final matrix = normalizeToIntMatrix(danger, scale: 100);
                    return CustomPaint(
                      painter: HeatMapPainter(
                        matrix,
                        opacity: 0.85,
                        palette: settings.palette,
                      ),
                      size: Size.infinite,
                    );
                  } else {
                    // Count-based matrix; if DP enabled, add Laplace noise via privacy service
                    if (settings.dpEnabled) {
                      final agg = aggregateEvents(events: events);
                      final payload =
                          const HeatmapPrivacyService().prepareUpload(
                        aggregator: agg,
                        minCount: settings.minCount,
                        epsilon: settings.epsilon,
                        seed: 0,
                      );
                      final rows = payload['rows'] as int;
                      final cols = payload['cols'] as int;
                      final entries = (payload['entries'] as List)
                          .map<List<int>>((e) => (e as List).cast<int>())
                          .toList(growable: false);
                      final matrix = matrixFromEntries(
                        rows: rows,
                        cols: cols,
                        entries: entries,
                      );
                      return CustomPaint(
                        painter: HeatMapPainter(
                          matrix,
                          opacity: 0.9,
                          palette: settings.palette,
                        ),
                        size: Size.infinite,
                      );
                    }
                    final raw = binEvents(events: events);
                    final matrix = applyKAnonymityThreshold(raw,
                        minCount: settings.minCount);
                    return CustomPaint(
                      painter: HeatMapPainter(
                        matrix,
                        opacity: 0.9,
                        palette: settings.palette,
                      ),
                      size: Size.infinite,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            Consumer(builder: (context, ref, _) {
              final settings = ref.watch(heatMapSettingsProvider);
              return HeatMapLegend(palette: settings.palette);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPaletteMenu(BuildContext context) {
    final settings = ref.watch(heatMapSettingsProvider);
    return DropdownButton<HeatMapPalette>(
      value: settings.palette,
      onChanged: (p) {
        if (p == null) return;
        ref.read(heatMapSettingsProvider.notifier).setPalette(p);
      },
      items: HeatMapPalette.values
          .map((p) => DropdownMenuItem(
                value: p,
                child: Text(p.name),
              ))
          .toList(),
    );
  }

  Widget _buildMinCountMenu(BuildContext context) {
    final settings = ref.watch(heatMapSettingsProvider);
    return Row(children: [
      DropdownButton<int>(
        value: settings.minCount,
        onChanged: (v) {
          if (v == null) return;
          ref.read(heatMapSettingsProvider.notifier).setMinCount(v);
        },
        items: const [2, 3, 4, 5, 6]
            .map((n) => DropdownMenuItem(value: n, child: Text('k≥$n')))
            .toList(),
      ),
      const SizedBox(width: 8),
      const Text('DP'),
      Switch(
        value: settings.dpEnabled,
        onChanged: (v) =>
            ref.read(heatMapSettingsProvider.notifier).setDpEnabled(enabled: v),
      ),
      if (settings.dpEnabled) ...[
        const SizedBox(width: 8),
        DropdownButton<double>(
          value: settings.epsilon,
          onChanged: (val) {
            if (val == null) return;
            ref.read(heatMapSettingsProvider.notifier).setEpsilon(val);
          },
          items: const [0.5, 1.0, 2.0]
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text('ε=$e'),
                  ))
              .toList(),
        ),
      ],
    ]);
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
          start: DateTime(now.year),
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
