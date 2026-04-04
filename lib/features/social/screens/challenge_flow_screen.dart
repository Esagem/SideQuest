import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_toast.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/social/widgets/challenge_message_input.dart';

/// Screen for sending a quest challenge to a friend.
///
/// Shows friend selection list, optional message input, and send button.
class ChallengeFlowScreen extends ConsumerStatefulWidget {
  /// Creates a [ChallengeFlowScreen].
  const ChallengeFlowScreen({required this.questId, super.key});

  /// The quest ID to challenge friends with.
  final String questId;

  @override
  ConsumerState<ChallengeFlowScreen> createState() =>
      _ChallengeFlowScreenState();
}

class _ChallengeFlowScreenState extends ConsumerState<ChallengeFlowScreen> {
  final _messageController = TextEditingController();
  String? _selectedFriendId;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendChallenge() {
    if (_selectedFriendId == null) {
      SQToast.error(context, 'Select a friend first.');
      return;
    }
    // TODO(social): Send via ChallengeRepository
    SQToast.success(context, 'Challenge sent!');
    context.pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Challenge a Friend')),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pick a friend to challenge:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              // Friend list placeholder
              Expanded(
                child: Center(
                  child: Text(
                    'Your friends will appear here.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              ChallengeMessageInput(controller: _messageController),
              const SizedBox(height: AppSpacing.md),
              SQButton.primary(
                label: 'Send Challenge ⚡',
                onPressed: _sendChallenge,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      );
}
