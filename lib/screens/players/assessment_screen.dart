import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:html' if (dart.library.html) 'dart:html' as html;
import 'package:path_provider/path_provider.dart';
import '../../models/player.dart';
import '../../models/assessment.dart';
import '../../services/database_service.dart';
import '../../services/pdf_service.dart';
import '../../widgets/common/interactive_star_rating.dart';

class AssessmentScreen extends ConsumerStatefulWidget {
  final String playerId;
  final String? assessmentId;

  const AssessmentScreen({
    super.key,
    required this.playerId,
    this.assessmentId,
  });

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
    final dbService = DatabaseService();

    // Load player
    final player = await dbService.getPlayer(int.parse(widget.playerId));

    // Load or create assessment
    PlayerAssessment assessment;
    if (widget.assessmentId != null) {
      // Load existing assessment
      assessment = await dbService.getAssessment(int.parse(widget.assessmentId!)) ??
                  PlayerAssessment()..playerId = widget.playerId;
      _isEditing = true;
    } else {
      // Create new assessment
      assessment = PlayerAssessment()
        ..playerId = widget.playerId
        ..type = AssessmentType.monthly
        ..assessorId = 'coach_1'; // TODO: Get from auth
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Assessment Bewerken' : 'Nieuwe Assessment'),
        actions: [
          if (_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: _exportToPDF,
              tooltip: 'Exporteer naar PDF',
            ),
          ],
          IconButton(
            icon: const Icon(Icons.save),
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

  Widget _buildPlayerHeader() {
    return Card(
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
  }

  Widget _buildAssessmentInfo() {
    return Card(
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
                    items: AssessmentType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.displayName),
                      );
                    }).toList(),
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
                      text: DateFormat('dd-MM-yyyy').format(_assessment!.assessmentDate),
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _assessment!.assessmentDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
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
  }

  Widget _buildSkillsAssessment() {
    return Column(
      children: [
        _buildSkillCategory(
          'Technische Vaardigheden',
          _assessment!.technicalSkills,
          Icons.sports_soccer,
          Colors.blue,
          (skill, rating) => _updateTechnicalSkill(skill, rating),
        ),
        const SizedBox(height: 16),
        _buildSkillCategory(
          'Tactische Vaardigheden',
          _assessment!.tacticalSkills,
          Icons.psychology,
          Colors.green,
          (skill, rating) => _updateTacticalSkill(skill, rating),
        ),
        const SizedBox(height: 16),
        _buildSkillCategory(
          'Fysieke Eigenschappen',
          _assessment!.physicalAttributes,
          Icons.fitness_center,
          Colors.orange,
          (skill, rating) => _updatePhysicalSkill(skill, rating),
        ),
        const SizedBox(height: 16),
        _buildSkillCategory(
          'Mentale Eigenschappen',
          _assessment!.mentalAttributes,
          Icons.lightbulb,
          Colors.purple,
          (skill, rating) => _updateMentalSkill(skill, rating),
        ),
      ],
    );
  }

  Widget _buildSkillCategory(
    String title,
    Map<String, int> skills,
    IconData icon,
    Color color,
    Function(String, int) onRatingChanged,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...skills.entries.map((entry) {
              return Padding(
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
                          onRatingChanged: (rating) => onRatingChanged(entry.key, rating),
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
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFields() {
    return Column(
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
                    _assessment!.areasForImprovement = value.isEmpty ? null : value;
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
                    _assessment!.developmentGoals = value.isEmpty ? null : value;
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
  }

  void _updateTechnicalSkill(String skill, int rating) {
    setState(() {
      switch (skill) {
        case 'Balbeheersing':
          _assessment!.ballControl = rating;
          break;
        case 'Passen':
          _assessment!.passing = rating;
          break;
        case 'Schieten':
          _assessment!.shooting = rating;
          break;
        case 'Dribbelen':
          _assessment!.dribbling = rating;
          break;
        case 'Verdedigen':
          _assessment!.defending = rating;
          break;
      }
    });
  }

  void _updateTacticalSkill(String skill, int rating) {
    setState(() {
      switch (skill) {
        case 'Positiespel':
          _assessment!.positioning = rating;
          break;
        case 'Spellezing':
          _assessment!.gameReading = rating;
          break;
        case 'Besluitvorming':
          _assessment!.decisionMaking = rating;
          break;
        case 'Communicatie':
          _assessment!.communication = rating;
          break;
        case 'Teamwork':
          _assessment!.teamwork = rating;
          break;
      }
    });
  }

  void _updatePhysicalSkill(String skill, int rating) {
    setState(() {
      switch (skill) {
        case 'Snelheid':
          _assessment!.speed = rating;
          break;
        case 'Conditie':
          _assessment!.stamina = rating;
          break;
        case 'Kracht':
          _assessment!.strength = rating;
          break;
        case 'Beweeglijkheid':
          _assessment!.agility = rating;
          break;
        case 'Coördinatie':
          _assessment!.coordination = rating;
          break;
      }
    });
  }

  void _updateMentalSkill(String skill, int rating) {
    setState(() {
      switch (skill) {
        case 'Zelfvertrouwen':
          _assessment!.confidence = rating;
          break;
        case 'Concentratie':
          _assessment!.concentration = rating;
          break;
        case 'Leiderschap':
          _assessment!.leadership = rating;
          break;
        case 'Coachbaarheid':
          _assessment!.coachability = rating;
          break;
        case 'Motivatie':
          _assessment!.motivation = rating;
          break;
      }
    });
  }

  Future<void> _saveAssessment() async {
    if (_formKey.currentState!.validate()) {
      try {
        _assessment!.updatedAt = DateTime.now();

        final dbService = DatabaseService();
        if (_isEditing) {
          await dbService.updateAssessment(_assessment!);
        } else {
          await dbService.addAssessment(_assessment!);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isEditing
                ? 'Assessment bijgewerkt'
                : 'Assessment opgeslagen'),
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

    Future<void> _exportToPDF() async {
    if (_player == null || _assessment == null) return;

    try {
      // Update assessment with current form data
      _assessment!.strengths = _strengthsController.text.isEmpty ? null : _strengthsController.text;
      _assessment!.areasForImprovement = _improvementController.text.isEmpty ? null : _improvementController.text;
      _assessment!.developmentGoals = _goalsController.text.isEmpty ? null : _goalsController.text;
      _assessment!.coachNotes = _notesController.text.isEmpty ? null : _notesController.text;

      // Generate PDF
      final pdfData = await PDFService.generateAssessmentReport(_player!, _assessment!);

      final fileName = 'assessment_${_player!.firstName}_${_player!.lastName}_${DateFormat('yyyy-MM-dd').format(_assessment!.assessmentDate)}.pdf';

      if (kIsWeb) {
        // Web platform: Trigger browser download
        final blob = html.Blob([pdfData], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = fileName;
        html.document.body!.children.add(anchor);
        anchor.click();
        html.document.body!.children.remove(anchor);
        html.Url.revokeObjectUrl(url);

        // Show success feedback
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PDF rapport gedownload: $fileName'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Mobile platform: Save to file system
        final downloadsDir = await getDownloadsDirectory();
        final file = File('${downloadsDir?.path ?? (await getApplicationDocumentsDirectory()).path}/$fileName');
        await file.writeAsBytes(pdfData);

        // Show success feedback
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PDF rapport opgeslagen: $fileName'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout bij PDF genereren: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
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
