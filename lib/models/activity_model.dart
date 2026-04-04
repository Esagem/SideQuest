import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_model.freezed.dart';
part 'activity_model.g.dart';

/// Types of activity feed events.
enum ActivityType {
  /// A quest was completed.
  questCompleted,

  /// A stage within a multi-stage quest was completed.
  stageCompleted,

  /// A challenge was sent to a friend.
  challengeSent,

  /// A received challenge was completed.
  challengeCompleted,

  /// A badge was earned.
  badgeEarned,

  /// A streak milestone was reached.
  streakMilestone,

  /// A creator milestone was reached.
  creatorMilestone,
}

/// An activity feed event for social display.
@freezed
class ActivityModel with _$ActivityModel {
  /// Creates an [ActivityModel].
  const factory ActivityModel({
    required String id,
    required String userId,
    required ActivityType type,
    String? questId,
    String? proofUrl,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
  }) = _ActivityModel;

  /// Creates an [ActivityModel] from a JSON map.
  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);
}
