/// Route path constants for the SideQuest application.
///
/// All route paths are defined here to avoid magic strings.
abstract final class Routes {
  // Auth
  /// Welcome / landing screen.
  static const String welcome = '/auth/welcome';

  /// Sign-up screen.
  static const String signUp = '/auth/signup';

  /// Log-in screen.
  static const String logIn = '/auth/login';

  // Onboarding
  /// Intent picker onboarding step.
  static const String onboardingIntents = '/onboarding/intents';

  /// Category picker onboarding step.
  static const String onboardingCategories = '/onboarding/categories';

  /// Starter quests onboarding step.
  static const String onboardingStarter = '/onboarding/starter';

  // Main tabs
  /// Home tab.
  static const String home = '/';

  /// Explore tab.
  static const String explore = '/explore';

  /// Activity tab.
  static const String activity = '/activity';

  /// Profile tab.
  static const String profile = '/profile';

  // Quest builder
  /// Full quest builder screen.
  static const String builder = '/builder';

  /// Quick create screen.
  static const String quickCreate = '/quick-create';

  // Detail / Action
  /// Quest detail — requires :questId parameter.
  static const String questDetail = '/quest/:questId';

  /// Proof submission — requires :userQuestId parameter.
  static const String proofSubmission = '/proof/:userQuestId';

  /// Share card — requires :userQuestId parameter.
  static const String shareCard = '/share/:userQuestId';

  // Social
  /// Friend search screen.
  static const String friendSearch = '/friends/search';

  /// Friend profile — requires :userId parameter.
  static const String friendProfile = '/profile/:userId';

  /// Challenge flow — requires :questId parameter.
  static const String challengeFlow = '/challenge/:questId';

  // Leaderboard
  /// Leaderboard detail — requires :type parameter.
  static const String leaderboard = '/leaderboard/:type';

  // Settings
  /// Settings screen.
  static const String settings = '/settings';

  /// Moderation policy screen.
  static const String moderationPolicy = '/settings/moderation-policy';
}
