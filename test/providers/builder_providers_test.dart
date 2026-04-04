import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/blocks/block_registry.dart';
import 'package:sidequest/models/blocks/location_block.dart';
import 'package:sidequest/models/blocks/proof_block.dart';
import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/providers/builder_providers.dart';

void main() {
  late BuilderNotifier notifier;

  setUp(() {
    notifier = BuilderNotifier();
  });

  group('initial state', () {
    test('starts with title block only', () {
      expect(notifier.state.blocks, ['title']);
    });

    test('has no expanded block', () {
      expect(notifier.state.expandedBlockId, isNull);
    });
  });

  group('addBlock', () {
    test('adds a block and auto-expands it', () {
      final proofMeta = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'proof');
      notifier.addBlock(proofMeta);
      expect(notifier.state.blocks, ['title', 'proof']);
      expect(notifier.state.expandedBlockId, 'proof');
    });

    test('prevents duplicate blocks with maxInstances=1', () {
      final proofMeta = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'proof');
      notifier
        ..addBlock(proofMeta)
        ..addBlock(proofMeta);
      expect(
        notifier.state.blocks.where((id) => id == 'proof').length,
        1,
      );
    });
  });

  group('removeBlock', () {
    test('removes a non-title block', () {
      final proofMeta = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'proof');
      notifier
        ..addBlock(proofMeta)
        ..removeBlock('proof');
      expect(notifier.state.blocks, ['title']);
    });

    test('cannot remove title block', () {
      notifier.removeBlock('title');
      expect(notifier.state.blocks, contains('title'));
    });

    test('clears expanded if removed block was expanded', () {
      final proofMeta = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'proof');
      notifier.addBlock(proofMeta);
      expect(notifier.state.expandedBlockId, 'proof');
      notifier.removeBlock('proof');
      expect(notifier.state.expandedBlockId, isNull);
    });

    test('removes config for removed block', () {
      final proofMeta = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'proof');
      notifier
        ..addBlock(proofMeta)
        ..updateBlockConfig(
          'proof',
          const ProofBlock(type: ProofType.video),
        )
        ..removeBlock('proof');
      expect(notifier.state.configs.containsKey('proof'), isFalse);
    });
  });

  group('reorderBlocks', () {
    test('reorders non-title blocks', () {
      final proof = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'proof');
      final location = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'location');
      notifier
        ..addBlock(proof)
        ..addBlock(location)
        ..reorderBlocks(2, 1);
      expect(notifier.state.blocks, ['title', 'location', 'proof']);
    });

    test('prevents moving title from index 0', () {
      final proof = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'proof');
      notifier
        ..addBlock(proof)
        ..reorderBlocks(0, 1);
      expect(notifier.state.blocks.first, 'title');
    });

    test('prevents moving block to index 0', () {
      final proof = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'proof');
      notifier
        ..addBlock(proof)
        ..reorderBlocks(1, 0);
      expect(notifier.state.blocks.first, 'title');
    });
  });

  group('toggleExpanded', () {
    test('expands a block', () {
      notifier.toggleExpanded('title');
      expect(notifier.state.expandedBlockId, 'title');
    });

    test('collapses when toggling same block', () {
      notifier
        ..toggleExpanded('title')
        ..toggleExpanded('title');
      expect(notifier.state.expandedBlockId, isNull);
    });
  });

  group('updateBlockConfig', () {
    test('stores config for a block', () {
      notifier.updateBlockConfig(
        'proof',
        const ProofBlock(type: ProofType.video),
      );
      expect(notifier.state.configs['proof'], isA<ProofBlock>());
    });
  });

  group('validate', () {
    test('returns errors when title and proof are missing', () {
      final errors = notifier.validate();
      expect(errors, contains('Title is required'));
      expect(errors, contains('Proof block is required'));
      expect(errors, contains('Category is required'));
    });

    test('returns empty when all required fields are present', () {
      final proofMeta = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'proof');
      notifier
        ..addBlock(proofMeta)
        ..updateTitle('My Quest')
        ..updateCategory('travel');
      expect(notifier.validate(), isEmpty);
    });

    test('returns error for missing proof block', () {
      notifier
        ..updateTitle('My Quest')
        ..updateCategory('travel');
      final errors = notifier.validate();
      expect(errors, contains('Proof block is required'));
    });
  });

  group('toQuestBlocks', () {
    test('returns null without proof block', () {
      expect(notifier.toQuestBlocks(), isNull);
    });

    test('compiles with proof block', () {
      final proofMeta = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'proof');
      notifier.addBlock(proofMeta);
      final blocks = notifier.toQuestBlocks();
      expect(blocks, isNotNull);
      expect(blocks!.proof.type, ProofType.photo);
    });

    test('includes configured blocks', () {
      final proofMeta = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'proof');
      final locationMeta = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'location');
      notifier
        ..addBlock(proofMeta)
        ..addBlock(locationMeta)
        ..updateBlockConfig(
          'location',
          const LocationBlock(type: LocationType.city, value: 'NYC'),
        );
      final blocks = notifier.toQuestBlocks();
      expect(blocks!.location?.value, 'NYC');
    });
  });

  group('toQuestModel', () {
    test('returns null when validation fails', () {
      expect(notifier.toQuestModel('user1'), isNull);
    });

    test('compiles valid quest model', () {
      final proofMeta = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'proof');
      notifier
        ..addBlock(proofMeta)
        ..updateTitle('Test Quest')
        ..updateDescription('A test quest')
        ..updateCategory('travel')
        ..updateDifficulty(Difficulty.hard)
        ..updateVisibility(QuestVisibility.public);

      final model = notifier.toQuestModel('user1');
      expect(model, isNotNull);
      expect(model!.title, 'Test Quest');
      expect(model.creatorId, 'user1');
      expect(model.difficulty, Difficulty.hard);
      expect(model.type, QuestType.public);
      expect(model.category, 'travel');
    });
  });

  group('reset', () {
    test('returns to initial state', () {
      final proofMeta = BlockRegistry.coreBlocks
          .firstWhere((b) => b.id == 'proof');
      notifier
        ..addBlock(proofMeta)
        ..updateTitle('Test')
        ..reset();
      expect(notifier.state.blocks, ['title']);
      expect(notifier.state.title, isEmpty);
      expect(notifier.state.configs, isEmpty);
    });
  });

  group('metaFor', () {
    test('finds known block meta', () {
      expect(BuilderNotifier.metaFor('proof')?.id, 'proof');
      expect(BuilderNotifier.metaFor('wildcard')?.id, 'wildcard');
    });

    test('returns null for unknown block', () {
      expect(BuilderNotifier.metaFor('nonexistent'), isNull);
    });
  });
}
