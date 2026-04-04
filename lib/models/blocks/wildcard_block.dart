import 'package:freezed_annotation/freezed_annotation.dart';

part 'wildcard_block.freezed.dart';
part 'wildcard_block.g.dart';

/// Configuration for the wildcard/random option block.
@freezed
class WildcardBlock with _$WildcardBlock {
  /// Creates a [WildcardBlock].
  const factory WildcardBlock({
    required List<String> options,
  }) = _WildcardBlock;

  /// Creates a [WildcardBlock] from a JSON map.
  factory WildcardBlock.fromJson(Map<String, dynamic> json) =>
      _$WildcardBlockFromJson(json);
}
