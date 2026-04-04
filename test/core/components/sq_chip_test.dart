import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/components/sq_chip.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_theme.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: child),
      );

  testWidgets('renders label', (tester) async {
    await tester.pumpWidget(wrap(
      const SQChip(label: 'Travel', color: AppColors.oceanTeal),
    ),);
    expect(find.text('Travel'), findsOneWidget);
  });

  testWidgets('responds to tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(wrap(
      SQChip(
        label: 'Tap',
        color: AppColors.oceanTeal,
        onTap: () => tapped = true,
      ),
    ),);
    await tester.tap(find.text('Tap'));
    expect(tapped, isTrue);
  });

  testWidgets('selected state renders', (tester) async {
    await tester.pumpWidget(wrap(
      const SQChip(
        label: 'Active',
        color: AppColors.sunsetOrange,
        isSelected: true,
      ),
    ),);
    expect(find.text('Active'), findsOneWidget);
  });

  testWidgets('unselected state renders', (tester) async {
    await tester.pumpWidget(wrap(
      const SQChip(label: 'Idle', color: AppColors.sunsetOrange),
    ),);
    expect(find.text('Idle'), findsOneWidget);
  });
}
