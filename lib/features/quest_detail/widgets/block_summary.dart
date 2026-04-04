import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/block_config.dart';

/// Read-only visual summary of all configured blocks on a quest.
///
/// Renders each block type with its emoji, label, and configured value.
class BlockSummary extends StatelessWidget {
  /// Creates a [BlockSummary].
  const BlockSummary({required this.blocks, super.key});

  /// The quest blocks to display.
  final QuestBlocks blocks;

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Quest Details', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: _BlockRow(
              emoji: item.emoji,
              label: item.label,
              value: item.value,
            ),
          ),
        ),
      ],
    );
  }

  List<_BlockItem> _buildItems() {
    final items = <_BlockItem>[
      _BlockItem('📸', 'Proof', blocks.proof.type.name),
    ];

    if (blocks.location != null) {
      items.add(_BlockItem(
        '📍',
        'Location',
        blocks.location!.value ?? blocks.location!.type.name,
      ),);
    }
    if (blocks.people != null) {
      final p = blocks.people!;
      final detail = p.minCount != null ? '${p.type.name} (${p.minCount}+)' : p.type.name;
      items.add(_BlockItem('👥', 'People', detail));
    }
    if (blocks.time != null) {
      items.add(_BlockItem(
        '⏱️',
        'Time',
        blocks.time!.value ?? blocks.time!.type.name,
      ),);
    }
    if (blocks.stages != null) {
      items.add(_BlockItem(
        '🪜',
        'Stages',
        '${blocks.stages!.items.length} stages',
      ),);
    }
    if (blocks.wildcard != null) {
      items.add(_BlockItem(
        '🎲',
        'Wildcard',
        '${blocks.wildcard!.options.length} options',
      ),);
    }
    if (blocks.prompt != null) {
      items.add(_BlockItem('💬', 'Prompt', blocks.prompt!.question));
    }
    if (blocks.chain != null) {
      final c = blocks.chain!;
      final detail = c.seriesIndex != null
          ? 'Part ${c.seriesIndex} of ${c.seriesTotal}'
          : 'Has prerequisite';
      items.add(_BlockItem('🔗', 'Chain', detail));
    }
    if (blocks.bonus != null) {
      items.add(_BlockItem(
        '🏅',
        'Bonus',
        '${blocks.bonus!.condition} (+${blocks.bonus!.xpBonus} XP)',
      ),);
    }
    if (blocks.constraint != null) {
      items.add(_BlockItem('🚫', 'Constraint', blocks.constraint!.text));
    }
    if (blocks.repeat != null) {
      items.add(_BlockItem('🔄', 'Repeat', blocks.repeat!.type.name));
    }
    if (blocks.intentBlock != null) {
      items.add(_BlockItem(
        '🎭',
        'Intent',
        blocks.intentBlock!.intents.join(', '),
      ),);
    }

    return items;
  }
}

class _BlockItem {
  const _BlockItem(this.emoji, this.label, this.value);
  final String emoji;
  final String label;
  final String value;
}

class _BlockRow extends StatelessWidget {
  const _BlockRow({
    required this.emoji,
    required this.label,
    required this.value,
  });

  final String emoji;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.softGray,
                      ),
                ),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      );
}
