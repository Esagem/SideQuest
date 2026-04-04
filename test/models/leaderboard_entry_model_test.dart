import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/leaderboard_entry_model.dart';

void main() {
  final json = {
    'rank': 1,
    'userId': 'u1',
    'displayName': 'Alice',
    'username': 'alice',
    'tier': 'explorer',
    'xp': 500,
    'questsCompleted': 10,
    'badgeShowcase': ['first_quest'],
  };

  test('fromJson → toJson round-trip', () {
    final model = LeaderboardEntryModel.fromJson(json);
    final roundTrip = LeaderboardEntryModel.fromJson(model.toJson());
    expect(roundTrip.rank, 1);
    expect(roundTrip.badgeShowcase, ['first_quest']);
    expect(roundTrip, model);
  });
}
