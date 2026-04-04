import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_spacing.dart';

/// A debounced search bar for quest title prefix matching.
///
/// Emits search queries after a 300ms debounce. Shows a clear button
/// when text is present.
class QuestSearchBar extends StatefulWidget {
  /// Creates a [QuestSearchBar].
  const QuestSearchBar({
    required this.onSearch,
    required this.onClear,
    super.key,
  });

  /// Called with the search query after debounce.
  final ValueChanged<String> onSearch;

  /// Called when the search is cleared.
  final VoidCallback onClear;

  @override
  State<QuestSearchBar> createState() => _QuestSearchBarState();
}

class _QuestSearchBarState extends State<QuestSearchBar> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.isEmpty) {
      widget.onClear();
      return;
    }
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => widget.onSearch(value),
    );
  }

  void _clear() {
    _controller.clear();
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      decoration: InputDecoration(
        hintText: 'Search quests...',
        prefixIcon: const Icon(Icons.search, color: AppColors.softGray),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close, color: AppColors.softGray),
                onPressed: _clear,
              )
            : null,
        filled: true,
        fillColor: isDark ? AppColors.slate : AppColors.offWhite,
        border: const OutlineInputBorder(
          borderRadius: AppRadius.smallRadius,
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}
