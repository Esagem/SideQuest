import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sidequest/models/activity_model.dart';

/// Repository for activity feed data in Firestore.
///
/// Activity documents are written by Cloud Functions.
/// This repository provides read-only paginated access.
class ActivityRepository {
  /// Creates an [ActivityRepository].
  ActivityRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<ActivityModel> get _collection =>
      _firestore.collection('activity').withConverter<ActivityModel>(
            fromFirestore: (snap, _) =>
                ActivityModel.fromJson({...snap.data()!, 'id': snap.id}),
            toFirestore: (model, _) => model.toJson()..remove('id'),
          );

  /// Watches activity for a specific user (paginated).
  Stream<List<ActivityModel>> watchForUser(
    String userId, {
    int limit = 20,
  }) =>
      _collection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((snap) => snap.docs.map((d) => d.data()).toList());

  /// Watches activity for a list of friend user IDs (paginated).
  Stream<List<ActivityModel>> watchForFriends(
    List<String> friendIds, {
    int limit = 20,
  }) {
    if (friendIds.isEmpty) return Stream.value([]);
    // Firestore whereIn limited to 30 items
    final batch = friendIds.take(30).toList();
    return _collection
        .where('userId', whereIn: batch)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }
}
