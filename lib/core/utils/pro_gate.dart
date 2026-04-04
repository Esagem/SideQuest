/// Utility for checking Pro subscription feature gates.
///
/// All gated features check [isPro] before enabling.
abstract final class ProGate {
  /// Whether video proof is available.
  static bool canUseVideoProof({required bool isPro}) => isPro;

  /// Whether premium share card templates are available.
  static bool canUsePremiumTemplates({required bool isPro}) => isPro;

  /// The number of streak freezes available per month.
  static int streakFreezeCount({required bool isPro}) => isPro ? 3 : 1;

  /// Whether ads should be hidden.
  static bool isAdFree({required bool isPro}) => isPro;
}
