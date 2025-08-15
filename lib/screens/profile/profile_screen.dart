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
import '../../widgets/common/network_image_smart.dart';
import '../../providers/notification_service_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/consent_provider.dart';

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
  bool _notifToggle = false;
  bool _analyticsConsent = false;

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
      // Load analytics consent
      final analytics = await ref.read(analyticsConsentProvider.future);
      if (mounted) setState(() => _analyticsConsent = analytics);
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
    final avatarSize = 96.0;
    const notifEnabled =
        bool.fromEnvironment('ENABLE_NOTIFICATIONS', defaultValue: false);

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
                        ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.square(96),
                            child: _profile!.avatarUrl != null
                                ? NetworkImageSmart(
                                    _profile!.avatarUrl!,
                                    fit: BoxFit.cover,
                                    width: avatarSize,
                                    height: avatarSize,
                                    filterQuality: FilterQuality.medium,
                                  )
                                : Image.asset(
                                    'assets/images/avatar_placeholder.png',
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.medium,
                                  ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          tooltip: 'Wijzig avatar',
                          constraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                          ),
                          onPressed: _isSaving ? null : _pickAvatar,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Demo-only notifications toggle (gated; no-op on web)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.notifications_active),
                              SizedBox(width: 8),
                              Text('Notificaties (Demo)')
                            ],
                          ),
                          const SizedBox(height: 8),
                          SwitchListTile(
                            value: _notifToggle,
                            title: Text(
                              notifEnabled
                                  ? 'Inschakelen voor huidige gebruiker/organisatie'
                                  : 'Niet beschikbaar (ENABLE_NOTIFICATIONS=false)',
                            ),
                            onChanged: (!notifEnabled || _profile == null)
                                ? null
                                : (val) async {
                                    setState(() => _notifToggle = val);
                                    // Capture messenger before awaits to satisfy analyzer
                                    final messenger =
                                        ScaffoldMessenger.of(context);
                                    final api =
                                        ref.read(notificationServiceProvider);
                                    final user = ref.read(currentUserProvider);
                                    final orgId =
                                        ref.read(organizationIdProvider);
                                    if (user != null) {
                                      if (val) {
                                        await api.subscribeToUser(user.id);
                                      } else {
                                        await api.unsubscribeFromUser(user.id);
                                      }
                                    }
                                    if (orgId != null) {
                                      if (val) {
                                        await api.subscribeToTenant(orgId);
                                      } else {
                                        await api.unsubscribeFromTenant(orgId);
                                      }
                                    }
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          val
                                              ? 'Notificaties ingeschakeld'
                                              : 'Notificaties uitgeschakeld',
                                        ),
                                      ),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Analytics consent toggle
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.analytics_outlined),
                              SizedBox(width: 8),
                              Text('Analytics toestemming')
                            ],
                          ),
                          const SizedBox(height: 8),
                          SwitchListTile(
                            value: _analyticsConsent,
                            title: const Text('Sta anonieme analytics toe'),
                            onChanged: (val) async {
                              setState(() => _analyticsConsent = val);
                              final service = ref.read(consentServiceProvider);
                              await service.setConsent({'analytics': val});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
