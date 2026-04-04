import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/challenge_model.dart';

void main() {
  final now = DateTime(2026);
  final json = {
    'id': 'c1',
    'senderId': 'u1',
    'receiverId': 'u2',
    'questId': 'q1',
    'message': 'Try this!',
    'status': 'pending',
    'createdAt': now.toIso8601String(),
  };

  test('fromJson → toJson round-trip', () {
    final model = ChallengeModel.fromJson(json);
    final roundTrip = ChallengeModel.fromJson(model.toJson());
    expect(roundTrip.status, ChallengeStatus.pending);
    expect(roundTrip.message, 'Try this!');
    expect(roundTrip, model);
  });
}
