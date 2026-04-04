import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/blocks/block_config.dart';
import 'package:sidequest/models/blocks/proof_block.dart';
import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/models/user_quest_model.dart';
import 'package:sidequest/repositories/quest_repository.dart';
import 'package:sidequest/repositories/user_quest_repository.dart';
import 'package:sidequest/services/quest_service.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late QuestRepository questRepo;
  late UserQuestRepository userQuestRepo;
  late QuestService service;

  final testQuest = QuestModel(
    id: '',
    creatorId: 'user1',
    type: QuestType.public,
    title: 'Test Quest',
    description: 'A test.',
    category: 'travel',
    difficulty: Difficulty.easy,
    visibility: QuestVisibility.public,
    blocks: const QuestBlocks(proof: ProofBlock(type: ProofType.photo)),
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  setUp(() {
    firestore = FakeFirebaseFirestore();
    questRepo = QuestRepository(firestore);
    userQuestRepo = UserQuestRepository(firestore);
    service = QuestService(
      questRepository: questRepo,
      userQuestRepository: userQuestRepo,
    );
  });

  group('createQuest', () {
    test('creates quest and adds to creator list', () async {
      final questId = await service.createQuest(
        quest: testQuest,
        creatorId: 'user1',
      );

      expect(questId, isNotEmpty);

      // Quest exists in quests collection
      final quest = await questRepo.getById(questId);
      expect(quest, isNotNull);
      expect(quest!.title, 'Test Quest');

      // UserQuest exists in user's subcollection
      final userQuests = await firestore
          .collection('users')
          .doc('user1')
          .collection('quests')
          .get();
      expect(userQuests.docs, hasLength(1));
    });
  });

  group('addQuestToList', () {
    test('creates user quest entry', () async {
      final questId = await questRepo.create(testQuest);

      final userQuestId = await service.addQuestToList(
        userId: 'user2',
        questId: questId,
        currentSortOrder: 0,
      );

      expect(userQuestId, isNotEmpty);

      final uq = await userQuestRepo.getById('user2', userQuestId);
      expect(uq, isNotNull);
      expect(uq!.questId, questId);
      expect(uq.status, UserQuestStatus.active);
    });
  });

  group('removeQuestFromList', () {
    test('deletes user quest entry', () async {
      final questId = await questRepo.create(testQuest);

      final userQuestId = await service.addQuestToList(
        userId: 'user2',
        questId: questId,
        currentSortOrder: 0,
      );

      await service.removeQuestFromList(
        userId: 'user2',
        userQuestId: userQuestId,
      );

      final uq = await userQuestRepo.getById('user2', userQuestId);
      expect(uq, isNull);
    });
  });

  group('completeQuest', () {
    test('updates user quest status to completed', () async {
      final questId = await questRepo.create(testQuest);

      final userQuestId = await service.addQuestToList(
        userId: 'user2',
        questId: questId,
        currentSortOrder: 0,
      );

      await service.completeQuest(
        userId: 'user2',
        userQuestId: userQuestId,
        questId: questId,
        xpEarned: 100,
        proofUrl: 'https://example.com/proof.jpg',
      );

      final uq = await userQuestRepo.getById('user2', userQuestId);
      expect(uq, isNotNull);
      // fake_cloud_firestore stores the raw value
      final rawDoc = await firestore
          .collection('users')
          .doc('user2')
          .collection('quests')
          .doc(userQuestId)
          .get();
      expect(rawDoc.data()!['status'], 'completed');
      expect(rawDoc.data()!['xpEarned'], 100);
    });
  });
}
