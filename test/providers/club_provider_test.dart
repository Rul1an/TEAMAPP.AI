import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/club/club.dart';
import 'package:jo17_tactical_manager/models/club/player_progress.dart';
import 'package:jo17_tactical_manager/models/club/staff_member.dart';
import 'package:jo17_tactical_manager/models/club/team.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/providers/club_provider.dart';
import 'package:jo17_tactical_manager/repositories/club_repository.dart';
import 'package:jo17_tactical_manager/services/club_service.dart';
import 'package:jo17_tactical_manager/core/result.dart';

class _FakeClubRepository implements ClubRepository {
  _FakeClubRepository(this._club);
  final Club _club;

  @override
  Future<Result<void>> add(Club club) async => const Success(null);

  @override
  Future<Result<void>> delete(String id) async => const Success(null);

  @override
  Future<Result<List<Club>>> getAll() async => Success([_club]);

  @override
  Future<Result<Club?>> getById(String id) async => Success(_club);

  @override
  Future<Result<void>> update(Club club) async => const Success(null);
}

void main() {
  test('loadClub loads teams, staff, players, and progress', () async {
    final service = ClubService();

    final club = Club(
      id: 'c1',
      name: 'Test Club',
      shortName: 'TC',
      foundedDate: DateTime(2020, 1, 1),
      settings: const ClubSettings(),
      status: ClubStatus.active,
      createdAt: DateTime.now(),
    );
    await service.createClub(club);

    final team = Team(
      id: 't1',
      clubId: club.id,
      name: 'Team A',
      shortName: 'TA',
      ageCategory: AgeCategory.jo15,
      level: TeamLevel.recreational,
      gender: TeamGender.male,
      currentSeason: '2024',
      settings: const TeamSettings(),
      status: TeamStatus.active,
      createdAt: DateTime.now(),
    );
    await service.createTeam(team);

    final staff = StaffMember(
      id: 's1',
      clubId: club.id,
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      primaryRole: StaffRole.headCoach,
      permissions: const StaffPermissions(),
      availability: const StaffAvailability(),
      status: StaffStatus.active,
      createdAt: DateTime.now(),
    );
    await service.addStaffMember(staff);

    final player = Player(
      id: 'p1',
      firstName: 'Alice',
      lastName: 'Smith',
      jerseyNumber: 9,
      birthDate: DateTime(2008, 1, 1),
      position: Position.forward,
      preferredFoot: PreferredFoot.right,
      height: 170,
      weight: 60,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await service.addPlayer(player, club.id);

    final progress = PlayerProgress(
      id: 'pr1',
      playerId: player.id,
      teamId: team.id,
      clubId: club.id,
      season: '2024',
      startDate: DateTime.now(),
      technicalSkills: const TechnicalSkills(),
      physicalAttributes: const PhysicalAttributes(),
      tacticalSkills: const TacticalSkills(),
      mentalAttributes: const MentalAttributes(),
      performanceMetrics: const PerformanceMetrics(),
      overallRating: const OverallRating(),
      status: ProgressStatus.active,
      createdAt: DateTime.now(),
    );
    await service.addPlayerProgress(progress);

    final repo = _FakeClubRepository(club);
    final provider = ClubProvider(
      clubRepository: repo,
      clubService: service,
    );

    await provider.loadClub(club.id);

    expect(provider.teams, [team]);
    expect(provider.staff, [staff]);
    expect(provider.allPlayers, [player]);
    expect(provider.playerProgress, [progress]);
  });
}
