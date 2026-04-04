import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_colors.dart';
import 'package:sidequest/core/theme/app_theme.dart';

void main() {
  group('AppTheme.lightTheme', () {
    late ThemeData theme;

    setUp(() {
      theme = AppTheme.lightTheme;
    });

    test('builds without errors', () {
      expect(theme, isNotNull);
    });

    test('has light brightness', () {
      expect(theme.brightness, Brightness.light);
    });

    test('uses correct scaffold background', () {
      expect(theme.scaffoldBackgroundColor, AppColors.white);
    });

    test('uses correct primary color', () {
      expect(theme.colorScheme.primary, AppColors.sunsetOrange);
    });

    test('uses correct error color', () {
      expect(theme.colorScheme.error, AppColors.emberRed);
    });

    test('configures AppBar with navy background', () {
      expect(theme.appBarTheme.backgroundColor, AppColors.navy);
    });

    test('configures BottomNavigationBar with navy background', () {
      expect(
        theme.bottomNavigationBarTheme.backgroundColor,
        AppColors.navy,
      );
    });
  });

  group('AppTheme.darkTheme', () {
    late ThemeData theme;

    setUp(() {
      theme = AppTheme.darkTheme;
    });

    test('builds without errors', () {
      expect(theme, isNotNull);
    });

    test('has dark brightness', () {
      expect(theme.brightness, Brightness.dark);
    });

    test('uses correct scaffold background', () {
      expect(theme.scaffoldBackgroundColor, AppColors.deepNavy);
    });

    test('uses correct primary color', () {
      expect(theme.colorScheme.primary, AppColors.sunsetOrangeDark);
    });

    test('uses correct error color', () {
      expect(theme.colorScheme.error, AppColors.emberRedDark);
    });

    test('configures AppBar with deep navy background', () {
      expect(theme.appBarTheme.backgroundColor, AppColors.deepNavy);
    });

    test('configures BottomNavigationBar with deep navy background', () {
      expect(
        theme.bottomNavigationBarTheme.backgroundColor,
        AppColors.deepNavy,
      );
    });
  });

  group('themes render in a widget', () {
    testWidgets('light theme renders without errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Center(child: Text('Light')),
          ),
        ),
      );
      expect(find.text('Light'), findsOneWidget);
    });

    testWidgets('dark theme renders without errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Center(child: Text('Dark')),
          ),
        ),
      );
      expect(find.text('Dark'), findsOneWidget);
    });
  });
}
