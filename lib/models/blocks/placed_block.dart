import 'package:freezed_annotation/freezed_annotation.dart';

part 'placed_block.freezed.dart';
part 'placed_block.g.dart';

/// A block that has been placed in the quest builder.
///
/// Wraps a block ID with its current configuration. The [config]
/// is the JSON-serializable configuration for this block type.
@freezed
class PlacedBlock with _$PlacedBlock {
  /// Creates a [PlacedBlock].
  const factory PlacedBlock({
    required String blockId,
    @Default({}) Map<String, dynamic> config,
  }) = _PlacedBlock;

  /// Creates a [PlacedBlock] from a JSON map.
  factory PlacedBlock.fromJson(Map<String, dynamic> json) =>
      _$PlacedBlockFromJson(json);
}
