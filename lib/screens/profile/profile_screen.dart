// Dart imports:
import 'dart:io' as io;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import '../../models/profile.dart';
import '../../providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  bool _isSaving = false;

  Profile? _profile;

  @override
  void initState() {
    super.initState();
    // Load profile once from repository.
    Future.microtask(() async {
      final repo = ref.read(profileRepositoryProvider);
      final res = await repo.getCurrent();
      final prof = res.dataOrNull;
      if (mounted && prof != null) {
        setState(() {
          _profile = prof;
          _usernameCtrl.text = prof.username ?? '';
          _websiteCtrl.text = prof.website ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _websiteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _isSaving = true);
      try {
        final file = io.File(picked.path);
        final repo = ref.read(profileRepositoryProvider);
        final res = await repo.uploadAvatar(file);
        final updated = res.dataOrNull;
        if (updated != null) {
          setState(() => _profile = updated);
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final repo = ref.read(profileRepositoryProvider);
      final res = await repo.update(
        username: _usernameCtrl.text.trim(),
        website: _websiteCtrl.text.trim(),
      );
      res.when(
        success: (prof) {
          setState(() => _profile = prof);
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Profiel bijgewerkt')));
          }
        },
        failure: (e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Fout: ${e.message}')));
          }
        },
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profiel')),
      body: _profile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: _profile!.avatarUrl != null
                              ? NetworkImage(_profile!.avatarUrl!)
                                    as ImageProvider
                              : const AssetImage(
                                  'assets/images/avatar_placeholder.png',
                                ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: _isSaving ? null : _pickAvatar,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Gebruikersnaam',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Gebruikersnaam is verplicht';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _websiteCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Website',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.url,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Opslaan'),
                    onPressed: _isSaving ? null : _save,
                  ),
                ],
              ),
            ),
    );
  }
}
