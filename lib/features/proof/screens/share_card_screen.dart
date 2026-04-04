import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// Screen for sharing a quest completion card to social media.
///
/// Shows a preview of the share card and platform sharing buttons.
class ShareCardScreen extends StatelessWidget {
  /// Creates a [ShareCardScreen].
  const ShareCardScreen({required this.userQuestId, super.key});

  /// The user quest document ID.
  final String userQuestId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Share Your Quest')),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              // Share card preview placeholder
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                  ),
                  child: const Center(
                    child: Text('Share Card Preview'),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Share buttons
              SQButton.primary(
                label: 'Share to Instagram',
                icon: Icons.camera_alt,
                onPressed: () {
                  // TODO(share): Implement platform sharing
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              SQButton.secondary(
                label: 'Share to Snapchat',
                icon: Icons.chat_bubble,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.sm),
              SQButton.tertiary(
                label: 'Copy Link',
                icon: Icons.link,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      );
}
