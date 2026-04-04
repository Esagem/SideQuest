import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/friendship_model.dart';

void main() {
  final now = DateTime(2026);
  final json = {
    'id': 'f1',
    'userIds': ['u1', 'u2'],
    'status': 'accepted',
    'requesterId': 'u1',
    'createdAt': now.toIso8601String(),
    'acceptedAt': now.toIso8601String(),
  };

  test('fromJson → toJson round-trip', () {
    final model = FriendshipModel.fromJson(json);
    final roundTrip = FriendshipModel.fromJson(model.toJson());
    expect(roundTrip.status, FriendshipStatus.accepted);
    expect(roundTrip.userIds, ['u1', 'u2']);
    expect(roundTrip, model);
  });
}
