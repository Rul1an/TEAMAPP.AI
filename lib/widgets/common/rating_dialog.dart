// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../models/performance_rating.dart';
import '../../models/player.dart';
import '../../providers/performance_ratings_provider.dart';
import 'star_rating.dart';

class RatingDialog extends ConsumerStatefulWidget {
  const RatingDialog({
    required this.player,
    required this.type,
    super.key,
    this.matchId,
    this.trainingId,
  });
  final Player player;
  final String? matchId;
  final String? trainingId;
  final RatingType type;

  @override
  ConsumerState<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends ConsumerState<RatingDialog> {
  final _notesController = TextEditingController();

  int _overallRating = 3;
  int? _attackingRating;
  int? _defendingRating;
  int? _tacticalRating;
  int? _workRateRating;
  int? _technicalRating;
  int? _coachabilityRating;
  int? _teamworkRating;

  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveRating() async {
    setState(() => _isLoading = true);

    final rating = PerformanceRating(
      playerId: widget.player.id,
      matchId: widget.matchId,
      trainingId: widget.trainingId,
      date: DateTime.now(),
      type: widget.type,
      overallRating: _overallRating,
      attackingRating: widget.type == RatingType.match
          ? _attackingRating
          : null,
      defendingRating: widget.type == RatingType.match
          ? _defendingRating
          : null,
      tacticalRating: _tacticalRating,
      workRateRating: _workRateRating,
      technicalRating: widget.type == RatingType.training
          ? _technicalRating
          : null,
      coachabilityRating: widget.type == RatingType.training
          ? _coachabilityRating
          : null,
      teamworkRating: widget.type == RatingType.training
          ? _teamworkRating
          : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      coachId: 'coach1', // TODO(author): Get from auth
    );

    final repo = ref.read(performanceRatingRepositoryProvider);
    final res = await repo.save(rating);

    if (res.isSuccess && mounted) {
      Navigator.of(context).pop(true);
    } else if (mounted) {
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMatch = widget.type == RatingType.match;

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Beoordeel ${widget.player.firstName} ${widget.player.lastName}',
          ),
          const SizedBox(height: 4),
          Text(
            isMatch ? 'Wedstrijd prestatie' : 'Training prestatie',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Rating (Required)
            InteractiveStarRating(
              label: 'Algemene prestatie *',
              initialRating: _overallRating,
              onRatingChanged: (rating) =>
                  setState(() => _overallRating = rating),
            ),
            const SizedBox(height: 16),

            // Match specific ratings
            if (isMatch) ...[
              InteractiveStarRating(
                label: 'Aanvallend',
                initialRating: _attackingRating ?? 0,
                onRatingChanged: (rating) =>
                    setState(() => _attackingRating = rating),
              ),
              const SizedBox(height: 12),
              InteractiveStarRating(
                label: 'Verdedigend',
                initialRating: _defendingRating ?? 0,
                onRatingChanged: (rating) =>
                    setState(() => _defendingRating = rating),
              ),
              const SizedBox(height: 12),
            ],

            // Training specific ratings
            if (!isMatch) ...[
              InteractiveStarRating(
                label: 'Technische uitvoering',
                initialRating: _technicalRating ?? 0,
                onRatingChanged: (rating) =>
                    setState(() => _technicalRating = rating),
              ),
              const SizedBox(height: 12),
              InteractiveStarRating(
                label: 'Coachbaarheid',
                initialRating: _coachabilityRating ?? 0,
                onRatingChanged: (rating) =>
                    setState(() => _coachabilityRating = rating),
              ),
              const SizedBox(height: 12),
              InteractiveStarRating(
                label: 'Teamwork',
                initialRating: _teamworkRating ?? 0,
                onRatingChanged: (rating) =>
                    setState(() => _teamworkRating = rating),
              ),
              const SizedBox(height: 12),
            ],

            // Common ratings
            InteractiveStarRating(
              label: 'Tactisch inzicht',
              initialRating: _tacticalRating ?? 0,
              onRatingChanged: (rating) =>
                  setState(() => _tacticalRating = rating),
            ),
            const SizedBox(height: 12),
            InteractiveStarRating(
              label: 'Werkethiek/Inzet',
              initialRating: _workRateRating ?? 0,
              onRatingChanged: (rating) =>
                  setState(() => _workRateRating = rating),
            ),
            const SizedBox(height: 16),

            // Notes
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Opmerkingen (optioneel)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Annuleren'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _saveRating,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Opslaan'),
        ),
      ],
    );
  }
}
