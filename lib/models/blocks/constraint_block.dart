import 'package:freezed_annotation/freezed_annotation.dart';

part 'constraint_block.freezed.dart';
part 'constraint_block.g.dart';

/// Configuration for the constraint/restriction block.
@freezed
class ConstraintBlock with _$ConstraintBlock {
  /// Creates a [ConstraintBlock].
  const factory ConstraintBlock({
    required String text,
  }) = _ConstraintBlock;

  /// Creates a [ConstraintBlock] from a JSON map.
  factory ConstraintBlock.fromJson(Map<String, dynamic> json) =>
      _$ConstraintBlockFromJson(json);
}
