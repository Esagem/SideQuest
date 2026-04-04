/// XP calculation constants for the SideQuest progression system.
///
/// Defines base XP values, difficulty multipliers, bonuses, creator
/// milestones, and tier thresholds. These values are used by [XpService]
/// to compute XP awards.
abstract final class XpConstants {
  /// Base XP awarded for completing a quest before multipliers.
  static const int baseXp = 100;

  /// Bonus XP for the first person to complete a public quest.
  static const int firstCompletionBonus = 50;

  /// Bonus XP for completing a quest received as a challenge.
  static const int challengeCompletionBonus = 25;

  /// Bonus XP per additional person in a group quest.
  static const int peopleBonus = 10;

  /// Difficulty multipliers applied to [baseXp].
  ///
  /// Keys match the [Difficulty] enum values from the quest model.
  static const Map<String, double> difficultyMultipliers = {
    'easy': 1.0,
    'medium': 1.5,
    'hard': 2.0,
    'legendary': 3.0,
  };

  /// Creator milestone thresholds and their XP bonus rewards.
  ///
  /// Key = number of people who added the quest,
  /// Value = bonus XP awarded to the creator.
  static const Map<int, int> creatorMilestones = {
    10: 10,
    50: 25,
    100: 50,
    500: 100,
  };
}
