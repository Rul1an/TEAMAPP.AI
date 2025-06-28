#!/usr/bin/env dart

// Script to fix critical type casting errors in JO17 Tactical Manager
// Run with: dart fix_critical_errors.dart

import 'dart:io';

void main() {
  print('🔧 Fixing critical type casting errors...\n');

  // Fix content_distribution.dart
  fixContentDistribution();

  // Fix morphocycle.dart
  fixMorphocycle();

  // Fix other critical files
  fixOtherCriticalFiles();

  print('\n✅ Critical errors fixed! Run flutter analyze to verify.');
}

void fixContentDistribution() {
  print('📝 Fixing lib/models/annual_planning/content_distribution.dart');

  const String filePath = 'lib/models/annual_planning/content_distribution.dart';
  final File file = File(filePath);

  if (!file.existsSync()) {
    print('❌ File not found: $filePath');
    return;
  }

  String content = file.readAsStringSync();

  // Fix the fromJson factory method with proper type casting
  const String oldFromJson = '''
  factory ContentDistribution.fromJson(Map<String, dynamic> json) {
    final distribution = ContentDistribution();
    distribution.id = json['id'] ?? "";
    distribution.technicalPercentage = json['technicalPercentage']?.toDouble() ?? 0.0;
    distribution.tacticalPercentage = json['tacticalPercentage']?.toDouble() ?? 0.0;
    distribution.physicalPercentage = json['physicalPercentage']?.toDouble() ?? 0.0;
    distribution.mentalPercentage = json['mentalPercentage']?.toDouble() ?? 0.0;
    distribution.gamePlayPercentage = json['gamePlayPercentage']?.toDouble() ?? 0.0;
    distribution.description = json['description'];
    distribution.createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now();
    distribution.updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : DateTime.now();
    return distribution;
  }''';

  const String newFromJson = '''
  factory ContentDistribution.fromJson(Map<String, dynamic> json) {
    final ContentDistribution distribution = ContentDistribution()
      ..id = json['id'] as String? ?? ''
      ..technicalPercentage = (json['technicalPercentage'] as num?)?.toDouble() ?? 0.0
      ..tacticalPercentage = (json['tacticalPercentage'] as num?)?.toDouble() ?? 0.0
      ..physicalPercentage = (json['physicalPercentage'] as num?)?.toDouble() ?? 0.0
      ..mentalPercentage = (json['mentalPercentage'] as num?)?.toDouble() ?? 0.0
      ..gamePlayPercentage = (json['gamePlayPercentage'] as num?)?.toDouble() ?? 0.0
      ..description = json['description'] as String?
      ..createdAt = json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now()
      ..updatedAt = json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now();
    return distribution;
  }''';

  content = content.replaceAll(oldFromJson, newFromJson);

  // Fix string literals to use single quotes
  content = content.replaceAll('""', "''");
  content = content.replaceAll('"Balanced training distribution"', "'Balanced training distribution'");
  content = content.replaceAll('"Technical skill focus"', "'Technical skill focus'");
  content = content.replaceAll('"Tactical development focus"', "'Tactical development focus'");
  content = content.replaceAll('"Match preparation focus"', "'Match preparation focus'");
  content = content.replaceAll('"Recovery and light training"', "'Recovery and light training'");

  file.writeAsStringSync(content);
  print('✅ Fixed content_distribution.dart');
}

void fixMorphocycle() {
  print('📝 Fixing lib/models/annual_planning/morphocycle.dart');

  const String filePath = 'lib/models/annual_planning/morphocycle.dart';
  final File file = File(filePath);

  if (!file.existsSync()) {
    print('❌ File not found: $filePath');
    return;
  }

  String content = file.readAsStringSync();

  // Fix type casting issues in morphocycle.dart
  // Replace dynamic assignments with proper type casting
  content = content.replaceAllMapped(
    RegExp(r"json\['(\w+)'\](?!\s+as)"),
    (match) => "json['${match.group(1)}'] as String? ?? ''",
  );

  file.writeAsStringSync(content);
  print('✅ Fixed morphocycle.dart');
}

void fixOtherCriticalFiles() {
  print('📝 Fixing other critical files...');

  // List of files with critical errors
  final List<String> criticalFiles = [
    'lib/screens/admin/performance_monitoring_screen.dart',
    'lib/screens/analytics/advanced_analytics_screen.dart',
    'lib/screens/dashboard/dashboard_screen.dart',
    'lib/services/monitoring_service.dart',
  ];

  for (final String filePath in criticalFiles) {
    final File file = File(filePath);
    if (!file.existsSync()) {
      print('❌ File not found: $filePath');
      continue;
    }

    String content = file.readAsStringSync();

    // Fix common issues
    // Remove unused imports
    if (filePath.contains('dashboard_screen.dart')) {
      content = content.replaceAll("import '../ai_demo_screen.dart';", "// import '../ai_demo_screen.dart'; // Removed unused import");
    }

    // Fix Sentry transaction name issues
    if (filePath.contains('monitoring_service.dart')) {
      content = content.replaceAll('.name', '.description ?? "Unknown"');
    }

    file.writeAsStringSync(content);
    print('✅ Fixed $filePath');
  }
}
