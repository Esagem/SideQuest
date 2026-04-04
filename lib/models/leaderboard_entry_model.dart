import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_entry_model.freezed.dart';
part 'leaderboard_entry_model.g.dart';

/// A single entry in a leaderboard ranking.
@freezed
class LeaderboardEntryModel with _$LeaderboardEntryModel {
  /// Creates a [LeaderboardEntryModel].
  const factory LeaderboardEntryModel({
    required int rank,
    required String userId,
    required String displayName,
    required String username,
    String? avatarUrl,
    required String tier,
    required int xp,
    required int questsCompleted,
    @Default([]) List<String> badgeShowcase,
  }) = _LeaderboardEntryModel;

  /// Creates a [LeaderboardEntryModel] from a JSON map.
  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryModelFromJson(json);
}
