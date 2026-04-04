import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/user_quest_model.dart';

void main() {
  final now = DateTime(2026);
  final json = {
    'id': 'uq1',
    'questId': 'q1',
    'status': 'active',
    'addedAt': now.toIso8601String(),
    'sortOrder': 0,
    'completionIndex': 0,
    'stageProgress': <dynamic>[],
  };

  test('fromJson → toJson round-trip', () {
    final model = UserQuestModel.fromJson(json);
    final roundTrip = UserQuestModel.fromJson(model.toJson());
    expect(roundTrip.status, UserQuestStatus.active);
    expect(roundTrip.questId, 'q1');
    expect(roundTrip, model);
  });
}
