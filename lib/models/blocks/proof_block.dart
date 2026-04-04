import 'package:freezed_annotation/freezed_annotation.dart';

part 'proof_block.freezed.dart';
part 'proof_block.g.dart';

/// The type of proof required for a quest.
enum ProofType {
  /// A single photo.
  photo,

  /// A video clip.
  video,

  /// Either photo or video.
  photoOrVideo,

  /// A before-and-after photo pair.
  beforeAfter,
}

/// Configuration for the proof requirement block.
@freezed
class ProofBlock with _$ProofBlock {
  /// Creates a [ProofBlock].
  const factory ProofBlock({
    required ProofType type,
  }) = _ProofBlock;

  /// Creates a [ProofBlock] from a JSON map.
  factory ProofBlock.fromJson(Map<String, dynamic> json) =>
      _$ProofBlockFromJson(json);
}
