import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/components/sq_toast.dart';
import 'package:sidequest/core/constants/categories.dart';
import 'package:sidequest/core/constants/difficulties.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/block_config.dart';
import 'package:sidequest/models/blocks/proof_block.dart';
import 'package:sidequest/models/quest_model.dart';
import 'package:sidequest/providers/auth_providers.dart';

/// Simplified linear quest creation flow.
///
/// Steps: Title → Category → Difficulty → Proof Type → Done.
/// Builds the same block structure as the full builder.
class QuickCreateScreen extends ConsumerStatefulWidget {
  /// Creates a [QuickCreateScreen].
  const QuickCreateScreen({super.key});

  @override
  ConsumerState<QuickCreateScreen> createState() => _QuickCreateScreenState();
}

class _QuickCreateScreenState extends ConsumerState<QuickCreateScreen> {
  final _titleController = TextEditingController();
  String _category = '';
  Difficulty _difficulty = Difficulty.easy;
  ProofType _proofType = ProofType.photo;
  int _step = 0;

  static const _totalSteps = 4;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  bool get _canAdvance => switch (_step) {
        0 => _titleController.text.trim().isNotEmpty,
        1 => _category.isNotEmpty,
        2 => true,
        3 => true,
        _ => false,
      };

  void _next() {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      context.pop();
    }
  }

  void _submit() {
    final userId = ref.read(authStateProvider).valueOrNull?.uid;
    if (userId == null) {
      SQToast.error(context, 'You must be signed in.');
      return;
    }

    final now = DateTime.now();
    final quest = QuestModel(
      id: '',
      creatorId: userId,
      type: QuestType.personal,
      title: _titleController.text.trim(),
      description: '',
      category: _category,
      difficulty: _difficulty,
      visibility: QuestVisibility.personal,
      blocks: QuestBlocks(proof: ProofBlock(type: _proofType)),
      createdAt: now,
      updatedAt: now,
    );

    // TODO(quest): Save via QuestService
    SQToast.success(context, 'Quest created: ${quest.title}');
    context.pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _back,
          ),
          title: const Text('Quick Create'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value: (_step + 1) / _totalSteps,
                  color: AppColors.sunsetOrange,
                  backgroundColor: AppColors.lightGray,
                ),
                const SizedBox(height: AppSpacing.xl),
                // Step content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _buildStep(),
                  ),
                ),
                // Actions
                SQButton.primary(
                  label: _step == _totalSteps - 1 ? 'Create Quest' : 'Next',
                  onPressed: _canAdvance ? _next : null,
                ),
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: TextButton(
                    onPressed: () {
                      context
                        ..pop()
                        ..push('/builder');
                    },
                    child: Text(
                      'Want more options? Switch to Builder',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.sunsetOrange,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildStep() => switch (_step) {
        0 => _TitleStep(
            key: const ValueKey('title'),
            controller: _titleController,
            onChanged: () => setState(() {}),
          ),
        1 => _CategoryStep(
            key: const ValueKey('category'),
            selected: _category,
            onSelected: (c) => setState(() => _category = c),
          ),
        2 => _DifficultyStep(
            key: const ValueKey('difficulty'),
            selected: _difficulty,
            onSelected: (d) => setState(() => _difficulty = d),
          ),
        3 => _ProofStep(
            key: const ValueKey('proof'),
            selected: _proofType,
            onSelected: (p) => setState(() => _proofType = p),
          ),
        _ => const SizedBox.shrink(),
      };
}

class _TitleStep extends StatelessWidget {
  const _TitleStep({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What do you want to do?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          SQInput(
            hint: 'e.g., Climb a mountain',
            controller: controller,
            maxLength: 100,
          ),
        ],
      );
}

class _CategoryStep extends StatelessWidget {
  const _CategoryStep({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pick a category',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: Category.values.map((c) {
              final key = c.name;
              return SQChip(
                label: c.displayName,
                color: c.color,
                isSelected: selected == key,
                onTap: () => onSelected(key),
              );
            }).toList(),
          ),
        ],
      );
}

class _DifficultyStep extends StatelessWidget {
  const _DifficultyStep({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final Difficulty selected;
  final ValueChanged<Difficulty> onSelected;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How hard is it?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: DifficultyLevel.values.map((d) {
              final difficulty = Difficulty.values.byName(d.name);
              return SQChip(
                label: '${d.label} (${d.multiplier}x)',
                color: d.color,
                isSelected: selected == difficulty,
                onTap: () => onSelected(difficulty),
              );
            }).toList(),
          ),
        ],
      );
}

class _ProofStep extends StatelessWidget {
  const _ProofStep({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final ProofType selected;
  final ValueChanged<ProofType> onSelected;

  static const _labels = {
    ProofType.photo: 'Photo',
    ProofType.video: 'Video',
    ProofType.photoOrVideo: 'Photo or Video',
    ProofType.beforeAfter: 'Before & After',
  };

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How will you prove it?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: ProofType.values.map((p) => SQChip(
                label: _labels[p]!,
                color: AppColors.sunsetOrange,
                isSelected: selected == p,
                onTap: () => onSelected(p),
              ),).toList(),
          ),
        ],
      );
}
