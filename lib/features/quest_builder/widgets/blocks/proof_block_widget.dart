import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/proof_block.dart';

/// Content widget for selecting proof type.
class ProofBlockWidget extends StatefulWidget {
  /// Creates a [ProofBlockWidget].
  const ProofBlockWidget({required this.onConfigChanged, super.key});

  /// Called with a [ProofBlock] when the proof type changes.
  final ValueChanged<dynamic> onConfigChanged;

  @override
  State<ProofBlockWidget> createState() => _ProofBlockWidgetState();
}

class _ProofBlockWidgetState extends State<ProofBlockWidget> {
  ProofType _selected = ProofType.photo;

  static const _labels = {
    ProofType.photo: 'Photo',
    ProofType.video: 'Video',
    ProofType.photoOrVideo: 'Photo or Video',
    ProofType.beforeAfter: 'Before & After',
  };

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: _labels.entries
            .map((e) => SQChip(
                  label: e.value,
                  color: AppColors.sunsetOrange,
                  isSelected: _selected == e.key,
                  onTap: () {
                    setState(() => _selected = e.key);
                    widget.onConfigChanged(ProofBlock(type: e.key));
                  },
                ),)
            .toList(),
      );
}
