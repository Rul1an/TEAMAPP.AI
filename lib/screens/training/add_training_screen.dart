import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../models/training.dart';
import '../../providers/trainings_provider.dart';

class AddTrainingScreen extends ConsumerStatefulWidget {
  const AddTrainingScreen({super.key});

  @override
  ConsumerState<AddTrainingScreen> createState() => _AddTrainingScreenState();
}

class _AddTrainingScreenState extends ConsumerState<AddTrainingScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late TextEditingController _durationController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _objectivesController;
  late TextEditingController _coachNotesController;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TrainingFocus? _selectedFocus;
  TrainingIntensity? _selectedIntensity;
  TrainingStatus _selectedStatus = TrainingStatus.planned;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _durationController = TextEditingController(text: '90');
    _locationController = TextEditingController(text: 'Sportpark De Toekomst');
    _descriptionController = TextEditingController();
    _objectivesController = TextEditingController();
    _coachNotesController = TextEditingController();

    // Set default date and time
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _selectedTime = const TimeOfDay(hour: 19, minute: 0);
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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Training Toevoegen'),
        ),
        body: SingleChildScrollView(
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
                                        ? DateFormat('d MMMM yyyy', 'nl_NL')
                                            .format(_selectedDate!)
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
                                  labelText: 'Locatie',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.location_on),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Locatie is verplicht';
                                  }
                                  return null;
                                },
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
                              child: DropdownButtonFormField<TrainingIntensity>(
                                value: _selectedIntensity,
                                decoration: const InputDecoration(
                                  labelText: 'Intensiteit',
                                  border: OutlineInputBorder(),
                                ),
                                items: TrainingIntensity.values
                                    .map(
                                      (intensity) => DropdownMenuItem(
                                        value: intensity,
                                        child:
                                            Text(_getIntensityText(intensity)),
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
                              _selectedStatus = value!;
                            });
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
                            hintText:
                                'Bijv. Verbeteren van passing, positiespel, conditie',
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
                            hintText: 'Interne notities voor de coaching staff',
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
                        : const Text('Training Toevoegen'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
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
    final TimeOfDay? picked = await showTimePicker(
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
      // Create new training
      final training = Training()
        ..date = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        )
        ..duration = int.parse(_durationController.text)
        ..location = _locationController.text
        ..description = _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text
        ..objectives = _objectivesController.text.isEmpty
            ? null
            : _objectivesController.text
        ..coachNotes = _coachNotesController.text.isEmpty
            ? null
            : _coachNotesController.text
        ..focus = _selectedFocus!
        ..intensity = _selectedIntensity!
        ..status = _selectedStatus
        ..presentPlayerIds = []
        ..absentPlayerIds = []
        ..injuredPlayerIds = []
        ..latePlayerIds = []
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      final repo = ref.read(trainingRepositoryProvider);
      final res = await repo.add(training);

      if (!res.isSuccess) {
        throw Exception(res.errorOrNull);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Training toegevoegd'),
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
