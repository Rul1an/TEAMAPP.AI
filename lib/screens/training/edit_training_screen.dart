// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Project imports:
import '../../models/training.dart';
import '../../providers/trainings_provider.dart';

class EditTrainingScreen extends ConsumerStatefulWidget {
  const EditTrainingScreen({required this.trainingId, super.key});
  final String trainingId;

  @override
  ConsumerState<EditTrainingScreen> createState() => _EditTrainingScreenState();
}

class _EditTrainingScreenState extends ConsumerState<EditTrainingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _durationController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _objectivesController;
  late TextEditingController _coachNotesController;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TrainingFocus? _selectedFocus;
  TrainingIntensity? _selectedIntensity;
  TrainingStatus? _selectedStatus;
  bool _isLoading = false;
  Training? _training;

  @override
  void initState() {
    super.initState();
    _durationController = TextEditingController();
    _locationController = TextEditingController();
    _descriptionController = TextEditingController();
    _objectivesController = TextEditingController();
    _coachNotesController = TextEditingController();
  }

  @override
  void dispose() {
    _durationController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _objectivesController.dispose();
    _coachNotesController.dispose();
    super.dispose();
  }

  void _loadTraining() {
    final trainings = ref.read(trainingsProvider).value ?? [];
    _training = trainings.firstWhere(
      (t) => t.id == widget.trainingId,
      orElse: Training.new,
    );

    if (_training != null && _training!.id != '') {
      _selectedDate = _training!.date;
      _selectedTime = TimeOfDay.fromDateTime(_training!.date);
      _durationController.text = _training!.duration.toString();
      _locationController.text = _training!.location ?? '';
      _descriptionController.text = _training!.description ?? '';
      _objectivesController.text = _training!.objectives ?? '';
      _coachNotesController.text = _training!.coachNotes ?? '';
      _selectedFocus = _training!.focus;
      _selectedIntensity = _training!.intensity;
      _selectedStatus = _training!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final trainingsAsync = ref.watch(trainingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Bewerken'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _showDeleteDialog,
          ),
        ],
      ),
      body: trainingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Fout: $error')),
        data: (trainings) {
          if (_training == null) {
            _loadTraining();
          }

          if (_training == null || _training!.id == '') {
            return const Center(child: Text('Training niet gevonden'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Training Information Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Training Informatie',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(context),
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: 'Datum',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.calendar_today),
                                    ),
                                    child: Text(
                                      _selectedDate != null
                                          ? DateFormat(
                                              'd MMMM yyyy',
                                              'nl_NL',
                                            ).format(_selectedDate!)
                                          : 'Selecteer datum',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectTime(context),
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: 'Tijd',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.access_time),
                                    ),
                                    child: Text(
                                      _selectedTime != null
                                          ? _selectedTime!.format(context)
                                          : 'Selecteer tijd',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _durationController,
                                  decoration: const InputDecoration(
                                    labelText: 'Duur (minuten)',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.timer),
                                    suffixText: 'min',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Duur is verplicht';
                                    }
                                    final duration = int.tryParse(value);
                                    if (duration == null ||
                                        duration < 30 ||
                                        duration > 180) {
                                      return 'Voer een duur tussen 30-180 minuten in';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _locationController,
                                  decoration: const InputDecoration(
                                    labelText: 'Locatie (optioneel)',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.location_on),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Training Type Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Training Type',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<TrainingFocus>(
                                  value: _selectedFocus,
                                  decoration: const InputDecoration(
                                    labelText: 'Focus',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: TrainingFocus.values
                                      .map(
                                        (focus) => DropdownMenuItem(
                                          value: focus,
                                          child: Text(_getFocusText(focus)),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedFocus = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Selecteer een focus';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child:
                                    DropdownButtonFormField<TrainingIntensity>(
                                      value: _selectedIntensity,
                                      decoration: const InputDecoration(
                                        labelText: 'Intensiteit',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: TrainingIntensity.values
                                          .map(
                                            (intensity) => DropdownMenuItem(
                                              value: intensity,
                                              child: Text(
                                                _getIntensityText(intensity),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedIntensity = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Selecteer een intensiteit';
                                        }
                                        return null;
                                      },
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<TrainingStatus>(
                            value: _selectedStatus,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                            ),
                            items: TrainingStatus.values
                                .map(
                                  (status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(_getStatusText(status)),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Selecteer een status';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Details Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Details',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Beschrijving (optioneel)',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _objectivesController,
                            decoration: const InputDecoration(
                              labelText: 'Doelstellingen (optioneel)',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _coachNotesController,
                            decoration: const InputDecoration(
                              labelText: 'Coach Notities (optioneel)',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveTraining,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Opslaan'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('nl', 'NL'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveTraining() async {
    if (!_formKey.currentState!.validate() ||
        _selectedDate == null ||
        _selectedTime == null) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecteer een datum'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecteer een tijd'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Update training object
      _training!.date = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      _training!.duration = int.parse(_durationController.text);
      _training!.location = _locationController.text.isEmpty
          ? null
          : _locationController.text;
      _training!.description = _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text;
      _training!.objectives = _objectivesController.text.isEmpty
          ? null
          : _objectivesController.text;
      _training!.coachNotes = _coachNotesController.text.isEmpty
          ? null
          : _coachNotesController.text;
      _training!.focus = _selectedFocus!;
      _training!.intensity = _selectedIntensity!;
      _training!.status = _selectedStatus!;
      _training!.updatedAt = DateTime.now();

      final repo = ref.read(trainingRepositoryProvider);
      final res = await repo.update(_training!);
      if (!res.isSuccess) throw Exception(res.errorOrNull);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Training bijgewerkt'),
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDeleteDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Training verwijderen'),
        content: Text(
          'Weet je zeker dat je de training van ${_selectedDate != null ? DateFormat('d MMMM yyyy', 'nl_NL').format(_selectedDate!) : 'deze datum'} wilt verwijderen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuleren'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteTraining();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Verwijderen'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTraining() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final repo = ref.read(trainingRepositoryProvider);
      await repo.delete(_training!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Training verwijderd'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/training');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout bij verwijderen: $e'),
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

  String _getStatusText(TrainingStatus status) {
    switch (status) {
      case TrainingStatus.planned:
        return 'Gepland';
      case TrainingStatus.completed:
        return 'Afgerond';
      case TrainingStatus.cancelled:
        return 'Geannuleerd';
    }
  }
}
