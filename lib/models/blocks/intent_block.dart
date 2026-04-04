import 'package:freezed_annotation/freezed_annotation.dart';

part 'intent_block.freezed.dart';
part 'intent_block.g.dart';

/// Configuration for the intent tag block.
@freezed
class IntentBlock with _$IntentBlock {
  /// Creates an [IntentBlock].
  const factory IntentBlock({
    required List<String> intents,
  }) = _IntentBlock;

  /// Creates an [IntentBlock] from a JSON map.
  factory IntentBlock.fromJson(Map<String, dynamic> json) =>
      _$IntentBlockFromJson(json);
}
