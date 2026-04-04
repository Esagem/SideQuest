import 'package:freezed_annotation/freezed_annotation.dart';

part 'repeat_block.freezed.dart';
part 'repeat_block.g.dart';

/// Whether a quest can be repeated.
enum RepeatType {
  /// Can only be completed once.
  oneTime,

  /// Can be completed multiple times.
  repeatable,
}

/// Configuration for the repeat/one-time block.
@freezed
class RepeatBlock with _$RepeatBlock {
  /// Creates a [RepeatBlock].
  const factory RepeatBlock({
    required RepeatType type,
  }) = _RepeatBlock;

  /// Creates a [RepeatBlock] from a JSON map.
  factory RepeatBlock.fromJson(Map<String, dynamic> json) =>
      _$RepeatBlockFromJson(json);
}
