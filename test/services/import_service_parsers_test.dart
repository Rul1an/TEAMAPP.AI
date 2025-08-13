// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/services/import_service.dart';
import 'package:jo17_tactical_manager/models/player.dart';

void main() {
  group('ImportService.parseDateString', () {
    test('parses common formats', () {
      expect(ImportService.parseDateString('01-02-2003').year, 2003);
      expect(ImportService.parseDateString('2003-02-01').year, 2003);
      expect(ImportService.parseDateString('01/02/2003').year, 2003);
    });
  });

  group('ImportService.parsePositionString', () {
    test('maps various labels to enums', () {
      expect(ImportService.parsePositionString('GK'), Position.goalkeeper);
      expect(ImportService.parsePositionString('Defender'), Position.defender);
      expect(
          ImportService.parsePositionString('Midfielder'), Position.midfielder);
      expect(ImportService.parsePositionString('Forward'), Position.forward);
    });
  });

  group('ImportService.parsePreferredFootString', () {
    test('detects left/right', () {
      expect(
          ImportService.parsePreferredFootString('Links'), PreferredFoot.left);
      expect(
          ImportService.parsePreferredFootString('Right'), PreferredFoot.right);
    });
  });
}
