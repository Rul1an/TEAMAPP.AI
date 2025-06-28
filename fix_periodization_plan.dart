import 'dart:io';

void main() {
  final file = File('lib/models/annual_planning/periodization_plan.dart');
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
    "(e) => e.name == json['modelType'],",
    "(e) => e.name == (json['modelType'] as String?),"
  );
  
  content = content.replaceAll(
    "(e) => e.name == json['targetAgeGroup'],",
    "(e) => e.name == (json['targetAgeGroup'] as String?),"
  );
  
  content = content.replaceAll(
    "plan.totalDurationWeeks = json['totalDurationWeeks'] ?? 36;",
    "plan.totalDurationWeeks = json['totalDurationWeeks'] as int? ?? 36;"
  );
  
  content = content.replaceAll(
    "plan.numberOfPeriods = json['numberOfPeriods'] ?? 4;",
    "plan.numberOfPeriods = json['numberOfPeriods'] as int? ?? 4;"
  );
  
  content = content.replaceAll(
    "plan.defaultIntensityTargets = json['defaultIntensityTargets'];",
    "plan.defaultIntensityTargets = json['defaultIntensityTargets'] as String?;"
  );
  
  content = content.replaceAll(
    "plan.defaultContentDistribution = json['defaultContentDistribution'];",
    "plan.defaultContentDistribution = json['defaultContentDistribution'] as String?;"
  );
  
  content = content.replaceAll(
    "plan.isTemplate = json['isTemplate'] ?? false;",
    "plan.isTemplate = json['isTemplate'] as bool? ?? false;"
  );
  
  content = content.replaceAll(
    "plan.isDefault = json['isDefault'] ?? false;",
    "plan.isDefault = json['isDefault'] as bool? ?? false;"
  );
  
  content = content.replaceAll(
    "plan.createdBy = json['createdBy'];",
    "plan.createdBy = json['createdBy'] as String?;"
  );
  
  content = content.replaceAll(
    "? DateTime.parse(json['createdAt'])",
    "? DateTime.parse(json['createdAt'] as String)"
  );
  
  content = content.replaceAll(
    "? DateTime.parse(json['updatedAt'])",
    "? DateTime.parse(json['updatedAt'] as String)"
  );
  
  file.writeAsStringSync(content);
  print('Fixed periodization_plan.dart');
}
