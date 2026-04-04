import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_avatar.dart';
import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_card.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A card showing a pending friend request with accept/decline actions.
class FriendRequestCard extends StatelessWidget {
  /// Creates a [FriendRequestCard].
  const FriendRequestCard({
    required this.displayName,
    required this.username,
    required this.onAccept,
    required this.onDecline,
    this.avatarUrl,
    super.key,
  });

  /// The requester's display name.
  final String displayName;

  /// The requester's username.
  final String username;

  /// The requester's avatar URL.
  final String? avatarUrl;

  /// Called when the request is accepted.
  final VoidCallback onAccept;

  /// Called when the request is declined.
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) => SQCard(
        child: Row(
          children: [
            SQAvatar(
              displayName: displayName,
              imageUrl: avatarUrl,
              size: AppSpacing.xxl,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '@$username',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: AppSpacing.xxl * 1.8,
              child: SQButton.primary(
                label: 'Accept',
                onPressed: onAccept,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            SizedBox(
              width: AppSpacing.xxl * 1.8,
              child: SQButton.tertiary(
                label: 'Decline',
                onPressed: onDecline,
              ),
            ),
          ],
        ),
      );
}
