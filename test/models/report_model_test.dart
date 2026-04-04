import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/report_model.dart';

void main() {
  final now = DateTime(2026);
  final json = {
    'id': 'r1',
    'reporterId': 'u1',
    'targetType': 'quest',
    'targetId': 'q1',
    'reason': 'spam',
    'status': 'pending',
    'createdAt': now.toIso8601String(),
  };

  test('fromJson → toJson round-trip', () {
    final model = ReportModel.fromJson(json);
    final roundTrip = ReportModel.fromJson(model.toJson());
    expect(roundTrip.reason, ReportReason.spam);
    expect(roundTrip.status, ReportStatus.pending);
    expect(roundTrip, model);
  });
}
