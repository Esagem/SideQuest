import 'package:freezed_annotation/freezed_annotation.dart';

part 'quality_signal_model.freezed.dart';
part 'quality_signal_model.g.dart';

/// Type of quality signal a user can give after completing a quest.
enum QualitySignalType {
  /// The quest was worth doing.
  worthIt,

  /// The quest needs improvement.
  needsWork,
}

/// A quality signal (rating) for a completed quest.
@freezed
class QualitySignalModel with _$QualitySignalModel {
  /// Creates a [QualitySignalModel].
  const factory QualitySignalModel({
    required String questId,
    required String userId,
    required QualitySignalType signal,
    required DateTime createdAt,
  }) = _QualitySignalModel;

  /// Creates a [QualitySignalModel] from a JSON map.
  factory QualitySignalModel.fromJson(Map<String, dynamic> json) =>
      _$QualitySignalModelFromJson(json);
}
