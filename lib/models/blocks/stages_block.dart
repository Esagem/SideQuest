import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:sidequest/models/blocks/proof_block.dart';

part 'stages_block.freezed.dart';
part 'stages_block.g.dart';

/// A single stage within a multi-stage quest.
@freezed
class StageItem with _$StageItem {
  /// Creates a [StageItem].
  const factory StageItem({
    required String id,
    required String title,
    String? description,
    @Default(false) bool proofRequired,
    ProofType? proofType,
    required int xp,
  }) = _StageItem;

  /// Creates a [StageItem] from a JSON map.
  factory StageItem.fromJson(Map<String, dynamic> json) =>
      _$StageItemFromJson(json);
}

/// Configuration for the multi-stage quest block.
@freezed
class StagesBlock with _$StagesBlock {
  /// Creates a [StagesBlock].
  const factory StagesBlock({
    required List<StageItem> items,
  }) = _StagesBlock;

  /// Creates a [StagesBlock] from a JSON map.
  factory StagesBlock.fromJson(Map<String, dynamic> json) =>
      _$StagesBlockFromJson(json);
}
