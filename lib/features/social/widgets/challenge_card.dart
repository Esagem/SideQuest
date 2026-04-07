import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_avatar.dart';
import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_card.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/challenge_model.dart';

/// A card showing an incoming or outgoing challenge.
///
/// For pending incoming challenges, shows Accept/Decline buttons.
/// For accepted challenges, shows "Challenge from {sender}" label.
/// For completed challenges, shows completion badge.
class ChallengeCard extends StatelessWidget {
  /// Creates a [ChallengeCard].
  const ChallengeCard({
    required this.challenge,
    required this.senderName,
    required this.questTitle,
    this.senderAvatarUrl,
    this.isIncoming = true,
    this.onAccept,
    this.onDecline,
    this.onTap,
    super.key,
  });

  /// The challenge data.
  final ChallengeModel challenge;

  /// The sender's display name.
  final String senderName;

  /// The quest title.
  final String questTitle;

  /// The sender's avatar URL.
  final String? senderAvatarUrl;

  /// Whether this is an incoming challenge (vs outgoing).
  final bool isIncoming;

  /// Called when the challenge is accepted.
  final VoidCallback? onAccept;

  /// Called when the challenge is declined.
  final VoidCallback? onDecline;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SQCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.bolt,
                  color: AppColors.sunsetOrange,
                  size: AppSpacing.lg,
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    isIncoming ? 'Challenge from' : 'Challenge sent to',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.softGray,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            // Sender info
            Row(
              children: [
                SQAvatar(
                  displayName: senderName,
                  imageUrl: senderAvatarUrl,
                  size: AppSpacing.xl,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        senderName,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        questTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Message
            if (challenge.message != null &&
                challenge.message!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                '"${challenge.message}"',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
            // Status / Actions
            const SizedBox(height: AppSpacing.sm),
            _StatusRow(
              status: challenge.status,
              isIncoming: isIncoming,
              onAccept: onAccept,
              onDecline: onDecline,
            ),
          ],
        ),
      );
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.status,
    required this.isIncoming,
    this.onAccept,
    this.onDecline,
  });

  final ChallengeStatus status;
  final bool isIncoming;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  @override
  Widget build(BuildContext context) => switch (status) {
        ChallengeStatus.pending when isIncoming => Row(
            children: [
              Expanded(
                child: SQButton.primary(
                  label: 'Accept',
                  onPressed: onAccept,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: SQButton.tertiary(
                  label: 'Decline',
                  onPressed: onDecline,
                ),
              ),
            ],
          ),
        ChallengeStatus.pending => Text(
            'Waiting for response...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.softGray,
                ),
          ),
        ChallengeStatus.accepted => Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.oceanTeal,
                size: AppSpacing.lg,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Flexible(
                child: Text(
                  'Accepted — quest in progress!',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.oceanTeal,
                      ),
                ),
              ),
            ],
          ),
        ChallengeStatus.completed => Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: AppColors.warmYellow,
                size: AppSpacing.lg,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Flexible(
                child: Text(
                  'Completed! +25 XP earned',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.warmYellow,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ChallengeStatus.declined => Text(
            'Declined',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.softGray,
                ),
          ),
      };
}
