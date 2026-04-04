import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/blocks/block_registry.dart';

void main() {
  group('BlockRegistry', () {
    test('has 8 core blocks', () {
      expect(BlockRegistry.coreBlocks, hasLength(8));
    });

    test('has 7 flavor blocks', () {
      expect(BlockRegistry.flavorBlocks, hasLength(7));
    });

    test('has 15 total blocks', () {
      expect(BlockRegistry.allBlocks, hasLength(15));
    });

    test('core blocks are marked as core', () {
      for (final block in BlockRegistry.coreBlocks) {
        expect(block.isCoreBlock, isTrue, reason: '${block.id} should be core');
      }
    });

    test('flavor blocks are marked as non-core', () {
      for (final block in BlockRegistry.flavorBlocks) {
        expect(
          block.isCoreBlock,
          isFalse,
          reason: '${block.id} should not be core',
        );
      }
    });

    test('title and proof are required', () {
      final required =
          BlockRegistry.coreBlocks.where((b) => b.isRequired).toList();
      expect(required, hasLength(2));
      expect(required.map((b) => b.id), containsAll(['title', 'proof']));
    });

    test('all blocks have unique IDs', () {
      final ids = BlockRegistry.allBlocks.map((b) => b.id).toSet();
      expect(ids, hasLength(BlockRegistry.allBlocks.length));
    });
  });
}
