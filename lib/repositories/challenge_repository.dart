import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sidequest/models/challenge_model.dart';

/// Repository for challenge data in Firestore.
///
/// All reads use [.withConverter] for type-safe access.
class ChallengeRepository {
  /// Creates a [ChallengeRepository].
  ChallengeRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<ChallengeModel> get _collection =>
      _firestore.collection('challenges').withConverter<ChallengeModel>(
            fromFirestore: (snap, _) =>
                ChallengeModel.fromJson({...snap.data()!, 'id': snap.id}),
            toFirestore: (model, _) => model.toJson()..remove('id'),
          );

  /// Sends a challenge from [senderId] to [receiverId] for [questId].
  Future<String> send({
    required String senderId,
    required String receiverId,
    required String questId,
    String? message,
  }) async {
    final doc = await _collection.add(ChallengeModel(
      id: '',
      senderId: senderId,
      receiverId: receiverId,
      questId: questId,
      message: message,
      status: ChallengeStatus.pending,
      createdAt: DateTime.now(),
    ),);
    return doc.id;
  }

  /// Accepts a challenge.
  Future<void> accept(String id) => _firestore
      .collection('challenges')
      .doc(id)
      .update({'status': 'accepted'});

  /// Declines a challenge.
  Future<void> decline(String id) => _firestore
      .collection('challenges')
      .doc(id)
      .update({'status': 'declined'});

  /// Marks a challenge as completed.
  Future<void> complete(String id) => _firestore
      .collection('challenges')
      .doc(id)
      .update({'status': 'completed'});

  /// Watches incoming challenges for a user.
  Stream<List<ChallengeModel>> watchIncoming(String userId) => _collection
      .where('receiverId', isEqualTo: userId)
      .where('status', isEqualTo: 'pending')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((d) => d.data()).toList());

  /// Watches outgoing challenges sent by a user.
  Stream<List<ChallengeModel>> watchOutgoing(String userId) => _collection
      .where('senderId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((d) => d.data()).toList());
}
