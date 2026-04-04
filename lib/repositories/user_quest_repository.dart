import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sidequest/models/user_quest_model.dart';

/// Repository for user quest data stored as a subcollection
/// under `users/{uid}/quests`.
///
/// All reads use [.withConverter] for type-safe access.
class UserQuestRepository {
  /// Creates a [UserQuestRepository].
  UserQuestRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<UserQuestModel> _collection(String uid) =>
      _firestore
          .collection('users')
          .doc(uid)
          .collection('quests')
          .withConverter<UserQuestModel>(
            fromFirestore: (snap, _) =>
                UserQuestModel.fromJson({...snap.data()!, 'id': snap.id}),
            toFirestore: (model, _) => model.toJson()..remove('id'),
          );

  /// Adds a quest to the user's list.
  Future<String> create(String uid, UserQuestModel userQuest) async {
    final doc = await _collection(uid).add(userQuest);
    return doc.id;
  }

  /// Gets a user quest by [id].
  Future<UserQuestModel?> getById(String uid, String id) async {
    final snap = await _collection(uid).doc(id).get();
    return snap.data();
  }

  /// Updates fields on a user quest document.
  Future<void> update(
    String uid,
    String id,
    Map<String, dynamic> data,
  ) =>
      _firestore
          .collection('users')
          .doc(uid)
          .collection('quests')
          .doc(id)
          .update(data);

  /// Deletes a user quest document.
  Future<void> delete(String uid, String id) =>
      _collection(uid).doc(id).delete();

  /// Watches active quests for a user.
  Stream<List<UserQuestModel>> watchActive(String uid) => _collection(uid)
      .where('status', isEqualTo: 'active')
      .orderBy('sortOrder')
      .snapshots()
      .map((snap) => snap.docs.map((d) => d.data()).toList());

  /// Watches completed quests for a user.
  Stream<List<UserQuestModel>> watchCompleted(String uid) => _collection(uid)
      .where('status', isEqualTo: 'completed')
      .orderBy('completedAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((d) => d.data()).toList());

  /// Updates stage progress for a user quest.
  Future<void> updateStageProgress(
    String uid,
    String id,
    List<Map<String, dynamic>> stageProgress,
  ) =>
      update(uid, id, {'stageProgress': stageProgress});

  /// Reorders a user quest by updating its sort order.
  Future<void> reorder(String uid, String id, int newSortOrder) =>
      update(uid, id, {'sortOrder': newSortOrder});
}
