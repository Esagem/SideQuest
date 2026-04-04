import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/features/auth/screens/age_gate_screen.dart';

void main() {
  group('isAge13OrOlder', () {
    test('returns true for someone exactly 13 today', () {
      final now = DateTime.now();
      final dob = DateTime(now.year - 13, now.month, now.day);
      expect(isAge13OrOlder(dob), isTrue);
    });

    test('returns true for someone 14 years old', () {
      final now = DateTime.now();
      final dob = DateTime(now.year - 14, now.month, now.day);
      expect(isAge13OrOlder(dob), isTrue);
    });

    test('returns true for someone 30 years old', () {
      final now = DateTime.now();
      final dob = DateTime(now.year - 30);
      expect(isAge13OrOlder(dob), isTrue);
    });

    test('returns false for someone 12 years old', () {
      final now = DateTime.now();
      final dob = DateTime(now.year - 12, now.month, now.day);
      expect(isAge13OrOlder(dob), isFalse);
    });

    test('returns false for someone turning 13 tomorrow', () {
      final now = DateTime.now();
      final dob = DateTime(now.year - 13, now.month, now.day + 1);
      expect(isAge13OrOlder(dob), isFalse);
    });

    test('returns false for a baby born today', () {
      expect(isAge13OrOlder(DateTime.now()), isFalse);
    });
  });
}
