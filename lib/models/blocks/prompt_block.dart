import 'package:freezed_annotation/freezed_annotation.dart';

part 'prompt_block.freezed.dart';
part 'prompt_block.g.dart';

/// Configuration for the reflection prompt block.
@freezed
class PromptBlock with _$PromptBlock {
  /// Creates a [PromptBlock].
  const factory PromptBlock({
    required String question,
  }) = _PromptBlock;

  /// Creates a [PromptBlock] from a JSON map.
  factory PromptBlock.fromJson(Map<String, dynamic> json) =>
      _$PromptBlockFromJson(json);
}
