import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge_model.freezed.dart';
part 'challenge_model.g.dart';

/// Status of a quest challenge between friends.
enum ChallengeStatus {
  /// Sent but not yet responded to.
  pending,

  /// Accepted by the receiver.
  accepted,

  /// Completed by the receiver.
  completed,

  /// Declined by the receiver.
  declined,
}

/// A quest challenge sent from one user to another.
@freezed
class ChallengeModel with _$ChallengeModel {
  /// Creates a [ChallengeModel].
  const factory ChallengeModel({
    required String id,
    required String senderId,
    required String receiverId,
    required String questId,
    String? message,
    required ChallengeStatus status,
    required DateTime createdAt,
  }) = _ChallengeModel;

  /// Creates a [ChallengeModel] from a JSON map.
  factory ChallengeModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeModelFromJson(json);
}
