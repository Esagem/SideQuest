import 'package:freezed_annotation/freezed_annotation.dart';

part 'friendship_model.freezed.dart';
part 'friendship_model.g.dart';

/// Status of a friendship between two users.
enum FriendshipStatus {
  /// Request sent but not yet accepted.
  pending,

  /// Both users are friends.
  accepted,
}

/// A friendship connection between two users.
@freezed
class FriendshipModel with _$FriendshipModel {
  /// Creates a [FriendshipModel].
  const factory FriendshipModel({
    required String id,
    required List<String> userIds,
    required FriendshipStatus status,
    required String requesterId,
    required DateTime createdAt,
    DateTime? acceptedAt,
  }) = _FriendshipModel;

  /// Creates a [FriendshipModel] from a JSON map.
  factory FriendshipModel.fromJson(Map<String, dynamic> json) =>
      _$FriendshipModelFromJson(json);
}
