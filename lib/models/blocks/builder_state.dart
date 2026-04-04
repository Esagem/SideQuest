import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:sidequest/models/blocks/placed_block.dart';

part 'builder_state.freezed.dart';
part 'builder_state.g.dart';

/// The state of the quest builder.
///
/// Tracks the list of [PlacedBlock]s and which block is currently
/// expanded for editing.
@freezed
class BuilderState with _$BuilderState {
  /// Creates a [BuilderState].
  const factory BuilderState({
    required List<PlacedBlock> blocks,
    String? expandedBlockId,
  }) = _BuilderState;

  /// Creates the initial builder state with a title block.
  factory BuilderState.initial() => const BuilderState(
        blocks: [PlacedBlock(blockId: 'title')],
      );

  /// Creates a [BuilderState] from a JSON map.
  factory BuilderState.fromJson(Map<String, dynamic> json) =>
      _$BuilderStateFromJson(json);
}
