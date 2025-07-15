import '../models/dto/player_roster_dto.dart';
import '../utils/base_csv_parser.dart';

class PlayerRosterCsvParser extends BaseCsvParser<PlayerRosterDto> {
  @override
  PlayerRosterDto? mapRow(Map<String, String> row) {
    try {
      final first = row['first_name'] ?? row['firstname'] ?? '';
      final last = row['last_name'] ?? row['lastname'] ?? '';
      final jersey = int.tryParse(row['jersey_number'] ?? row['number'] ?? '') ?? 0;
      final birth = PlayerRosterDto.parseDate(row['birth_date'] ?? row['birthdate'] ?? '');
      final pos = PlayerRosterDto.parsePosition(row['position'] ?? '');
      if (first.isEmpty || last.isEmpty || jersey == 0) return null;
      return PlayerRosterDto(
        firstName: first,
        lastName: last,
        birthDate: birth,
        jerseyNumber: jersey,
        position: pos,
      );
    } catch (_) {
      return null;
    }
  }
}