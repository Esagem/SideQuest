import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sidequest/models/quest_model.dart';

/// Repository for quest data in Firestore.
///
/// All reads use [.withConverter] for type-safe access.
class QuestRepository {
  /// Creates a [QuestRepository].
  QuestRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<QuestModel> get _collection =>
      _firestore.collection('quests').withConverter<QuestModel>(
            fromFirestore: (snap, _) =>
                QuestModel.fromJson({...snap.data()!, 'id': snap.id}),
            toFirestore: (model, _) => model.toJson()..remove('id'),
          );

  /// Creates a new quest and returns its document ID.
  Future<String> create(QuestModel quest) async {
    final doc = await _collection.add(quest);
    return doc.id;
  }

  /// Gets a quest by [id]. Returns null if not found.
  Future<QuestModel?> getById(String id) async {
    final snap = await _collection.doc(id).get();
    return snap.data();
  }

  /// Watches a quest by [id] in real-time.
  Stream<QuestModel?> watchById(String id) =>
      _collection.doc(id).snapshots().map((snap) => snap.data());

  /// Updates fields on a quest document.
  Future<void> update(String id, Map<String, dynamic> data) =>
      _firestore.collection('quests').doc(id).update(data);

  /// Deletes a quest document.
  Future<void> delete(String id) => _collection.doc(id).delete();

  /// Watches public quests filtered by [category].
  Stream<List<QuestModel>> watchPublicByCategory(String category) =>
      _collection
          .where('visibility', isEqualTo: 'public')
          .where('isHidden', isEqualTo: false)
          .where('category', isEqualTo: category)
          .orderBy('addedCount', descending: true)
          .limit(50)
          .snapshots()
          .map((snap) => snap.docs.map((d) => d.data()).toList());

  /// Searches public quests by title prefix.
  Stream<List<QuestModel>> searchByTitle(String prefix) {
    final end = '$prefix\uf8ff';
    return _collection
        .where('visibility', isEqualTo: 'public')
        .where('isHidden', isEqualTo: false)
        .where('title', isGreaterThanOrEqualTo: prefix)
        .where('title', isLessThanOrEqualTo: end)
        .limit(20)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  /// Watches trending quests ordered by add count.
  Stream<List<QuestModel>> watchTrending() => _collection
      .where('visibility', isEqualTo: 'public')
      .where('isHidden', isEqualTo: false)
      .orderBy('addedCount', descending: true)
      .limit(50)
      .snapshots()
      .map((snap) => snap.docs.map((d) => d.data()).toList());

  /// Watches newest quests ordered by creation date.
  Stream<List<QuestModel>> watchNew() => _collection
      .where('visibility', isEqualTo: 'public')
      .where('isHidden', isEqualTo: false)
      .orderBy('createdAt', descending: true)
      .limit(50)
      .snapshots()
      .map((snap) => snap.docs.map((d) => d.data()).toList());
}
