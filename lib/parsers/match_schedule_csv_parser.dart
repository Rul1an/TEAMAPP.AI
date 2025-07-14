import '../models/dto/match_schedule_dto.dart';
import '../utils/base_csv_parser.dart';

class MatchScheduleCsvParser extends BaseCsvParser<MatchScheduleDto> {
  @override
  MatchScheduleDto? mapRow(Map<String, String> row) {
    try {
      return MatchScheduleDto(
        date: MatchScheduleDto.parseDate(row['match_date'] ?? row['date'] ?? ''),
        opponent: row['opponent']?.trim() ?? '',
        venue: row['venue']?.trim() ?? '',
        teamId: row['team_id']?.trim() ?? '',
      );
    } catch (_) {
      // Invalid row – let caller know by returning null
      return null;
    }
  }
}