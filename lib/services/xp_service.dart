import 'package:sidequest/models/blocks/block_config.dart';
import 'package:sidequest/models/quest_model.dart';

/// XP calculation service for the SideQuest progression system.
///
/// Implements the XP formulas from architecture.md Section 8.
/// All calculations are deterministic and can run client-side for
/// previews; the server (Cloud Functions) is authoritative.
abstract final class XpService {
  /// Base XP awarded before multipliers.
  static const int baseXp = 100;

  /// XP multipliers per difficulty level.
  static const Map<Difficulty, double> difficultyMultipliers = {
    Difficulty.easy: 1.0,
    Difficulty.medium: 1.5,
    Difficulty.hard: 2.0,
    Difficulty.legendary: 3.0,
  };

  /// Bonus for the first person to complete a public quest.
  static const int firstCompletionBonus = 50;

  /// Bonus for completing a quest received as a challenge.
  static const int challengeCompletionBonus = 25;

  /// Bonus XP per additional person in a group quest.
  static const int peopleBonus = 10;

  /// Creator milestone thresholds → bonus XP awarded to creator.
  static const Map<int, int> creatorMilestones = {
    10: 10,
    50: 25,
    100: 50,
    500: 100,
  };

  /// Calculates XP for completing a non-staged quest.
  ///
  /// Applies difficulty multiplier, first-completion bonus,
  /// challenge bonus, people bonus, and any bonus block XP.
  static int calculateQuestXp({
    required Difficulty difficulty,
    required QuestBlocks blocks,
    required bool isFirstCompletion,
    required bool isChallenge,
    int additionalPeople = 0,
  }) {
    var xp = baseXp * difficultyMultipliers[difficulty]!;

    if (isFirstCompletion) xp += firstCompletionBonus;
    if (isChallenge) xp += challengeCompletionBonus;
    if (blocks.people != null && additionalPeople > 0) {
      xp += additionalPeople * peopleBonus;
    }
    if (blocks.bonus != null) {
      xp += blocks.bonus!.xpBonus;
    }

    return xp.round();
  }

  /// Calculates XP for completing a single stage.
  static int calculateStageXp({
    required int stageBaseXp,
    required Difficulty difficulty,
  }) =>
      (stageBaseXp * difficultyMultipliers[difficulty]!).round();

  /// Determines the tier label from total [xp].
  static String tierFromXp(int xp) {
    if (xp >= 15000) return 'legend';
    if (xp >= 5000) return 'trailblazer';
    if (xp >= 2000) return 'adventurer';
    if (xp >= 500) return 'explorer';
    return 'novice';
  }
}
