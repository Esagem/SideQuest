import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// Static screen displaying the SideQuest community guidelines
/// and moderation policy.
class ModerationPolicyScreen extends StatelessWidget {
  /// Creates a [ModerationPolicyScreen].
  const ModerationPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Community Guidelines')),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: const [
            _Section(
              title: 'What is SideQuest?',
              body: 'SideQuest is a community for people who want to '
                  'stop scrolling and start doing. We celebrate real-world '
                  'experiences and personal growth.',
            ),
            _Section(
              title: "What's Encouraged",
              body: '• Creative, fun, and challenging quests\n'
                  '• Honest proof of quest completion\n'
                  '• Supportive reactions and constructive feedback\n'
                  '• Challenging friends to try new things',
            ),
            _Section(
              title: "What's Not Allowed",
              body: '• Dangerous activities that could cause harm\n'
                  '• Harassment, bullying, or hate speech\n'
                  '• Spam, scams, or misleading content\n'
                  '• Inappropriate or explicit content\n'
                  '• Impersonation or deceptive accounts',
            ),
            _Section(
              title: 'Consequences',
              body: '• First offense: content removed + warning\n'
                  '• Second offense: temporary account restriction\n'
                  '• Severe or repeated violations: account suspension\n'
                  '• Illegal content: reported to authorities',
            ),
            _Section(
              title: 'Reporting',
              body: 'You can report any quest, proof, or user profile '
                  'using the three-dot menu. Our team reviews all reports '
                  'within 24 hours.',
            ),
            _Section(
              title: 'Contact',
              body: 'Questions or concerns? Reach us at:\n'
                  'support@sidequestapp.com',
            ),
          ],
        ),
      );
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.softGray,
                    height: 1.6,
                  ),
            ),
          ],
        ),
      );
}
