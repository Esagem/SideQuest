import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_quest_model.freezed.dart';
part 'user_quest_model.g.dart';

/// Status of a user's quest.
enum UserQuestStatus {
  /// Currently in progress.
  active,

  /// Successfully completed.
  completed,

  /// Removed from active list.
  archived,
}

/// Status of a single stage within a multi-stage quest.
enum StageStatus {
  /// Not yet available.
  locked,

  /// Currently available for completion.
  active,

  /// Successfully completed.
  completed,
}

/// Progress for a single stage within a multi-stage quest.
@freezed
class StageProgress with _$StageProgress {
  /// Creates a [StageProgress].
  const factory StageProgress({
    required String stageId,
    required StageStatus status,
    DateTime? completedAt,
    String? proofUrl,
    String? proofCaption,
  }) = _StageProgress;

  /// Creates a [StageProgress] from a JSON map.
  factory StageProgress.fromJson(Map<String, dynamic> json) =>
      _$StageProgressFromJson(json);
}

/// A user's personal copy of a quest with progress and proof data.
@freezed
class UserQuestModel with _$UserQuestModel {
  /// Creates a [UserQuestModel].
  const factory UserQuestModel({
    required String id,
    required String questId,
    required UserQuestStatus status,
    required DateTime addedAt,
    DateTime? completedAt,
    String? proofUrl,
    String? proofVideoUrl,
    String? proofExternalUrl,
    String? proofCaption,
    String? promptAnswer,
    int? xpEarned,
    required int sortOrder,
    @Default(0) int completionIndex,
    @Default([]) List<StageProgress> stageProgress,
  }) = _UserQuestModel;

  /// Creates a [UserQuestModel] from a JSON map.
  factory UserQuestModel.fromJson(Map<String, dynamic> json) =>
      _$UserQuestModelFromJson(json);
}
