import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/components/sq_toast.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/features/proof/widgets/platform_share_row.dart';
import 'package:sidequest/features/proof/widgets/share_card_canvas.dart';
import 'package:sidequest/services/deep_link_service.dart';
import 'package:sidequest/services/share_service.dart';

/// Screen for sharing a quest completion card to social media.
///
/// Shows the auto-generated share card preview, platform share buttons,
/// and format toggles. Displayed immediately after proof submission.
class ShareCardScreen extends StatefulWidget {
  /// Creates a [ShareCardScreen].
  const ShareCardScreen({required this.userQuestId, super.key});

  /// The user quest document ID.
  final String userQuestId;

  @override
  State<ShareCardScreen> createState() => _ShareCardScreenState();
}

class _ShareCardScreenState extends State<ShareCardScreen> {
  final _repaintKey = GlobalKey();
  var _format = ShareCardFormat.story;

  // TODO(share): Load actual quest data from provider
  ShareCardData get _data => ShareCardData(
        questTitle: 'Quest Completed!',
        category: 'travel',
        difficulty: 'Hard',
        xpEarned: 200,
        intentEmojis: const ['🌱', '💪'],
        tier: 'Explorer',
        streakCount: 7,
        questId: widget.userQuestId,
      );

  Future<void> _shareToPlaftorm(
    Future<void> Function(String) shareFn,
  ) async {
    try {
      final path = await ShareCardCanvas.capture(_repaintKey);
      await shareFn(path);
    } on Exception catch (e) {
      if (mounted) SQToast.error(context, 'Share failed: $e');
    }
  }

  Future<void> _copyLink() async {
    await ShareService.copyLink(widget.userQuestId);
    if (mounted) SQToast.success(context, 'Link copied!');
  }

  Future<void> _saveToGallery() async {
    try {
      await ShareCardCanvas.capture(_repaintKey);
      if (mounted) SQToast.success(context, 'Saved to camera roll!');
    } on Exception catch (e) {
      if (mounted) SQToast.error(context, 'Save failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Share Your Quest'),
          actions: [
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text('Done'),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              // Format toggle
              _FormatToggle(
                selected: _format,
                onChanged: (f) => setState(() => _format = f),
              ),
              const SizedBox(height: AppSpacing.md),
              // Share card preview
              Expanded(
                child: Center(
                  child: ShareCardCanvas(
                    data: _data,
                    repaintKey: _repaintKey,
                    format: _format,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Platform share row
              PlatformShareRow(
                onInstagram: () => _shareToPlaftorm(
                  ShareService.shareToInstagramStory,
                ),
                onSnapchat: () => _shareToPlaftorm(
                  ShareService.shareToSnapchat,
                ),
                onTikTok: () => _shareToPlaftorm(
                  ShareService.shareToTikTok,
                ),
                onTwitter: () => _shareToPlaftorm(
                  (path) => ShareService.shareToTwitter(
                    imagePath: path,
                    text: 'Just completed a quest on SideQuest!',
                    url: DeepLinkService.questLink(widget.userQuestId),
                  ),
                ),
                onCopyLink: _copyLink,
                onMore: () => _shareToPlaftorm(
                  (path) => ShareService.shareGeneric(
                    imagePath: path,
                    text: 'Check out my SideQuest completion!',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Save to gallery
              SQButton.tertiary(
                label: 'Save to Camera Roll',
                icon: Icons.save_alt,
                onPressed: _saveToGallery,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      );
}

class _FormatToggle extends StatelessWidget {
  const _FormatToggle({required this.selected, required this.onChanged});

  final ShareCardFormat selected;
  final ValueChanged<ShareCardFormat> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ShareCardFormat.values.map((f) {
          final isSelected = f == selected;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
            child: ChoiceChip(
              label: Text(_label(f)),
              selected: isSelected,
              onSelected: (_) => onChanged(f),
            ),
          );
        }).toList(),
      );

  String _label(ShareCardFormat f) => switch (f) {
        ShareCardFormat.story => '9:16',
        ShareCardFormat.square => '1:1',
        ShareCardFormat.landscape => '16:9',
      };
}
