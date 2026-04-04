import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/core/theme/app_typography.dart';

/// Age verification screen that rejects users under 13.
///
/// Shows a date picker and validates the user's age. If under 13,
/// displays a rejection message and disables progression.
class AgeGateScreen extends StatefulWidget {
  /// Creates an [AgeGateScreen].
  const AgeGateScreen({
    required this.onVerified,
    super.key,
  });

  /// Called when the user's age is verified as 13+.
  final VoidCallback onVerified;

  @override
  State<AgeGateScreen> createState() => _AgeGateScreenState();
}

class _AgeGateScreenState extends State<AgeGateScreen> {
  DateTime? _selectedDate;

  bool get _isUnder13 {
    if (_selectedDate == null) return false;
    final now = DateTime.now();
    final age = now.year - _selectedDate!.year;
    final monthDiff = now.month - _selectedDate!.month;
    final dayDiff = now.day - _selectedDate!.day;
    return age < 13 ||
        (age == 13 && (monthDiff < 0 || (monthDiff == 0 && dayDiff < 0)));
  }

  bool get _isValid => _selectedDate != null && !_isUnder13;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Verify Your Age')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cake_outlined,
                  size: AppSpacing.xxl * 1.5,
                  color: AppColors.sunsetOrange,
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'When were you born?',
                  style: AppTypography.sectionHeader,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'You must be 13 or older to use SideQuest.',
                  style: AppTypography.caption,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                OutlinedButton(
                  onPressed: _pickDate,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(AppSpacing.xxl),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}'
                        : 'Select Date',
                  ),
                ),
                if (_selectedDate != null && _isUnder13) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.emberRed.withAlpha(26),
                      borderRadius: BorderRadius.circular(AppSpacing.xs),
                    ),
                    child: Text(
                      'Sorry, you must be 13 or older to create a '
                      "SideQuest account. Please come back when you're old enough!",
                      style: AppTypography.body.copyWith(
                        color: AppColors.emberRed,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const Spacer(),
                SQButton.primary(
                  label: 'Continue',
                  onPressed: _isValid ? widget.onVerified : null,
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      );
}

/// Utility to check if a date of birth meets the 13+ age requirement.
bool isAge13OrOlder(DateTime dateOfBirth) {
  final now = DateTime.now();
  final age = now.year - dateOfBirth.year;
  final monthDiff = now.month - dateOfBirth.month;
  final dayDiff = now.day - dateOfBirth.day;
  return age > 13 || (age == 13 && (monthDiff > 0 || (monthDiff == 0 && dayDiff >= 0)));
}
