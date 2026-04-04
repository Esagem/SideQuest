import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

/// The type of content being reported.
enum ReportTargetType {
  /// A quest definition.
  quest,

  /// A proof submission.
  proof,

  /// A user profile.
  user,
}

/// The reason for a report.
enum ReportReason {
  /// Content promotes dangerous activity.
  dangerous,

  /// Content is inappropriate.
  inappropriate,

  /// Content is spam.
  spam,

  /// Content is harassment.
  harassment,

  /// Other reason (see details).
  other,
}

/// The moderation status of a report.
enum ReportStatus {
  /// Awaiting review.
  pending,

  /// Reviewed by a moderator.
  reviewed,

  /// Action was taken.
  actioned,

  /// Report was dismissed.
  dismissed,
}

/// A user-submitted report for moderation.
@freezed
class ReportModel with _$ReportModel {
  /// Creates a [ReportModel].
  const factory ReportModel({
    required String id,
    required String reporterId,
    required ReportTargetType targetType,
    required String targetId,
    required ReportReason reason,
    String? details,
    required ReportStatus status,
    required DateTime createdAt,
    DateTime? reviewedAt,
    String? reviewedBy,
  }) = _ReportModel;

  /// Creates a [ReportModel] from a JSON map.
  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
}
