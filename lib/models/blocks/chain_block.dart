import 'package:freezed_annotation/freezed_annotation.dart';

part 'chain_block.freezed.dart';
part 'chain_block.g.dart';

/// Configuration for the quest chain/series block.
@freezed
class ChainBlock with _$ChainBlock {
  /// Creates a [ChainBlock].
  const factory ChainBlock({
    String? prerequisiteQuestId,
    int? seriesIndex,
    int? seriesTotal,
  }) = _ChainBlock;

  /// Creates a [ChainBlock] from a JSON map.
  factory ChainBlock.fromJson(Map<String, dynamic> json) =>
      _$ChainBlockFromJson(json);
}
