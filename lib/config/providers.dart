// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../data/supabase_club_data_source.dart';
import '../data/supabase_feature_data_source.dart';
import '../data/supabase_organization_data_source.dart';
import '../data/supabase_permission_data_source.dart';
import '../hive/hive_club_cache.dart';
import '../hive/hive_feature_cache.dart';
import '../hive/hive_organization_cache.dart';
import '../hive/hive_permission_cache.dart';
import '../providers/club_provider.dart';
import '../repositories/club_repository.dart';
import '../repositories/club_repository_impl.dart';
import '../repositories/feature_repository.dart';
import '../repositories/feature_repository_impl.dart';
import '../repositories/organization_repository.dart';
import '../repositories/organization_repository_impl.dart';
import '../repositories/permission_repository.dart';
import '../repositories/permission_repository_impl.dart';
import '../services/feature_service.dart';

export '../providers/auth_provider.dart';
export '../providers/demo_mode_provider.dart';
export '../providers/organization_provider.dart';

// Club repository dependencies
final supabaseClubDataSourceProvider =
    Provider<SupabaseClubDataSource>((ref) => SupabaseClubDataSource());

final hiveClubCacheProvider = Provider<HiveClubCache>((ref) => HiveClubCache());

final clubRepositoryProvider = Provider<ClubRepository>((ref) {
  final remote = ref.watch(supabaseClubDataSourceProvider);
  final cache = ref.watch(hiveClubCacheProvider);
  return ClubRepositoryImpl(remote: remote, cache: cache);
});

// Feature service provider
final featureServiceProvider =
    Provider<FeatureService>((ref) => FeatureService());

// Club provider using repository
final clubProvider = ChangeNotifierProvider<ClubProvider>(
  (ref) {
    final repo = ref.watch(clubRepositoryProvider);
    return ClubProvider(clubRepository: repo);
  },
);

// Calendar provider
final calendarProvider = ChangeNotifierProvider<CalendarProvider>(
  (ref) => CalendarProvider(),
);

// Player tracking provider
final playerTrackingProvider = ChangeNotifierProvider<PlayerTrackingProvider>(
  (ref) => PlayerTrackingProvider(),
);

// Organization repository deps
final supabaseOrganizationDataSourceProvider =
    Provider<SupabaseOrganizationDataSource>(
  (ref) => SupabaseOrganizationDataSource(),
);

final hiveOrganizationCacheProvider =
    Provider<HiveOrganizationCache>((ref) => HiveOrganizationCache());

final organizationRepositoryProvider = Provider<OrganizationRepository>((ref) {
  final remote = ref.watch(supabaseOrganizationDataSourceProvider);
  final cache = ref.watch(hiveOrganizationCacheProvider);
  return OrganizationRepositoryImpl(remote: remote, cache: cache);
});

// Permission & Feature repository deps
final supabasePermissionDataSourceProvider =
    Provider<SupabasePermissionDataSource>(
  (ref) => SupabasePermissionDataSource(),
);

final hivePermissionCacheProvider = Provider<HivePermissionCache>(
  (ref) => HivePermissionCache(),
);

final permissionRepositoryProvider = Provider<PermissionRepository>((ref) {
  final remote = ref.watch(supabasePermissionDataSourceProvider);
  final cache = ref.watch(hivePermissionCacheProvider);
  return PermissionRepositoryImpl(remote: remote, cache: cache);
});

final supabaseFeatureDataSourceProvider = Provider<SupabaseFeatureDataSource>(
  (ref) => SupabaseFeatureDataSource(),
);

final hiveFeatureCacheProvider = Provider<HiveFeatureCache>(
  (ref) => HiveFeatureCache(),
);

final featureRepositoryProvider = Provider<FeatureRepository>((ref) {
  final remote = ref.watch(supabaseFeatureDataSourceProvider);
  final cache = ref.watch(hiveFeatureCacheProvider);
  return FeatureRepositoryImpl(remote: remote, cache: cache);
});

// Calendar provider implementation
class CalendarProvider extends ChangeNotifier {
  final List<CalendarEvent> _events = [];

  List<CalendarEvent> get events => List.unmodifiable(_events);

  void addEvent(CalendarEvent event) {
    _events.add(event);
    notifyListeners();
  }

  void removeEvent(String eventId) {
    _events.removeWhere((event) => event.id == eventId);
    notifyListeners();
  }

  List<CalendarEvent> getEventsForDate(DateTime date) => _events
      .where(
        (event) =>
            event.date.year == date.year &&
            event.date.month == date.month &&
            event.date.day == date.day,
      )
      .toList();
}

// Calendar event model
class CalendarEvent {
  // 'training', 'match', 'meeting', etc.

  CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    this.description,
  });
  final String id;
  final String title;
  final DateTime date;
  final String? description;
  final String type;
}

// Player tracking provider implementation
class PlayerTrackingProvider extends ChangeNotifier {
  final Map<String, PlayerPerformanceData> _performanceData = {};

  Map<String, PlayerPerformanceData> get performanceData =>
      Map.unmodifiable(_performanceData);

  void updatePlayerData(String playerId, PlayerPerformanceData data) {
    _performanceData[playerId] = data;
    notifyListeners();
  }
}

// Player performance data model
class PlayerPerformanceData {
  PlayerPerformanceData({
    required this.playerId,
    required this.date,
    required this.metrics,
  });
  final String playerId;
  final DateTime date;
  final Map<String, double> metrics;
}
