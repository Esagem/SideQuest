import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/constants/tiers.dart';

void main() {
  group('Tier.fromXp', () {
    test('returns novice for 0 XP', () {
      expect(Tier.fromXp(0), Tier.novice);
    });

    test('returns novice for 499 XP', () {
      expect(Tier.fromXp(499), Tier.novice);
    });

    test('returns explorer at 500 XP boundary', () {
      expect(Tier.fromXp(500), Tier.explorer);
    });

    test('returns explorer for 1999 XP', () {
      expect(Tier.fromXp(1999), Tier.explorer);
    });

    test('returns adventurer at 2000 XP boundary', () {
      expect(Tier.fromXp(2000), Tier.adventurer);
    });

    test('returns trailblazer at 5000 XP boundary', () {
      expect(Tier.fromXp(5000), Tier.trailblazer);
    });

    test('returns legend at 15000 XP boundary', () {
      expect(Tier.fromXp(15000), Tier.legend);
    });

    test('returns legend for very high XP', () {
      expect(Tier.fromXp(99999), Tier.legend);
    });
  });
}
