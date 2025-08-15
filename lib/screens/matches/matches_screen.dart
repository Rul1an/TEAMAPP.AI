// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

// Project imports:
import '../../models/match.dart';
import '../../providers/export_service_provider.dart';
import '../../providers/matches_provider.dart'
    show matchRepositoryProvider, matchesNotifierProvider;
import '../../providers/auth_provider.dart';
import '../../services/permission_service.dart';
import '../../services/schedule_import_service.dart';
import '../../services/analytics_events.dart';
import '../../widgets/common/app_error_boundary.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AnalyticsLogger _analytics = const AnalyticsLogger();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matchesAsync = ref.watch(matchesNotifierProvider);
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final userRole = ref.watch(userRoleProvider);
    final isViewOnly = PermissionService.isViewOnlyUser(userRole);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wedstrijden'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nieuwe wedstrijd plannen',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () {
              unawaited(_analytics.log(AnalyticsEvent.trainingCreate,
                  parameters: {'entity': 'match'}));
              context.go('/matches/add');
            },
          ),
          if (!isViewOnly)
            IconButton(
              icon: const Icon(Icons.upload_file),
              tooltip: 'Importeer schema',
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              onPressed: _importCsv,
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.download),
            tooltip: 'Export opties',
            onSelected: (value) async {
              try {
                if (value == 'pdf') {
                  unawaited(_analytics.log(AnalyticsEvent.exportPdf,
                      parameters: {'entity': 'matches'}));
                  await ref.read(exportServiceProvider).exportMatchesToPDF();
                  if (mounted && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Export gestart'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Export mislukt: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'pdf',
                child: ListTile(
                  leading: Icon(Icons.picture_as_pdf),
                  title: Text('Exporteer naar PDF'),
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Aankomend'),
            Tab(text: 'Afgelopen'),
            Tab(text: 'Alle'),
          ],
        ),
      ),
      body: matchesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (matches) {
          final upcomingMatches = matches
              .where((m) => m.status == MatchStatus.scheduled)
              .toList()
            ..sort((a, b) => a.date.compareTo(b.date));
          final completedMatches = matches
              .where((m) => m.status == MatchStatus.completed)
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date));
          final allMatches = List<Match>.from(matches)
            ..sort((a, b) => b.date.compareTo(a.date));

          return AppErrorBoundary(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMatchList(
                  upcomingMatches,
                  isDesktop,
                  'Geen aankomende wedstrijden',
                  isViewOnly,
                ),
                _buildMatchList(
                  completedMatches,
                  isDesktop,
                  'Geen afgelopen wedstrijden',
                  isViewOnly,
                ),
                _buildMatchList(
                  allMatches,
                  isDesktop,
                  'Geen wedstrijden',
                  isViewOnly,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: (isDesktop || isViewOnly)
          ? null
          : FloatingActionButton(
              onPressed: () {
                unawaited(_analytics.log(AnalyticsEvent.trainingCreate,
                    parameters: {'entity': 'match', 'source': 'fab'}));
                context.go('/matches/add');
              },
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildMatchList(
    List<Match> matches,
    bool isDesktop,
    String emptyMessage,
    bool isViewOnly,
  ) {
    if (matches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_soccer, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(emptyMessage, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (!isViewOnly)
              ElevatedButton.icon(
                onPressed: () => context.go('/matches/add'),
                icon: const Icon(Icons.add),
                label: const Text('Voeg wedstrijd toe'),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(matchesNotifierProvider.notifier).loadMatches();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,
        cacheExtent: 300,
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return _MatchCard(
            match: match,
            onTap: () => context.go('/matches/${match.id}'),
          );
        },
      ),
    );
  }

  Future<void> _importCsv() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result == null || result.files.single.bytes == null) return;

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Importeren…')),
    );

    final service = ScheduleImportService(ref.read(matchRepositoryProvider));
    final res = await service.importCsvBytes(result.files.single.bytes!);

    if (!mounted) return;
    final report = res.dataOrNull;
    if (report == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Import mislukt'), backgroundColor: Colors.red),
      );
      return;
    }

    final color = report.hasErrors ? Colors.orange : Colors.green;
    final msg =
        'Geïmporteerd: ${report.imported}. Errors: ${report.errors.length}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );

    // Refresh match list
    await ref.read(matchesNotifierProvider.notifier).loadMatches();
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.match, required this.onTap});
  final Match match;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isCompleted = match.status == MatchStatus.completed;
    final hasScore = match.teamScore != null && match.opponentScore != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                  // Date and Time
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('dd').format(match.date),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('MMM').format(match.date),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Match Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildLocationBadge(match.location),
                            const SizedBox(width: 8),
                            _buildCompetitionBadge(match.competition),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          match.opponent,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                match.venue ?? 'Locatie onbekend',
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Score or Time
                  if (isCompleted && hasScore)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _getResultColor(match),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${match.teamScore} - ${match.opponentScore}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            _getResultText(match),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('HH:mm').format(match.date),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _getStatusText(match.status),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationBadge(Location location) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: location == Location.home ? Colors.green : Colors.blue,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          location == Location.home ? 'THUIS' : 'UIT',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _buildCompetitionBadge(Competition competition) {
    String text;
    Color color;

    switch (competition) {
      case Competition.league:
        text = 'COMPETITIE';
        color = Colors.purple;
      case Competition.cup:
        text = 'BEKER';
        color = Colors.orange;
      case Competition.friendly:
        text = 'VRIENDSCHAPPELIJK';
        color = Colors.grey;
      case Competition.tournament:
        text = 'TOERNOOI';
        color = Colors.indigo;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getResultColor(Match match) {
    if (match.teamScore == null || match.opponentScore == null) {
      return Colors.grey;
    }

    if (match.teamScore! > match.opponentScore!) {
      return Colors.green;
    } else if (match.teamScore! < match.opponentScore!) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  String _getResultText(Match match) {
    if (match.teamScore == null || match.opponentScore == null) {
      return '';
    }

    if (match.teamScore! > match.opponentScore!) {
      return 'Gewonnen';
    } else if (match.teamScore! < match.opponentScore!) {
      return 'Verloren';
    } else {
      return 'Gelijk';
    }
  }

  String _getStatusText(MatchStatus status) {
    switch (status) {
      case MatchStatus.scheduled:
        return 'Gepland';
      case MatchStatus.inProgress:
        return 'Live';
      case MatchStatus.completed:
        return 'Afgelopen';
      case MatchStatus.cancelled:
        return 'Afgelast';
      case MatchStatus.postponed:
        return 'Uitgesteld';
    }
  }
}
