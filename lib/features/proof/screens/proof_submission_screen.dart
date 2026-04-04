import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_input.dart';
import 'package:sidequest/core/components/sq_toast.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/proof/widgets/camera_capture.dart';
import 'package:sidequest/features/proof/widgets/prompt_answer_input.dart';
import 'package:sidequest/models/blocks/proof_block.dart';

/// Proof submission screen for completing a quest or stage.
///
/// Shows the required proof type, capture UI, caption input,
/// optional prompt answer, and a submit button. Handles Before & After
/// and Video proof types as special cases.
class ProofSubmissionScreen extends ConsumerStatefulWidget {
  /// Creates a [ProofSubmissionScreen].
  const ProofSubmissionScreen({
    required this.userQuestId,
    this.questTitle = '',
    this.proofType = ProofType.photo,
    this.promptQuestion,
    this.stageTitle,
    this.isPro = false,
    super.key,
  });

  /// The user quest document ID.
  final String userQuestId;

  /// The quest title for display.
  final String questTitle;

  /// The required proof type.
  final ProofType proofType;

  /// The reflection prompt question, if any.
  final String? promptQuestion;

  /// The stage title if this is a staged quest completion.
  final String? stageTitle;

  /// Whether the user has Pro access (enables video).
  final bool isPro;

  @override
  ConsumerState<ProofSubmissionScreen> createState() =>
      _ProofSubmissionScreenState();
}

class _ProofSubmissionScreenState
    extends ConsumerState<ProofSubmissionScreen> {
  File? _primaryImage;
  File? _secondaryImage; // For Before & After
  final _captionController = TextEditingController();
  final _promptController = TextEditingController();
  final _externalUrlController = TextEditingController();
  bool _isUploading = false;
  double _uploadProgress = 0;

  @override
  void dispose() {
    _captionController.dispose();
    _promptController.dispose();
    _externalUrlController.dispose();
    super.dispose();
  }

  bool get _isBeforeAfter => widget.proofType == ProofType.beforeAfter;
  bool get _isVideo => widget.proofType == ProofType.video;

  bool get _canSubmit {
    if (_isUploading) return false;
    if (_isVideo && !widget.isPro) return false;

    // Photo proof required
    if (!_isVideo && _primaryImage == null) return false;

    // Before & After requires both
    if (_isBeforeAfter && _secondaryImage == null) return false;

    // Prompt answer required if prompt exists
    if (widget.promptQuestion != null &&
        _promptController.text.trim().isEmpty) {
      return false;
    }

    return true;
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });

    try {
      // TODO(proof): Upload via StorageService, update UserQuest
      await Future<void>.delayed(const Duration(seconds: 1));

      if (mounted) {
        SQToast.success(context, 'Proof submitted!');
        context.pushReplacement('/share/${widget.userQuestId}');
      }
    } on Exception catch (e) {
      if (mounted) SQToast.error(context, 'Upload failed: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.stageTitle ?? 'Submit Proof'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Quest title
              if (widget.questTitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Text(
                    widget.questTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),

              // Proof type label
              _ProofTypeLabel(proofType: widget.proofType),
              const SizedBox(height: AppSpacing.md),

              // Video Pro gate
              if (_isVideo && !widget.isPro) ...[
                _ProGateMessage(),
              ] else if (_isVideo) ...[
                // TODO(proof): Video capture widget
                const Text('Video capture — Pro feature'),
              ] else ...[
                // Photo capture
                CameraCapture(
                  label: _isBeforeAfter ? 'Before' : null,
                  imageFile: _primaryImage,
                  onImagePicked: (f) => setState(() => _primaryImage = f),
                ),
                if (_isBeforeAfter) ...[
                  const SizedBox(height: AppSpacing.sm),
                  CameraCapture(
                    label: 'After',
                    imageFile: _secondaryImage,
                    onImagePicked: (f) =>
                        setState(() => _secondaryImage = f),
                  ),
                ],
              ],
              const SizedBox(height: AppSpacing.md),

              // External URL
              SQInput(
                label: 'External Link (optional)',
                hint: 'Link an Instagram or TikTok post',
                controller: _externalUrlController,
              ),
              const SizedBox(height: AppSpacing.md),

              // Caption
              SQInput(
                label: 'Caption (optional)',
                hint: 'Tell the story...',
                controller: _captionController,
                maxLines: 3,
                maxLength: 500,
              ),
              const SizedBox(height: AppSpacing.md),

              // Prompt answer
              if (widget.promptQuestion != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: PromptAnswerInput(
                    question: widget.promptQuestion!,
                    controller: _promptController,
                  ),
                ),

              // Upload progress
              if (_isUploading) ...[
                LinearProgressIndicator(
                  value: _uploadProgress,
                  color: AppColors.sunsetOrange,
                  backgroundColor: AppColors.lightGray,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              // Submit
              SQButton.primary(
                label: _isUploading ? 'Uploading...' : 'Submit Proof',
                onPressed: _canSubmit ? _submit : null,
                isLoading: _isUploading,
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      );
}

class _ProofTypeLabel extends StatelessWidget {
  const _ProofTypeLabel({required this.proofType});

  final ProofType proofType;

  String get _label => switch (proofType) {
        ProofType.photo => '📸 Take a photo',
        ProofType.video => '🎬 Record a video',
        ProofType.photoOrVideo => '📸 Photo or 🎬 Video',
        ProofType.beforeAfter => '📸 Before & After photos',
      };

  @override
  Widget build(BuildContext context) => Text(
        _label,
        style: Theme.of(context).textTheme.titleMedium,
      );
}

class _ProGateMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.warmYellow.withAlpha(26),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.star,
              color: AppColors.warmYellow,
              size: AppSpacing.xl,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Video proof is a Pro feature',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Upgrade to SideQuest Pro to submit video proof.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}
