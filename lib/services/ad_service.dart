import 'package:flutter/foundation.dart';

/// Service for managing AdMob ads throughout the app.
///
/// Shows banner ads on Explore and Leaderboard screens, and
/// interstitial ads after every 5th quest completion. All ads
/// are hidden when the user is a Pro subscriber.
class AdService {
  /// Creates an [AdService].
  AdService();

  /// Test banner ad unit ID (Android).
  static const String testBannerAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/6300978111';

  /// Test banner ad unit ID (iOS).
  static const String testBannerAdUnitIdIos =
      'ca-app-pub-3940256099942544/2934735716';

  /// Test interstitial ad unit ID (Android).
  static const String testInterstitialAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/1033173712';

  /// Test interstitial ad unit ID (iOS).
  static const String testInterstitialAdUnitIdIos =
      'ca-app-pub-3940256099942544/4411468910';

  /// Interstitial frequency: show after every N completions.
  static const int interstitialFrequency = 5;

  int _completionCount = 0;

  /// Whether ads should be shown (false for Pro users).
  bool shouldShowAds({required bool isPro}) => !isPro;

  /// Records a quest completion and returns whether to show
  /// an interstitial ad.
  bool recordCompletion({required bool isPro}) {
    if (isPro) return false;
    _completionCount++;
    if (_completionCount % interstitialFrequency == 0) {
      debugPrint('AdService: showing interstitial after $_completionCount completions');
      return true;
    }
    return false;
  }

  /// Resets the completion counter.
  void resetCounter() => _completionCount = 0;

  /// The current completion count (for testing).
  @visibleForTesting
  int get completionCount => _completionCount;
}
