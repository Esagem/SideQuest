import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/onboarding/screens/category_picker_screen.dart';
import 'package:sidequest/features/onboarding/screens/intent_picker_screen.dart';
import 'package:sidequest/features/onboarding/screens/starter_quests_screen.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.lightTheme,
      home: child,
    );

void main() {
  group('IntentPickerScreen', () {
    testWidgets('renders headline', (tester) async {
      await tester.pumpWidget(_wrap(const IntentPickerScreen()));
      expect(find.text('What drives you?'), findsOneWidget);
    });

    testWidgets('renders visible intent cards', (tester) async {
      await tester.pumpWidget(_wrap(const IntentPickerScreen()));
      // First 4 visible on test surface (2x2 grid)
      expect(find.text('Growth'), findsOneWidget);
      expect(find.text('Connection'), findsOneWidget);
      expect(find.text('Fun'), findsOneWidget);
      expect(find.text('Challenge'), findsOneWidget);
    });

    testWidgets('shows minimum selection hint', (tester) async {
      await tester.pumpWidget(_wrap(const IntentPickerScreen()));
      expect(find.text('Pick at least 2'), findsOneWidget);
    });

    testWidgets('Continue button exists', (tester) async {
      await tester.pumpWidget(_wrap(const IntentPickerScreen()));
      expect(find.text('Continue'), findsOneWidget);
    });
  });

  group('CategoryPickerScreen', () {
    testWidgets('renders headline', (tester) async {
      await tester.pumpWidget(_wrap(const CategoryPickerScreen()));
      expect(find.text('Pick your playgrounds'), findsOneWidget);
    });

    testWidgets('renders all 8 category chips', (tester) async {
      await tester.pumpWidget(_wrap(const CategoryPickerScreen()));
      expect(find.text('Travel & Adventure'), findsOneWidget);
      expect(find.text('Food & Drink'), findsOneWidget);
      expect(find.text('Fitness & Sports'), findsOneWidget);
      expect(find.text('Creative & Arts'), findsOneWidget);
      expect(find.text('Social & Community'), findsOneWidget);
      expect(find.text('Career & Learning'), findsOneWidget);
      expect(find.text('Thrill & Adrenaline'), findsOneWidget);
      expect(find.text('Random / Wildcard'), findsOneWidget);
    });

    testWidgets('shows minimum hint', (tester) async {
      await tester.pumpWidget(_wrap(const CategoryPickerScreen()));
      expect(find.text('Choose at least 3 categories'), findsOneWidget);
    });
  });

  group('StarterQuestsScreen', () {
    testWidgets('renders headline', (tester) async {
      await tester.pumpWidget(_wrap(const StarterQuestsScreen()));
      expect(find.text('Here are your first quests'), findsOneWidget);
    });

    testWidgets('shows 3 starter quest cards', (tester) async {
      await tester.pumpWidget(_wrap(const StarterQuestsScreen()));
      expect(
        find.text("Visit a place you've never been"),
        findsOneWidget,
      );
      expect(
        find.text("Try a cuisine you've never tasted"),
        findsOneWidget,
      );
    });

    testWidgets('shows checkmarks on quest cards', (tester) async {
      await tester.pumpWidget(_wrap(const StarterQuestsScreen()));
      expect(find.byIcon(Icons.check_circle), findsWidgets);
    });

    testWidgets("has Let's Go button", (tester) async {
      await tester.pumpWidget(_wrap(const StarterQuestsScreen()));
      expect(find.text("Let's Go!"), findsOneWidget);
    });
  });
}
