import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// Content widget for the title block with title and description inputs.
class TitleBlockWidget extends StatefulWidget {
  /// Creates a [TitleBlockWidget].
  const TitleBlockWidget({
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    super.key,
  });

  /// Called when the title text changes.
  final ValueChanged<String> onTitleChanged;

  /// Called when the description text changes.
  final ValueChanged<String> onDescriptionChanged;

  @override
  State<TitleBlockWidget> createState() => _TitleBlockWidgetState();
}

class _TitleBlockWidgetState extends State<TitleBlockWidget> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => widget.onTitleChanged(_titleController.text));
    _descController.addListener(() => widget.onDescriptionChanged(_descController.text));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SQInput(
            label: 'Quest Title',
            hint: 'What is your quest?',
            controller: _titleController,
            maxLength: 100,
          ),
          const SizedBox(height: AppSpacing.sm),
          SQInput(
            label: 'Description',
            hint: 'Describe the quest...',
            controller: _descController,
            maxLength: 500,
            maxLines: 4,
          ),
        ],
      );
}
