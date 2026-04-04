import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/blocks/block_config.dart';
import 'package:sidequest/models/blocks/proof_block.dart';
import 'package:sidequest/models/quality_signal_model.dart';
import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/repositories/quality_signal_repository.dart';
import 'package:sidequest/repositories/quest_repository.dart';
import 'package:sidequest/services/quality_signal_service.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late QualitySignalService service;
  late QuestRepository questRepo;

  final testQuest = QuestModel(
    id: '',
    creatorId: 'creator',
    type: QuestType.public,
    title: 'Test',
    description: '',
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
    service = QualitySignalService(
      signalRepository: QualitySignalRepository(firestore),
      questRepository: questRepo,
    );
  });

  group('submitSignal', () {
    test('creates signal and returns true', () async {
      final questId = await questRepo.create(testQuest);

      final result = await service.submitSignal(
        questId: questId,
        userId: 'u1',
        signal: QualitySignalType.worthIt,
      );
      expect(result, isTrue);

      final signals = await firestore.collection('qualitySignals').get();
      expect(signals.docs, hasLength(1));
      expect(signals.docs.first.data()['signal'], 'worthIt');
    });

    test('write-once: returns false on duplicate', () async {
      final questId = await questRepo.create(testQuest);

      await service.submitSignal(
        questId: questId,
        userId: 'u1',
        signal: QualitySignalType.worthIt,
      );

      final result = await service.submitSignal(
        questId: questId,
        userId: 'u1',
        signal: QualitySignalType.needsWork,
      );
      expect(result, isFalse);

      // Still only one signal
      final signals = await firestore.collection('qualitySignals').get();
      expect(signals.docs, hasLength(1));
    });

    test('different users can signal same quest', () async {
      final questId = await questRepo.create(testQuest);

      await service.submitSignal(
        questId: questId,
        userId: 'u1',
        signal: QualitySignalType.worthIt,
      );
      await service.submitSignal(
        questId: questId,
        userId: 'u2',
        signal: QualitySignalType.needsWork,
      );

      final signals = await firestore.collection('qualitySignals').get();
      expect(signals.docs, hasLength(2));
    });
  });

  group('hasSignaled', () {
    test('returns false when not signaled', () async {
      final result = await service.hasSignaled(
        questId: 'q1',
        userId: 'u1',
      );
      expect(result, isFalse);
    });

    test('returns true after signaling', () async {
      final questId = await questRepo.create(testQuest);
      await service.submitSignal(
        questId: questId,
        userId: 'u1',
        signal: QualitySignalType.worthIt,
      );

      final result = await service.hasSignaled(
        questId: questId,
        userId: 'u1',
      );
      expect(result, isTrue);
    });
  });

  group('feedQualityScore', () {
    test('returns 1.0 when fewer than 10 ratings', () {
      expect(
        QualitySignalService.feedQualityScore(
          worthItCount: 3,
          needsWorkCount: 2,
        ),
        1.0,
      );
    });

    test('returns 1.0 when needs work ratio <= 50%', () {
      expect(
        QualitySignalService.feedQualityScore(
          worthItCount: 8,
          needsWorkCount: 5,
        ),
        1.0,
      );
    });

    test('returns 0.5 when needs work ratio > 50%', () {
      expect(
        QualitySignalService.feedQualityScore(
          worthItCount: 3,
          needsWorkCount: 7,
        ),
        0.5,
      );
    });

    test('returns 1.0 with no ratings at all', () {
      expect(
        QualitySignalService.feedQualityScore(
          worthItCount: 0,
          needsWorkCount: 0,
        ),
        1.0,
      );
    });

    test('exact 50% threshold is not deprioritized', () {
      expect(
        QualitySignalService.feedQualityScore(
          worthItCount: 5,
          needsWorkCount: 5,
        ),
        1.0,
      );
    });

    test('51% needs work is deprioritized', () {
      expect(
        QualitySignalService.feedQualityScore(
          worthItCount: 49,
          needsWorkCount: 51,
        ),
        0.5,
      );
    });
  });
}
