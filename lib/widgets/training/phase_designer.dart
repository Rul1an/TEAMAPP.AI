// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../models/training_session/session_phase.dart';

class PhaseDesigner extends StatefulWidget {
  const PhaseDesigner({
    required this.phase,
    required this.onPhaseUpdated,
    super.key,
    this.onPhaseDeleted,
  });
  final SessionPhase phase;
  final void Function(SessionPhase) onPhaseUpdated;
  final VoidCallback? onPhaseDeleted;

  @override
  State<PhaseDesigner> createState() => _PhaseDesignerState();
}

class _PhaseDesignerState extends State<PhaseDesigner> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late int _duration;
  late PhaseType _type;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.phase.name);
    _descriptionController =
        TextEditingController(text: widget.phase.description);
    _duration = widget.phase.durationMinutes;
    _type = widget.phase.type;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with phase type
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getPhaseTypeColor(_type),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getPhaseTypeIcon(_type),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getPhaseTypeDisplayName(_type),
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        TextField(
                          controller: _nameController,
                          style: Theme.of(context).textTheme.titleMedium,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (_) => _updatePhase(),
                        ),
                      ],
                    ),
                  ),
                  if (widget.onPhaseDeleted != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: widget.onPhaseDeleted,
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Duration slider
              Row(
                children: [
                  const Icon(Icons.timer, size: 20),
                  const SizedBox(width: 8),
                  Text('Duur: $_duration min'),
                  Expanded(
                    child: Slider(
                      value: _duration.toDouble(),
                      min: 5,
                      max: 60,
                      divisions: 11,
                      onChanged: (value) {
                        setState(() {
                          _duration = value.round();
                        });
                        _updatePhase();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Beschrijving',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                maxLines: 2,
                onChanged: (_) => _updatePhase(),
              ),

              const SizedBox(height: 12),

              // Phase type selector
              Text(
                'Fase Type:',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: PhaseType.values
                    .map(
                      (type) => ChoiceChip(
                        label: Text(_getPhaseTypeDisplayName(type)),
                        selected: _type == type,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _type = type;
                            });
                            _updatePhase();
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      );

  void _updatePhase() {
    final updatedPhase = widget.phase.copyWith(
      name: _nameController.text,
      description: _descriptionController.text,
      type: _type,
    );
    // Update timing based on duration
    updatedPhase.endTime =
        updatedPhase.startTime.add(Duration(minutes: _duration));
    widget.onPhaseUpdated(updatedPhase);
  }

  String _getPhaseTypeDisplayName(PhaseType type) {
    switch (type) {
      case PhaseType.preparation:
        return 'Voorbereiding';
      case PhaseType.warmup:
        return 'Warming-up';
      case PhaseType.technical:
        return 'Technisch';
      case PhaseType.tactical:
        return 'Tactisch';
      case PhaseType.physical:
        return 'Fysiek';
      case PhaseType.main:
        return 'Hoofddeel';
      case PhaseType.game:
        return 'Spelvormen';
      case PhaseType.discussion:
        return 'Bespreking';
      case PhaseType.evaluation:
        return 'Evaluatie';
      case PhaseType.cooldown:
        return 'Cool-down';
    }
  }

  Color _getPhaseTypeColor(PhaseType type) {
    switch (type) {
      case PhaseType.preparation:
        return Colors.blue;
      case PhaseType.warmup:
        return Colors.green;
      case PhaseType.technical:
        return Colors.orange;
      case PhaseType.tactical:
        return Colors.purple;
      case PhaseType.physical:
        return Colors.pink;
      case PhaseType.main:
        return Colors.red;
      case PhaseType.game:
        return Colors.teal;
      case PhaseType.discussion:
        return Colors.indigo;
      case PhaseType.evaluation:
        return Colors.amber;
      case PhaseType.cooldown:
        return Colors.grey;
    }
  }

  IconData _getPhaseTypeIcon(PhaseType type) {
    switch (type) {
      case PhaseType.preparation:
        return Icons.settings;
      case PhaseType.warmup:
        return Icons.directions_run;
      case PhaseType.technical:
        return Icons.precision_manufacturing;
      case PhaseType.tactical:
        return Icons.psychology;
      case PhaseType.physical:
        return Icons.fitness_center;
      case PhaseType.main:
        return Icons.sports_soccer;
      case PhaseType.game:
        return Icons.sports;
      case PhaseType.discussion:
        return Icons.forum;
      case PhaseType.evaluation:
        return Icons.rate_review;
      case PhaseType.cooldown:
        return Icons.self_improvement;
    }
  }
}
