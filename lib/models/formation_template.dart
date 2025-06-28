import 'package:isar/isar.dart';
import 'team.dart';

// part 'formation_template.g.dart'; // Temporarily commented out

class FormationTemplate {

  FormationTemplate() {
    name = '';
    description = '';
    formation = Formation.fourThreeThree;
    positionPreferences = {};
    isDefault = false;
    isCustom = true;
    createdBy = 'coach_1'; // TODO: Get from auth
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  // Factory method for creating default templates
  factory FormationTemplate.defaultTemplate({
    required String name,
    required String description,
    required Formation formation,
    required Map<String, String> positionPreferences,
  }) => FormationTemplate()
      ..name = name
      ..description = description
      ..formation = formation
      ..positionPreferences = positionPreferences
      ..isDefault = true
      ..isCustom = false
      ..createdBy = 'system';
  String id = '';

  late String name;
  late String description;

  @Enumerated(EnumType.name)
  late Formation formation;

  // Position mappings - position key to position preferences
  @Ignore()
  late Map<String, String> positionPreferences; // e.g., {'GK': 'goalkeeper', 'CB1': 'defender'}

  // Template metadata
  late bool isDefault; // System-provided templates
  late bool isCustom; // User-created templates
  late String createdBy; // Coach ID

  late DateTime createdAt;
  late DateTime updatedAt;

  // Helper method to get position preferences for a formation
  static Map<String, String> getDefaultPositionPreferences(Formation formation) {
    switch (formation) {
      case Formation.fourThreeThree:
        return {
          'GK': 'goalkeeper',
          'LB': 'defender',
          'CB1': 'defender',
          'CB2': 'defender',
          'RB': 'defender',
          'CM1': 'midfielder',
          'CM2': 'midfielder',
          'CM3': 'midfielder',
          'LW': 'forward',
          'ST': 'forward',
          'RW': 'forward',
        };
      case Formation.fourFourTwo:
        return {
          'GK': 'goalkeeper',
          'LB': 'defender',
          'CB1': 'defender',
          'CB2': 'defender',
          'RB': 'defender',
          'LM': 'midfielder',
          'CM1': 'midfielder',
          'CM2': 'midfielder',
          'RM': 'midfielder',
          'ST1': 'forward',
          'ST2': 'forward',
        };
      case Formation.fourFourTwoDiamond:
        return {
          'GK': 'goalkeeper',
          'LB': 'defender',
          'CB1': 'defender',
          'CB2': 'defender',
          'RB': 'defender',
          'DM': 'midfielder',
          'LM': 'midfielder',
          'RM': 'midfielder',
          'AM': 'midfielder',
          'ST1': 'forward',
          'ST2': 'forward',
        };
      case Formation.fourThreeThreeDefensive:
        return {
          'GK': 'goalkeeper',
          'LB': 'defender',
          'CB1': 'defender',
          'CB2': 'defender',
          'RB': 'defender',
          'DM': 'midfielder',
          'CM1': 'midfielder',
          'CM2': 'midfielder',
          'LW': 'forward',
          'ST': 'forward',
          'RW': 'forward',
        };
      case Formation.threeForThree:
        return {
          'GK': 'goalkeeper',
          'CB1': 'defender',
          'CB2': 'defender',
          'CB3': 'defender',
          'LM': 'midfielder',
          'CM1': 'midfielder',
          'CM2': 'midfielder',
          'RM': 'midfielder',
          'LW': 'forward',
          'ST': 'forward',
          'RW': 'forward',
        };
      case Formation.fourTwoThreeOne:
        return {
          'GK': 'goalkeeper',
          'LB': 'defender',
          'CB1': 'defender',
          'CB2': 'defender',
          'RB': 'defender',
          'DM1': 'midfielder',
          'DM2': 'midfielder',
          'LW': 'forward',
          'AM': 'midfielder',
          'RW': 'forward',
          'ST': 'forward',
        };
    }
  }
}
