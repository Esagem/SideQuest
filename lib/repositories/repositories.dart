/// Repository layer for Firestore data access.
///
/// All Firestore reads and writes flow through repositories.
/// Widgets and providers must never access Firestore directly.
library;

export 'activity_repository.dart';
export 'auth_repository.dart';
export 'challenge_repository.dart';
export 'friendship_repository.dart';
export 'leaderboard_repository.dart';
export 'quality_signal_repository.dart';
export 'quest_repository.dart';
export 'report_repository.dart';
export 'user_quest_repository.dart';
export 'user_repository.dart';
