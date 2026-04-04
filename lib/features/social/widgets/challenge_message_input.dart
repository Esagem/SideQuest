import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// An input field for composing a message with a quest challenge.
class ChallengeMessageInput extends StatelessWidget {
  /// Creates a [ChallengeMessageInput].
  const ChallengeMessageInput({
    required this.controller,
    super.key,
  });

  /// Controller for reading the message text.
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add a message (optional)',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          SQInput(
            hint: 'I dare you to try this!',
            controller: controller,
            maxLines: 2,
            maxLength: 200,
          ),
        ],
      );
}
