import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/models/user_quest_model.dart';
import 'package:sidequest/repositories/quest_repository.dart';
import 'package:sidequest/repositories/user_quest_repository.dart';

/// Business logic for quest lifecycle operations.
///
/// Orchestrates quest creation, adding/removing from user lists,
/// and completion. Works across [QuestRepository] and
/// [UserQuestRepository].
class QuestService {
  /// Creates a [QuestService].
  QuestService({
    required this.questRepository,
    required this.userQuestRepository,
  });

  /// The quest repository for public quest data.
  final QuestRepository questRepository;

  /// The user quest repository for per-user quest data.
  final UserQuestRepository userQuestRepository;

  /// Creates a new quest and adds it to the creator's list.
  ///
  /// Returns the newly created quest's document ID.
  Future<String> createQuest({
    required QuestModel quest,
    required String creatorId,
  }) async {
    final questId = await questRepository.create(quest);

    // Add to creator's personal quest list
    await userQuestRepository.create(
      creatorId,
      UserQuestModel(
        id: '',
        questId: questId,
        status: UserQuestStatus.active,
        addedAt: DateTime.now(),
        sortOrder: 0,
      ),
    );

    return questId;
  }

  /// Adds an existing quest to a user's list and increments addedCount.
  Future<String> addQuestToList({
    required String userId,
    required String questId,
    required int currentSortOrder,
  }) async {
    final userQuestId = await userQuestRepository.create(
      userId,
      UserQuestModel(
        id: '',
        questId: questId,
        status: UserQuestStatus.active,
        addedAt: DateTime.now(),
        sortOrder: currentSortOrder,
      ),
    );

    // Increment the quest's addedCount
    await questRepository.update(questId, {
      'addedCount': _increment,
    });

    return userQuestId;
  }

  /// Removes a quest from a user's list.
  Future<void> removeQuestFromList({
    required String userId,
    required String userQuestId,
  }) =>
      userQuestRepository.delete(userId, userQuestId);

  /// Marks a user quest as completed.
  ///
  /// Updates the status, completion date, proof data, and XP earned.
  /// Also increments the quest's completedCount.
  Future<void> completeQuest({
    required String userId,
    required String userQuestId,
    required String questId,
    required int xpEarned,
    String? proofUrl,
    String? proofCaption,
    String? promptAnswer,
  }) async {
    await userQuestRepository.update(userId, userQuestId, {
      'status': 'completed',
      'completedAt': DateTime.now().toIso8601String(),
      'xpEarned': xpEarned,
      if (proofUrl != null) 'proofUrl': proofUrl,
      if (proofCaption != null) 'proofCaption': proofCaption,
      if (promptAnswer != null) 'promptAnswer': promptAnswer,
    });

    await questRepository.update(questId, {
      'completedCount': _increment,
    });
  }

  /// Archives a user quest (removes from active list without deleting).
  Future<void> archiveQuest({
    required String userId,
    required String userQuestId,
  }) =>
      userQuestRepository.update(userId, userQuestId, {
        'status': 'archived',
      });
}

/// Sentinel value indicating a Firestore FieldValue.increment(1).
///
/// In production this would use [FieldValue.increment(1)] directly,
/// but keeping as a constant allows easier testing.
const _increment = 1;
