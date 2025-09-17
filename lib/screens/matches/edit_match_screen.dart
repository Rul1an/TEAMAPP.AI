// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Project imports:
import '../../models/match.dart';
import '../../providers/matches_provider.dart';

class EditMatchScreen extends ConsumerStatefulWidget {
  const EditMatchScreen({required this.matchId, super.key});
  final String matchId;

  @override
  ConsumerState<EditMatchScreen> createState() => _EditMatchScreenState();
}

class _EditMatchScreenState extends ConsumerState<EditMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _opponentController;
  late TextEditingController _teamScoreController;
  late TextEditingController _opponentScoreController;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  Location? _selectedLocation;
  Competition? _selectedCompetition;
  MatchStatus? _selectedStatus;
  bool _isLoading = false;
  Match? _match;

  @override
  void initState() {
    super.initState();
    _opponentController = TextEditingController();
    _teamScoreController = TextEditingController();
    _opponentScoreController = TextEditingController();
  }

  @override
  void dispose() {
    _opponentController.dispose();
    _teamScoreController.dispose();
    _opponentScoreController.dispose();
    super.dispose();
  }

  void _loadMatch() {
    final matches = ref.read(matchesProvider).value ?? [];
    _match = matches.firstWhere(
      (m) => m.id == widget.matchId,
      orElse: Match.new,
    );

    if (_match != null && _match!.id != '') {
      _opponentController.text = _match!.opponent;
      _teamScoreController.text = _match!.teamScore?.toString() ?? '';
      _opponentScoreController.text = _match!.opponentScore?.toString() ?? '';
      _selectedDate = _match!.date;
      _selectedTime = TimeOfDay.fromDateTime(_match!.date);
      _selectedLocation = _match!.location;
      _selectedCompetition = _match!.competition;
      _selectedStatus = _match!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchesAsync = ref.watch(matchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wedstrijd Bewerken'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Verwijder wedstrijd',
            onPressed: _showDeleteDialog,
          ),
        ],
      ),
      body: matchesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Fout: $error')),
        data: (matches) {
          if (_match == null) {
            _loadMatch();
          }

          if (_match == null || _match!.id == '') {
            return const Center(child: Text('Wedstrijd niet gevonden'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Match Information Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wedstrijd Informatie',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _opponentController,
                            decoration: const InputDecoration(
                              labelText: 'Tegenstander',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.sports_soccer),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tegenstander is verplicht';
                              }
                              return null;
                            },
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
                                child: DropdownButtonFormField<Location>(
                                  value: _selectedLocation,
                                  decoration: const InputDecoration(
                                    labelText: 'Locatie',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: Location.values
                                      .map(
                                        (location) => DropdownMenuItem(
                                          value: location,
                                          child: Text(
                                            _getLocationText(location),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedLocation = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Selecteer een locatie';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<Competition>(
                                  value: _selectedCompetition,
                                  decoration: const InputDecoration(
                                    labelText: 'Competitie',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: Competition.values
                                      .map(
                                        (competition) => DropdownMenuItem(
                                          value: competition,
                                          child: Text(
                                            _getCompetitionText(competition),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCompetition = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Selecteer een competitie';
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

                  // Score & Status Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Score & Status',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<MatchStatus>(
                            value: _selectedStatus,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                            ),
                            items: MatchStatus.values
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
                                // Clear scores if not completed
                                if (value != MatchStatus.completed) {
                                  _teamScoreController.clear();
                                  _opponentScoreController.clear();
                                }
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Selecteer een status';
                              }
                              return null;
                            },
                          ),
                          if (_selectedStatus == MatchStatus.completed) ...[
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _teamScoreController,
                                    decoration: InputDecoration(
                                      labelText: 'JO17 Score',
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(
                                        Icons.sports_score,
                                      ),
                                      fillColor: Colors.green.withValues(
                                        alpha: 0.1,
                                      ),
                                      filled: true,
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(2),
                                    ],
                                    validator: (value) {
                                      if (_selectedStatus ==
                                          MatchStatus.completed) {
                                        if (value == null || value.isEmpty) {
                                          return 'Score verplicht';
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _opponentScoreController,
                                    decoration: InputDecoration(
                                      labelText: 'Tegenstander Score',
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(
                                        Icons.sports_score,
                                      ),
                                      fillColor: Colors.red.withValues(
                                        alpha: 0.1,
                                      ),
                                      filled: true,
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(2),
                                    ],
                                    validator: (value) {
                                      if (_selectedStatus ==
                                          MatchStatus.completed) {
                                        if (value == null || value.isEmpty) {
                                          return 'Score verplicht';
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (_teamScoreController.text.isNotEmpty &&
                                _opponentScoreController.text.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getResultColor().withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _getResultColor(),
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    _getResultText(),
                                    style: TextStyle(
                                      color: _getResultColor(),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
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
                      onPressed: _isLoading ? null : _saveMatch,
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

  Color _getResultColor() {
    if (_teamScoreController.text.isEmpty ||
        _opponentScoreController.text.isEmpty) {
      return Colors.grey;
    }
    
    final teamScore = int.tryParse(_teamScoreController.text);
    final opponentScore = int.tryParse(_opponentScoreController.text);
    
    if (teamScore == null || opponentScore == null) {
      return Colors.grey;
    }

    if (teamScore > opponentScore) return Colors.green;
    if (teamScore < opponentScore) return Colors.red;
    return Colors.orange;
  }

  String _getResultText() {
    if (_teamScoreController.text.isEmpty ||
        _opponentScoreController.text.isEmpty) {
      return '';
    }
    
    final teamScore = int.tryParse(_teamScoreController.text);
    final opponentScore = int.tryParse(_opponentScoreController.text);
    
    if (teamScore == null || opponentScore == null) {
      return '';
    }

    if (teamScore > opponentScore) return 'Gewonnen!';
    if (teamScore < opponentScore) return 'Verloren';
    return 'Gelijkspel';
  }

  Future<void> _saveMatch() async {
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
      // Update match object
      _match!.opponent = _opponentController.text;
      _match!.date = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      _match!.location = _selectedLocation!;
      _match!.competition = _selectedCompetition!;
      _match!.status = _selectedStatus!;

      if (_selectedStatus == MatchStatus.completed) {
        _match!.teamScore = int.tryParse(_teamScoreController.text);
        _match!.opponentScore = int.tryParse(_opponentScoreController.text);
        // result is computed automatically from scores
      } else {
        _match!.teamScore = null;
        _match!.opponentScore = null;
        // result will be null automatically
      }

      final repo = ref.read(matchRepositoryProvider);
      final res = await repo.update(_match!);
      if (!res.isSuccess) throw Exception(res.errorOrNull);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wedstrijd bijgewerkt'),
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
        title: const Text('Wedstrijd verwijderen'),
        content: Text(
          'Weet je zeker dat je de wedstrijd tegen ${_match!.opponent} wilt verwijderen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuleren'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteMatch();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Verwijderen'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMatch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final repo = ref.read(matchRepositoryProvider);
      final res = await repo.delete(_match!.id);
      if (!res.isSuccess) throw Exception(res.errorOrNull);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wedstrijd verwijderd'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/matches');
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

  String _getLocationText(Location location) {
    switch (location) {
      case Location.home:
        return 'Thuis';
      case Location.away:
        return 'Uit';
    }
  }

  String _getCompetitionText(Competition competition) {
    switch (competition) {
      case Competition.league:
        return 'Competitie';
      case Competition.cup:
        return 'Beker';
      case Competition.friendly:
        return 'Vriendschappelijk';
      case Competition.tournament:
        return 'Toernooi';
    }
  }

  String _getStatusText(MatchStatus status) {
    switch (status) {
      case MatchStatus.scheduled:
        return 'Gepland';
      case MatchStatus.inProgress:
        return 'Bezig';
      case MatchStatus.completed:
        return 'Afgerond';
      case MatchStatus.cancelled:
        return 'Geannuleerd';
      case MatchStatus.postponed:
        return 'Uitgesteld';
    }
  }
}
