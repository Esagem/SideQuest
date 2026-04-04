import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/user_model.dart';

void main() {
  final now = DateTime(2026);
  final json = {
    'uid': 'u1',
    'email': 'a@b.com',
    'displayName': 'Alice',
    'username': 'alice',
    'dateOfBirth': now.toIso8601String(),
    'xp': 500,
    'tier': 'explorer',
    'currentStreak': 3,
    'longestStreak': 7,
    'streakFreezeAvailable': 1,
    'questsCompleted': 10,
    'friendCount': 5,
    'badges': <String>['first_quest'],
    'badgeShowcase': <String>[],
    'categoryPreferences': <String>['travel'],
    'intentStats': <String, dynamic>{'growth': 5},
    'isPro': false,
    'blockedUsers': <String>[],
    'createdAt': now.toIso8601String(),
    'updatedAt': now.toIso8601String(),
  };

  test('fromJson → toJson round-trip', () {
    final model = UserModel.fromJson(json);
    final result = model.toJson();
    final roundTrip = UserModel.fromJson(result);
    expect(roundTrip.uid, 'u1');
    expect(roundTrip.email, 'a@b.com');
    expect(roundTrip.xp, 500);
    expect(roundTrip.badges, ['first_quest']);
    expect(roundTrip, model);
  });
}
