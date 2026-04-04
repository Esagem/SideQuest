import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sidequest/core/theme/app_spacing.dart';

/// The scrollable build area containing placed blocks.
///
/// Uses [ReorderableListView] for drag-and-drop reordering with
/// magnetic snap animation (200ms ease-out) and haptic feedback.
/// Title block at index 0 is not draggable.
class BlockBuildArea extends StatelessWidget {
  /// Creates a [BlockBuildArea].
  const BlockBuildArea({
    required this.children,
    required this.onReorder,
    super.key,
  });

  /// The block card widgets to display.
  final List<Widget> children;

  /// Called when blocks are reordered via drag-and-drop.
  final void Function(int oldIndex, int newIndex) onReorder;

  @override
  Widget build(BuildContext context) => ReorderableListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: children.length,
        onReorder: (oldIndex, newIndex) {
          HapticFeedback.mediumImpact();
          onReorder(oldIndex, newIndex);
        },
        proxyDecorator: _proxyDecorator,
        itemBuilder: (context, index) => Padding(
          key: ValueKey('block_$index'),
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: children[index],
        ),
      );

  /// Applies the drag decoration: slight scale-up + elevated shadow.
  Widget _proxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
  ) =>
      AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final scale = Tween<double>(begin: 1, end: 1.05)
              .animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),);
          return Transform.scale(
            scale: scale.value,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(AppSpacing.md),
              child: child,
            ),
          );
        },
      );
}
