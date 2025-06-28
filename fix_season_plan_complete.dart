import 'dart:io';

void main() {
  final file = File('lib/models/annual_planning/season_plan.dart');
  String content = file.readAsStringSync();
  
  // Fix DateTime.parse calls
  content = content.replaceAll(
    "DateTime.parse(json['seasonStartDate'])",
    "DateTime.parse(json['seasonStartDate'] as String)"
  );
  
  content = content.replaceAll(
    "DateTime.parse(json['seasonEndDate'])",
    "DateTime.parse(json['seasonEndDate'] as String)"
  );
  
  content = content.replaceAll(
    "DateTime.parse(json['firstMatchDate'])",
    "DateTime.parse(json['firstMatchDate'] as String)"
  );
  
  content = content.replaceAll(
    "DateTime.parse(json['lastMatchDate'])",
    "DateTime.parse(json['lastMatchDate'] as String)"
  );
  
  content = content.replaceAll(
    "DateTime.parse(json['midSeasonBreakStart'])",
    "DateTime.parse(json['midSeasonBreakStart'] as String)"
  );
  
  content = content.replaceAll(
    "DateTime.parse(json['midSeasonBreakEnd'])",
    "DateTime.parse(json['midSeasonBreakEnd'] as String)"
  );
  
  // Fix List.from calls
  content = content.replaceAll(
    "List<String>.from(json['holidayPeriods'] ?? [])",
    "List<String>.from(json['holidayPeriods'] as List<dynamic>? ?? [])"
  );
  
  content = content.replaceAll(
    "List<String>.from(json['additionalCompetitions'] ?? [])",
    "List<String>.from(json['additionalCompetitions'] as List<dynamic>? ?? [])"
  );
  
  content = content.replaceAll(
    "List<String>.from(json['seasonObjectives'] ?? [])",
    "List<String>.from(json['seasonObjectives'] as List<dynamic>? ?? [])"
  );
  
  content = content.replaceAll(
    "List<String>.from(json['keyPerformanceIndicators'] ?? [])",
    "List<String>.from(json['keyPerformanceIndicators'] as List<dynamic>? ?? [])"
  );
  
  // Fix enum parsing
  content = content.replaceAll(
    "(e) => e.name == json['status']",
    "(e) => e.name == (json['status'] as String?)"
  );
  
  file.writeAsStringSync(content);
  print('Fixed season_plan.dart completely');
}
