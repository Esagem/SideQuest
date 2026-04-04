import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sidequest/models/user_model.dart';

/// Repository for user profile data in Firestore.
///
/// All reads use [.withConverter] for type-safe access.
class UserRepository {
  /// Creates a [UserRepository].
  UserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<UserModel> get _collection =>
      _firestore.collection('users').withConverter<UserModel>(
            fromFirestore: (snap, _) => UserModel.fromJson(snap.data()!),
            toFirestore: (model, _) => model.toJson(),
          );

  /// Creates a new user document.
  Future<void> create(UserModel user) =>
      _collection.doc(user.uid).set(user);

  /// Gets a user by [id]. Returns null if not found.
  Future<UserModel?> getById(String id) async {
    final snap = await _collection.doc(id).get();
    return snap.data();
  }

  /// Watches a user by [id] in real-time.
  Stream<UserModel?> watchById(String id) =>
      _collection.doc(id).snapshots().map((snap) => snap.data());

  /// Updates fields on a user document.
  Future<void> update(String id, Map<String, dynamic> data) =>
      _firestore.collection('users').doc(id).update(data);

  /// Deletes a user document.
  Future<void> delete(String id) => _collection.doc(id).delete();

  /// Checks if a [username] is available.
  Future<bool> checkUsernameAvailable(String username) async {
    final snap = await _collection
        .where('username', isEqualTo: username.toLowerCase())
        .limit(1)
        .get();
    return snap.docs.isEmpty;
  }

  /// Searches users by username prefix.
  Stream<List<UserModel>> searchByUsername(String prefix) {
    final end = '$prefix\uf8ff';
    return _collection
        .where('username', isGreaterThanOrEqualTo: prefix.toLowerCase())
        .where('username', isLessThanOrEqualTo: end)
        .limit(20)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  /// Searches users by display name prefix.
  Stream<List<UserModel>> searchByDisplayName(String prefix) {
    final end = '$prefix\uf8ff';
    return _collection
        .where('displayName', isGreaterThanOrEqualTo: prefix)
        .where('displayName', isLessThanOrEqualTo: end)
        .limit(20)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }
}
