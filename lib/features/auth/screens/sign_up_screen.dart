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

/// Sign-up screen with email/password, social auth, and age gate.
class SignUpScreen extends ConsumerStatefulWidget {
  /// Creates a [SignUpScreen].
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime? _dateOfBirth;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isUnder13 {
    if (_dateOfBirth == null) return false;
    final now = DateTime.now();
    final age = now.year - _dateOfBirth!.year;
    final monthDiff = now.month - _dateOfBirth!.month;
    final dayDiff = now.day - _dateOfBirth!.day;
    return age < 13 || (age == 13 && (monthDiff < 0 || (monthDiff == 0 && dayDiff < 0)));
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null) {
      SQToast.error(context, 'Please select your date of birth.');
      return;
    }
    if (_isUnder13) {
      SQToast.error(context, 'You must be 13 or older to use SideQuest.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signUp(
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

  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
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

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Create Account')),
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
                      validator: _validateEmail,
                    ),
                    SQInput(
                      label: 'Password',
                      hint: 'At least 8 characters',
                      controller: _passwordController,
                      validator: _validatePassword,
                      obscureText: true,
                    ),
                    SQInput(
                      label: 'Confirm Password',
                      hint: 'Re-enter password',
                      controller: _confirmPasswordController,
                      validator: _validateConfirmPassword,
                      obscureText: true,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton(
                  onPressed: _pickDateOfBirth,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(AppSpacing.xxl),
                  ),
                  child: Text(
                    _dateOfBirth != null
                        ? 'Born: ${_dateOfBirth!.month}/${_dateOfBirth!.day}/${_dateOfBirth!.year}'
                        : 'Select Date of Birth',
                  ),
                ),
                if (_dateOfBirth != null && _isUnder13) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'You must be 13 or older to use SideQuest.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.emberRed,
                        ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                SQButton.primary(
                  label: 'Create Account',
                  onPressed: _isLoading ? null : _signUp,
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
