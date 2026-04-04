import 'package:flutter/material.dart';

import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_spacing.dart';
import 'package:sidequest/core/theme/app_typography.dart';
import 'package:sidequest/services/subscription_service.dart';

/// Paywall screen showing Pro subscription benefits and pricing.
class PaywallScreen extends StatelessWidget {
  /// Creates a [PaywallScreen].
  const PaywallScreen({
    required this.onPurchaseMonthly,
    required this.onPurchaseAnnual,
    required this.onRestore,
    super.key,
  });

  /// Called when the user taps the monthly subscription.
  final VoidCallback onPurchaseMonthly;

  /// Called when the user taps the annual subscription.
  final VoidCallback onPurchaseAnnual;

  /// Called when the user taps restore purchases.
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('SideQuest Pro')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Icon(
                Icons.star,
                size: AppSpacing.xxl * 1.5,
                color: AppColors.warmYellow,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Upgrade to Pro',
                style: AppTypography.hero,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              // Benefits list
              ...SubscriptionService.proBenefits.map(
                (benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.oceanTeal,
                        size: AppSpacing.lg,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          benefit,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Pricing
              SQButton.primary(
                label: 'Monthly — ${SubscriptionService.monthlyPrice}',
                onPressed: onPurchaseMonthly,
              ),
              const SizedBox(height: AppSpacing.sm),
              SQButton.secondary(
                label: 'Annual — ${SubscriptionService.annualPrice}',
                onPressed: onPurchaseAnnual,
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: onRestore,
                child: Text(
                  'Restore Purchases',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.softGray,
                      ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      );
}
