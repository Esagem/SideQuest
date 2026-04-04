import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/components/sq_badge_icon.dart';
import 'package:sidequest/core/theme/app_theme.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: child),
      );

  testWidgets('renders known badge', (tester) async {
    await tester.pumpWidget(wrap(
      const SQBadgeIcon(badgeId: 'first_quest'),
    ),);
    expect(find.byIcon(Icons.flag_rounded), findsOneWidget);
  });

  testWidgets('renders fallback for unknown badge', (tester) async {
    await tester.pumpWidget(wrap(
      const SQBadgeIcon(badgeId: 'nonexistent'),
    ),);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
  });

  testWidgets('respects custom size', (tester) async {
    await tester.pumpWidget(wrap(
      const SQBadgeIcon(badgeId: 'explorer', size: 64),
    ),);
    expect(find.byType(SQBadgeIcon), findsOneWidget);
  });
}
