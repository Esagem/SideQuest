import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/components/sq_ad_banner.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/core/utils/pro_gate.dart';
import 'package:sidequest/features/settings/screens/paywall_screen.dart';
import 'package:sidequest/services/ad_service.dart';
import 'package:sidequest/services/subscription_service.dart';

void main() {
  group('AdService', () {
    late AdService adService;

    setUp(() => adService = AdService());

    test('shouldShowAds returns true for free users', () {
      expect(adService.shouldShowAds(isPro: false), isTrue);
    });

    test('shouldShowAds returns false for Pro users', () {
      expect(adService.shouldShowAds(isPro: true), isFalse);
    });

    test('recordCompletion triggers interstitial every 5th', () {
      for (var i = 1; i < 5; i++) {
        expect(adService.recordCompletion(isPro: false), isFalse);
      }
      expect(adService.recordCompletion(isPro: false), isTrue);
    });

    test('recordCompletion never triggers for Pro', () {
      for (var i = 0; i < 10; i++) {
        expect(adService.recordCompletion(isPro: true), isFalse);
      }
    });

    test('recordCompletion triggers again at 10th', () {
      for (var i = 0; i < 9; i++) {
        adService.recordCompletion(isPro: false);
      }
      expect(adService.recordCompletion(isPro: false), isTrue);
    });

    test('resetCounter resets the count', () {
      for (var i = 0; i < 3; i++) {
        adService.recordCompletion(isPro: false);
      }
      adService.resetCounter();
      expect(adService.completionCount, 0);
    });
  });

  group('SQAdBanner', () {
    Widget wrap({bool isPro = false}) => MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(body: SQAdBanner(isPro: isPro)),
        );

    testWidgets('shows ad placeholder for free users', (tester) async {
      await tester.pumpWidget(wrap());
      expect(find.text('Ad Placeholder'), findsOneWidget);
    });

    testWidgets('hidden for Pro users', (tester) async {
      await tester.pumpWidget(wrap(isPro: true));
      expect(find.text('Ad Placeholder'), findsNothing);
    });
  });

  group('ProGate', () {
    test('video proof gated for free users', () {
      expect(ProGate.canUseVideoProof(isPro: false), isFalse);
      expect(ProGate.canUseVideoProof(isPro: true), isTrue);
    });

    test('premium templates gated for free users', () {
      expect(ProGate.canUsePremiumTemplates(isPro: false), isFalse);
      expect(ProGate.canUsePremiumTemplates(isPro: true), isTrue);
    });

    test('streak freeze count differs by tier', () {
      expect(ProGate.streakFreezeCount(isPro: false), 1);
      expect(ProGate.streakFreezeCount(isPro: true), 3);
    });

    test('ad-free for Pro', () {
      expect(ProGate.isAdFree(isPro: false), isFalse);
      expect(ProGate.isAdFree(isPro: true), isTrue);
    });
  });

  group('SubscriptionService', () {
    test('has correct pricing strings', () {
      expect(SubscriptionService.monthlyPrice, r'$4.99/month');
      expect(SubscriptionService.annualPrice, r'$39.99/year');
    });

    test('has 5 Pro benefits', () {
      expect(SubscriptionService.proBenefits, hasLength(5));
    });
  });

  group('PaywallScreen', () {
    testWidgets('renders Pro benefits', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: PaywallScreen(
          onPurchaseMonthly: () {},
          onPurchaseAnnual: () {},
          onRestore: () {},
        ),
      ),);
      expect(find.text('Upgrade to Pro'), findsOneWidget);
      expect(find.text('Ad-free experience'), findsOneWidget);
      expect(find.text('Video proof submissions'), findsOneWidget);
    });

    testWidgets('renders pricing buttons', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: PaywallScreen(
          onPurchaseMonthly: () {},
          onPurchaseAnnual: () {},
          onRestore: () {},
        ),
      ),);
      expect(find.textContaining(r'$4.99'), findsOneWidget);
      expect(find.textContaining(r'$39.99'), findsOneWidget);
    });

    testWidgets('has restore purchases button', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: PaywallScreen(
          onPurchaseMonthly: () {},
          onPurchaseAnnual: () {},
          onRestore: () {},
        ),
      ),);
      expect(find.text('Restore Purchases'), findsOneWidget);
    });
  });
}
