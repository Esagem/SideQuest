import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:sidequest/models/blocks/block_config.dart';

part 'quest_model.freezed.dart';
part 'quest_model.g.dart';

/// The type of quest.
enum QuestType {
  /// Created by the user for themselves.
  personal,

  /// Shared publicly for anyone to add.
  public,

  /// Sent as a challenge to a friend.
  challenge,

  /// A pre-made starter quest from SideQuest.
  seed,
}

/// Visibility setting for a quest.
enum QuestVisibility {
  /// Only visible to the creator.
  personal,

  /// Visible to all users.
  public,
}

/// Difficulty level for a quest.
enum Difficulty {
  /// Easy — 1.0x XP multiplier.
  easy,

  /// Medium — 1.5x XP multiplier.
  medium,

  /// Hard — 2.0x XP multiplier.
  hard,

  /// Legendary — 3.0x XP multiplier.
  legendary,
}

/// A quest definition with all metadata and block configurations.
@freezed
class QuestModel with _$QuestModel {
  /// Creates a [QuestModel].
  const factory QuestModel({
    required String id,
    required String creatorId,
    required QuestType type,
    required String title,
    required String description,
    required String category,
    @Default([]) List<String> tags,
    required Difficulty difficulty,
    required QuestVisibility visibility,
    @Default([]) List<String> intent,
    @Default(false) bool repeatable,
    required QuestBlocks blocks,
    @Default(0) int addedCount,
    @Default(0) int completedCount,
    @Default(0) int worthItCount,
    @Default(0) int needsWorkCount,
    String? featuredProofUrl,
    @Default(0) int reportCount,
    @Default(false) bool isHidden,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _QuestModel;

  /// Creates a [QuestModel] from a JSON map.
  factory QuestModel.fromJson(Map<String, dynamic> json) =>
      _$QuestModelFromJson(json);
}
