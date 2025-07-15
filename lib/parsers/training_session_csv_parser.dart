import '../models/dto/training_session_dto.dart';
import '../utils/base_csv_parser.dart';

class TrainingSessionCsvParser extends BaseCsvParser<TrainingSessionDto> {
  @override
  TrainingSessionDto? mapRow(Map<String, String> row) {
    try {
      final dateStr = row['date'] ?? row['training_date'] ?? '';
      final start = row['start_time'] ?? row['start'] ?? '';
      final end = row['end_time'] ?? row['end'] ?? '';
      final team = row['team_id'] ?? row['team'] ?? '';
      if (team.isEmpty || start.isEmpty || end.isEmpty) return null;
      final date = TrainingSessionDto.parseDate(dateStr);
      return TrainingSessionDto(
        date: date,
        startTime: start,
        endTime: end,
        teamId: team,
      );
    } catch (_) {
      return null;
    }
  }
}