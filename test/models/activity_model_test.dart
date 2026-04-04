import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/activity_model.dart';

void main() {
  final now = DateTime(2026);
  final json = {
    'id': 'a1',
    'userId': 'u1',
    'type': 'questCompleted',
    'questId': 'q1',
    'metadata': <String, dynamic>{'xp': 150},
    'createdAt': now.toIso8601String(),
  };

  test('fromJson → toJson round-trip', () {
    final model = ActivityModel.fromJson(json);
    final roundTrip = ActivityModel.fromJson(model.toJson());
    expect(roundTrip.type, ActivityType.questCompleted);
    expect(roundTrip.metadata['xp'], 150);
    expect(roundTrip, model);
  });
}
