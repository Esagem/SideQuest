import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_block.freezed.dart';
part 'time_block.g.dart';

/// The type of time constraint.
enum TimeType {
  /// Must be done by a specific deadline.
  deadline,

  /// Must be completed within a time duration.
  duration,

  /// Must be done at a specific time of day.
  timeOfDay,

  /// No time constraint.
  open,
}

/// Configuration for the time constraint block.
@freezed
class TimeBlock with _$TimeBlock {
  /// Creates a [TimeBlock].
  const factory TimeBlock({
    required TimeType type,
    String? value,
  }) = _TimeBlock;

  /// Creates a [TimeBlock] from a JSON map.
  factory TimeBlock.fromJson(Map<String, dynamic> json) =>
      _$TimeBlockFromJson(json);
}
