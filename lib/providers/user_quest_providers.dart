import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sidequest/models/user_quest_model.dart';
import 'package:sidequest/providers/auth_providers.dart';
import 'package:sidequest/repositories/user_quest_repository.dart';

/// Provides the [UserQuestRepository] instance.
final userQuestRepositoryProvider = Provider<UserQuestRepository>(
  (ref) => UserQuestRepository(FirebaseFirestore.instance),
);

/// Watches the current user's active quests.
final activeQuestsProvider = StreamProvider<List<UserQuestModel>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value([]);
  return ref.read(userQuestRepositoryProvider).watchActive(user.uid);
});

/// Watches the current user's completed quests.
final completedQuestsProvider = StreamProvider<List<UserQuestModel>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value([]);
  return ref.read(userQuestRepositoryProvider).watchCompleted(user.uid);
});
