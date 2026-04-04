import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/stages_block.dart';
import 'package:sidequest/models/user_quest_model.dart';

/// A vertical stepper showing stage completion progress.
///
/// Completed stages show a teal checkmark and optional proof thumbnail.
/// The active stage shows an orange circle with a "Complete" button.
/// Locked stages are dimmed.
class StageProgressTracker extends StatelessWidget {
  /// Creates a [StageProgressTracker].
  const StageProgressTracker({
    required this.stages,
    required this.progress,
    this.onCompleteStage,
    this.onViewProof,
    super.key,
  });

  /// The stage definitions from the quest.
  final List<StageItem> stages;

  /// The user's progress for each stage.
  final List<StageProgress> progress;

  /// Called when the active stage's "Complete" button is tapped.
  final void Function(String stageId)? onCompleteStage;

  /// Called when a completed stage's proof is tapped.
  final void Function(String stageId)? onViewProof;

  StageStatus _statusFor(String stageId) {
    for (final p in progress) {
      if (p.stageId == stageId) return p.status;
    }
    return StageStatus.locked;
  }

  String? _proofUrlFor(String stageId) {
    for (final p in progress) {
      if (p.stageId == stageId) return p.proofUrl;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Stages', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < stages.length; i++) ...[
            _StageTile(
              stage: stages[i],
              status: _statusFor(stages[i].id),
              proofUrl: _proofUrlFor(stages[i].id),
              isLast: i == stages.length - 1,
              onComplete: onCompleteStage != null
                  ? () => onCompleteStage!(stages[i].id)
                  : null,
              onViewProof: onViewProof != null
                  ? () => onViewProof!(stages[i].id)
                  : null,
            ),
          ],
        ],
      );
}

class _StageTile extends StatelessWidget {
  const _StageTile({
    required this.stage,
    required this.status,
    required this.isLast,
    this.proofUrl,
    this.onComplete,
    this.onViewProof,
  });

  final StageItem stage;
  final StageStatus status;
  final bool isLast;
  final String? proofUrl;
  final VoidCallback? onComplete;
  final VoidCallback? onViewProof;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicator column
            Column(
              children: [
                _StageCircle(status: status),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: status == StageStatus.completed
                          ? AppColors.oceanTeal
                          : AppColors.lightGray,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stage.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: status == StageStatus.locked
                                ? AppColors.softGray
                                : null,
                          ),
                    ),
                    if (stage.description != null)
                      Text(
                        stage.description!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    Text(
                      '${stage.xp} XP',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    if (status == StageStatus.active && onComplete != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      SizedBox(
                        height: AppSpacing.xl,
                        child: ElevatedButton(
                          onPressed: onComplete,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.sunsetOrange,
                            foregroundColor: AppColors.white,
                          ),
                          child: const Text('Complete Stage'),
                        ),
                      ),
                    ],
                    if (status == StageStatus.completed &&
                        proofUrl != null &&
                        onViewProof != null)
                      GestureDetector(
                        onTap: onViewProof,
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            'View proof',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.oceanTeal,
                                    ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _StageCircle extends StatelessWidget {
  const _StageCircle({required this.status});

  final StageStatus status;

  @override
  Widget build(BuildContext context) {
    const size = AppSpacing.lg;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: switch (status) {
          StageStatus.completed => AppColors.oceanTeal,
          StageStatus.active => AppColors.sunsetOrange,
          StageStatus.locked => AppColors.lightGray,
        },
      ),
      child: status == StageStatus.completed
          ? const Icon(Icons.check, color: AppColors.white, size: AppSpacing.md)
          : null,
    );
  }
}
