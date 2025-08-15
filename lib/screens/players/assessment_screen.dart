// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Project imports:
import '../../models/assessment.dart';
import '../../models/player.dart';
import '../../providers/assessments_provider.dart';
import '../../providers/players_provider.dart';
import '../../widgets/common/interactive_star_rating.dart';
import '../../providers/pdf/pdf_generators_providers.dart';
import '../../utils/share_pdf_utils.dart';

class AssessmentScreen extends ConsumerStatefulWidget {
  const AssessmentScreen({
    required this.playerId,
    super.key,
    this.assessmentId,
  });
  final String playerId;
  final String? assessmentId;

  @override
  ConsumerState<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends ConsumerState<AssessmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _strengthsController = TextEditingController();
  final _improvementController = TextEditingController();
  final _goalsController = TextEditingController();
  final _notesController = TextEditingController();

  Player? _player;
  PlayerAssessment? _assessment;
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _strengthsController.dispose();
    _improvementController.dispose();
    _goalsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    // Load player via repository
    final playerRes =
        await ref.read(playerRepositoryProvider).getById(widget.playerId);
    final player = playerRes.dataOrNull;

    // Load or create assessment via repository
    PlayerAssessment assessment;
    if (widget.assessmentId != null) {
      final assessRes = await ref
          .read(assessmentRepositoryProvider)
          .getAll(); // could add byPlayer; fallback
      assessment = assessRes.dataOrNull?.firstWhere(
            (a) => a.id == widget.assessmentId,
            orElse: () => PlayerAssessment()..playerId = widget.playerId,
          ) ??
          (PlayerAssessment()..playerId = widget.playerId);
      _isEditing = true;
    } else {
      assessment = PlayerAssessment()
        ..playerId = widget.playerId
        ..type = AssessmentType.monthly
        ..assessorId = 'coach_1';
    }

    if (mounted) {
      setState(() {
        _player = player;
        _assessment = assessment;
        _strengthsController.text = assessment.strengths ?? '';
        _improvementController.text = assessment.areasForImprovement ?? '';
        _goalsController.text = assessment.developmentGoals ?? '';
        _notesController.text = assessment.coachNotes ?? '';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Assessment Bewerken' : 'Nieuwe Assessment'),
        actions: [
          if (_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () => _exportPdf(ref),
              tooltip: 'Exporteer naar PDF',
            ),
          ],
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Opslaan',
            onPressed: _saveAssessment,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlayerHeader(),
              const SizedBox(height: 24),
              _buildAssessmentInfo(),
              const SizedBox(height: 24),
              _buildSkillsAssessment(),
              const SizedBox(height: 24),
              _buildTextFields(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerHeader() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: _getPositionColor(_player!.position),
                child: Text(
                  _player!.jerseyNumber.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _player!.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '${_getPositionName(_player!.position)} • ${_player!.age} jaar',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildAssessmentInfo() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assessment Informatie',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<AssessmentType>(
                      value: _assessment!.type,
                      decoration: const InputDecoration(
                        labelText: 'Type Assessment',
                        border: OutlineInputBorder(),
                      ),
                      items: AssessmentType.values
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type.displayName),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _assessment!.type = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Datum',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: DateFormat(
                          'dd-MM-yyyy',
                        ).format(_assessment!.assessmentDate),
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _assessment!.assessmentDate,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 365),
                          ),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _assessment!.assessmentDate = date;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildSkillsAssessment() => Column(
        children: [
          _buildSkillCategory(
            'Technische Vaardigheden',
            _assessment!.technicalSkills,
            Icons.sports_soccer,
            Colors.blue,
            _updateTechnicalSkill,
          ),
          const SizedBox(height: 16),
          _buildSkillCategory(
            'Tactische Vaardigheden',
            _assessment!.tacticalSkills,
            Icons.psychology,
            Colors.green,
            _updateTacticalSkill,
          ),
          const SizedBox(height: 16),
          _buildSkillCategory(
            'Fysieke Eigenschappen',
            _assessment!.physicalAttributes,
            Icons.fitness_center,
            Colors.orange,
            _updatePhysicalSkill,
          ),
          const SizedBox(height: 16),
          _buildSkillCategory(
            'Mentale Eigenschappen',
            _assessment!.mentalAttributes,
            Icons.lightbulb,
            Colors.purple,
            _updateMentalSkill,
          ),
        ],
      );

  Widget _buildSkillCategory(
    String title,
    Map<String, int> skills,
    IconData icon,
    Color color,
    void Function(String, int) onRatingChanged,
  ) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: 8),
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 16),
              ...skills.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          InteractiveStarRating(
                            rating: entry.value,
                            onRatingChanged: (rating) =>
                                onRatingChanged(entry.key, rating),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${entry.value}/5',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildTextFields() => Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evaluatie',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _strengthsController,
                    decoration: const InputDecoration(
                      labelText: 'Sterke Punten',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      _assessment!.strengths = value.isEmpty ? null : value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _improvementController,
                    decoration: const InputDecoration(
                      labelText: 'Verbeterpunten',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      _assessment!.areasForImprovement =
                          value.isEmpty ? null : value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _goalsController,
                    decoration: const InputDecoration(
                      labelText: 'Ontwikkelingsdoelen',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      _assessment!.developmentGoals =
                          value.isEmpty ? null : value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Coach Notities',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                    onChanged: (value) {
                      _assessment!.coachNotes = value.isEmpty ? null : value;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  void _updateTechnicalSkill(String skill, int rating) {
    setState(() {
      switch (skill) {
        case 'Balbeheersing':
          _assessment!.ballControl = rating;
        case 'Passen':
          _assessment!.passing = rating;
        case 'Schieten':
          _assessment!.shooting = rating;
        case 'Dribbelen':
          _assessment!.dribbling = rating;
        case 'Verdedigen':
          _assessment!.defending = rating;
      }
    });
  }

  void _updateTacticalSkill(String skill, int rating) {
    setState(() {
      switch (skill) {
        case 'Positiespel':
          _assessment!.positioning = rating;
        case 'Spellezing':
          _assessment!.gameReading = rating;
        case 'Besluitvorming':
          _assessment!.decisionMaking = rating;
        case 'Communicatie':
          _assessment!.communication = rating;
        case 'Teamwork':
          _assessment!.teamwork = rating;
      }
    });
  }

  void _updatePhysicalSkill(String skill, int rating) {
    setState(() {
      switch (skill) {
        case 'Snelheid':
          _assessment!.speed = rating;
        case 'Conditie':
          _assessment!.stamina = rating;
        case 'Kracht':
          _assessment!.strength = rating;
        case 'Beweeglijkheid':
          _assessment!.agility = rating;
        case 'Coördinatie':
          _assessment!.coordination = rating;
      }
    });
  }

  void _updateMentalSkill(String skill, int rating) {
    setState(() {
      switch (skill) {
        case 'Zelfvertrouwen':
          _assessment!.confidence = rating;
        case 'Concentratie':
          _assessment!.concentration = rating;
        case 'Leiderschap':
          _assessment!.leadership = rating;
        case 'Coachbaarheid':
          _assessment!.coachability = rating;
        case 'Motivatie':
          _assessment!.motivation = rating;
      }
    });
  }

  Future<void> _saveAssessment() async {
    if (_formKey.currentState!.validate()) {
      try {
        _assessment!.updatedAt = DateTime.now();

        final repo = ref.read(assessmentRepositoryProvider);
        await repo.save(_assessment!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEditing ? 'Assessment bijgewerkt' : 'Assessment opgeslagen',
              ),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
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
  }

  Future<void> _exportPdf(WidgetRef ref) async {
    if (_assessment == null || _player == null) return;

    final generator = ref.read(playerAssessmentPdfGeneratorProvider);
    final bytes = await generator.generate(_assessment!);
    final filename =
        'assessment_${_player!.id}_${DateFormat('yyyy-MM-dd').format(_assessment!.assessmentDate)}.pdf';

    if (mounted) {
      await SharePdfUtils.sharePdf(bytes, filename, context);
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
}
