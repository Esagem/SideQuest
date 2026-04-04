import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sidequest/models/leaderboard_entry_model.dart';

/// Repository for leaderboard data in Firestore.
///
/// Leaderboards are precomputed by Cloud Functions and stored
/// as documents in the `leaderboards` collection.
class LeaderboardRepository {
  /// Creates a [LeaderboardRepository].
  LeaderboardRepository(this._firestore);

  final FirebaseFirestore _firestore;

  /// Gets a leaderboard by [type] (e.g. 'weekly', 'global').
  Future<List<LeaderboardEntryModel>> getLeaderboard(String type) async {
    final doc =
        await _firestore.collection('leaderboards').doc(type).get();
    if (!doc.exists || doc.data() == null) return [];
    final entries = doc.data()!['entries'] as List<dynamic>? ?? [];
    return entries
        .cast<Map<String, dynamic>>()
        .map(LeaderboardEntryModel.fromJson)
        .toList();
  }

  /// Gets a friends leaderboard filtered by friend user IDs.
  Future<List<LeaderboardEntryModel>> getFriendsLeaderboard(
    String userId,
    List<String> friendIds,
  ) async {
    final allIds = [userId, ...friendIds];
    final snap = await _firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: allIds.take(30).toList())
        .get();

    final entries = snap.docs.asMap().entries.map((e) {
      final data = e.value.data();
      return LeaderboardEntryModel(
        rank: e.key + 1,
        userId: e.value.id,
        displayName: data['displayName'] as String? ?? '',
        username: data['username'] as String? ?? '',
        avatarUrl: data['avatarUrl'] as String?,
        tier: data['tier'] as String? ?? 'novice',
        xp: data['xp'] as int? ?? 0,
        questsCompleted: data['questsCompleted'] as int? ?? 0,
        badgeShowcase:
            (data['badgeShowcase'] as List<dynamic>?)?.cast<String>() ?? [],
      );
    }).toList()
      ..sort((a, b) => b.xp.compareTo(a.xp));

    // Re-rank after sorting
    return [
      for (var i = 0; i < entries.length; i++)
        entries[i].copyWith(rank: i + 1),
    ];
  }
}
