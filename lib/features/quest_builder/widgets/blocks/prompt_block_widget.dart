import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/models/blocks/prompt_block.dart';

/// Content widget for entering a reflection prompt question.
class PromptBlockWidget extends StatefulWidget {
  /// Creates a [PromptBlockWidget].
  const PromptBlockWidget({required this.onConfigChanged, super.key});

  /// Called with a [PromptBlock] when the question changes.
  final ValueChanged<dynamic> onConfigChanged;

  @override
  State<PromptBlockWidget> createState() => _PromptBlockWidgetState();
}

class _PromptBlockWidgetState extends State<PromptBlockWidget> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () => widget.onConfigChanged(PromptBlock(question: _controller.text)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SQInput(
        label: 'Reflection Question',
        hint: 'What question should be answered?',
        controller: _controller,
        maxLines: 3,
      );
}
