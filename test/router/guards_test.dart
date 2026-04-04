import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/router/guards.dart';

void main() {
  group('RouteGuards.authRedirect', () {
    test('redirects unauthenticated user to welcome', () {
      final result = RouteGuards.authRedirect(
        isLoggedIn: false,
        isOnboarded: false,
        currentLocation: '/',
      );
      expect(result, '/auth/welcome');
    });

    test('allows unauthenticated user on auth pages', () {
      final result = RouteGuards.authRedirect(
        isLoggedIn: false,
        isOnboarded: false,
        currentLocation: '/auth/signup',
      );
      expect(result, isNull);
    });

    test('redirects authenticated user from auth to home', () {
      final result = RouteGuards.authRedirect(
        isLoggedIn: true,
        isOnboarded: true,
        currentLocation: '/auth/welcome',
      );
      expect(result, '/');
    });

    test('redirects authenticated non-onboarded user to onboarding', () {
      final result = RouteGuards.authRedirect(
        isLoggedIn: true,
        isOnboarded: false,
        currentLocation: '/',
      );
      expect(result, '/onboarding/intents');
    });

    test('allows authenticated onboarded user on main routes', () {
      final result = RouteGuards.authRedirect(
        isLoggedIn: true,
        isOnboarded: true,
        currentLocation: '/',
      );
      expect(result, isNull);
    });

    test('allows authenticated user on onboarding pages', () {
      final result = RouteGuards.authRedirect(
        isLoggedIn: true,
        isOnboarded: false,
        currentLocation: '/onboarding/intents',
      );
      expect(result, isNull);
    });
  });
}
