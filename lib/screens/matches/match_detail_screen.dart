import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../models/match.dart';
import '../../models/performance_rating.dart';
import '../../models/player.dart';
import '../../providers/database_provider.dart';
import '../../services/database_service.dart';
import '../../widgets/common/rating_dialog.dart';

class MatchDetailScreen extends ConsumerStatefulWidget {
  const MatchDetailScreen({
    super.key,
    required this.matchId,
  });
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wedstrijd Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.go('/matches/${widget.matchId}/edit');
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveMatch,
            tooltip: 'Opslaan',
          ),
        ],
      ),
      body: matchesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Fout: $error')),
        data: (matches) {
          final match = matches.firstWhere(
            (m) => m.id.toString() == widget.matchId,
            orElse: () {
              final newMatch = Match();
              newMatch.date = DateTime.now();
              newMatch.opponent = '';
              newMatch.location = Location.home;
              newMatch.competition = Competition.league;
              newMatch.status = MatchStatus.scheduled;
              return newMatch;
            },
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
                    // Performance Ratings for completed matches
                    if (match.status == MatchStatus.completed) ...[
                      const SizedBox(height: 24),
                      _buildRatingsSection(match, players),
                    ],
                    // Action Buttons
                    if (match.status == MatchStatus.scheduled) ...[
                      const SizedBox(height: 24),
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
                              onPressed: () => _showScoreDialog(context, match),
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
                  'Datum', DateFormat('dd-MM-yyyy HH:mm').format(match.date),),
              _buildInfoRow(
                  'Locatie', match.location == Location.home ? 'Thuis' : 'Uit',),
              _buildInfoRow(
                  'Competitie', _getCompetitionName(match.competition),),
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
              Text(
                'Score',
                style: Theme.of(context).textTheme.titleLarge,
              ),
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
                  Text(
                    '-',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
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
              if (match.result != null) ...[
                const SizedBox(height: 8),
                Center(
                  child: Chip(
                    label: Text(
                      _getResultName(match.result!),
                      style: TextStyle(
                        color: _getResultColor(match.result!),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor:
                        _getResultColor(match.result!).withValues(alpha: 0.2),
                  ),
                ),
              ],
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
                    'Opstelling (${_selectedStartingLineup.length}/11)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    onPressed: () => _showPlayerSelectionDialog(players, true),
                    icon: const Icon(Icons.add),
                    label: const Text('Selecteer'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_selectedStartingLineup.isEmpty)
                const Text(
                  'Nog geen spelers geselecteerd',
                  style: TextStyle(fontStyle: FontStyle.italic),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedStartingLineup.map((playerId) {
                    final player = players.firstWhere(
                      (p) => p.id.toString() == playerId,
                      orElse: () {
                        final newPlayer = Player();
                        newPlayer.firstName = 'Onbekend';
                        newPlayer.lastName = '';
                        newPlayer.jerseyNumber = 0;
                        newPlayer.birthDate = DateTime.now();
                        newPlayer.position = Position.midfielder;
                        newPlayer.preferredFoot = PreferredFoot.right;
                        newPlayer.height = 0;
                        newPlayer.weight = 0;
                        return newPlayer;
                      },
                    );
                    return Chip(
                      label: Text('${player.jerseyNumber}. ${player.name}'),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          _selectedStartingLineup.remove(playerId);
                        });
                      },
                      backgroundColor: _getPositionColor(player.position)
                          .withValues(alpha: 0.2),
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
                    'Wisselspelers (${_selectedSubstitutes.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    onPressed: () => _showPlayerSelectionDialog(players, false),
                    icon: const Icon(Icons.add),
                    label: const Text('Selecteer'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_selectedSubstitutes.isEmpty)
                const Text(
                  'Nog geen wisselspelers geselecteerd',
                  style: TextStyle(fontStyle: FontStyle.italic),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedSubstitutes.map((playerId) {
                    final player = players.firstWhere(
                      (p) => p.id.toString() == playerId,
                      orElse: () {
                        final newPlayer = Player();
                        newPlayer.firstName = 'Onbekend';
                        newPlayer.lastName = '';
                        newPlayer.jerseyNumber = 0;
                        newPlayer.birthDate = DateTime.now();
                        newPlayer.position = Position.midfielder;
                        newPlayer.preferredFoot = PreferredFoot.right;
                        newPlayer.height = 0;
                        newPlayer.weight = 0;
                        return newPlayer;
                      },
                    );
                    return Chip(
                      label: Text('${player.jerseyNumber}. ${player.name}'),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          _selectedSubstitutes.remove(playerId);
                        });
                      },
                      backgroundColor: Colors.grey.withValues(alpha: 0.2),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      );

  void _showPlayerSelectionDialog(List<Player> players, bool isStartingLineup) {
    final selectedPlayers =
        isStartingLineup ? _selectedStartingLineup : _selectedSubstitutes;
    final otherPlayers =
        isStartingLineup ? _selectedSubstitutes : _selectedStartingLineup;

    // Filter out players already selected
    final availablePlayers = players.where((player) {
      final playerId = player.id.toString();
      return !selectedPlayers.contains(playerId) &&
          !otherPlayers.contains(playerId);
    }).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isStartingLineup
            ? 'Selecteer Spelers voor Opstelling'
            : 'Selecteer Wisselspelers',),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: availablePlayers.length,
            itemBuilder: (context, index) {
              final player = availablePlayers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getPositionColor(player.position),
                  child: Text(
                    player.jerseyNumber.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(player.name),
                subtitle: Text(_getPositionName(player.position)),
                onTap: () {
                  setState(() {
                    if (isStartingLineup && selectedPlayers.length < 11) {
                      selectedPlayers.add(player.id.toString());
                    } else if (!isStartingLineup) {
                      selectedPlayers.add(player.id.toString());
                    }
                  });
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
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
    if (_formKey.currentState!.validate()) {
      try {
        // TODO(author): Implement actual save functionality
        // final dbService = ref.read(databaseServiceProvider);
        // final teamScore = int.tryParse(_teamScoreController.text);
        // final opponentScore = int.tryParse(_opponentScoreController.text);
        // await dbService.updateMatch(
        //   matchId: widget.matchId,
        //   teamScore: teamScore,
        //   opponentScore: opponentScore,
        //   startingLineupIds: _selectedStartingLineup,
        //   substituteIds: _selectedSubstitutes,
        // );

        if (mounted && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wedstrijd opgeslagen')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fout bij opslaan: $e')),
          );
        }
      }
    }
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
        return 'Afgelopen';
      case MatchStatus.cancelled:
        return 'Geannuleerd';
      case MatchStatus.postponed:
        return 'Uitgesteld';
    }
  }

  String _getResultName(MatchResult result) {
    switch (result) {
      case MatchResult.win:
        return 'Gewonnen';
      case MatchResult.draw:
        return 'Gelijk';
      case MatchResult.loss:
        return 'Verloren';
    }
  }

  Color _getResultColor(MatchResult result) {
    switch (result) {
      case MatchResult.win:
        return Colors.green;
      case MatchResult.draw:
        return Colors.orange;
      case MatchResult.loss:
        return Colors.red;
    }
  }

  String _getPositionName(Position position) {
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
        return Colors.orange;
      case Position.defender:
        return Colors.blue;
      case Position.midfielder:
        return Colors.green;
      case Position.forward:
        return Colors.red;
    }
  }

  Widget _buildRatingsSection(Match match, List<Player> players) {
    // Get players who participated in the match
    final participatingPlayers = players.where((player) {
      final playerId = player.id.toString();
      return _selectedStartingLineup.contains(playerId) ||
          _selectedSubstitutes.contains(playerId);
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Speler Beoordelingen',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                FilledButton.icon(
                  onPressed: participatingPlayers.isEmpty
                      ? null
                      : () => _showRatingOptions(match, participatingPlayers),
                  icon: const Icon(Icons.star),
                  label: const Text('Beoordeel Spelers'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (participatingPlayers.isEmpty)
              const Text(
                'Selecteer eerst spelers in de opstelling om beoordelingen te geven',
                style: TextStyle(fontStyle: FontStyle.italic),
              )
            else
              Text(
                '${participatingPlayers.length} spelers kunnen beoordeeld worden',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }

  void _showRatingOptions(Match match, List<Player> players) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Beoordeel Spelers',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getPositionColor(player.position),
                      child: Text(
                        player.jerseyNumber.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(player.name),
                    subtitle: Text(_getPositionName(player.position)),
                    trailing: const Icon(Icons.star_outline),
                    onTap: () {
                      // Close the bottom sheet first
                      Navigator.of(context).pop();

                      // Show the rating dialog after a small delay to ensure the bottom sheet is closed
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        if (!mounted) return;

                        final result = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => RatingDialog(
                            player: player,
                            matchId: match.id.toString(),
                            type: RatingType.match,
                          ),
                        );

                        if (result == true && mounted && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Beoordeling opgeslagen voor ${player.name}',),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showScoreDialog(BuildContext context, Match match) {
    final teamScoreController = TextEditingController(
      text: match.teamScore?.toString() ?? '',
    );
    final opponentScoreController = TextEditingController(
      text: match.opponentScore?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Score Invoeren'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: teamScoreController,
                    decoration: const InputDecoration(
                      labelText: 'JO17',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    autofocus: true,
                  ),
                ),
                const SizedBox(width: 16),
                const Text('-', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: opponentScoreController,
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
            onPressed: () async {
              final teamScore = int.tryParse(teamScoreController.text);
              final opponentScore = int.tryParse(opponentScoreController.text);

              if (teamScore != null && opponentScore != null) {
                match.teamScore = teamScore;
                match.opponentScore = opponentScore;
                match.status = MatchStatus.completed;

                await DatabaseService().updateMatch(match);

                if (mounted && context.mounted) {
                  Navigator.of(context).pop();
                  setState(() {
                    _teamScoreController.text = teamScore.toString();
                    _opponentScoreController.text = opponentScore.toString();
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Score opgeslagen'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Opslaan'),
          ),
        ],
      ),
    );
  }
}
