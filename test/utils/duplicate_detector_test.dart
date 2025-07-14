import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/utils/duplicate_detector.dart';

void main() {
  group('DuplicateDetector', () {
    test('marks item as duplicate after first insertion', () {
      final detector = DuplicateDetector<String>();
      expect(detector.isDuplicate('a'), isFalse); // first time – not duplicate
      expect(detector.isDuplicate('a'), isTrue); // second time – duplicate
    });

    test('respects initial hashes', () {
      final detector = DuplicateDetector<String>(initialHashes: {'x'});
      expect(detector.isDuplicate('x'), isTrue); // pre-seeded duplicate
      expect(detector.isDuplicate('y'), isFalse);
    });

    test('clear() resets state', () {
      final detector = DuplicateDetector<int>();
      detector.isDuplicate(1); // adds 1
      expect(detector.isDuplicate(1), isTrue);
      detector.clear();
      expect(detector.isDuplicate(1), isFalse); // after clear – not duplicate
    });
  });
}