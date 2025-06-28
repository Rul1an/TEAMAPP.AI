import 'dart:io';

void main() {
  final file = File('lib/models/annual_planning/season_plan.dart');
  String content = file.readAsStringSync();
  
  // Fix the fromJson method with proper type casting
  content = content.replaceAll(
    "plan.id = json['id'] ?? '';",
    "plan.id = json['id'] as String? ?? '';"
  );
  
  content = content.replaceAll(
    "plan.name = json['name'] ?? '';",
    "plan.name = json['name'] as String? ?? '';"
  );
  
  content = content.replaceAll(
    "plan.description = json['description'] ?? '';",
    "plan.description = json['description'] as String? ?? '';"
  );
  
  content = content.replaceAll(
    "plan.season = json['season'] ?? '';",
    "plan.season = json['season'] as String? ?? '';"
  );
  
  content = content.replaceAll(
    "plan.periodizationPlanId = json['periodizationPlanId'];",
    "plan.periodizationPlanId = json['periodizationPlanId'] as String?;"
  );
  
  content = content.replaceAll(
    "? DateTime.parse(json['createdAt'])",
    "? DateTime.parse(json['createdAt'] as String)"
  );
  
  content = content.replaceAll(
    "? DateTime.parse(json['updatedAt'])",
    "? DateTime.parse(json['updatedAt'] as String)"
  );
  
  content = content.replaceAll(
    "as List<dynamic>? ?? []",
    "as List<dynamic>? ?? []"
  );
  
  file.writeAsStringSync(content);
  print('Fixed season_plan.dart');
}
