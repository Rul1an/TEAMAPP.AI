import 'package:flutter/material.dart';
import '../../models/annual_planning/week_schedule.dart';

class TrainingDialog extends StatefulWidget {
  const TrainingDialog({
    super.key,
    this.existingTraining,
    required this.weekStartDate,
    required this.onSave,
  });
  final WeeklyTraining? existingTraining;
  final DateTime weekStartDate;
  final void Function(WeeklyTraining) onSave;

  @override
  State<TrainingDialog> createState() => _TrainingDialogState();
}

class _TrainingDialogState extends State<TrainingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  Duration _duration = const Duration(hours: 1, minutes: 30);

  final List<String> _commonLocations = [
    'VRU',
    'WD NJ',
    'Sportpark VOAB',
    'Binnenbaan',
    'Kunstgras',
    'Gymzaal',
    'Inh. / Bek.',
  ];

  final List<String> _commonTrainingTypes = [
    'Verdedigende Organisatie 1',
    'Verdedigende Organisatie 2',
    'Verdedigende Organisatie 3',
    'Aanvallende Organisatie 1',
    'Aanvallende Organisatie 2',
    'Aanvallende Organisatie 3',
    'Omschakeling A->V',
    'Omschakeling V->A',
    'Set Pieces',
    'Techniektraining',
    'Fysieke Training',
    'Conditietraining',
    'Spelhervatting',
    'Positiespel',
    'Pressing',
    'Opbouw',
    'Afronding',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.existingTraining != null) {
      final training = widget.existingTraining!;
      _nameController.text = training.name;
      _locationController.text = training.location;
      _notesController.text = training.notes ?? '';
      _selectedDate = training.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(training.dateTime);
      _duration = training.duration;
    } else {
      _nameController.text = _commonTrainingTypes.first;
      _locationController.text = _commonLocations.first;
      _selectedDate =
          widget.weekStartDate.add(const Duration(days: 1)); // Default Tuesday
      _selectedTime = const TimeOfDay(hour: 19, minute: 30); // Default 19:30
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          widget.existingTraining != null
              ? 'Training Bewerken'
              : 'Training Toevoegen',
          style: TextStyle(color: Colors.green[800]),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Training Type Dropdown
                DropdownButtonFormField<String>(
                  value: _nameController.text.isNotEmpty
                      ? _nameController.text
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Type Training',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.sports_soccer),
                  ),
                  items: _commonTrainingTypes
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)),)
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _nameController.text = value;
                    }
                  },
                  validator: (value) => value?.isEmpty == true
                      ? 'Selecteer een training type'
                      : null,
                ),
                const SizedBox(height: 16),

                // Custom name option
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Naam (optioneel aanpassen)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Voer een naam in' : null,
                ),
                const SizedBox(height: 16),

                // Location Dropdown
                DropdownButtonFormField<String>(
                  value: _locationController.text.isNotEmpty
                      ? _locationController.text
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Locatie',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  items: _commonLocations
                      .map((location) => DropdownMenuItem(
                          value: location, child: Text(location),),)
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _locationController.text = value;
                    }
                  },
                  validator: (value) =>
                      value?.isEmpty == true ? 'Selecteer een locatie' : null,
                ),
                const SizedBox(height: 16),

                // Date Selection
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _selectDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Datum',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(_formatDate(_selectedDate)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: _selectTime,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Tijd',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(_selectedTime.format(context)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Duration Selection
                DropdownButtonFormField<Duration>(
                  value: _duration,
                  decoration: const InputDecoration(
                    labelText: 'Duur',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.timer),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: Duration(hours: 1),
                      child: Text('1 uur'),
                    ),
                    DropdownMenuItem(
                      value: Duration(hours: 1, minutes: 15),
                      child: Text('1 uur 15 min'),
                    ),
                    DropdownMenuItem(
                      value: Duration(hours: 1, minutes: 30),
                      child: Text('1 uur 30 min'),
                    ),
                    DropdownMenuItem(
                      value: Duration(hours: 1, minutes: 45),
                      child: Text('1 uur 45 min'),
                    ),
                    DropdownMenuItem(
                      value: Duration(hours: 2),
                      child: Text('2 uur'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _duration = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notities (optioneel)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuleren'),
          ),
          ElevatedButton(
            onPressed: _saveTraining,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
            ),
            child: Text(
                widget.existingTraining != null ? 'Bijwerken' : 'Toevoegen',),
          ),
        ],
      );

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.weekStartDate,
      lastDate: widget.weekStartDate.add(const Duration(days: 6)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _saveTraining() {
    if (_formKey.currentState!.validate()) {
      final training = WeeklyTraining(
        name: _nameController.text,
        dateTime: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
        location: _locationController.text,
        duration: _duration,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      widget.onSave(training);
      Navigator.of(context).pop();
    }
  }

  String _formatDate(DateTime date) {
    const weekdays = ['Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za', 'Zo'];
    final weekday = weekdays[date.weekday - 1];
    return '$weekday ${date.day}/${date.month}';
  }
}
