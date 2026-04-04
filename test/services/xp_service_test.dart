import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/blocks/block_config.dart';
import 'package:sidequest/models/blocks/bonus_block.dart';
import 'package:sidequest/models/blocks/people_block.dart';
import 'package:sidequest/models/blocks/proof_block.dart';
import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/services/xp_service.dart';

void main() {
  const baseBlocks = QuestBlocks(proof: ProofBlock(type: ProofType.photo));

  group('calculateQuestXp', () {
    test('easy quest base XP is 100', () {
      final xp = XpService.calculateQuestXp(
        difficulty: Difficulty.easy,
        blocks: baseBlocks,
        isFirstCompletion: false,
        isChallenge: false,
      );
      expect(xp, 100);
    });

    test('medium quest is 150 XP', () {
      final xp = XpService.calculateQuestXp(
        difficulty: Difficulty.medium,
        blocks: baseBlocks,
        isFirstCompletion: false,
        isChallenge: false,
      );
      expect(xp, 150);
    });

    test('hard quest is 200 XP', () {
      final xp = XpService.calculateQuestXp(
        difficulty: Difficulty.hard,
        blocks: baseBlocks,
        isFirstCompletion: false,
        isChallenge: false,
      );
      expect(xp, 200);
    });

    test('legendary quest is 300 XP', () {
      final xp = XpService.calculateQuestXp(
        difficulty: Difficulty.legendary,
        blocks: baseBlocks,
        isFirstCompletion: false,
        isChallenge: false,
      );
      expect(xp, 300);
    });

    test('first completion adds 50 bonus', () {
      final xp = XpService.calculateQuestXp(
        difficulty: Difficulty.easy,
        blocks: baseBlocks,
        isFirstCompletion: true,
        isChallenge: false,
      );
      expect(xp, 150);
    });

    test('challenge adds 25 bonus', () {
      final xp = XpService.calculateQuestXp(
        difficulty: Difficulty.easy,
        blocks: baseBlocks,
        isFirstCompletion: false,
        isChallenge: true,
      );
      expect(xp, 125);
    });

    test('people bonus adds 10 per person', () {
      const blocksWithPeople = QuestBlocks(
        proof: ProofBlock(type: ProofType.photo),
        people: PeopleBlock(type: PeopleType.group, minCount: 3),
      );
      final xp = XpService.calculateQuestXp(
        difficulty: Difficulty.easy,
        blocks: blocksWithPeople,
        isFirstCompletion: false,
        isChallenge: false,
        additionalPeople: 3,
      );
      expect(xp, 130);
    });

    test('bonus block adds xpBonus', () {
      const blocksWithBonus = QuestBlocks(
        proof: ProofBlock(type: ProofType.photo),
        bonus: BonusBlock(condition: 'under 5 min', xpBonus: 50),
      );
      final xp = XpService.calculateQuestXp(
        difficulty: Difficulty.easy,
        blocks: blocksWithBonus,
        isFirstCompletion: false,
        isChallenge: false,
      );
      expect(xp, 150);
    });

    test('all bonuses stack', () {
      const blocksWithAll = QuestBlocks(
        proof: ProofBlock(type: ProofType.photo),
        people: PeopleBlock(type: PeopleType.group),
        bonus: BonusBlock(condition: 'fast', xpBonus: 20),
      );
      final xp = XpService.calculateQuestXp(
        difficulty: Difficulty.legendary,
        blocks: blocksWithAll,
        isFirstCompletion: true,
        isChallenge: true,
        additionalPeople: 2,
      );
      // 300 (legendary) + 50 (first) + 25 (challenge) + 20 (people) + 20 (bonus) = 415
      expect(xp, 415);
    });
  });

  group('calculateStageXp', () {
    test('applies difficulty multiplier to stage base XP', () {
      expect(
        XpService.calculateStageXp(
          stageBaseXp: 50,
          difficulty: Difficulty.easy,
        ),
        50,
      );
      expect(
        XpService.calculateStageXp(
          stageBaseXp: 50,
          difficulty: Difficulty.medium,
        ),
        75,
      );
      expect(
        XpService.calculateStageXp(
          stageBaseXp: 50,
          difficulty: Difficulty.hard,
        ),
        100,
      );
      expect(
        XpService.calculateStageXp(
          stageBaseXp: 50,
          difficulty: Difficulty.legendary,
        ),
        150,
      );
    });
  });

  group('tierFromXp', () {
    test('novice for 0-499', () {
      expect(XpService.tierFromXp(0), 'novice');
      expect(XpService.tierFromXp(499), 'novice');
    });

    test('explorer for 500-1999', () {
      expect(XpService.tierFromXp(500), 'explorer');
      expect(XpService.tierFromXp(1999), 'explorer');
    });

    test('adventurer for 2000-4999', () {
      expect(XpService.tierFromXp(2000), 'adventurer');
      expect(XpService.tierFromXp(4999), 'adventurer');
    });

    test('trailblazer for 5000-14999', () {
      expect(XpService.tierFromXp(5000), 'trailblazer');
      expect(XpService.tierFromXp(14999), 'trailblazer');
    });

    test('legend for 15000+', () {
      expect(XpService.tierFromXp(15000), 'legend');
      expect(XpService.tierFromXp(99999), 'legend');
    });
  });

  group('constants match spec', () {
    test('baseXp is 100', () {
      expect(XpService.baseXp, 100);
    });

    test('firstCompletionBonus is 50', () {
      expect(XpService.firstCompletionBonus, 50);
    });

    test('challengeCompletionBonus is 25', () {
      expect(XpService.challengeCompletionBonus, 25);
    });

    test('peopleBonus is 10', () {
      expect(XpService.peopleBonus, 10);
    });

    test('difficulty multipliers', () {
      expect(XpService.difficultyMultipliers[Difficulty.easy], 1.0);
      expect(XpService.difficultyMultipliers[Difficulty.medium], 1.5);
      expect(XpService.difficultyMultipliers[Difficulty.hard], 2.0);
      expect(XpService.difficultyMultipliers[Difficulty.legendary], 3.0);
    });
  });
}
