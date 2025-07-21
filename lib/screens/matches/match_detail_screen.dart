// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Project imports:
import '../../models/match.dart';
import '../../models/player.dart';
import '../../providers/matches_provider.dart';
import '../../providers/players_provider.dart';
import '../../providers/pdf/pdf_generators_providers.dart';
import '../../utils/share_pdf_utils.dart';
import '../../providers/auth_provider.dart';
import '../../services/permission_service.dart';
import '../../widgets/highlight_gallery.dart';

class MatchDetailScreen extends ConsumerStatefulWidget {
  const MatchDetailScreen({required this.matchId, super.key});
  final String matchId;

  @override
  ConsumerState<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends ConsumerState<MatchDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _teamScoreController;
  late TextEditingController _opponentScoreController;

  List<String> _selectedStartingLineup = [];
  List<String> _selectedSubstitutes = [];

  // Determines if the current user is allowed to manage (edit) match data.
  bool get canManage {
    final userRole = ref.watch(userRoleProvider);
    return !PermissionService.isViewOnlyUser(userRole);
  }

  @override
  void initState() {
    super.initState();
    _teamScoreController = TextEditingController();
    _opponentScoreController = TextEditingController();
  }

  @override
  void dispose() {
    _teamScoreController.dispose();
    _opponentScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matchesAsync = ref.watch(matchesProvider);
    final playersAsync = ref.watch(playersProvider);
    final userRole = ref.watch(userRoleProvider);
    final canManage = !PermissionService.isViewOnlyUser(userRole);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wedstrijd Details'),
        actions: [
          if (canManage) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.go('/matches/${widget.matchId}/edit');
              },
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Exporteer PDF',
              onPressed: _exportPdf,
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveMatch,
              tooltip: 'Opslaan',
            ),
          ],
        ],
      ),
      body: matchesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Fout: $error')),
        data: (matches) {
          final match = matches.firstWhere(
            (m) => m.id == widget.matchId,
            orElse: () => Match()
              ..date = DateTime.now()
              ..opponent = ''
              ..location = Location.home
              ..competition = Competition.league
              ..status = MatchStatus.scheduled,
          );

          if (match.id == '0') {
            return const Center(child: Text('Wedstrijd niet gevonden'));
          }

          // Initialize controllers with existing data
          if (_teamScoreController.text.isEmpty && match.teamScore != null) {
            _teamScoreController.text = match.teamScore.toString();
          }
          if (_opponentScoreController.text.isEmpty &&
              match.opponentScore != null) {
            _opponentScoreController.text = match.opponentScore.toString();
          }
          if (_selectedStartingLineup.isEmpty &&
              match.startingLineupIds.isNotEmpty) {
            _selectedStartingLineup = List.from(match.startingLineupIds);
          }
          if (_selectedSubstitutes.isEmpty && match.substituteIds.isNotEmpty) {
            _selectedSubstitutes = List.from(match.substituteIds);
          }

          return playersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Fout: $error')),
            data: (players) => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMatchInfo(match),
                    const SizedBox(height: 24),
                    _buildScoreSection(match),
                    const SizedBox(height: 24),
                    _buildLineupSection(players),
                    const SizedBox(height: 24),
                    _buildSubstitutesSection(players),
                    const SizedBox(height: 24),
                    _buildHighlightsSection(widget.matchId),
                    // Performance Ratings for completed matches
                    if (match.status == MatchStatus.completed) ...[
                      const SizedBox(height: 24),
                      _buildRatingsSection(match, players),
                    ],
                    // Action Buttons
                    if (match.status == MatchStatus.scheduled) ...[
                      const SizedBox(height: 24),
                      if (canManage)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    context.go('/lineup?matchId=${match.id}'),
                                icon: const Icon(Icons.people),
                                label: const Text('Opstelling Maken'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _showScoreDialog(context, match),
                                icon: const Icon(Icons.sports_score),
                                label: const Text('Score Invoeren'),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildMatchInfo(Match match) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wedstrijd Informatie',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildInfoRow('Tegenstander', match.opponent),
              _buildInfoRow(
                'Datum',
                DateFormat('dd-MM-yyyy HH:mm').format(match.date),
              ),
              _buildInfoRow(
                'Locatie',
                match.location == Location.home ? 'Thuis' : 'Uit',
              ),
              _buildInfoRow(
                'Competitie',
                _getCompetitionName(match.competition),
              ),
              _buildInfoRow('Status', _getStatusName(match.status)),
            ],
          ),
        ),
      );

  Widget _buildInfoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                '$label:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );

  Widget _buildScoreSection(Match match) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Score', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _teamScoreController,
                      decoration: const InputDecoration(
                        labelText: 'JO17',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('-', style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _opponentScoreController,
                      decoration: InputDecoration(
                        labelText: match.opponent,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildLineupSection(List<Player> players) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Basisopstelling',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    onPressed: canManage
                        ? () => _showPlayerSelection(
                              context,
                              players,
                              _selectedStartingLineup,
                              'Basisopstelling',
                              11,
                            )
                        : null,
                    icon: const Icon(Icons.add),
                    label: const Text('Selecteer'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_selectedStartingLineup.isEmpty)
                const Text('Geen spelers geselecteerd')
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedStartingLineup.map((playerId) {
                    final player = players.firstWhere(
                      (p) => p.id == playerId,
                      orElse: () => Player()
                        ..firstName = 'Onbekend'
                        ..lastName = ''
                        ..jerseyNumber = 0
                        ..birthDate = DateTime.now()
                        ..position = Position.midfielder
                        ..preferredFoot = PreferredFoot.right
                        ..height = 0
                        ..weight = 0,
                    );
                    return Chip(
                      label: Text('${player.jerseyNumber} - ${player.name}'),
                      onDeleted: () {
                        setState(() {
                          _selectedStartingLineup.remove(playerId);
                        });
                      },
                      backgroundColor:
                          _getPositionColor(player.position).withAlpha(50),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      );

  Widget _buildSubstitutesSection(List<Player> players) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Wisselspelers',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    onPressed: canManage
                        ? () => _showPlayerSelection(
                              context,
                              players,
                              _selectedSubstitutes,
                              'Wisselspelers',
                              7,
                            )
                        : null,
                    icon: const Icon(Icons.add),
                    label: const Text('Selecteer'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_selectedSubstitutes.isEmpty)
                const Text('Geen wisselspelers geselecteerd')
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedSubstitutes.map((playerId) {
                    final player = players.firstWhere(
                      (p) => p.id == playerId,
                      orElse: () => Player()
                        ..firstName = 'Onbekend'
                        ..lastName = ''
                        ..jerseyNumber = 0
                        ..birthDate = DateTime.now()
                        ..position = Position.midfielder
                        ..preferredFoot = PreferredFoot.right
                        ..height = 0
                        ..weight = 0,
                    );
                    return Chip(
                      label: Text('${player.jerseyNumber} - ${player.name}'),
                      onDeleted: () {
                        setState(() {
                          _selectedSubstitutes.remove(playerId);
                        });
                      },
                      backgroundColor: Colors.grey.withAlpha(50),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      );

  Widget _buildRatingsSection(Match match, List<Player> players) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Speler Beoordelingen',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                onPressed: canManage ? _showRatingOptions : null,
                icon: const Icon(Icons.star),
                label: const Text('Beoordeel'),
              ),
              const SizedBox(height: 16),
              // Show existing ratings or placeholder
              const Text('Klik op "Beoordeel" om spelers te beoordelen'),
            ],
          ),
        ),
      );

  Widget _buildHighlightsSection(String matchId) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Highlights',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              HighlightGallery(matchId: matchId),
            ],
          ),
        ),
      );

  void _showPlayerSelection(
    BuildContext context,
    List<Player> players,
    List<String> selectedPlayers,
    String title,
    int maxSelection,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                Text('Selecteer maximaal $maxSelection spelers'),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      final isSelected = selectedPlayers.contains(player.id);
                      final canSelect =
                          selectedPlayers.length < maxSelection || isSelected;

                      return CheckboxListTile(
                        title: Text(player.name),
                        subtitle: Text(
                          '${player.jerseyNumber} - ${_getPositionText(player.position)}',
                        ),
                        value: isSelected,
                        onChanged: canSelect
                            ? (bool? value) {
                                setState(() {
                                  if (value ?? false) {
                                    selectedPlayers.add(player.id);
                                  } else {
                                    selectedPlayers.remove(player.id);
                                  }
                                });
                              }
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuleren'),
            ),
            ElevatedButton(
              onPressed: () {
                this.setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Opslaan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showScoreDialog(BuildContext context, Match match) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Score Invoeren'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _teamScoreController,
                    decoration: const InputDecoration(
                      labelText: 'JO17',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 16),
                const Text('-'),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _opponentScoreController,
                    decoration: InputDecoration(
                      labelText: match.opponent,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuleren'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveMatch();
            },
            child: const Text('Opslaan'),
          ),
        ],
      ),
    );
  }

  void _showRatingOptions() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Speler Beoordelingen'),
        content: const Text('Selecteer spelers om te beoordelen'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Sluiten'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveMatch() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final matchesAsync = ref.read(matchesProvider);
      final matches = matchesAsync.value ?? [];

      final matchIndex = matches.indexWhere((m) => m.id == widget.matchId);
      if (matchIndex == -1) return;

      final match = matches[matchIndex];

      final repo = ref.read(matchRepositoryProvider);
      match
        ..teamScore = int.tryParse(_teamScoreController.text)
        ..opponentScore = int.tryParse(_opponentScoreController.text)
        ..startingLineupIds = _selectedStartingLineup
        ..substituteIds = _selectedSubstitutes;

      final res = await repo.update(match);
      if (!res.isSuccess) throw Exception(res.errorOrNull);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wedstrijd opgeslagen'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout bij opslaan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportPdf() async {
    final matchAsync = ref.read(matchesProvider);
    matchAsync.whenData((matches) async {
      final match = matches.firstWhere(
        (m) => m.id == widget.matchId,
        orElse: Match.new,
      );
      if (match.id.isEmpty) return;

      final generator = ref.read(matchReportPdfGeneratorProvider);
      final bytes = await generator.generate(match);
      final filename = 'match_report_${match.id}.pdf';
      if (mounted) {
        await SharePdfUtils.sharePdf(bytes, filename, context);
      }
    });
  }

  String _getCompetitionName(Competition competition) {
    switch (competition) {
      case Competition.league:
        return 'Competitie';
      case Competition.cup:
        return 'Beker';
      case Competition.friendly:
        return 'Vriendschappelijk';
      case Competition.tournament:
        return 'Toernooi';
    }
  }

  String _getStatusName(MatchStatus status) {
    switch (status) {
      case MatchStatus.scheduled:
        return 'Gepland';
      case MatchStatus.inProgress:
        return 'Bezig';
      case MatchStatus.completed:
        return 'Afgerond';
      case MatchStatus.cancelled:
        return 'Geannuleerd';
      case MatchStatus.postponed:
        return 'Uitgesteld';
    }
  }

  String _getPositionText(Position position) {
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

  Color _getPositionColor(Position position) {
    switch (position) {
      case Position.goalkeeper:
        return Colors.blue;
      case Position.defender:
        return Colors.green;
      case Position.midfielder:
        return Colors.orange;
      case Position.forward:
        return Colors.red;
    }
  }
}
