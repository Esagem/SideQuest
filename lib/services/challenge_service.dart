import 'package:sidequest/models/user_quest_model.dart';
import 'package:sidequest/repositories/challenge_repository.dart';
import 'package:sidequest/repositories/user_quest_repository.dart';

/// Business logic for the challenge lifecycle.
///
/// Orchestrates sending, accepting, declining, and completing
/// challenges across [ChallengeRepository] and [UserQuestRepository].
class ChallengeService {
  /// Creates a [ChallengeService].
  ChallengeService({
    required this.challengeRepository,
    required this.userQuestRepository,
  });

  /// The challenge data repository.
  final ChallengeRepository challengeRepository;

  /// The user quest data repository.
  final UserQuestRepository userQuestRepository;

  /// Sends a challenge from [senderId] to [receiverId] for [questId].
  ///
  /// Returns the challenge document ID.
  Future<String> sendChallenge({
    required String senderId,
    required String receiverId,
    required String questId,
    String? message,
  }) =>
      challengeRepository.send(
        senderId: senderId,
        receiverId: receiverId,
        questId: questId,
        message: message,
      );

  /// Accepts a challenge, adding the quest to the receiver's list.
  ///
  /// Updates challenge status to accepted and creates a [UserQuestModel]
  /// on the receiver's quest subcollection.
  Future<void> acceptChallenge({
    required String challengeId,
    required String receiverId,
    required String questId,
  }) async {
    await challengeRepository.accept(challengeId);
    await userQuestRepository.create(
      receiverId,
      UserQuestModel(
        id: '',
        questId: questId,
        status: UserQuestStatus.active,
        addedAt: DateTime.now(),
        sortOrder: 0,
      ),
    );
  }

  /// Declines a challenge, updating status to declined.
  Future<void> declineChallenge({required String challengeId}) =>
      challengeRepository.decline(challengeId);

  /// Marks a challenge as completed.
  ///
  /// The +25 XP challenger bonus is handled server-side by the
  /// [onQuestCompleted] Cloud Function.
  Future<void> completeChallenge({required String challengeId}) =>
      challengeRepository.complete(challengeId);
}
