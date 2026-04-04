import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_toast.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/social/widgets/challenge_message_input.dart';

/// Screen for sending a quest challenge to a friend.
///
/// 3-step flow: select friend → compose message → confirm and send.
/// Quest is pre-selected via the [questId] parameter.
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
  int _step = 0;
  String? _selectedFriendId;
  String _selectedFriendName = '';

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _selectFriend(String id, String name) {
    setState(() {
      _selectedFriendId = id;
      _selectedFriendName = name;
      _step = 1;
    });
  }

  void _sendChallenge() {
    if (_selectedFriendId == null) {
      SQToast.error(context, 'Select a friend first.');
      return;
    }
    // TODO(challenge): Send via ChallengeRepository.send()
    SQToast.success(context, 'Challenge sent to $_selectedFriendName!');
    context.pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Challenge a Friend'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_step > 0) {
                setState(() => _step--);
              } else {
                context.pop();
              }
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress
              LinearProgressIndicator(
                value: (_step + 1) / 2,
                color: AppColors.sunsetOrange,
                backgroundColor: AppColors.lightGray,
              ),
              const SizedBox(height: AppSpacing.lg),
              // Step content
              Expanded(
                child: _step == 0
                    ? _FriendPickerStep(onSelect: _selectFriend)
                    : _MessageStep(
                        friendName: _selectedFriendName,
                        controller: _messageController,
                      ),
              ),
              // Send button
              SQButton.primary(
                label: _step == 0 ? 'Next' : 'Send Challenge ⚡',
                onPressed: _step == 0
                    ? (_selectedFriendId != null
                        ? () => setState(() => _step = 1)
                        : null)
                    : _sendChallenge,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      );
}

/// Step 1: Pick a friend from the user's friends list.
class _FriendPickerStep extends StatelessWidget {
  const _FriendPickerStep({required this.onSelect});

  final void Function(String id, String name) onSelect;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Who do you want to challenge?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          // TODO(challenge): Replace with real friends provider
          Expanded(
            child: Center(
              child: Text(
                'Your friends will appear here.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      );
}

/// Step 2: Optional message and confirmation.
class _MessageStep extends StatelessWidget {
  const _MessageStep({
    required this.friendName,
    required this.controller,
  });

  final String friendName;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Challenge $friendName',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          ChallengeMessageInput(controller: controller),
          const SizedBox(height: AppSpacing.md),
          Text(
            "They'll get a notification and can accept or decline.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.softGray,
                ),
          ),
        ],
      );
}
