import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/player.dart';
import '../../providers/export_service_provider.dart';
import '../../providers/players_provider.dart';
import '../../services/import_service.dart';
import '../../utils/colors.dart';

class PlayersScreen extends ConsumerStatefulWidget {
  const PlayersScreen({super.key});

  @override
  ConsumerState<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends ConsumerState<PlayersScreen> {
  String _searchQuery = '';
  Position? _selectedPosition;

  late final ImportService _importService;

  @override
  void initState() {
    super.initState();
    _importService = ImportService(ref.read(playerRepositoryProvider));
  }

  Future<void> _importPlayers() async {
    final result = await _importService.importPlayers();

    if (!mounted) return;

    if (result.success) {
      // Refresh players list
      ref.invalidate(playersProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.green,
        ),
      );

      // Show errors if any
      if (result.errors.isNotEmpty) {
        unawaited(
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Import waarschuwingen'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children:
                      result.errors.map((error) => Text('• $error')).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportPlayers() async {
    final players = ref.read(playersProvider).valueOrNull ?? [];

    if (players.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Geen spelers om te exporteren'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    await ref.read(exportServiceProvider).exportPlayersToExcel(players);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Spelers geëxporteerd'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _downloadTemplate() async {
    await _importService.generatePlayerTemplate();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Template gedownload'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playersAsync = ref.watch(playersProvider);
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spelers'),
        actions: [
          // Duidelijke import knop
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Importeer spelers',
            onPressed: _importPlayers,
          ),
          // Menu voor meer opties
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Meer opties',
            onSelected: (value) async {
              switch (value) {
                case 'import':
                  await _importPlayers();
                  break;
                case 'export':
                  await _exportPlayers();
                  break;
                case 'template':
                  await _downloadTemplate();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'import',
                child: ListTile(
                  leading: Icon(Icons.upload_file, size: 20),
                  title: Text('Importeer spelers'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: Icon(Icons.download, size: 20),
                  title: Text('Exporteer spelers'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'template',
                child: ListTile(
                  leading: Icon(Icons.description, size: 20),
                  title: Text('Download template'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => context.go('/players/add'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
            child: Row(
              children: [
                Expanded(
                  flex: isDesktop ? 3 : 1,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Zoek op naam of rugnummer...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                if (isTablet) ...[
                  const SizedBox(width: 16),
                  Flexible(
                    child: DropdownButtonFormField<Position?>(
                      value: _selectedPosition,
                      decoration: InputDecoration(
                        labelText: 'Positie',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                      items: [
                        const DropdownMenuItem(
                          child: Text('Alle posities'),
                        ),
                        ...Position.values.map(
                          (position) => DropdownMenuItem(
                            value: position,
                            child: Text(_getPositionText(position)),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPosition = value;
                        });
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Position filter chips for mobile
          if (!isTablet)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  FilterChip(
                    label: const Text('Alle'),
                    selected: _selectedPosition == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedPosition = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ...Position.values.map(
                    (position) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(_getPositionText(position)),
                        selected: _selectedPosition == position,
                        onSelected: (selected) {
                          setState(() {
                            _selectedPosition = selected ? position : null;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          // Players Grid/List
          Expanded(
            child: playersAsync.when(
              data: (players) {
                final filteredPlayers = players.where((player) {
                  final fullName =
                      '${player.firstName} ${player.lastName}'.toLowerCase();
                  final matchesSearch = _searchQuery.isEmpty ||
                      fullName.contains(_searchQuery) ||
                      player.jerseyNumber.toString().contains(_searchQuery);
                  final matchesPosition = _selectedPosition == null ||
                      player.position == _selectedPosition;
                  return matchesSearch && matchesPosition;
                }).toList();

                if (filteredPlayers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Geen spelers gevonden',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () => context.go('/players/add'),
                          icon: const Icon(Icons.person_add),
                          label: const Text('Voeg eerste speler toe'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(playersProvider);
                  },
                  child: isDesktop
                      ? GridView.builder(
                          padding: const EdgeInsets.all(24),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 400,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: filteredPlayers.length,
                          itemBuilder: (context, index) {
                            final player = filteredPlayers[index];
                            return _PlayerCard(
                              player: player,
                              onTap: () => context.go('/players/${player.id}'),
                            );
                          },
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(isTablet ? 24 : 16),
                          itemCount: filteredPlayers.length,
                          itemBuilder: (context, index) {
                            final player = filteredPlayers[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _PlayerCard(
                                player: player,
                                onTap: () =>
                                    context.go('/players/${player.id}'),
                              ),
                            );
                          },
                        ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Er ging iets mis',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(error.toString()),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(playersProvider),
                      child: const Text('Probeer opnieuw'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isDesktop
          ? null
          : FloatingActionButton(
              onPressed: () => context.go('/players/add'),
              child: const Icon(Icons.person_add),
            ),
    );
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
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({
    required this.player,
    required this.onTap,
  });
  final Player player;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: getPositionColor(player.position),
                  child: Text(
                    player.jerseyNumber.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${player.firstName} ${player.lastName}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getPositionText(player.position),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.sports_soccer,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${player.matchesPlayed} wedstrijden',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.sports_score,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${player.goals} goals',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      );

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
}
