import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/user_model.dart';
import 'package:sidequest/services/badge_service.dart';

UserModel _makeUser({
  int questsCompleted = 0,
  int currentStreak = 0,
  List<String> badges = const [],
  Map<String, int> intentStats = const {},
}) =>
    UserModel(
      uid: 'u1',
      email: 'a@b.com',
      displayName: 'Test',
      username: 'test',
      dateOfBirth: DateTime(2000),
      questsCompleted: questsCompleted,
      currentStreak: currentStreak,
      badges: badges,
      intentStats: intentStats,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

void main() {
  group('milestone badges', () {
    test('awards first_quest at 1 completion', () {
      final user = _makeUser(questsCompleted: 1);
      final earned = BadgeService.checkEligibility(user: user);
      expect(earned, contains('first_quest'));
    });

    test('awards ten_quests at 10 completions', () {
      final user = _makeUser(questsCompleted: 10);
      final earned = BadgeService.checkEligibility(user: user);
      expect(earned, contains('ten_quests'));
    });

    test('awards fifty_quests at 50 completions', () {
      final user = _makeUser(questsCompleted: 50);
      final earned = BadgeService.checkEligibility(user: user);
      expect(earned, contains('fifty_quests'));
    });

    test('awards hundred_quests at 100 completions', () {
      final user = _makeUser(questsCompleted: 100);
      final earned = BadgeService.checkEligibility(user: user);
      expect(earned, contains('hundred_quests'));
    });

    test('does not re-award existing badges', () {
      final user = _makeUser(
        questsCompleted: 10,
        badges: ['first_quest', 'ten_quests'],
      );
      final earned = BadgeService.checkEligibility(user: user);
      expect(earned, isNot(contains('first_quest')));
      expect(earned, isNot(contains('ten_quests')));
    });
  });

  group('streak badges', () {
    test('awards streak_7 at 7-day streak', () {
      final user = _makeUser(currentStreak: 7);
      final earned = BadgeService.checkEligibility(user: user);
      expect(earned, contains('streak_7'));
    });

    test('awards streak_30 at 30-day streak', () {
      final user = _makeUser(currentStreak: 30);
      final earned = BadgeService.checkEligibility(user: user);
      expect(earned, contains('streak_30'));
    });
  });

  group('category badges', () {
    test('awards globetrotter for 10 travel quests', () {
      final user = _makeUser(questsCompleted: 10);
      final earned = BadgeService.checkEligibility(
        user: user,
        categoryCompletions: 10,
        completedCategory: 'travel',
      );
      expect(earned, contains('globetrotter'));
    });

    test('awards foodie for 10 food quests', () {
      final user = _makeUser(questsCompleted: 10);
      final earned = BadgeService.checkEligibility(
        user: user,
        categoryCompletions: 10,
        completedCategory: 'food',
      );
      expect(earned, contains('foodie'));
    });

    test('does not award for < 10 completions', () {
      final user = _makeUser(questsCompleted: 9);
      final earned = BadgeService.checkEligibility(
        user: user,
        categoryCompletions: 9,
        completedCategory: 'travel',
      );
      expect(earned, isNot(contains('globetrotter')));
    });
  });

  group('intent badges', () {
    test('awards connector for 10 connection intents', () {
      final user = _makeUser(intentStats: {'connection': 10});
      final earned = BadgeService.checkEligibility(user: user);
      expect(earned, contains('connector'));
    });

    test('awards grower for 10 growth intents', () {
      final user = _makeUser(intentStats: {'growth': 10});
      final earned = BadgeService.checkEligibility(user: user);
      expect(earned, contains('grower'));
    });
  });

  group('social badges', () {
    test('awards challenger for 5 challenges sent', () {
      final user = _makeUser();
      final earned = BadgeService.checkEligibility(
        user: user,
        challengesSent: 5,
      );
      expect(earned, contains('challenger'));
    });

    test('awards accepter for 5 challenges completed', () {
      final user = _makeUser();
      final earned = BadgeService.checkEligibility(
        user: user,
        challengesCompleted: 5,
      );
      expect(earned, contains('accepter'));
    });
  });

  group('creator badge', () {
    test('awards builder for quest with 50+ adds', () {
      final user = _makeUser();
      final earned = BadgeService.checkEligibility(
        user: user,
        questAddedCount: 50,
      );
      expect(earned, contains('builder'));
    });

    test('does not award for < 50 adds', () {
      final user = _makeUser();
      final earned = BadgeService.checkEligibility(
        user: user,
        questAddedCount: 49,
      );
      expect(earned, isNot(contains('builder')));
    });
  });
}
