import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/match.dart';
import '../models/player.dart';
import '../models/team.dart';
import '../models/training.dart';
import '../services/database_service.dart';

// Database service provider
final databaseServiceProvider = Provider<DatabaseService>((ref) => DatabaseService());

// Initialize database
final initializeDatabaseProvider = FutureProvider<void>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  await dbService.initialize();
});

// Team providers
final teamsProvider = FutureProvider<List<Team>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return dbService.getAllTeams();
});

final selectedTeamProvider = FutureProvider.family<Team?, String?>((ref, teamId) async {
  if (teamId == null) return null;
  final dbService = ref.read(databaseServiceProvider);
  return dbService.getTeam(teamId);
});

// Player providers
final playersProvider = FutureProvider<List<Player>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return dbService.getAllPlayers();
});

final selectedPlayerProvider = FutureProvider.family<Player?, String?>((ref, playerId) async {
  if (playerId == null) return null;
  final dbService = ref.read(databaseServiceProvider);
  return dbService.getPlayer(playerId);
});

final playersByPositionProvider = FutureProvider.family<List<Player>, Position>((ref, position) async {
  final dbService = ref.read(databaseServiceProvider);
  return dbService.getPlayersByPosition(position);
});

// Training providers
final trainingsProvider = FutureProvider<List<Training>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return dbService.getAllTrainings();
});

final upcomingTrainingsProvider = FutureProvider<List<Training>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return dbService.getUpcomingTrainings();
});

// Match providers
final matchesProvider = FutureProvider<List<Match>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return dbService.getAllMatches();
});

final upcomingMatchesProvider = FutureProvider<List<Match>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return dbService.getUpcomingMatches();
});

// Statistics provider
final statisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return dbService.getStatistics();
});

// Selected item providers
final selectedPlayerIdProvider = StateProvider<String?>((ref) => null);
final selectedMatchIdProvider = StateProvider<String?>((ref) => null);
final selectedTrainingIdProvider = StateProvider<String?>((ref) => null);

// Helper class for date range
class DateTimeRange {

  DateTimeRange({required this.start, required this.end});
  final DateTime start;
  final DateTime end;
}
