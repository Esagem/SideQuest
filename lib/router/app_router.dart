import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sidequest/features/activity/screens/activity_screen.dart';
import 'package:sidequest/features/auth/screens/log_in_screen.dart';
import 'package:sidequest/features/auth/screens/sign_up_screen.dart';
import 'package:sidequest/features/auth/screens/welcome_screen.dart';
import 'package:sidequest/features/explore/screens/explore_screen.dart';
import 'package:sidequest/features/home/screens/home_screen.dart';
import 'package:sidequest/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:sidequest/features/onboarding/screens/category_picker_screen.dart';
import 'package:sidequest/features/onboarding/screens/intent_picker_screen.dart';
import 'package:sidequest/features/onboarding/screens/starter_quests_screen.dart';
import 'package:sidequest/features/profile/screens/friend_profile_screen.dart';
import 'package:sidequest/features/profile/screens/profile_screen.dart';
import 'package:sidequest/features/proof/screens/proof_submission_screen.dart';
import 'package:sidequest/features/proof/screens/share_card_screen.dart';
import 'package:sidequest/features/quest_detail/screens/quest_detail_screen.dart';
import 'package:sidequest/features/settings/screens/moderation_policy_screen.dart';
import 'package:sidequest/features/settings/screens/report_screen.dart';
import 'package:sidequest/features/settings/screens/settings_screen.dart';
import 'package:sidequest/features/social/screens/challenge_flow_screen.dart';
import 'package:sidequest/features/social/screens/friend_search_screen.dart';
import 'package:sidequest/providers/auth_providers.dart';
import 'package:sidequest/router/main_shell.dart';

/// Provides the [GoRouter] instance configured with all routes.
///
/// Uses [authStateProvider] to determine redirect behavior:
/// - Unauthenticated users are redirected to the welcome screen.
/// - Authenticated users on auth pages are redirected home.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isLoggedIn && !isAuthRoute) return '/auth/welcome';
      if (isLoggedIn && isAuthRoute) return '/';
      return null;
    },
    routes: [
      // Auth
      GoRoute(
        path: '/auth/welcome',
        builder: (_, __) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (_, __) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (_, __) => const LogInScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding/intents',
        builder: (_, __) => const IntentPickerScreen(),
      ),
      GoRoute(
        path: '/onboarding/categories',
        builder: (_, __) => const CategoryPickerScreen(),
      ),
      GoRoute(
        path: '/onboarding/starter',
        builder: (_, __) => const StarterQuestsScreen(),
      ),

      // Main Shell (Bottom Nav)
      ShellRoute(
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: '/explore',
            builder: (_, __) => const ExploreScreen(),
          ),
          GoRoute(
            path: '/activity',
            builder: (_, __) => const ActivityScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),

      // Quest Builder (full screen, no bottom nav)
      GoRoute(
        path: '/builder',
        builder: (_, __) => const _PlaceholderScreen(title: 'Quest Builder'),
      ),

      // Quest Detail
      GoRoute(
        path: '/quest/:questId',
        builder: (_, state) => QuestDetailScreen(
          questId: state.pathParameters['questId']!,
        ),
      ),

      // Proof
      GoRoute(
        path: '/proof/:userQuestId',
        builder: (_, state) => ProofSubmissionScreen(
          userQuestId: state.pathParameters['userQuestId']!,
        ),
      ),
      GoRoute(
        path: '/share/:userQuestId',
        builder: (_, state) => ShareCardScreen(
          userQuestId: state.pathParameters['userQuestId']!,
        ),
      ),

      // Friend Profile
      GoRoute(
        path: '/profile/:userId',
        builder: (_, state) => FriendProfileScreen(
          userId: state.pathParameters['userId']!,
        ),
      ),

      // Social
      GoRoute(
        path: '/friends/search',
        builder: (_, __) => const FriendSearchScreen(),
      ),
      GoRoute(
        path: '/challenge/:questId',
        builder: (_, state) => ChallengeFlowScreen(
          questId: state.pathParameters['questId']!,
        ),
      ),

      // Settings
      // Leaderboard
      GoRoute(
        path: '/leaderboard',
        builder: (_, __) => const LeaderboardScreen(),
      ),

      GoRoute(
        path: '/settings',
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/moderation-policy',
        builder: (_, __) => const ModerationPolicyScreen(),
      ),
      GoRoute(
        path: '/report/:targetType/:targetId',
        builder: (_, state) => ReportScreen(
          targetType: state.pathParameters['targetType']!,
          targetId: state.pathParameters['targetId']!,
        ),
      ),
    ],
  );
});

/// Temporary placeholder screen for unimplemented routes.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(child: Text(title)),
      );
}
