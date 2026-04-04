import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sidequest/models/friendship_model.dart';

/// Repository for friendship data in Firestore.
///
/// All reads use [.withConverter] for type-safe access.
class FriendshipRepository {
  /// Creates a [FriendshipRepository].
  FriendshipRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<FriendshipModel> get _collection =>
      _firestore.collection('friendships').withConverter<FriendshipModel>(
            fromFirestore: (snap, _) =>
                FriendshipModel.fromJson({...snap.data()!, 'id': snap.id}),
            toFirestore: (model, _) => model.toJson()..remove('id'),
          );

  /// Sends a friend request from [requesterId] to [receiverId].
  Future<String> send({
    required String requesterId,
    required String receiverId,
  }) async {
    final doc = await _collection.add(FriendshipModel(
      id: '',
      userIds: [requesterId, receiverId],
      status: FriendshipStatus.pending,
      requesterId: requesterId,
      createdAt: DateTime.now(),
    ),);
    return doc.id;
  }

  /// Accepts a pending friend request.
  Future<void> accept(String id) => _firestore
      .collection('friendships')
      .doc(id)
      .update({
        'status': 'accepted',
        'acceptedAt': DateTime.now().toIso8601String(),
      });

  /// Declines (deletes) a pending friend request.
  Future<void> decline(String id) => _collection.doc(id).delete();

  /// Removes an existing friendship.
  Future<void> remove(String id) => _collection.doc(id).delete();

  /// Watches accepted friends for a user.
  Stream<List<FriendshipModel>> watchFriends(String userId) => _collection
      .where('userIds', arrayContains: userId)
      .where('status', isEqualTo: 'accepted')
      .snapshots()
      .map((snap) => snap.docs.map((d) => d.data()).toList());

  /// Watches pending incoming friend requests for a user.
  Stream<List<FriendshipModel>> watchPendingRequests(String userId) =>
      _collection
          .where('userIds', arrayContains: userId)
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .map((snap) => snap.docs
              .map((d) => d.data())
              .where((f) => f.requesterId != userId)
              .toList(),);
}
