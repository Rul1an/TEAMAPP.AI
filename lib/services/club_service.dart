// Project imports:
import '../models/club/club.dart';
import '../models/club/player_progress.dart';
import '../models/club/staff_member.dart';
import '../models/club/team.dart';
import '../models/player.dart';

/// 🏆 Club Service
/// Handles all club-related API operations and data management
class ClubService {
  // For now, we'll use in-memory storage
  // In production, this would connect to a real backend/database
  static final Map<String, Club> _clubs = {};
  static final Map<String, List<Team>> _clubTeams = {};
  static final Map<String, List<StaffMember>> _clubStaff = {};
  static final Map<String, List<Player>> _clubPlayers = {};
  static final Map<String, List<PlayerProgress>> _clubProgress = {};

  // Club Operations
  Future<Club> getClub(String clubId) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate API delay
    if (!_clubs.containsKey(clubId)) {
      throw Exception('Club not found');
    }
    return _clubs[clubId]!;
  }

  Future<Club> createClub(Club club) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _clubs[club.id] = club;
    _clubTeams[club.id] = [];
    _clubStaff[club.id] = [];
    _clubPlayers[club.id] = [];
    _clubProgress[club.id] = [];
    return club;
  }

  Future<Club> updateClub(Club club) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!_clubs.containsKey(club.id)) {
      throw Exception('Club not found');
    }
    _clubs[club.id] = club.copyWith(updatedAt: DateTime.now());
    return _clubs[club.id]!;
  }

  Future<void> deleteClub(String clubId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _clubs.remove(clubId);
    _clubTeams.remove(clubId);
    _clubStaff.remove(clubId);
    _clubPlayers.remove(clubId);
    _clubProgress.remove(clubId);
  }

  Future<List<Club>> getAllClubs() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _clubs.values.toList();
  }

  // Team Operations
  Future<List<Team>> getTeamsForClub(String clubId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _clubTeams[clubId]?.toList() ?? [];
  }

  Future<Team> createTeam(Team team) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final teams = _clubTeams.putIfAbsent(team.clubId, () => []);
    teams.add(team);
    return team;
  }

  // Staff Operations
  Future<List<StaffMember>> getStaffForClub(String clubId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _clubStaff[clubId]?.toList() ?? [];
  }

  Future<StaffMember> addStaffMember(StaffMember staff) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final staffList = _clubStaff.putIfAbsent(staff.clubId, () => []);
    staffList.add(staff);
    return staff;
  }

  // Player Operations
  Future<List<Player>> getPlayersForClub(String clubId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _clubPlayers[clubId]?.toList() ?? [];
  }

  Future<Player> addPlayer(Player player, String clubId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final players = _clubPlayers.putIfAbsent(clubId, () => []);
    players.add(player);
    return player;
  }

  // Player Progress Operations
  Future<List<PlayerProgress>> getPlayerProgressForClub(String clubId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _clubProgress[clubId]?.toList() ?? [];
  }

  Future<PlayerProgress> addPlayerProgress(PlayerProgress progress) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final progressList = _clubProgress.putIfAbsent(progress.clubId, () => []);
    progressList.add(progress);
    return progress;
  }

  // Simplified demo data for testing
  Future<void> initializeDemoData() async {
    // Basic demo implementation would go here
  }
}
