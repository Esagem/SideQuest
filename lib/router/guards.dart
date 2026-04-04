/// Navigation guards for the SideQuest router.
///
/// Provides redirect logic for authentication and onboarding state.
abstract final class RouteGuards {
  /// Determines redirect based on auth and onboarding state.
  ///
  /// Returns the redirect path, or null to allow navigation.
  static String? authRedirect({
    required bool isLoggedIn,
    required bool isOnboarded,
    required String currentLocation,
  }) {
    final isAuthRoute = currentLocation.startsWith('/auth');
    final isOnboardingRoute = currentLocation.startsWith('/onboarding');

    // Not logged in and not on an auth page → go to welcome
    if (!isLoggedIn && !isAuthRoute) return '/auth/welcome';

    // Logged in but not onboarded and not on an onboarding page
    if (isLoggedIn && !isOnboarded && !isOnboardingRoute) {
      return '/onboarding/intents';
    }

    // Logged in but trying to visit auth pages → go home
    if (isLoggedIn && isAuthRoute) return '/';

    return null;
  }
}
