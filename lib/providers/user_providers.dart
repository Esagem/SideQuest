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
/// Returns null if not authenticated.
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.read(userRepositoryProvider).watchById(user.uid);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});
