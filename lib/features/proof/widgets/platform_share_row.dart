import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A row of platform-specific share buttons.
///
/// Each platform is shown as a tappable circle with an icon.
class PlatformShareRow extends StatelessWidget {
  /// Creates a [PlatformShareRow].
  const PlatformShareRow({
    required this.onInstagram,
    required this.onSnapchat,
    required this.onTikTok,
    required this.onTwitter,
    required this.onCopyLink,
    required this.onMore,
    super.key,
  });

  /// Called when Instagram is tapped.
  final VoidCallback onInstagram;

  /// Called when Snapchat is tapped.
  final VoidCallback onSnapchat;

  /// Called when TikTok is tapped.
  final VoidCallback onTikTok;

  /// Called when X/Twitter is tapped.
  final VoidCallback onTwitter;

  /// Called when Copy Link is tapped.
  final VoidCallback onCopyLink;

  /// Called when More is tapped.
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _PlatformButton(
            icon: Icons.camera_alt,
            label: 'Instagram',
            color: AppColors.sunsetOrange,
            onTap: onInstagram,
          ),
          _PlatformButton(
            icon: Icons.chat_bubble,
            label: 'Snapchat',
            color: AppColors.warmYellow,
            onTap: onSnapchat,
          ),
          _PlatformButton(
            icon: Icons.music_note,
            label: 'TikTok',
            color: AppColors.navy,
            onTap: onTikTok,
          ),
          _PlatformButton(
            icon: Icons.alternate_email,
            label: 'X',
            color: AppColors.navy,
            onTap: onTwitter,
          ),
          _PlatformButton(
            icon: Icons.link,
            label: 'Copy Link',
            color: AppColors.softGray,
            onTap: onCopyLink,
          ),
          _PlatformButton(
            icon: Icons.more_horiz,
            label: 'More',
            color: AppColors.softGray,
            onTap: onMore,
          ),
        ],
      );
}

class _PlatformButton extends StatelessWidget {
  const _PlatformButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: AppSpacing.lg,
              child: Icon(icon, color: AppColors.white, size: AppSpacing.lg),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      );
}
