import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/repositories/quest_repository.dart';
import 'package:sidequest/repositories/user_quest_repository.dart';
import 'package:sidequest/services/quest_service.dart';

/// Provides the [QuestRepository] instance.
final questRepositoryProvider = Provider<QuestRepository>(
  (ref) => QuestRepository(FirebaseFirestore.instance),
);

/// Provides the [QuestService] instance.
final questServiceProvider = Provider<QuestService>(
  (ref) => QuestService(
    questRepository: ref.read(questRepositoryProvider),
    userQuestRepository: UserQuestRepository(FirebaseFirestore.instance),
  ),
);

/// Watches trending public quests ordered by add count.
final publicQuestsProvider = StreamProvider<List<QuestModel>>(
  (ref) => ref.watch(questRepositoryProvider).watchTrending(),
);

/// Watches a single quest by its [id] in real-time.
final questByIdProvider =
    StreamProvider.family<QuestModel?, String>(
  (ref, id) => ref.watch(questRepositoryProvider).watchById(id),
);
