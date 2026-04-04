import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sidequest/features/auth/screens/log_in_screen.dart';
import 'package:sidequest/features/auth/screens/sign_up_screen.dart';
import 'package:sidequest/features/auth/screens/welcome_screen.dart';
import 'package:sidequest/features/home/screens/home_screen.dart';
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
            builder: (_, __) => const _PlaceholderScreen(title: 'Explore'),
          ),
          GoRoute(
            path: '/activity',
            builder: (_, __) => const _PlaceholderScreen(title: 'Activity'),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const _PlaceholderScreen(title: 'Profile'),
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
        builder: (_, state) => _PlaceholderScreen(
          title: 'Quest ${state.pathParameters['questId']}',
        ),
      ),

      // Settings
      GoRoute(
        path: '/settings',
        builder: (_, __) => const _PlaceholderScreen(title: 'Settings'),
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
