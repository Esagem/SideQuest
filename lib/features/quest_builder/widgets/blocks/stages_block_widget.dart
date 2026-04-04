import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/proof_block.dart';
import 'package:sidequest/models/blocks/stages_block.dart';

/// Content widget for configuring multi-stage quests.
///
/// Displays a list of stage items, each with a title, optional description,
/// proof-required toggle, proof type selector, and XP input. Requires a
/// minimum of 2 stages. Calls [onConfigChanged] with a [StagesBlock]
/// whenever the stage list changes.
class StagesBlockWidget extends StatefulWidget {
  /// Creates a [StagesBlockWidget].
  const StagesBlockWidget({
    required this.onConfigChanged,
    super.key,
  });

  /// Called with a [StagesBlock] when the configuration changes.
  final ValueChanged<dynamic> onConfigChanged;

  @override
  State<StagesBlockWidget> createState() => _StagesBlockWidgetState();
}

class _StagesBlockWidgetState extends State<StagesBlockWidget> {
  final List<_StageEntry> _stages = [];

  @override
  void initState() {
    super.initState();
    _addStage();
    _addStage();
  }

  /// Adds a new empty stage entry.
  void _addStage() {
    final entry = _StageEntry(
      titleController: TextEditingController(),
      descriptionController: TextEditingController(),
      xpController: TextEditingController(),
    );
    entry.titleController.addListener(_emitConfig);
    entry.descriptionController.addListener(_emitConfig);
    entry.xpController.addListener(_emitConfig);
    setState(() => _stages.add(entry));
  }

  /// Removes the stage at [index] if above the minimum of 2.
  void _removeStage(int index) {
    if (_stages.length <= 2) return;
    setState(() => _stages.removeAt(index).dispose());
    _emitConfig();
  }

  /// Emits the current configuration to the parent.
  void _emitConfig() {
    final items = <StageItem>[];
    for (var i = 0; i < _stages.length; i++) {
      final entry = _stages[i];
      items.add(StageItem(
        id: 'stage_$i',
        title: entry.titleController.text,
        description: entry.descriptionController.text.isNotEmpty
            ? entry.descriptionController.text
            : null,
        proofRequired: entry.proofRequired,
        proofType: entry.proofRequired ? entry.proofType : null,
        xp: int.tryParse(entry.xpController.text) ?? 0,
      ),);
    }
    widget.onConfigChanged(StagesBlock(items: items));
  }

  @override
  void dispose() {
    for (final entry in _stages) {
      entry.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < _stages.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.md),
            _StageTile(
              index: i,
              entry: _stages[i],
              canRemove: _stages.length > 2,
              onRemove: () => _removeStage(i),
              onProofToggled: (value) {
                setState(() => _stages[i].proofRequired = value);
                _emitConfig();
              },
              onProofTypeSelected: (type) {
                setState(() => _stages[i].proofType = type);
                _emitConfig();
              },
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SQButton.tertiary(
            label: 'Add Stage',
            icon: Icons.add,
            onPressed: () {
              _addStage();
              _emitConfig();
            },
          ),
        ],
      );
}

/// Internal mutable state holder for a single stage entry.
class _StageEntry {
  _StageEntry({
    required this.titleController,
    required this.descriptionController,
    required this.xpController,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController xpController;
  bool proofRequired = false;
  ProofType proofType = ProofType.photo;

  /// Disposes all controllers owned by this entry.
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    xpController.dispose();
  }
}

/// A single stage tile with title, description, proof toggle, and XP fields.
class _StageTile extends StatelessWidget {
  const _StageTile({
    required this.index,
    required this.entry,
    required this.canRemove,
    required this.onRemove,
    required this.onProofToggled,
    required this.onProofTypeSelected,
  });

  final int index;
  final _StageEntry entry;
  final bool canRemove;
  final VoidCallback onRemove;
  final ValueChanged<bool> onProofToggled;
  final ValueChanged<ProofType> onProofTypeSelected;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: const BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: AppRadius.smallRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Stage ${index + 1}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                if (canRemove)
                  GestureDetector(
                    onTap: onRemove,
                    child: const Icon(
                      Icons.close,
                      size: AppSpacing.lg - 4,
                      color: AppColors.softGray,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            SQInput(
              label: 'Title',
              hint: 'Stage title',
              controller: entry.titleController,
            ),
            const SizedBox(height: AppSpacing.xs),
            SQInput(
              label: 'Description (optional)',
              hint: 'Stage description',
              controller: entry.descriptionController,
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Text(
                  'Proof required',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Switch(
                  value: entry.proofRequired,
                  onChanged: onProofToggled,
                  activeColor: AppColors.oceanTeal,
                ),
              ],
            ),
            if (entry.proofRequired) ...[
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                children: ProofType.values
                    .map((type) => SQChip(
                          label: type.name,
                          color: AppColors.oceanTeal,
                          isSelected: entry.proofType == type,
                          onTap: () => onProofTypeSelected(type),
                        ),)
                    .toList(),
              ),
            ],
            const SizedBox(height: AppSpacing.xs),
            SQInput(
              label: 'XP',
              hint: '0',
              controller: entry.xpController,
            ),
          ],
        ),
      );
}
