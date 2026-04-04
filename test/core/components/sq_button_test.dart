import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/components/sq_button.dart';
import 'package:sidequest/core/theme/app_theme.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: child),
      );

  group('SQButton.primary', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(wrap(
        SQButton.primary(label: 'Go', onPressed: () {}),
      ),);
      expect(find.text('Go'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(
        SQButton.primary(label: 'Go', onPressed: () => tapped = true),
      ),);
      await tester.tap(find.text('Go'));
      expect(tapped, isTrue);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(wrap(
        const SQButton.primary(label: 'Go'),
      ),);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows loading indicator', (tester) async {
      await tester.pumpWidget(wrap(
        SQButton.primary(label: 'Go', onPressed: () {}, isLoading: true),
      ),);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Go'), findsNothing);
    });

    testWidgets('shows icon when provided', (tester) async {
      await tester.pumpWidget(wrap(
        SQButton.primary(label: 'Go', icon: Icons.bolt, onPressed: () {}),
      ),);
      expect(find.byIcon(Icons.bolt), findsOneWidget);
      expect(find.text('Go'), findsOneWidget);
    });
  });

  group('SQButton.secondary', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(wrap(
        SQButton.secondary(label: 'Challenge', onPressed: () {}),
      ),);
      expect(find.text('Challenge'), findsOneWidget);
    });
  });

  group('SQButton.tertiary', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(wrap(
        SQButton.tertiary(label: 'Cancel', onPressed: () {}),
      ),);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });

  group('SQButton.destructive', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(wrap(
        SQButton.destructive(label: 'Delete', onPressed: () {}),
      ),);
      expect(find.text('Delete'), findsOneWidget);
    });
  });

  group('dark theme', () {
    testWidgets('renders in dark theme without errors', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: SQButton.primary(label: 'Dark', onPressed: () {}),
        ),
      ),);
      expect(find.text('Dark'), findsOneWidget);
    });
  });
}
