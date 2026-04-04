import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sidequest/models/quality_signal_model.dart';

/// Repository for quest quality signals in Firestore.
///
/// Write-once: users can create signals but cannot update or delete them
/// (enforced by Firestore security rules).
class QualitySignalRepository {
  /// Creates a [QualitySignalRepository].
  QualitySignalRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<QualitySignalModel> get _collection =>
      _firestore
          .collection('qualitySignals')
          .withConverter<QualitySignalModel>(
            fromFirestore: (snap, _) =>
                QualitySignalModel.fromJson(snap.data()!),
            toFirestore: (model, _) => model.toJson(),
          );

  /// Creates a new quality signal.
  Future<String> create(QualitySignalModel signal) async {
    final doc = await _collection.add(signal);
    return doc.id;
  }

  /// Gets all quality signals for a quest.
  Future<List<QualitySignalModel>> getForQuest(String questId) async {
    final snap =
        await _collection.where('questId', isEqualTo: questId).get();
    return snap.docs.map((d) => d.data()).toList();
  }

  /// Checks whether a user has already signaled a quest.
  Future<bool> hasUserSignaled({
    required String questId,
    required String userId,
  }) async {
    final snap = await _collection
        .where('questId', isEqualTo: questId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }
}
