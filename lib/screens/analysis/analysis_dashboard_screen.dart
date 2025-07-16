// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

// Project imports:
import '../../models/video_event.dart';
import '../../providers/video_event_cache_provider.dart';
import '../../providers/video_event_detector_provider.dart';
import '../../providers/players_provider.dart';
import '../../providers/player_movement_analytics_provider.dart';
import '../../widgets/distance_bar_chart.dart';

/// Displays the tactical events (goals, corners, fouls …) of a match in real
/// time, backed by an encrypted offline cache so that coaches can review the
/// footage even without network connectivity.
class AnalysisDashboardScreen extends ConsumerStatefulWidget {
  const AnalysisDashboardScreen({
    required this.matchId,
    super.key,
  });

  final String matchId;

  @override
  ConsumerState<AnalysisDashboardScreen> createState() => _AnalysisDashboardState();
}

class _AnalysisDashboardState extends ConsumerState<AnalysisDashboardScreen> {
  final List<VideoEvent> _events = [];
  StreamSubscription<VideoEvent>? _subscription;
  bool _isLoading = true;
  String? _selectedPlayerId;

  @override
  void initState() {
    super.initState();

    _loadCacheThenSubscribe();
  }

  Future<void> _loadCacheThenSubscribe() async {
    // 1. Load cached events (if any)
    final cache = ref.read(videoEventCacheProvider);
    final cached = await cache.read(widget.matchId);

    if (mounted) {
      setState(() {
        _events.addAll(cached);
        _isLoading = false;
      });
    }

    // 2. Subscribe to realtime updates
    _subscription = ref
        .read(videoEventDetectorServiceProvider)
        .streamEvents(matchId: widget.matchId)
        .listen((event) async {
      setState(() => _events.add(event));
      await cache.write(widget.matchId, _events);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sort events by timestamp asc for presentation.
    _events.sort((a, b) => a.timestampMs.compareTo(b.timestampMs));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analysis Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Events'),
              Tab(text: 'Movement'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 600;
                      return isWide ? _buildDataTable() : _buildListView();
                    },
                  ),
                  _buildMovementTab(),
                ],
              ),
      ),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: DataTable(
        columnSpacing: 24,
        headingRowColor: MaterialStateProperty.resolveWith(
          (states) => Colors.grey.shade200,
        ),
        columns: const [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('Time')),
          DataColumn(label: Text('Type')),
        ],
        rows: _events.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final e = entry.value;
          return DataRow(cells: [
            DataCell(Text(index.toString())),
            DataCell(Text(_formatTs(e.timestampMs))),
            DataCell(Text(_typePretty(e.type))),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _events.length,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, idx) {
        final e = _events[idx];
        return ListTile(
          leading: _iconForType(e.type),
          title: Text(_typePretty(e.type)),
          subtitle: Text(_formatTs(e.timestampMs)),
        );
      },
    );
  }

  String _formatTs(int ms) {
    final duration = Duration(milliseconds: ms);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _typePretty(VideoEventType type) {
    switch (type) {
      case VideoEventType.goal:
        return 'Goal';
      case VideoEventType.corner:
        return 'Corner';
      case VideoEventType.foul:
        return 'Foul';
    }
  }

  Icon _iconForType(VideoEventType type) {
    switch (type) {
      case VideoEventType.goal:
        return const Icon(Icons.sports_soccer, color: Colors.green);
      case VideoEventType.corner:
        return const Icon(Icons.flag, color: Colors.orange);
      case VideoEventType.foul:
        return const Icon(Icons.warning, color: Colors.red);
    }
  }

  Widget _buildMovementTab() {
    final playersAsync = ref.watch(playersProvider);

    return playersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err')),
      data: (players) {
        if (players.isEmpty) {
          return const Center(child: Text('No players'));
        }

        _selectedPlayerId ??= players.first.id;

        final analyticsAsync = ref.watch(
          playerMovementAnalyticsProvider((_selectedPlayerId!, widget.matchId)),
        );

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButton<String>(
                value: _selectedPlayerId,
                onChanged: (val) => setState(() => _selectedPlayerId = val),
                items: players
                    .map(
                      (p) => DropdownMenuItem(
                        value: p.id,
                        child: Text(p.name),
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: analyticsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, st) => Center(child: Text('Error: $err')),
                data: (analytics) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Heat-map',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        HeatMap(
                          datasets: _matrixToDataset(analytics.heatmap),
                          colorMode: ColorMode.opacity,
                          showColorTip: false,
                          size: 16,
                          defaultColor: Colors.grey.shade200,
                          colorsets: const {
                            1: Color(0xFF9be9a8),
                            3: Color(0xFF40c463),
                            6: Color(0xFF30a14e),
                            9: Color(0xFF216e39),
                          },
                        ),
                        const SizedBox(height: 24),
                        const Text('Distance covered',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Center(
                          child: DistanceBarChart(
                            distanceMeters: analytics.distanceMeters,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

Map<DateTime, int> _matrixToDataset(List<List<int>> matrix) {
  final map = <DateTime, int>{};
  var dayOffset = 0;
  for (final row in matrix) {
    for (final value in row) {
      map[DateTime(2000).add(Duration(days: dayOffset))] = value;
      dayOffset++;
    }
  }
  return map;
}