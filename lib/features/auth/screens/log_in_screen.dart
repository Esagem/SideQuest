import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/components/sq_toast.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/auth/widgets/auth_form.dart';
import 'package:sidequest/features/auth/widgets/social_auth_button.dart';
import 'package:sidequest/providers/auth_providers.dart';

/// Log-in screen with email/password and social auth options.
class LogInScreen extends ConsumerStatefulWidget {
  /// Creates a [LogInScreen].
  const LogInScreen({super.key});

  @override
  ConsumerState<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _logIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      if (mounted) context.go('/');
    } on Exception catch (e) {
      if (mounted) SQToast.error(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      SQToast.error(context, 'Enter your email first.');
      return;
    }
    try {
      await ref.read(authRepositoryProvider).sendPasswordReset(email: email);
      if (mounted) {
        SQToast.success(context, 'Password reset email sent.');
      }
    } on Exception catch (e) {
      if (mounted) SQToast.error(context, e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      if (mounted) context.go('/');
    } on Exception catch (e) {
      if (mounted) SQToast.error(context, e.toString());
    }
  }

  Future<void> _signInWithApple() async {
    try {
      await ref.read(authRepositoryProvider).signInWithApple();
      if (mounted) context.go('/');
    } on Exception catch (e) {
      if (mounted) SQToast.error(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Log In')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthForm(
                  formKey: _formKey,
                  children: [
                    SQInput(
                      label: 'Email',
                      hint: 'your@email.com',
                      controller: _emailController,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Email is required' : null,
                    ),
                    SQInput(
                      label: 'Password',
                      hint: 'Your password',
                      controller: _passwordController,
                      validator: (v) => v == null || v.isEmpty
                          ? 'Password is required'
                          : null,
                      obscureText: true,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: Text(
                      'Forgot password?',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.sunsetOrange,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SQButton.primary(
                  label: 'Log In',
                  onPressed: _isLoading ? null : _logIn,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Text(
                        'or',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SocialAuthButton.google(onPressed: _signInWithGoogle),
                const SizedBox(height: AppSpacing.sm),
                SocialAuthButton.apple(onPressed: _signInWithApple),
              ],
            ),
          ),
        ),
      );
}
