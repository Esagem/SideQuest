import 'package:freezed_annotation/freezed_annotation.dart';

part 'bonus_block.freezed.dart';
part 'bonus_block.g.dart';

/// Configuration for the bonus XP condition block.
@freezed
class BonusBlock with _$BonusBlock {
  /// Creates a [BonusBlock].
  const factory BonusBlock({
    required String condition,
    required int xpBonus,
  }) = _BonusBlock;

  /// Creates a [BonusBlock] from a JSON map.
  factory BonusBlock.fromJson(Map<String, dynamic> json) =>
      _$BonusBlockFromJson(json);
}
