import 'package:flutter/foundation.dart';

import 'package:sidequest/repositories/user_repository.dart';

/// Subscription tier offerings.
enum SubscriptionTier {
  /// Free tier — ads, 1 streak freeze, no video proof.
  free,

  /// Pro monthly — $4.99/month.
  proMonthly,

  /// Pro annual — $39.99/year.
  proAnnual,
}

/// Service for managing RevenueCat subscriptions.
///
/// Handles subscription state, purchase flow, restore, and
/// updating the user's isPro flag in Firestore.
class SubscriptionService {
  /// Creates a [SubscriptionService].
  SubscriptionService(this._userRepository);

  final UserRepository _userRepository;

  /// Monthly price display string.
  static const String monthlyPrice = r'$4.99/month';

  /// Annual price display string.
  static const String annualPrice = r'$39.99/year';

  /// Pro benefits list for the paywall.
  static const List<String> proBenefits = [
    'Ad-free experience',
    'Video proof submissions',
    'Premium share card templates',
    '3 streak freezes per month (vs 1)',
    'Pro badge on your profile',
  ];

  /// Initiates a subscription purchase.
  ///
  /// In production this would call RevenueCat's purchase API.
  /// Returns true if the purchase succeeded.
  Future<bool> purchase({
    required String userId,
    required SubscriptionTier tier,
  }) async {
    // TODO(subscriptions): Implement with purchases_flutter
    debugPrint('SubscriptionService: purchase $tier for $userId');
    await _updateProStatus(userId, isPro: true);
    return true;
  }

  /// Restores previous purchases.
  ///
  /// Returns true if a Pro subscription was found and restored.
  Future<bool> restorePurchases({required String userId}) async {
    // TODO(subscriptions): Implement with purchases_flutter
    debugPrint('SubscriptionService: restore for $userId');
    return false;
  }

  /// Checks the current subscription status.
  ///
  /// Returns true if the user has an active Pro subscription.
  Future<bool> checkStatus({required String userId}) async =>
      // TODO(subscriptions): Check with RevenueCat
      false;

  Future<void> _updateProStatus(String userId, {required bool isPro}) =>
      _userRepository.update(userId, {'isPro': isPro});
}
