// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import '../models/club/club.dart';
import '../models/club/player_progress.dart';
import '../models/club/staff_member.dart';
import '../models/club/team.dart';
import '../models/player.dart';
import '../repositories/club_repository.dart';
import '../services/club_service.dart';

/// 🏆 Club Provider
/// Manages club-level operations, teams, staff, and player progress
class ClubProvider extends ChangeNotifier {
  ClubProvider({
    required ClubRepository clubRepository,
    required ClubService clubService,
  })  : _clubRepository = clubRepository,
        _clubService = clubService;

  final ClubRepository _clubRepository;
  final ClubService _clubService;

  // State
  Club? _currentClub;
  final List<Team> _teams = [];
  final List<StaffMember> _staff = [];
  final List<Player> _allPlayers = [];
  final List<PlayerProgress> _playerProgress = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  Club? get currentClub => _currentClub;
  List<Team> get teams => List.unmodifiable(_teams);
  List<StaffMember> get staff => List.unmodifiable(_staff);
  List<Player> get allPlayers => List.unmodifiable(_allPlayers);
  List<PlayerProgress> get playerProgress => List.unmodifiable(_playerProgress);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasClub => _currentClub != null;

  // Filtered Data
  List<Team> getTeamsByAgeCategory(AgeCategory ageCategory) =>
      _teams.where((team) => team.ageCategory == ageCategory).toList();

  List<Team> getTeamsByGender(TeamGender gender) =>
      _teams.where((team) => team.gender == gender).toList();

  List<Team> getActiveTeams() =>
      _teams.where((team) => team.status == TeamStatus.active).toList();

  List<StaffMember> getStaffByRole(StaffRole role) => _staff
      .where(
        (member) =>
            member.primaryRole == role || member.additionalRoles.contains(role),
      )
      .toList();

  List<StaffMember> getStaffForTeam(String teamId) =>
      _staff.where((member) => member.teamIds.contains(teamId)).toList();

  List<Player> getPlayersForTeam(String teamId) {
    final team = _teams.firstWhere((t) => t.id == teamId);
    return _allPlayers
        .where((player) => team.playerIds.contains(player.id))
        .toList();
  }

  List<PlayerProgress> getProgressForPlayer(String playerId) => _playerProgress
      .where((progress) => progress.playerId == playerId)
      .toList();

  List<PlayerProgress> getProgressForSeason(String season) =>
      _playerProgress.where((progress) => progress.season == season).toList();

  // Club Management
  Future<void> loadClub(String clubId) async {
    _setLoading(true);
    try {
      final res = await _clubRepository.getById(clubId);
      if (res.isSuccess) {
        _currentClub = res.dataOrNull;
        await _loadClubData();
        _clearError();
      } else {
        throw Exception(res.errorOrNull);
      }
    } catch (e) {
      _setError('Failed to load club: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateClub(Club club) async {
    _setLoading(true);
    try {
      final res = await _clubRepository.update(club);
      if (res.isSuccess) {
        _currentClub = club;
        _clearError();
      } else {
        throw Exception(res.errorOrNull);
      }
    } catch (e) {
      _setError('Failed to update club: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadClubData() async {
    if (_currentClub == null) return;
    await Future.wait([
      _loadTeams(),
      _loadStaff(),
      _loadAllPlayers(),
      _loadPlayerProgress(),
    ]);
  }

  // Team Management
  Future<void> _loadTeams() async {
    if (_currentClub == null) return;
    try {
      final loaded = await _clubService.getTeamsForClub(_currentClub!.id);
      _teams
        ..clear()
        ..addAll(loaded);
    } catch (e) {
      _setError('Failed to load teams: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> addTeam(Team team) async {
    _setLoading(true);
    try {
      final newTeam = await _clubService.createTeam(team);
      _teams.add(newTeam);
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to add team: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Data loading methods
  Future<void> _loadStaff() async {
    if (_currentClub == null) return;
    try {
      final loaded = await _clubService.getStaffForClub(_currentClub!.id);
      _staff
        ..clear()
        ..addAll(loaded);
    } catch (e) {
      _setError('Failed to load staff: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> _loadAllPlayers() async {
    if (_currentClub == null) return;
    try {
      final loaded = await _clubService.getPlayersForClub(_currentClub!.id);
      _allPlayers
        ..clear()
        ..addAll(loaded);
    } catch (e) {
      _setError('Failed to load players: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> _loadPlayerProgress() async {
    if (_currentClub == null) return;
    try {
      final loaded =
          await _clubService.getPlayerProgressForClub(_currentClub!.id);
      _playerProgress
        ..clear()
        ..addAll(loaded);
    } catch (e) {
      _setError('Failed to load player progress: $e');
    } finally {
      notifyListeners();
    }
  }

  // Helper Methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearData() {
    _currentClub = null;
    _teams.clear();
    _staff.clear();
    _allPlayers.clear();
    _playerProgress.clear();
    _clearError();
    notifyListeners();
  }
}
