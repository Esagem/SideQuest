import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/constants/xp.dart';

void main() {
  group('XpConstants', () {
    test('baseXp is 100', () {
      expect(XpConstants.baseXp, 100);
    });

    test('firstCompletionBonus is 50', () {
      expect(XpConstants.firstCompletionBonus, 50);
    });

    test('challengeCompletionBonus is 25', () {
      expect(XpConstants.challengeCompletionBonus, 25);
    });

    test('peopleBonus is 10', () {
      expect(XpConstants.peopleBonus, 10);
    });

    test('difficulty multipliers match spec', () {
      expect(XpConstants.difficultyMultipliers['easy'], 1.0);
      expect(XpConstants.difficultyMultipliers['medium'], 1.5);
      expect(XpConstants.difficultyMultipliers['hard'], 2.0);
      expect(XpConstants.difficultyMultipliers['legendary'], 3.0);
    });

    test('creator milestones are correct', () {
      expect(XpConstants.creatorMilestones[10], 10);
      expect(XpConstants.creatorMilestones[50], 25);
      expect(XpConstants.creatorMilestones[100], 50);
      expect(XpConstants.creatorMilestones[500], 100);
    });
  });
}
