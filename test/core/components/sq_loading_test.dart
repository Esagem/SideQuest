import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/components/sq_loading.dart';
import 'package:sidequest/core/theme/app_theme.dart';

void main() {
  Widget wrap(Widget child, {bool dark = false}) => MaterialApp(
        theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
        home: Scaffold(body: child),
      );

  testWidgets('spinner renders', (tester) async {
    await tester.pumpWidget(wrap(const SQLoading()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('skeleton renders', (tester) async {
    await tester.pumpWidget(wrap(const SQLoading.skeleton()));
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('spinner renders in dark theme', (tester) async {
    await tester.pumpWidget(wrap(const SQLoading(), dark: true));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('skeleton renders in dark theme', (tester) async {
    await tester.pumpWidget(wrap(const SQLoading.skeleton(), dark: true));
    expect(find.byType(ListView), findsOneWidget);
  });
}
