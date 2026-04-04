import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sidequest/repositories/auth_repository.dart';

/// Provides the [AuthRepository] instance.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(FirebaseAuth.instance),
);

/// Stream of Firebase auth state changes.
///
/// Emits the current [User] when signed in, or null when signed out.
final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges,
);
