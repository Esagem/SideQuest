import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sidequest/models/blocks/block_config.dart';
import 'package:sidequest/models/blocks/block_meta.dart';
import 'package:sidequest/models/blocks/block_registry.dart';
import 'package:sidequest/models/blocks/bonus_block.dart';
import 'package:sidequest/models/blocks/chain_block.dart';
import 'package:sidequest/models/blocks/constraint_block.dart';
import 'package:sidequest/models/blocks/intent_block.dart';
import 'package:sidequest/models/blocks/location_block.dart';
import 'package:sidequest/models/blocks/people_block.dart';
import 'package:sidequest/models/blocks/prompt_block.dart';
import 'package:sidequest/models/blocks/proof_block.dart';
import 'package:sidequest/models/blocks/repeat_block.dart';
import 'package:sidequest/models/blocks/stages_block.dart';
import 'package:sidequest/models/blocks/time_block.dart';
import 'package:sidequest/models/blocks/wildcard_block.dart';
import 'package:sidequest/models/quest_model.dart';

/// Provides the [BuilderNotifier] for managing quest builder state.
final builderStateProvider =
    StateNotifierProvider<BuilderNotifier, BuilderStateData>(
  (ref) => BuilderNotifier(),
);

/// The state of the quest builder.
///
/// Tracks placed blocks, their configurations, the expanded block,
/// and quest-level metadata (title, description, category, etc.).
class BuilderStateData {
  /// Creates a [BuilderStateData].
  const BuilderStateData({
    required this.blocks,
    this.expandedBlockId,
    this.title = '',
    this.description = '',
    this.category = '',
    this.difficulty = Difficulty.easy,
    this.visibility = QuestVisibility.personal,
    this.configs = const {},
  });

  /// Creates the initial state with only a Title block.
  factory BuilderStateData.initial() => const BuilderStateData(
        blocks: ['title'],
      );

  /// The list of placed block IDs in order.
  final List<String> blocks;

  /// The currently expanded block ID, or null.
  final String? expandedBlockId;

  /// Quest title.
  final String title;

  /// Quest description.
  final String description;

  /// Quest category key.
  final String category;

  /// Quest difficulty.
  final Difficulty difficulty;

  /// Quest visibility.
  final QuestVisibility visibility;

  /// Block configurations keyed by block ID.
  final Map<String, dynamic> configs;

  /// Creates a copy with the given fields replaced.
  BuilderStateData copyWith({
    List<String>? blocks,
    String? Function()? expandedBlockId,
    String? title,
    String? description,
    String? category,
    Difficulty? difficulty,
    QuestVisibility? visibility,
    Map<String, dynamic>? configs,
  }) =>
      BuilderStateData(
        blocks: blocks ?? this.blocks,
        expandedBlockId: expandedBlockId != null
            ? expandedBlockId()
            : this.expandedBlockId,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        difficulty: difficulty ?? this.difficulty,
        visibility: visibility ?? this.visibility,
        configs: configs ?? this.configs,
      );
}

/// Manages the quest builder state.
///
/// Handles adding, removing, reordering blocks, updating configs,
/// and compiling the final [QuestBlocks] and [QuestModel].
class BuilderNotifier extends StateNotifier<BuilderStateData> {
  /// Creates a [BuilderNotifier] with initial state.
  BuilderNotifier() : super(BuilderStateData.initial());

  /// Adds a block to the builder and auto-expands it.
  ///
  /// Prevents adding duplicate blocks that have maxInstances=1.
  void addBlock(BlockMeta meta) {
    if (meta.maxInstances == 1 && state.blocks.contains(meta.id)) return;
    state = state.copyWith(
      blocks: [...state.blocks, meta.id],
      expandedBlockId: () => meta.id,
    );
  }

  /// Removes a block from the builder.
  ///
  /// Title block cannot be removed.
  void removeBlock(String blockId) {
    if (blockId == 'title') return;
    final updated = state.blocks.where((id) => id != blockId).toList();
    final configs = Map<String, dynamic>.of(state.configs)..remove(blockId);
    state = state.copyWith(
      blocks: updated,
      configs: configs,
      expandedBlockId: () =>
          state.expandedBlockId == blockId ? null : state.expandedBlockId,
    );
  }

  /// Reorders blocks, keeping Title always at index 0.
  void reorderBlocks(int oldIndex, int newIndex) {
    if (oldIndex == 0 || newIndex == 0) return;
    final blocks = List<String>.of(state.blocks);
    final item = blocks.removeAt(oldIndex);
    final adjustedNew = newIndex > oldIndex ? newIndex - 1 : newIndex;
    blocks.insert(adjustedNew < 1 ? 1 : adjustedNew, item);
    state = state.copyWith(blocks: blocks);
  }

  /// Updates the configuration for a specific block.
  void updateBlockConfig(String blockId, dynamic config) {
    final configs = Map<String, dynamic>.of(state.configs)
      ..[blockId] = config;
    state = state.copyWith(configs: configs);
  }

  /// Toggles the expanded state of a block.
  void toggleExpanded(String blockId) {
    state = state.copyWith(
      expandedBlockId: () =>
          state.expandedBlockId == blockId ? null : blockId,
    );
  }

  /// Updates the quest title.
  void updateTitle(String title) =>
      state = state.copyWith(title: title);

  /// Updates the quest description.
  void updateDescription(String description) =>
      state = state.copyWith(description: description);

  /// Updates the quest category.
  void updateCategory(String category) =>
      state = state.copyWith(category: category);

  /// Updates the quest difficulty.
  void updateDifficulty(Difficulty difficulty) =>
      state = state.copyWith(difficulty: difficulty);

  /// Updates the quest visibility.
  void updateVisibility(QuestVisibility visibility) =>
      state = state.copyWith(visibility: visibility);

  /// Validates the current builder state.
  ///
  /// Returns a list of validation error messages, or empty if valid.
  List<String> validate() {
    final errors = <String>[];
    if (state.title.trim().isEmpty) errors.add('Title is required');
    if (!state.blocks.contains('proof')) errors.add('Proof block is required');
    if (state.category.isEmpty) errors.add('Category is required');
    return errors;
  }

  /// Compiles the placed blocks into a [QuestBlocks] model.
  ///
  /// Returns null if the required Proof block is missing.
  QuestBlocks? toQuestBlocks() {
    if (!state.blocks.contains('proof')) return null;

    final c = state.configs;
    return QuestBlocks(
      proof: c['proof'] is ProofBlock
          ? c['proof'] as ProofBlock
          : const ProofBlock(type: ProofType.photo),
      location: c['location'] as LocationBlock?,
      people: c['people'] as PeopleBlock?,
      time: c['time'] as TimeBlock?,
      wildcard: c['wildcard'] as WildcardBlock?,
      prompt: c['prompt'] as PromptBlock?,
      chain: c['chain'] as ChainBlock?,
      bonus: c['bonus'] as BonusBlock?,
      constraint: c['constraint'] as ConstraintBlock?,
      repeat: c['repeat'] as RepeatBlock?,
      stages: c['stages'] as StagesBlock?,
      intentBlock: c['intent'] as IntentBlock?,
    );
  }

  /// Compiles the full [QuestModel] from builder state.
  ///
  /// Returns null if validation fails.
  QuestModel? toQuestModel(String creatorId) {
    if (validate().isNotEmpty) return null;
    final blocks = toQuestBlocks();
    if (blocks == null) return null;

    final now = DateTime.now();
    return QuestModel(
      id: '',
      creatorId: creatorId,
      type: state.visibility == QuestVisibility.public
          ? QuestType.public
          : QuestType.personal,
      title: state.title.trim(),
      description: state.description.trim(),
      category: state.category,
      difficulty: state.difficulty,
      visibility: state.visibility,
      blocks: blocks,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Resets the builder to its initial state.
  void reset() => state = BuilderStateData.initial();

  /// Looks up a [BlockMeta] by its [blockId].
  static BlockMeta? metaFor(String blockId) {
    for (final meta in BlockRegistry.allBlocks) {
      if (meta.id == blockId) return meta;
    }
    return null;
  }
}
