import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_toast.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/quest_builder/widgets/block_build_area.dart';
import 'package:sidequest/features/quest_builder/widgets/block_card.dart';
import 'package:sidequest/features/quest_builder/widgets/block_tray.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/bonus_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/category_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/chain_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/constraint_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/difficulty_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/intent_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/location_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/people_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/prompt_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/proof_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/repeat_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/stages_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/time_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/title_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/blocks/wildcard_block_widget.dart';
import 'package:sidequest/features/quest_builder/widgets/quest_preview_card.dart';
import 'package:sidequest/providers/auth_providers.dart';
import 'package:sidequest/providers/builder_providers.dart';
import 'package:sidequest/providers/quest_providers.dart';

/// Full-screen quest builder with drag-and-drop block placement.
///
/// Top bar has close, title, and publish button. The main area is a
/// scrollable list of placed blocks. The bottom has a block tray.
class BuilderScreen extends ConsumerStatefulWidget {
  /// Creates a [BuilderScreen].
  const BuilderScreen({super.key});

  @override
  ConsumerState<BuilderScreen> createState() => _BuilderScreenState();
}

class _BuilderScreenState extends ConsumerState<BuilderScreen> {
  bool _isPublishing = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(builderStateProvider);
    final notifier = ref.read(builderStateProvider.notifier);
    final isValid = notifier.validate().isEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _isPublishing
              ? null
              : () {
                  notifier.reset();
                  context.pop();
                },
        ),
        title: const Text('Create Quest'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: SizedBox(
              width: AppSpacing.xxl * 2.5,
              child: _isPublishing
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : SQButton.primary(
                      label: 'Publish',
                      onPressed: isValid ? _publish : null,
                    ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Preview card
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              0,
            ),
            child: QuestPreviewCard(state: state),
          ),
          // Build area
          Expanded(
            child: BlockBuildArea(
              onReorder: notifier.reorderBlocks,
              children: [
                for (var i = 0; i < state.blocks.length; i++)
                  _buildBlockCard(
                    state.blocks[i],
                    isExpanded: state.expandedBlockId == state.blocks[i],
                    isRequired: state.blocks[i] == 'title',
                  ),
              ],
            ),
          ),
          // Block tray
          BlockTray(
            placedBlockIds: state.blocks.toSet(),
            onBlockTap: notifier.addBlock,
          ),
        ],
      ),
    );
  }

  Widget _buildBlockCard(
    String blockId, {
    required bool isExpanded,
    required bool isRequired,
  }) {
    final notifier = ref.read(builderStateProvider.notifier);
    final meta = BuilderNotifier.metaFor(blockId);
    if (meta == null) return const SizedBox.shrink();

    return BlockCard(
      meta: meta,
      isExpanded: isExpanded,
      onTap: () => notifier.toggleExpanded(blockId),
      onRemove: isRequired ? null : () => notifier.removeBlock(blockId),
      summary: _summaryFor(blockId, ref.read(builderStateProvider)),
      child: _buildBlockContent(blockId),
    );
  }

  Widget? _buildBlockContent(String blockId) {
    final notifier = ref.read(builderStateProvider.notifier);
    void onChanged(dynamic config) =>
        notifier.updateBlockConfig(blockId, config);

    return switch (blockId) {
      'title' => TitleBlockWidget(
          onTitleChanged: notifier.updateTitle,
          onDescriptionChanged: notifier.updateDescription,
        ),
      'proof' => ProofBlockWidget(onConfigChanged: onChanged),
      'location' => LocationBlockWidget(onConfigChanged: onChanged),
      'people' => PeopleBlockWidget(onConfigChanged: onChanged),
      'time' => TimeBlockWidget(onConfigChanged: onChanged),
      'category' => CategoryBlockWidget(
          onConfigChanged: (category) =>
              notifier.updateCategory(category as String),
        ),
      'difficulty' => DifficultyBlockWidget(
          onConfigChanged: notifier.updateDifficulty,
        ),
      'stages' => StagesBlockWidget(onConfigChanged: onChanged),
      'wildcard' => WildcardBlockWidget(onConfigChanged: onChanged),
      'prompt' => PromptBlockWidget(onConfigChanged: onChanged),
      'chain' => ChainBlockWidget(onConfigChanged: onChanged),
      'bonus' => BonusBlockWidget(onConfigChanged: onChanged),
      'constraint' => ConstraintBlockWidget(onConfigChanged: onChanged),
      'repeat' => RepeatBlockWidget(onConfigChanged: onChanged),
      'intent' => IntentBlockWidget(onConfigChanged: onChanged),
      _ => null,
    };
  }

  String? _summaryFor(String blockId, BuilderStateData state) =>
      switch (blockId) {
        'title' => state.title.isEmpty ? null : state.title,
        'category' => state.category.isEmpty ? null : state.category,
        'difficulty' => state.difficulty.name,
        _ => null,
      };

  Future<void> _publish() async {
    final userId = ref.read(authStateProvider).valueOrNull?.uid;
    if (userId == null) {
      SQToast.error(context, 'You must be signed in to publish.');
      return;
    }

    final notifier = ref.read(builderStateProvider.notifier);
    final model = notifier.toQuestModel(userId);
    if (model == null) {
      SQToast.error(context, 'Please fill in all required fields.');
      return;
    }

    setState(() => _isPublishing = true);
    try {
      final questId = await ref
          .read(questServiceProvider)
          .createQuest(quest: model, creatorId: userId);
      notifier.reset();
      if (mounted) context.go('/quest/$questId');
    } on Exception {
      if (mounted) SQToast.error(context, 'Failed to publish. Try again.');
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }
}
