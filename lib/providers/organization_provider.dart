import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/organization.dart';
import '../services/organization_service.dart';
import 'auth_provider.dart';
import 'demo_mode_provider.dart';

// Organization service provider
final organizationServiceProvider =
    Provider<OrganizationService>((ref) => OrganizationService());

// Current organization provider
final currentOrganizationProvider = StateProvider<Organization?>((ref) {
  // In demo mode, return demo organization
  final demoMode = ref.watch(demoModeProvider);
  if (demoMode.isActive) {
    return Organization(
      id: demoMode.organizationId ?? 'demo-org',
      name: 'Demo Club',
      slug: 'demo-club',
      tier: OrganizationTier.enterprise, // Full features in demo
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // For MVP: return default organization for logged in users
  final user = ref.watch(currentUserProvider);
  if (user != null) {
    // TODO(author): Fetch real organization from database
    return Organization(
      id: 'default-org',
      name: 'Mijn Voetbalclub',
      slug: 'mijn-voetbalclub',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  return null;
});

// Organization ID helper
final currentOrganizationIdProvider = Provider<String?>((ref) {
  final org = ref.watch(currentOrganizationProvider);
  return org?.id;
});

// Organization tier provider
final currentOrganizationTierProvider = Provider<OrganizationTier>((ref) {
  final org = ref.watch(currentOrganizationProvider);
  return org?.tier ?? OrganizationTier.basic;
});

// Feature availability providers
final svsEnabledProvider = Provider<bool>((ref) {
  final org = ref.watch(currentOrganizationProvider);
  final tier = org?.tier ?? OrganizationTier.basic;
  return tier.defaultSettings.svsEnabled;
});

final analyticsEnabledProvider = Provider<bool>((ref) {
  final org = ref.watch(currentOrganizationProvider);
  final tier = org?.tier ?? OrganizationTier.basic;
  return tier.defaultSettings.analyticsEnabled;
});

// Organization limits providers
final maxPlayersProvider = Provider<int>((ref) {
  final org = ref.watch(currentOrganizationProvider);
  final tier = org?.tier ?? OrganizationTier.basic;
  return tier.defaultSettings.maxPlayers;
});

final maxTeamsProvider = Provider<int>((ref) {
  final org = ref.watch(currentOrganizationProvider);
  final tier = org?.tier ?? OrganizationTier.basic;
  return tier.defaultSettings.maxTeams;
});

final maxCoachesProvider = Provider<int>((ref) {
  final org = ref.watch(currentOrganizationProvider);
  final tier = org?.tier ?? OrganizationTier.basic;
  return tier.defaultSettings.maxCoaches;
});
