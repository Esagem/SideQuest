import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/user_model.dart';
import 'package:sidequest/services/streak_service.dart';

UserModel _makeUser({
  int currentStreak = 5,
  int streakFreezeAvailable = 1,
  DateTime? lastCompletionDate,
}) =>
    UserModel(
      uid: 'u1',
      email: 'a@b.com',
      displayName: 'Test',
      username: 'test',
      dateOfBirth: DateTime(2000),
      currentStreak: currentStreak,
      streakFreezeAvailable: streakFreezeAvailable,
      lastCompletionDate: lastCompletionDate,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

void main() {
  final now = DateTime(2026, 6, 15);

  group('isStreakActive', () {
    test('active when completed within 7 days', () {
      final user = _makeUser(
        lastCompletionDate: now.subtract(const Duration(days: 3)),
      );
      expect(StreakService.isStreakActive(user, now: now), isTrue);
    });

    test('inactive when completed 7+ days ago', () {
      final user = _makeUser(
        lastCompletionDate: now.subtract(const Duration(days: 7)),
      );
      expect(StreakService.isStreakActive(user, now: now), isFalse);
    });

    test('inactive when no completion date', () {
      final user = _makeUser();
      expect(StreakService.isStreakActive(user, now: now), isFalse);
    });
  });

  group('checkStreak', () {
    test('returns active when streak is within window', () {
      final user = _makeUser(
        lastCompletionDate: now.subtract(const Duration(days: 2)),
      );
      final result = StreakService.checkStreak(user, now: now);
      expect(result.status, StreakStatus.active);
      expect(result.currentStreak, 5);
    });

    test('returns frozen when freeze is available', () {
      final user = _makeUser(
        lastCompletionDate: now.subtract(const Duration(days: 8)),
        streakFreezeAvailable: 2,
      );
      final result = StreakService.checkStreak(user, now: now);
      expect(result.status, StreakStatus.frozen);
      expect(result.currentStreak, 5);
      expect(result.freezesRemaining, 1);
    });

    test('returns broken when no freeze available', () {
      final user = _makeUser(
        lastCompletionDate: now.subtract(const Duration(days: 10)),
        streakFreezeAvailable: 0,
      );
      final result = StreakService.checkStreak(user, now: now);
      expect(result.status, StreakStatus.broken);
      expect(result.currentStreak, 0);
    });

    test('returns broken when no completion and no freeze', () {
      final user = _makeUser(streakFreezeAvailable: 0);
      final result = StreakService.checkStreak(user, now: now);
      expect(result.status, StreakStatus.broken);
    });
  });

  group('calculateMilestone', () {
    test('returns 50 XP at 4 weeks', () {
      expect(StreakService.calculateMilestone(4), 50);
    });

    test('returns 100 XP at 12 weeks', () {
      expect(StreakService.calculateMilestone(12), 100);
    });

    test('returns 200 XP at 26 weeks', () {
      expect(StreakService.calculateMilestone(26), 200);
    });

    test('returns 500 XP at 52 weeks', () {
      expect(StreakService.calculateMilestone(52), 500);
    });

    test('returns 0 for non-milestone weeks', () {
      expect(StreakService.calculateMilestone(1), 0);
      expect(StreakService.calculateMilestone(5), 0);
      expect(StreakService.calculateMilestone(53), 0);
    });
  });

  group('monthlyFreezeAllocation', () {
    test('free users get 1 freeze', () {
      expect(StreakService.monthlyFreezeAllocation(isPro: false), 1);
    });

    test('pro users get 3 freezes', () {
      expect(StreakService.monthlyFreezeAllocation(isPro: true), 3);
    });
  });
}
