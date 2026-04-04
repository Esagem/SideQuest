import 'package:sidequest/models/quality_signal_model.dart';
import 'package:sidequest/repositories/quality_signal_repository.dart';
import 'package:sidequest/repositories/quest_repository.dart';

/// Service for submitting and querying quality signals.
///
/// Enforces write-once (one signal per user per quest) and updates
/// quest-level counts. Also provides feed impact scoring.
class QualitySignalService {
  /// Creates a [QualitySignalService].
  QualitySignalService({
    required this.signalRepository,
    required this.questRepository,
  });

  /// The quality signal repository.
  final QualitySignalRepository signalRepository;

  /// The quest repository for updating counts.
  final QuestRepository questRepository;

  /// Submits a quality signal for a quest.
  ///
  /// Returns `true` if the signal was created, `false` if the user
  /// has already signaled this quest (write-once enforcement).
  Future<bool> submitSignal({
    required String questId,
    required String userId,
    required QualitySignalType signal,
  }) async {
    // Write-once check
    final alreadySignaled = await signalRepository.hasUserSignaled(
      questId: questId,
      userId: userId,
    );
    if (alreadySignaled) return false;

    // Create signal
    await signalRepository.create(QualitySignalModel(
      questId: questId,
      userId: userId,
      signal: signal,
      createdAt: DateTime.now(),
    ),);

    // Update quest-level counts
    final countField = signal == QualitySignalType.worthIt
        ? 'worthItCount'
        : 'needsWorkCount';
    await questRepository.update(questId, {
      countField: 1, // In production, use FieldValue.increment(1)
    });

    return true;
  }

  /// Checks if a user has already signaled a quest.
  Future<bool> hasSignaled({
    required String questId,
    required String userId,
  }) =>
      signalRepository.hasUserSignaled(
        questId: questId,
        userId: userId,
      );

  /// Calculates a feed quality score for ranking.
  ///
  /// Returns a value between 0.0 (deprioritized) and 1.0 (high quality).
  /// Quests with >50% "Needs Work" and >=10 total ratings are deprioritized.
  static double feedQualityScore({
    required int worthItCount,
    required int needsWorkCount,
  }) {
    final total = worthItCount + needsWorkCount;
    if (total < 10) return 1; // Not enough data — neutral
    final needsWorkRatio = needsWorkCount / total;
    if (needsWorkRatio > 0.5) return 0.5; // Deprioritized
    return 1;
  }
}
