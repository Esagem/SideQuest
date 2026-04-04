import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// An input field for answering a quest's reflection prompt.
///
/// Shows the prompt question as a label above the text input.
class PromptAnswerInput extends StatelessWidget {
  /// Creates a [PromptAnswerInput].
  const PromptAnswerInput({
    required this.question,
    required this.controller,
    super.key,
  });

  /// The reflection question from the quest's Prompt Block.
  final String question;

  /// Controller for reading the answer text.
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            question,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          SQInput(
            hint: 'Your answer...',
            controller: controller,
            maxLines: 4,
            maxLength: 500,
          ),
        ],
      );
}
