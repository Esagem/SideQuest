import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/components/sq_avatar.dart';
import 'package:sidequest/core/theme/app_theme.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: child),
      );

  testWidgets('shows initials when no image', (tester) async {
    await tester.pumpWidget(wrap(
      const SQAvatar(displayName: 'John Doe'),
    ),);
    expect(find.text('JD'), findsOneWidget);
  });

  testWidgets('shows single initial for single name', (tester) async {
    await tester.pumpWidget(wrap(
      const SQAvatar(displayName: 'Alice'),
    ),);
    expect(find.text('A'), findsOneWidget);
  });

  testWidgets('shows tier badge when provided', (tester) async {
    await tester.pumpWidget(wrap(
      const SQAvatar(displayName: 'Jo', tierBadge: 'gold'),
    ),);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
  });

  testWidgets('does not show badge when null', (tester) async {
    await tester.pumpWidget(wrap(
      const SQAvatar(displayName: 'Jo'),
    ),);
    expect(find.byIcon(Icons.star_rounded), findsNothing);
  });
}
