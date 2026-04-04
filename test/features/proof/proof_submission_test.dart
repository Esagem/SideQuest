import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/proof/screens/proof_submission_screen.dart';
import 'package:sidequest/models/blocks/proof_block.dart';

Widget _wrap(ProofSubmissionScreen screen) => ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: screen,
      ),
    );

void main() {
  group('ProofSubmissionScreen', () {
    testWidgets('renders photo proof type label', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProofSubmissionScreen(userQuestId: 'uq1'),
      ),);
      expect(find.textContaining('Take a photo'), findsOneWidget);
    });

    testWidgets('renders video proof type label', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProofSubmissionScreen(
          userQuestId: 'uq1',
          proofType: ProofType.video,
        ),
      ),);
      expect(find.textContaining('Record a video'), findsOneWidget);
    });

    testWidgets('renders before & after labels', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProofSubmissionScreen(
          userQuestId: 'uq1',
          proofType: ProofType.beforeAfter,
        ),
      ),);
      expect(find.text('Before'), findsOneWidget);
      expect(find.text('After'), findsOneWidget);
    });

    testWidgets('shows Pro gate for video when not Pro', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProofSubmissionScreen(
          userQuestId: 'uq1',
          proofType: ProofType.video,
        ),
      ),);
      expect(find.text('Video proof is a Pro feature'), findsOneWidget);
    });

    testWidgets('submit button disabled without photo', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProofSubmissionScreen(userQuestId: 'uq1'),
      ),);
      // Button renders but should be disabled (onPressed null)
      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton).last,
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('shows prompt question when provided', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProofSubmissionScreen(
          userQuestId: 'uq1',
          promptQuestion: 'How did it feel?',
        ),
      ),);
      expect(find.text('How did it feel?'), findsOneWidget);
    });

    testWidgets('shows quest title', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProofSubmissionScreen(
          userQuestId: 'uq1',
          questTitle: 'Climb Everest',
        ),
      ),);
      expect(find.text('Climb Everest'), findsOneWidget);
    });

    testWidgets('shows stage title in app bar when staged', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProofSubmissionScreen(
          userQuestId: 'uq1',
          stageTitle: 'Stage 1: Plan Route',
        ),
      ),);
      expect(find.text('Stage 1: Plan Route'), findsOneWidget);
    });

    testWidgets('shows caption and external URL inputs', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProofSubmissionScreen(userQuestId: 'uq1'),
      ),);
      expect(find.text('Caption (optional)'), findsOneWidget);
      expect(find.text('External Link (optional)'), findsOneWidget);
    });

    testWidgets('camera and gallery buttons shown', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProofSubmissionScreen(userQuestId: 'uq1'),
      ),);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      expect(find.byIcon(Icons.photo_library), findsOneWidget);
    });
  });
}
