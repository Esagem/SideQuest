import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sidequest/models/user_model.dart';
import 'package:sidequest/providers/auth_providers.dart';
import 'package:sidequest/repositories/user_repository.dart';

/// Provides the [UserRepository] instance.
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(FirebaseFirestore.instance),
);

/// Watches the current signed-in user's profile from Firestore.
///
/// Returns null if not authenticated. Creates a stub document if the
/// authenticated user has no Firestore record (e.g. legacy accounts).
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      final repo = ref.read(userRepositoryProvider);
      return repo.watchById(user.uid).asyncMap((model) async {
        if (model != null) return model;
        // No document found — create a stub so the profile screen works.
        final email = user.email ?? '';
        final username = email
            .split('@')
            .first
            .toLowerCase()
            .replaceAll(RegExp('[^a-z0-9_]'), '_');
        final now = DateTime.now();
        final stub = UserModel(
          uid: user.uid,
          email: email,
          displayName: username,
          username: username,
          dateOfBirth: now,
          createdAt: now,
          updatedAt: now,
        );
        await repo.create(stub);
        return stub;
      });
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});
