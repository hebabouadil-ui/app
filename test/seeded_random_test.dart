import 'package:dream_ai/core/utils/seeded_random.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SeededRandom', () {
    test('fnv1a32 is stable for the same input', () {
      expect(SeededRandom.fnv1a32('hello'), SeededRandom.fnv1a32('hello'));
      expect(SeededRandom.fnv1a32('a') == SeededRandom.fnv1a32('b'), isFalse);
    });

    test('same seed produces the same sequence', () {
      final SeededRandom a = SeededRandom.fromString('seed-123');
      final SeededRandom b = SeededRandom.fromString('seed-123');
      for (int i = 0; i < 50; i++) {
        expect(a.nextInt(0, 1000), b.nextInt(0, 1000));
      }
    });

    test('nextScore stays within bounds', () {
      final SeededRandom r = SeededRandom.fromString('bounds');
      for (int i = 0; i < 500; i++) {
        final int s = r.nextScore(min: 35, max: 99);
        expect(s, inInclusiveRange(35, 99));
      }
    });

    test('nextInt respects inclusive range', () {
      final SeededRandom r = SeededRandom.fromString('range');
      for (int i = 0; i < 500; i++) {
        expect(r.nextInt(5, 7), inInclusiveRange(5, 7));
      }
    });

    test('pickMany returns distinct items', () {
      final SeededRandom r = SeededRandom.fromString('pick');
      final List<String> items = <String>['a', 'b', 'c', 'd', 'e'];
      final List<String> picked = r.pickMany(items, 3);
      expect(picked.length, 3);
      expect(picked.toSet().length, 3); // all distinct
    });
  });
}
