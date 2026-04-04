import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// A SideQuest user profile with progression and social data.
@freezed
class UserModel with _$UserModel {
  /// Creates a [UserModel].
  const factory UserModel({
    required String uid,
    required String email,
    required String displayName,
    required String username,
    String? avatarUrl,
    String? bio,
    required DateTime dateOfBirth,
    @Default(0) int xp,
    @Default('novice') String tier,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    DateTime? lastCompletionDate,
    @Default(1) int streakFreezeAvailable,
    @Default(0) int questsCompleted,
    @Default(0) int friendCount,
    @Default([]) List<String> badges,
    @Default([]) List<String> badgeShowcase,
    @Default([]) List<String> categoryPreferences,
    @Default({}) Map<String, int> intentStats,
    @Default(false) bool isPro,
    @Default([]) List<String> blockedUsers,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  /// Creates a [UserModel] from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
