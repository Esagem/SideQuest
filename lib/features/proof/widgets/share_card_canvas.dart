import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_radius.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/core/theme/app_typography.dart';

/// The format variant for a share card.
enum ShareCardFormat {
  /// 9:16 story format — proof fills background, text overlaid at bottom.
  story,

  /// 1:1 square format — proof top half, info bottom half.
  square,

  /// 16:9 landscape — proof left, info right.
  landscape,
}

/// Data needed to render a share card.
class ShareCardData {
  /// Creates a [ShareCardData].
  const ShareCardData({
    required this.questTitle,
    required this.category,
    this.proofImageFile,
    this.difficulty,
    this.xpEarned,
    this.intentEmojis = const [],
    this.tier,
    this.streakCount,
    this.questId,
  });

  /// The quest title.
  final String questTitle;

  /// Category key for accent color.
  final String category;

  /// The proof photo file.
  final File? proofImageFile;

  /// Difficulty label.
  final String? difficulty;

  /// XP earned for this completion.
  final int? xpEarned;

  /// Intent emojis to display.
  final List<String> intentEmojis;

  /// User's tier label.
  final String? tier;

  /// User's current streak count.
  final int? streakCount;

  /// Quest ID for the QR code deep link.
  final String? questId;
}

/// A composited share card built with [RepaintBoundary] for capture.
///
/// Renders the proof photo, quest info, QR code, and SideQuest branding.
/// Use [ShareCardCanvas.capture] to export as an image file.
class ShareCardCanvas extends StatelessWidget {
  /// Creates a [ShareCardCanvas].
  const ShareCardCanvas({
    required this.data,
    required this.repaintKey,
    this.format = ShareCardFormat.story,
    super.key,
  });

  /// The share card data.
  final ShareCardData data;

  /// The [GlobalKey] for the [RepaintBoundary], used for capture.
  final GlobalKey repaintKey;

  /// The format variant.
  final ShareCardFormat format;

  /// Captures the share card as a PNG image file.
  ///
  /// Returns the file path of the saved image.
  static Future<String> capture(GlobalKey key) async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/share_card_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes);
    return file.path;
  }

  double get _aspectRatio => switch (format) {
        ShareCardFormat.story => 9 / 16,
        ShareCardFormat.square => 1,
        ShareCardFormat.landscape => 16 / 9,
      };

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.categoryColor(data.category);

    return RepaintBoundary(
      key: repaintKey,
      child: AspectRatio(
        aspectRatio: _aspectRatio,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: AppRadius.cardRadius,
          ),
          child: switch (format) {
            ShareCardFormat.story => _StoryLayout(data: data, accent: accentColor),
            ShareCardFormat.square => _SquareLayout(data: data, accent: accentColor),
            ShareCardFormat.landscape => _LandscapeLayout(data: data, accent: accentColor),
          },
        ),
      ),
    );
  }
}

/// 9:16 story — proof fills background, text overlaid at bottom.
class _StoryLayout extends StatelessWidget {
  const _StoryLayout({required this.data, required this.accent});

  final ShareCardData data;
  final Color accent;

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          if (data.proofImageFile != null)
            Image.file(data.proofImageFile!, fit: BoxFit.cover),
          // Gradient overlay at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    accent.withAlpha(230),
                  ],
                ),
              ),
              child: _InfoOverlay(data: data),
            ),
          ),
        ],
      );
}

/// 1:1 square — proof top half, info bottom half.
class _SquareLayout extends StatelessWidget {
  const _SquareLayout({required this.data, required this.accent});

  final ShareCardData data;
  final Color accent;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: data.proofImageFile != null
                ? Image.file(data.proofImageFile!, fit: BoxFit.cover, width: double.infinity)
                : ColoredBox(
                    color: accent.withAlpha(128),
                    child: const Center(
                      child: Icon(Icons.image, color: AppColors.white, size: AppSpacing.xxl),
                    ),
                  ),
          ),
          Container(
            color: accent,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _InfoOverlay(data: data),
          ),
        ],
      );
}

/// 16:9 landscape — proof left, info right.
class _LandscapeLayout extends StatelessWidget {
  const _LandscapeLayout({required this.data, required this.accent});

  final ShareCardData data;
  final Color accent;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: data.proofImageFile != null
                ? Image.file(data.proofImageFile!, fit: BoxFit.cover, height: double.infinity)
                : ColoredBox(
                    color: accent.withAlpha(128),
                    child: const Center(
                      child: Icon(Icons.image, color: AppColors.white, size: AppSpacing.xxl),
                    ),
                  ),
          ),
          Expanded(
            child: Container(
              color: accent,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _InfoOverlay(data: data),
            ),
          ),
        ],
      );
}

/// The text info overlay shared across all formats.
class _InfoOverlay extends StatelessWidget {
  const _InfoOverlay({required this.data});

  final ShareCardData data;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quest title
          Text(
            data.questTitle,
            style: AppTypography.cardTitle.copyWith(color: AppColors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          // Stats row
          Row(
            children: [
              if (data.difficulty != null)
                _Pill(data.difficulty!),
              if (data.xpEarned != null) ...[
                const SizedBox(width: AppSpacing.xxs),
                _Pill('+${data.xpEarned} XP'),
              ],
              ...data.intentEmojis.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.xxs),
                  child: Text(e, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // User info + branding row
          Row(
            children: [
              if (data.tier != null)
                Text(
                  data.tier!,
                  style: AppTypography.caption.copyWith(color: AppColors.white),
                ),
              if (data.streakCount != null && data.streakCount! > 0) ...[
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '🔥 ${data.streakCount}',
                  style: AppTypography.caption.copyWith(color: AppColors.white),
                ),
              ],
              const Spacer(),
              // QR code
              if (data.questId != null)
                SizedBox(
                  width: AppSpacing.xxl,
                  height: AppSpacing.xxl,
                  child: QrImageView(
                    data: 'https://sidequestapp.com/quest/${data.questId}',
                    eyeStyle: const QrEyeStyle(color: AppColors.white),
                    dataModuleStyle:
                        const QrDataModuleStyle(color: AppColors.white),
                    padding: EdgeInsets.zero,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          // SideQuest branding
          Text(
            'SideQuest',
            style: AppTypography.overline.copyWith(color: AppColors.white),
          ),
        ],
      );
}

class _Pill extends StatelessWidget {
  const _Pill(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: AppColors.white.withAlpha(51),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Text(
          text,
          style: AppTypography.caption.copyWith(color: AppColors.white),
        ),
      );
}
