// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../models/annual_planning/week_schedule.dart';

class MatchDialog extends StatefulWidget {
  const MatchDialog({
    required this.weekStartDate,
    required this.onSave,
    super.key,
    this.existingMatch,
  });
  final WeeklyMatch? existingMatch;
  final DateTime weekStartDate;
  final void Function(WeeklyMatch) onSave;

  @override
  State<MatchDialog> createState() => _MatchDialogState();
}

class _MatchDialogState extends State<MatchDialog> {
  final _formKey = GlobalKey<FormState>();
  final _opponentController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _isHomeMatch = true;
  MatchType _matchType = MatchType.regular;

  final List<String> _commonOpponents = [
    'Zeeland JO17-1',
    'Goes JO17-1',
    'Borssele JO17-1',
    'Middelburg JO17-1',
    'Vlissingen JO17-1',
    'Bevelands Elftal JO17-1',
    'HHC Hardenberg JO17-1',
    'GWVC JO17-1',
    'JEKA JO17-1',
    'Yerseke JO17-1',
    'SVV JO17-1',
    'Hoek JO17-1',
    'TerneuzenvvV JO17-1',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.existingMatch != null) {
      final match = widget.existingMatch;
      _opponentController.text = match.opponent;
      _locationController.text = match.location;
      _notesController.text = match.notes ?? '';
      _selectedDate = match.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(match.dateTime);
      _isHomeMatch = match.isHomeMatch;
      _matchType = match.type;
    } else {
      _opponentController.text = _commonOpponents.first;
      _locationController.text = 'Thuis';
      _selectedDate = widget.weekStartDate.add(
        const Duration(days: 5),
      ); // Default Saturday
      _selectedTime = const TimeOfDay(hour: 14, minute: 30); // Default 14:30
    }
  }

  @override
  void dispose() {
    _opponentController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          widget.existingMatch != null
              ? 'Wedstrijd Bewerken'
              : 'Wedstrijd Toevoegen',
          style: TextStyle(color: Colors.green[800]),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Opponent Dropdown/Text
                DropdownButtonFormField<String>(
                  value: _commonOpponents.contains(_opponentController.text)
                      ? _opponentController.text
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Tegenstander',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.groups),
                  ),
                  items: _commonOpponents
                      .map(
                        (opponent) => DropdownMenuItem(
                          value: opponent,
                          child: Text(opponent),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _opponentController.text = value;
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Custom opponent field
                TextFormField(
                  controller: _opponentController,
                  decoration: const InputDecoration(
                    labelText: 'Tegenstander',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? false ? 'Voer tegenstander in' : null,
                ),
                const SizedBox(height: 16),

                // Match Type
                DropdownButtonFormField<MatchType>(
                  value: _matchType,
                  decoration: const InputDecoration(
                    labelText: 'Type Wedstrijd',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.sports_soccer),
                  ),
                  items: MatchType.values
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
                        _matchType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Home/Away Toggle
                Row(
                  children: [
                    const Text('Locatie: '),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: _isHomeMatch,
                            onChanged: (value) {
                              setState(() {
                                _isHomeMatch = value!;
                                _locationController.text = 'Thuis';
                              });
                            },
                          ),
                          const Text('Thuis'),
                          Radio<bool>(
                            value: false,
                            groupValue: _isHomeMatch,
                            onChanged: (value) {
                              setState(() {
                                _isHomeMatch = value!;
                                _locationController.text = 'Uit';
                              });
                            },
                          ),
                          const Text('Uit'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Location
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Locatie',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? false ? 'Voer locatie in' : null,
                ),
                const SizedBox(height: 16),

                // Date and Time Selection
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
                            labelText: 'Aftrap',
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
            onPressed: _saveMatch,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
            ),
            child:
                Text(widget.existingMatch != null ? 'Bijwerken' : 'Toevoegen'),
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

  void _saveMatch() {
    if (_formKey.currentState!.validate()) {
      final match = WeeklyMatch(
        opponent: _opponentController.text,
        dateTime: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
        location: _locationController.text,
        isHomeMatch: _isHomeMatch,
        type: _matchType,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      widget.onSave(match);
      Navigator.of(context).pop();
    }
  }

  String _formatDate(DateTime date) {
    const weekdays = ['Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za', 'Zo'];
    final weekday = weekdays[date.weekday - 1];
    return '$weekday ${date.day}/${date.month}';
  }
}
