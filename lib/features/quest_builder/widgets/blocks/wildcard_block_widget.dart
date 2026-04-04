import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/blocks/wildcard_block.dart';

/// Content widget for configuring wildcard options.
class WildcardBlockWidget extends StatefulWidget {
  /// Creates a [WildcardBlockWidget].
  const WildcardBlockWidget({required this.onConfigChanged, super.key});

  /// Called with a [WildcardBlock] when options change.
  final ValueChanged<dynamic> onConfigChanged;

  @override
  State<WildcardBlockWidget> createState() => _WildcardBlockWidgetState();
}

class _WildcardBlockWidgetState extends State<WildcardBlockWidget> {
  final _options = <TextEditingController>[
    TextEditingController(),
    TextEditingController(),
  ];

  void _addOption() {
    setState(() => _options.add(TextEditingController()..addListener(_emit)));
    _emit();
  }

  void _emit() {
    widget.onConfigChanged(WildcardBlock(
      options: _options.map((c) => c.text).where((t) => t.isNotEmpty).toList(),
    ),);
  }

  @override
  void initState() {
    super.initState();
    for (final c in _options) {
      c.addListener(_emit);
    }
  }

  @override
  void dispose() {
    for (final c in _options) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < _options.length; i++) ...[
            SQInput(
              hint: 'Option ${i + 1}',
              controller: _options[i],
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          SQButton.tertiary(label: 'Add Option', onPressed: _addOption),
        ],
      );
}
