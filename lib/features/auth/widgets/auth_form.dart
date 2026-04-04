import 'package:flutter/material.dart';

import 'package:sidequest/core/theme/app_spacing.dart';

/// A reusable form wrapper with validation support for auth screens.
///
/// Wraps children in a [Form] with a [GlobalKey] and provides
/// a [validate] method to check all fields.
class AuthForm extends StatelessWidget {
  /// Creates an [AuthForm].
  const AuthForm({
    required this.formKey,
    required this.children,
    super.key,
  });

  /// The form key used for validation.
  final GlobalKey<FormState> formKey;

  /// The form field widgets.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1)
                const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      );
}
