import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/player.dart';
import '../../providers/players_provider.dart';

class EditPlayerScreen extends ConsumerStatefulWidget {

  const EditPlayerScreen({
    super.key,
    required this.playerId,
  });
  final String playerId;

  @override
  ConsumerState<EditPlayerScreen> createState() => _EditPlayerScreenState();
}

class _EditPlayerScreenState extends ConsumerState<EditPlayerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _jerseyNumberController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _emailController;

  DateTime? _selectedDate;
  Position? _selectedPosition;
  PreferredFoot? _selectedFoot;
  bool _isLoading = false;
  Player? _player;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _jerseyNumberController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _jerseyNumberController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _loadPlayer() {
    final players = ref.read(playersNotifierProvider).value ?? [];
    _player = players.firstWhere(
      (p) => p.id.toString() == widget.playerId,
      orElse: Player.new,
    );

    if (_player != null && _player!.id != '') {
      _firstNameController.text = _player!.firstName;
      _lastNameController.text = _player!.lastName;
      _jerseyNumberController.text = _player!.jerseyNumber.toString();
      _heightController.text = _player!.height.toInt().toString();
      _weightController.text = _player!.weight.toInt().toString();
      _emailController.text = _player!.email ?? '';
      _selectedDate = _player!.birthDate;
      _selectedPosition = _player!.position;
      _selectedFoot = _player!.preferredFoot;
    }
  }

  @override
  Widget build(BuildContext context) {
    final playersAsync = ref.watch(playersNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speler Bewerken'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _showDeleteDialog,
          ),
        ],
      ),
      body: playersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Fout: $error')),
        data: (players) {
          if (_player == null) {
            _loadPlayer();
          }

          if (_player == null || _player!.id == '') {
            return const Center(child: Text('Speler niet gevonden'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Information Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Persoonlijke Informatie',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Voornaam',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Voornaam is verplicht';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Achternaam',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Achternaam is verplicht';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email (optioneel)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!value.contains('@')) {
                                  return 'Voer een geldig email adres in';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Geboortedatum',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                _selectedDate != null
                                    ? DateFormat('d MMMM yyyy', 'nl_NL').format(_selectedDate!)
                                    : 'Selecteer datum',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Football Information Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Voetbal Informatie',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _jerseyNumberController,
                                  decoration: const InputDecoration(
                                    labelText: 'Rugnummer',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.sports_soccer),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Rugnummer is verplicht';
                                    }
                                    final number = int.tryParse(value);
                                    if (number == null || number < 1 || number > 99) {
                                      return 'Voer een nummer tussen 1-99 in';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<Position>(
                                  value: _selectedPosition,
                                  decoration: const InputDecoration(
                                    labelText: 'Positie',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: Position.values.map((position) => DropdownMenuItem(
                                      value: position,
                                      child: Text(_getPositionText(position)),
                                    ),).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedPosition = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Selecteer een positie';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<PreferredFoot>(
                            value: _selectedFoot,
                            decoration: const InputDecoration(
                              labelText: 'Voorkeur voet',
                              border: OutlineInputBorder(),
                            ),
                            items: PreferredFoot.values.map((foot) => DropdownMenuItem(
                                value: foot,
                                child: Text(_getFootText(foot)),
                              ),).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedFoot = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Selecteer voorkeur voet';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Physical Information Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fysieke Informatie',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _heightController,
                                  decoration: const InputDecoration(
                                    labelText: 'Lengte (cm)',
                                    border: OutlineInputBorder(),
                                    suffixText: 'cm',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Lengte is verplicht';
                                    }
                                    final height = int.tryParse(value);
                                    if (height == null || height < 100 || height > 250) {
                                      return 'Voer een realistische lengte in';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _weightController,
                                  decoration: const InputDecoration(
                                    labelText: 'Gewicht (kg)',
                                    border: OutlineInputBorder(),
                                    suffixText: 'kg',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Gewicht is verplicht';
                                    }
                                    final weight = int.tryParse(value);
                                    if (weight == null || weight < 30 || weight > 150) {
                                      return 'Voer een realistisch gewicht in';
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
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _savePlayer,
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 16)),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      locale: const Locale('nl', 'NL'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _savePlayer() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecteer een geboortedatum'),
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
      // Update player object
      _player!.firstName = _firstNameController.text;
      _player!.lastName = _lastNameController.text;
      _player!.jerseyNumber = int.parse(_jerseyNumberController.text);
      _player!.birthDate = _selectedDate!;
      _player!.position = _selectedPosition!;
      _player!.preferredFoot = _selectedFoot!;
      _player!.height = double.parse(_heightController.text);
      _player!.weight = double.parse(_weightController.text);
      _player!.email = _emailController.text.isEmpty ? null : _emailController.text;

      await ref.read(playersNotifierProvider.notifier).updatePlayer(_player!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Speler bijgewerkt'),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Speler verwijderen'),
        content: Text('Weet je zeker dat je ${_player!.name} wilt verwijderen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuleren'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deletePlayer();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Verwijderen'),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePlayer() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(playersNotifierProvider.notifier).deletePlayer(_player!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Speler verwijderd'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/players');
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

  String _getFootText(PreferredFoot foot) {
    switch (foot) {
      case PreferredFoot.left:
        return 'Links';
      case PreferredFoot.right:
        return 'Rechts';
      case PreferredFoot.both:
        return 'Beide';
    }
  }
}
