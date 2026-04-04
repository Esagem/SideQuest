import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service for sharing quest completion cards to social platforms.
///
/// Provides platform-specific sharing via URL schemes and fallback
/// to the system share sheet via share_plus.
abstract final class ShareService {
  /// Shares an image to Instagram Stories via URL scheme.
  static Future<void> shareToInstagramStory(String imagePath) async {
    final uri = Uri.parse(
      'instagram-stories://share?backgroundImage=$imagePath',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      await _fallbackShare(imagePath, 'Check out my SideQuest!');
    }
  }

  /// Shares an image to Snapchat via Creative Kit or fallback.
  static Future<void> shareToSnapchat(String imagePath) async {
    // Snap Creative Kit requires native SDK — fall back to share sheet
    await _fallbackShare(imagePath, 'Check out my SideQuest!');
  }

  /// Shares an image to TikTok via share API or fallback.
  static Future<void> shareToTikTok(String imagePath) async {
    // TikTok share API requires native SDK — fall back to share sheet
    await _fallbackShare(imagePath, 'Check out my SideQuest!');
  }

  /// Shares to X/Twitter with pre-composed text and URL.
  static Future<void> shareToTwitter({
    required String imagePath,
    required String text,
    String? url,
  }) async {
    final fullText = url != null ? '$text\n$url' : text;
    await Share.shareXFiles(
      [XFile(imagePath)],
      text: fullText,
    );
  }

  /// Copies a quest deep link to the clipboard.
  static Future<void> copyLink(String questId) async {
    final link = 'https://sidequestapp.com/quest/$questId';
    await Clipboard.setData(ClipboardData(text: link));
  }

  /// Opens the system share sheet with the image and optional text.
  static Future<void> shareGeneric({
    required String imagePath,
    String? text,
  }) =>
      Share.shareXFiles([XFile(imagePath)], text: text);

  static Future<void> _fallbackShare(String imagePath, String text) =>
      Share.shareXFiles([XFile(imagePath)], text: text);
}
