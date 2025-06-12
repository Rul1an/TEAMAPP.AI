import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../models/team.dart';
import '../models/training.dart';
import '../models/match.dart';
import '../services/database_service.dart';

// Database service provider
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

// Initialize database
final initializeDatabaseProvider = FutureProvider<void>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  await dbService.initialize();
});

// Team providers
final teamsProvider = FutureProvider<List<Team>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return await dbService.getAllTeams();
});

final selectedTeamProvider = FutureProvider.family<Team?, int?>((ref, teamId) async {
  if (teamId == null) return null;
  final dbService = ref.read(databaseServiceProvider);
  return await dbService.getTeam(teamId);
});

// Player providers
final playersProvider = FutureProvider<List<Player>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return await dbService.getAllPlayers();
});

final selectedPlayerProvider = FutureProvider.family<Player?, int?>((ref, playerId) async {
  if (playerId == null) return null;
  final dbService = ref.read(databaseServiceProvider);
  return await dbService.getPlayer(playerId);
});

final playersByPositionProvider = FutureProvider.family<List<Player>, Position>((ref, position) async {
  final dbService = ref.read(databaseServiceProvider);
  return await dbService.getPlayersByPosition(position);
});

// Training providers
final trainingsProvider = FutureProvider<List<Training>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return await dbService.getAllTrainings();
});

final upcomingTrainingsProvider = FutureProvider<List<Training>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return await dbService.getUpcomingTrainings();
});

// Match providers
final matchesProvider = FutureProvider<List<Match>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return await dbService.getAllMatches();
});

final upcomingMatchesProvider = FutureProvider<List<Match>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return await dbService.getUpcomingMatches();
});

// Statistics provider
final statisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return await dbService.getStatistics();
});

// Selected item providers
final selectedPlayerIdProvider = StateProvider<int?>((ref) => null);
final selectedMatchIdProvider = StateProvider<int?>((ref) => null);
final selectedTrainingIdProvider = StateProvider<int?>((ref) => null);

// Helper class for date range
class DateTimeRange {
  final DateTime start;
  final DateTime end;

  DateTimeRange({required this.start, required this.end});
}
