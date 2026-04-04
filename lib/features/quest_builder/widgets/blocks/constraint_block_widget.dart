import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/models/blocks/constraint_block.dart';

/// Content widget for entering a constraint/restriction.
class ConstraintBlockWidget extends StatefulWidget {
  /// Creates a [ConstraintBlockWidget].
  const ConstraintBlockWidget({required this.onConfigChanged, super.key});

  /// Called with a [ConstraintBlock] when the text changes.
  final ValueChanged<dynamic> onConfigChanged;

  @override
  State<ConstraintBlockWidget> createState() => _ConstraintBlockWidgetState();
}

class _ConstraintBlockWidgetState extends State<ConstraintBlockWidget> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () => widget.onConfigChanged(ConstraintBlock(text: _controller.text)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SQInput(
        label: 'Constraint',
        hint: 'e.g., No phone allowed',
        controller: _controller,
      );
}
