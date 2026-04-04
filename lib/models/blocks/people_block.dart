import 'package:freezed_annotation/freezed_annotation.dart';

part 'people_block.freezed.dart';
part 'people_block.g.dart';

/// The type of people requirement.
enum PeopleType {
  /// Must be done alone.
  solo,

  /// Must be done with a friend.
  withFriend,

  /// Must be done in a group.
  group,

  /// Must involve a stranger.
  stranger,
}

/// Configuration for the people requirement block.
@freezed
class PeopleBlock with _$PeopleBlock {
  /// Creates a [PeopleBlock].
  const factory PeopleBlock({
    required PeopleType type,
    int? minCount,
  }) = _PeopleBlock;

  /// Creates a [PeopleBlock] from a JSON map.
  factory PeopleBlock.fromJson(Map<String, dynamic> json) =>
      _$PeopleBlockFromJson(json);
}
