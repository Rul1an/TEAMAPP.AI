// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../compat/share_plus_compat.dart';

// Project imports:
import '../../models/performance_rating.dart';
import '../../models/player.dart';
import '../../models/training.dart';
import '../../providers/players_provider.dart';
import '../../providers/trainings_provider.dart';
import '../../widgets/common/rating_dialog.dart';
import '../../providers/pdf/pdf_generators_providers.dart';
import '../../utils/share_pdf_utils.dart';
import '../../models/training_session/training_session.dart';
import '../../providers/auth_provider.dart';
import '../../services/permission_service.dart';
import '../../services/deep_link_service.dart';
import '../../services/analytics_service.dart';

class TrainingAttendanceScreen extends ConsumerStatefulWidget {
  const TrainingAttendanceScreen({required this.trainingId, super.key});
  final String trainingId;

  @override
  ConsumerState<TrainingAttendanceScreen> createState() =>
      _TrainingAttendanceScreenState();
}

class _TrainingAttendanceScreenState
    extends ConsumerState<TrainingAttendanceScreen> {
  final Map<String, AttendanceStatus> _attendance = {};
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final trainingsAsync = ref.watch(trainingsProvider);
    final playersAsync = ref.watch(playersProvider);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    final userRole = ref.watch(userRoleProvider);
    final canManage = !PermissionService.isViewOnlyUser(userRole);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Aanwezigheid'),
        actions: [
          // Share deep-link available for all roles
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Deel training',
            onPressed: _shareTraining,
          ),
          if (canManage) ...[
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Export PDF',
              onPressed: () => _exportPdf(ref),
            ),
            IconButton(
              icon: const Icon(Icons.star),
              onPressed: _showRatingOptions,
              tooltip: 'Beoordeel Spelers',
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _isLoading ? null : _saveAttendance,
            ),
          ],
        ],
      ),
      body: trainingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Fout: $error')),
        data: (trainings) {
          final training = trainings.firstWhere(
            (t) => t.id == widget.trainingId,
            orElse: Training.new,
          );
          if (training.id.isEmpty) {
            return const Center(child: Text('Training niet gevonden'));
          }

          return Column(
            children: [
              _buildTrainingHeader(training),
              Expanded(
                child: playersAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Fout: $error')),
                  data: (players) {
                    // Sort players by jersey number
                    final sortedPlayers = List<Player>.from(
                      players,
                    )..sort((a, b) => a.jerseyNumber.compareTo(b.jerseyNumber));

                    return isDesktop
                        ? _buildDesktopLayout(sortedPlayers)
                        : _buildMobileLayout(sortedPlayers);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: isDesktop
          ? null
          : canManage
              ? FloatingActionButton(
                  onPressed: () => context.go('/training/add'),
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }

  Widget _buildTrainingHeader(Training training) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.fitness_center,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE d MMMM yyyy', 'nl_NL')
                        .format(training.date),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Chip(
                        label: Text(_getFocusText(training.focus)),
                        backgroundColor: _getFocusColor(
                          training.focus,
                        ).withValues(alpha: 0.2),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(_getIntensityText(training.intensity)),
                        backgroundColor: _getIntensityColor(
                          training.intensity,
                        ).withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '${_attendance.values.where((s) => s == AttendanceStatus.present).length}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Text('Aanwezig'),
              ],
            ),
          ],
        ),
      );

  Widget _buildDesktopLayout(List<Player> players) => GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          childAspectRatio: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          return _buildPlayerAttendanceCard(player);
        },
      );

  Widget _buildMobileLayout(List<Player> players) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildPlayerAttendanceCard(player),
          );
        },
      );

  Widget _buildPlayerAttendanceCard(Player player) {
    final status = _attendance[player.id] ?? AttendanceStatus.unknown;

    return Card(
      child: InkWell(
        onTap: () {
          setState(() {
            _attendance[player.id] = _getNextStatus(status);
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  player.jerseyNumber.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _getPositionText(player.position),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              _buildStatusButton(status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(AttendanceStatus status) {
    final color = _getStatusColor(status);
    final icon = _getStatusIcon(status);
    final text = _getStatusText(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  AttendanceStatus _getNextStatus(AttendanceStatus current) {
    switch (current) {
      case AttendanceStatus.unknown:
        return AttendanceStatus.present;
      case AttendanceStatus.present:
        return AttendanceStatus.absent;
      case AttendanceStatus.absent:
        return AttendanceStatus.injured;
      case AttendanceStatus.injured:
        return AttendanceStatus.late;
      case AttendanceStatus.late:
        return AttendanceStatus.unknown;
    }
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.injured:
        return Colors.orange;
      case AttendanceStatus.late:
        return Colors.blue;
      case AttendanceStatus.unknown:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.absent:
        return Icons.cancel;
      case AttendanceStatus.injured:
        return Icons.local_hospital;
      case AttendanceStatus.late:
        return Icons.access_time;
      case AttendanceStatus.unknown:
        return Icons.help_outline;
    }
  }

  String _getStatusText(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'Aanwezig';
      case AttendanceStatus.absent:
        return 'Afwezig';
      case AttendanceStatus.injured:
        return 'Geblesseerd';
      case AttendanceStatus.late:
        return 'Te laat';
      case AttendanceStatus.unknown:
        return 'Onbekend';
    }
  }

  String _getFocusText(TrainingFocus focus) {
    switch (focus) {
      case TrainingFocus.technical:
        return 'Techniek';
      case TrainingFocus.tactical:
        return 'Tactiek';
      case TrainingFocus.physical:
        return 'Fysiek';
      case TrainingFocus.mental:
        return 'Mentaal';
      case TrainingFocus.matchPrep:
        return 'Wedstrijdvoorbereiding';
    }
  }

  Color _getFocusColor(TrainingFocus focus) {
    switch (focus) {
      case TrainingFocus.technical:
        return Colors.blue;
      case TrainingFocus.tactical:
        return Colors.purple;
      case TrainingFocus.physical:
        return Colors.orange;
      case TrainingFocus.mental:
        return Colors.teal;
      case TrainingFocus.matchPrep:
        return Colors.green;
    }
  }

  String _getIntensityText(TrainingIntensity intensity) {
    switch (intensity) {
      case TrainingIntensity.low:
        return 'Laag';
      case TrainingIntensity.medium:
        return 'Gemiddeld';
      case TrainingIntensity.high:
        return 'Hoog';
      case TrainingIntensity.recovery:
        return 'Herstel';
    }
  }

  Color _getIntensityColor(TrainingIntensity intensity) {
    switch (intensity) {
      case TrainingIntensity.low:
        return Colors.green;
      case TrainingIntensity.medium:
        return Colors.orange;
      case TrainingIntensity.high:
        return Colors.red;
      case TrainingIntensity.recovery:
        return Colors.blue;
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

  void _showRatingOptions() {
    ref.read(playersProvider).whenData((players) {
      final presentPlayers = players.where((player) {
        final status = _attendance[player.id];
        return status == AttendanceStatus.present ||
            status == AttendanceStatus.late;
      }).toList();

      if (presentPlayers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Markeer eerst aanwezige spelers om beoordelingen te geven',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      showModalBottomSheet<void>(
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
                      'Beoordeel Aanwezige Spelers',
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
                  itemCount: presentPlayers.length,
                  itemBuilder: (context, index) {
                    final player = presentPlayers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          player.jerseyNumber.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(player.name),
                      subtitle: Text(_getPositionText(player.position)),
                      trailing: const Icon(Icons.star_outline),
                      onTap: () async {
                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);

                        navigator.pop();

                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => RatingDialog(
                            player: player,
                            trainingId: widget.trainingId,
                            type: RatingType.training,
                          ),
                        );

                        if (!mounted) return;

                        if (result ?? false) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Beoordeling opgeslagen voor ${player.name}',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _saveAttendance() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO(author): Save attendance to database
      // For now, just update player statistics
      final players = ref.read(playersProvider).value ?? [];

      for (final entry in _attendance.entries) {
        final playerId = entry.key;
        final status = entry.value;

        final player = players.firstWhere(
          (p) => p.id == playerId,
          orElse: Player.new,
        );

        if (player.id != '') {
          // Update player training statistics using cascade
          final wasPresent = status == AttendanceStatus.present ||
              status == AttendanceStatus.late;

          player
            ..trainingsTotal = player.trainingsTotal + 1
            ..trainingsAttended =
                player.trainingsAttended + (wasPresent ? 1 : 0);

          // Save to database
          final playerRepo = ref.read(playerRepositoryProvider);
          await playerRepo.update(player);
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aanwezigheid opgeslagen'),
            backgroundColor: Colors.green,
          ),
        );
        // Remain on the current screen so the user can continue working.
        // Navigating away immediately after saving caused integration tests to fail
        // and disrupted the UX when users want to verify their changes.
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _exportPdf(WidgetRef ref) async {
    final trainings = ref.read(trainingsProvider).value;
    if (trainings == null) return;
    final training = trainings.firstWhere(
      (t) => t.id == widget.trainingId,
      orElse: Training.new,
    );
    if (training.id.isEmpty) return;

    final players = ref.read(playersProvider).value ?? [];
    final generator = ref.read(trainingSessionPdfGeneratorProvider);
    final bytes = await generator.generate(
      (
        TrainingSession.create(
          teamId: 'team',
          date: training.date,
          trainingNumber: 1,
        ),
        players,
      ),
    );
    if (!mounted) return;
    await SharePdfUtils.sharePdf(
      bytes,
      'training_${training.id}.pdf',
      context,
    );
  }

  Future<void> _shareTraining() async {
    final link = DeepLinkService.instance.createTrainingLink(widget.trainingId);
    await AnalyticsService.instance.logEvent(
      'share_training',
      parameters: {'training_id': widget.trainingId},
    );
    try {
      await SharePlus.instance.share(
        ShareParams(text: link.toString()),
      );
    } catch (_) {
      // In tests, the share_plus MethodChannel may not be registered.
    }
  }
}

enum AttendanceStatus { present, absent, injured, late, unknown }
