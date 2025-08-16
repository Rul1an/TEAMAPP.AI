import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
import '../../../utils/heatmap_export.dart';
import 'package:file_saver/file_saver.dart' as fs;

class HeatMapCard extends ConsumerStatefulWidget {
  const HeatMapCard({super.key});

  @override
  ConsumerState<HeatMapCard> createState() => _HeatMapCardState();
}

class _HeatMapCardState extends ConsumerState<HeatMapCard> {
  ActionCategory _category = ActionCategory.overall;
  _TimeFrame _frame = _TimeFrame.season;
  bool _showPredictions = false;
  final GlobalKey _repaintKey = GlobalKey();

  // Export state (for CSV/JSON)
  List<List<int>>? _lastEntries; // [row, col, count]

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
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Text('Pred.'),
                        Switch(
                          value: _showPredictions,
                          onChanged: (v) =>
                              setState(() => _showPredictions = v),
                        ),
                        const SizedBox(width: 8),
                        _buildPaletteMenu(context),
                        const SizedBox(width: 8),
                        _buildMinCountMenu(context),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: 'Exporteren (PNG)',
                          icon: const Icon(Icons.download),
                          onPressed: _exportHeatmap,
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          tooltip: 'Exporteren (CSV)',
                          icon: const Icon(Icons.table_view),
                          onPressed: _exportCsv,
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          tooltip: 'Exporteren (JSON)',
                          icon: const Icon(Icons.data_object),
                          onPressed: _exportJson,
                        ),
                        const SizedBox(width: 8),
                        _buildCategoryDropdown(),
                        const SizedBox(width: 8),
                        _buildFrameDropdown(),
                      ],
                    ),
                  ),
                ),
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
                    // Predictions: CSV/JSON export niet van toepassing (geen telwaarden)
                    _lastEntries = null;
                    return RepaintBoundary(
                      key: _repaintKey,
                      child: CustomPaint(
                        painter: HeatMapPainter(
                          matrix,
                          opacity: 0.85,
                          palette: settings.palette,
                        ),
                        size: Size.infinite,
                      ),
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
                      _lastEntries = entries;
                      final matrix = matrixFromEntries(
                        rows: rows,
                        cols: cols,
                        entries: entries,
                      );
                      return RepaintBoundary(
                        key: _repaintKey,
                        child: CustomPaint(
                          painter: HeatMapPainter(
                            matrix,
                            opacity: 0.9,
                            palette: settings.palette,
                          ),
                          size: Size.infinite,
                        ),
                      );
                    }
                    final raw = binEvents(events: events);
                    final matrix = applyKAnonymityThreshold(raw,
                        minCount: settings.minCount);
                    // Genereer entries uit matrix voor exporten
                    final rows = matrix.isEmpty ? 0 : matrix[0].length;
                    final cols = matrix.length;
                    final entries = <List<int>>[];
                    for (int r = 0; r < rows; r += 1) {
                      for (int c = 0; c < cols; c += 1) {
                        final count = matrix[c][r];
                        if (count > 0) {
                          entries.add(<int>[r, c, count]);
                        }
                      }
                    }
                    _lastEntries = entries;
                    return RepaintBoundary(
                      key: _repaintKey,
                      child: CustomPaint(
                        painter: HeatMapPainter(
                          matrix,
                          opacity: 0.9,
                          palette: settings.palette,
                        ),
                        size: Size.infinite,
                      ),
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

  Future<void> _exportHeatmap() async {
    try {
      final ctx = _repaintKey.currentContext;
      if (ctx == null) return;
      final boundary = ctx.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final bytes = byteData.buffer.asUint8List();

      // Build filename with metadata
      final settings = ref.read(heatMapSettingsProvider);
      final ts = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final dpPart = settings.dpEnabled ? 'dp_${settings.epsilon}' : 'dp_off';
      final predPart = _showPredictions ? 'pred_on' : 'pred_off';
      final name =
          'heatmap_${settings.palette.name}_k${settings.minCount}_${dpPart}_${_category.name}_${predPart}_$ts.png';

      await fs.FileSaver.instance.saveFile(
        name: name,
        bytes: bytes,
        mimeType: fs.MimeType.png,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Heatmap geëxporteerd als PNG')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export mislukt: $e')),
      );
    }
  }

  Future<void> _exportCsv() async {
    try {
      final entries = _lastEntries;
      if (entries == null || entries.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Geen data om te exporteren')),
        );
        return;
      }
      final settings = ref.read(heatMapSettingsProvider);
      final ts = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final dpPart = settings.dpEnabled ? 'dp_${settings.epsilon}' : 'dp_off';
      final name =
          'heatmap_counts_${settings.palette.name}_k${settings.minCount}_${dpPart}_${_category.name}_$ts.csv';

      // Derive grid dimensions from sparse entries
      final dims = computeRowsCols(entries);
      final rows = dims.rows;
      final cols = dims.cols;

      // Build CSV via shared util
      final meta = HeatMapExportMeta(
        rows: rows,
        cols: cols,
        palette: settings.palette.name,
        minCount: settings.minCount,
        dpEnabled: settings.dpEnabled,
        epsilon: settings.dpEnabled ? settings.epsilon : null,
        category: _category.name,
        predictions: false,
        timestampIso: DateTime.now().toIso8601String(),
      );
      final csv = buildHeatmapCsv(entries: entries, meta: meta);
      final bytes = Uint8List.fromList(csv.codeUnits);
      await fs.FileSaver.instance.saveFile(
        name: name,
        bytes: bytes,
        mimeType: fs.MimeType.csv,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CSV geëxporteerd')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV export mislukt: $e')),
      );
    }
  }

  Future<void> _exportJson() async {
    try {
      final entries = _lastEntries;
      if (entries == null || entries.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Geen data om te exporteren')),
        );
        return;
      }
      final settings = ref.read(heatMapSettingsProvider);
      // Derive rows/cols
      final dims = computeRowsCols(entries);
      final meta = HeatMapExportMeta(
        rows: dims.rows,
        cols: dims.cols,
        palette: settings.palette.name,
        minCount: settings.minCount,
        dpEnabled: settings.dpEnabled,
        epsilon: settings.dpEnabled ? settings.epsilon : null,
        category: _category.name,
        predictions: false,
        timestampIso: DateTime.now().toIso8601String(),
      );
      final jsonStr = buildHeatmapJson(entries: entries, meta: meta);
      final bytes = Uint8List.fromList(jsonStr.codeUnits);
      final ts = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final dpPart = settings.dpEnabled ? 'dp_${settings.epsilon}' : 'dp_off';
      final name =
          'heatmap_counts_${settings.palette.name}_k${settings.minCount}_${dpPart}_${_category.name}_$ts.json';
      await fs.FileSaver.instance.saveFile(
        name: name,
        bytes: bytes,
        mimeType: fs.MimeType.json,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('JSON geëxporteerd')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('JSON export mislukt: $e')),
      );
    }
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
