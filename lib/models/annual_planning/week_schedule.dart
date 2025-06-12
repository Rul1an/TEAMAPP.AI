import 'morphocycle.dart';

class WeekSchedule {
  final int weekNumber;
  final DateTime weekStartDate;
  final List<WeeklyTraining> trainingSessions;
  final List<WeeklyMatch> matches;
  final String? notes;
  final bool isVacation;
  final String? vacationDescription;

  WeekSchedule({
    required this.weekNumber,
    required this.weekStartDate,
    this.trainingSessions = const [],
    this.matches = const [],
    this.notes,
    this.isVacation = false,
    this.vacationDescription,
  });

  DateTime get weekEndDate => weekStartDate.add(const Duration(days: 6));

  bool get hasActivities => trainingSessions.isNotEmpty || matches.isNotEmpty;

  String get monthName {
    const months = [
      'Januari', 'Februari', 'Maart', 'April', 'Mei', 'Juni',
      'Juli', 'Augustus', 'September', 'Oktober', 'November', 'December'
    ];
    return months[weekStartDate.month - 1];
  }
}

class WeeklyTraining {
  final String name;
  final DateTime dateTime;
  final String location;
  final Duration duration;
  final String? notes;
  final TrainingIntensity? intensity;
  final int? durationMinutes;
  final int? rpe;

  WeeklyTraining({
    required this.name,
    required this.dateTime,
    required this.location,
    this.duration = const Duration(hours: 1, minutes: 30),
    this.notes,
    this.intensity,
    this.durationMinutes,
    this.rpe,
  });

  String get timeString {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String get dayName {
    const days = ['Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za', 'Zo'];
    return days[dateTime.weekday - 1];
  }

  // Training load calculation using Foster method
  double get trainingLoad {
    if (rpe != null && durationMinutes != null) {
      return rpe! * durationMinutes!.toDouble();
    }
    return 0.0;
  }

  // Get intensity description
  String get intensityDescription {
    if (intensity == null) return 'Standard';

    switch (intensity!) {
      case TrainingIntensity.recovery:
        return 'Recovery (30-40%)';
      case TrainingIntensity.activation:
        return 'Activation (50-60%)';
      case TrainingIntensity.development:
        return 'Development (70-80%)';
      case TrainingIntensity.acquisition:
        return 'Acquisition (85-95%)';
      case TrainingIntensity.competition:
        return 'Competition (100%)';
    }
  }
}

class WeeklyMatch {
  final String opponent;
  final DateTime dateTime;
  final String location;
  final bool isHomeMatch;
  final String? result;
  final String? notes;
  final MatchType type;

  WeeklyMatch({
    required this.opponent,
    required this.dateTime,
    required this.location,
    this.isHomeMatch = true,
    this.result,
    this.notes,
    this.type = MatchType.regular,
  });

  String get timeString {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String get dayName {
    const days = ['Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za', 'Zo'];
    return days[dateTime.weekday - 1];
  }

  String get locationDisplay {
    return isHomeMatch ? 'Thuis' : location;
  }
}

enum MatchType {
  regular,
  cup,
  friendly,
  tournament,
}

extension MatchTypeExtension on MatchType {
  String get displayName {
    switch (this) {
      case MatchType.regular:
        return 'Competitie';
      case MatchType.cup:
        return 'Beker';
      case MatchType.friendly:
        return 'Oefenwedstrijd';
      case MatchType.tournament:
        return 'Toernooi';
    }
  }
}
