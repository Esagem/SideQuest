import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/components/sq_toast.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/models/report_model.dart';

/// Screen for reporting a quest, proof, or user.
///
/// Shows reason selection chips, optional details input, and submit.
class ReportScreen extends ConsumerStatefulWidget {
  /// Creates a [ReportScreen].
  const ReportScreen({
    required this.targetType,
    required this.targetId,
    super.key,
  });

  /// The type of content being reported (quest, proof, user).
  final String targetType;

  /// The ID of the content being reported.
  final String targetId;

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  ReportReason? _selectedReason;
  final _detailsController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  static const _reasonLabels = {
    ReportReason.dangerous: 'Dangerous',
    ReportReason.inappropriate: 'Inappropriate',
    ReportReason.spam: 'Spam',
    ReportReason.harassment: 'Harassment',
    ReportReason.other: 'Other',
  };

  Future<void> _submit() async {
    if (_selectedReason == null) {
      SQToast.error(context, 'Please select a reason.');
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      // TODO(moderation): Submit via ReportRepository.create()
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        SQToast.success(
          context,
          "Thanks for reporting. We'll review this within 24 hours.",
        );
        context.pop();
      }
    } on Exception catch (e) {
      if (mounted) SQToast.error(context, 'Failed to submit: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Report')),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Why are you reporting this ${widget.targetType}?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: _reasonLabels.entries
                    .map((e) => SQChip(
                          label: e.value,
                          color: AppColors.emberRed,
                          isSelected: _selectedReason == e.key,
                          onTap: () =>
                              setState(() => _selectedReason = e.key),
                        ),)
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
              SQInput(
                label: 'Additional details (optional)',
                hint: 'Tell us more about the issue...',
                controller: _detailsController,
                maxLines: 4,
                maxLength: 500,
              ),
              const Spacer(),
              SQButton.destructive(
                label: 'Submit Report',
                onPressed: _isSubmitting ? null : _submit,
                isLoading: _isSubmitting,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      );
}
