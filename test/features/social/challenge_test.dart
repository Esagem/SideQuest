import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/social/screens/challenge_flow_screen.dart';
import 'package:sidequest/features/social/widgets/challenge_card.dart';
import 'package:sidequest/models/challenge_model.dart';
import 'package:sidequest/repositories/challenge_repository.dart';
import 'package:sidequest/repositories/user_quest_repository.dart';
import 'package:sidequest/services/challenge_service.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

void main() {
  group('ChallengeFlowScreen', () {
    testWidgets('renders Challenge title', (tester) async {
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ChallengeFlowScreen(questId: 'q1'),
        ),
      ),);
      expect(find.text('Challenge a Friend'), findsOneWidget);
    });

    testWidgets('shows progress indicator', (tester) async {
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ChallengeFlowScreen(questId: 'q1'),
        ),
      ),);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('shows friend picker step first', (tester) async {
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ChallengeFlowScreen(questId: 'q1'),
        ),
      ),);
      expect(
        find.text('Who do you want to challenge?'),
        findsOneWidget,
      );
    });
  });

  group('ChallengeCard', () {
    final pendingChallenge = ChallengeModel(
      id: 'c1',
      senderId: 'u1',
      receiverId: 'u2',
      questId: 'q1',
      message: 'I dare you!',
      status: ChallengeStatus.pending,
      createdAt: DateTime(2026),
    );

    final acceptedChallenge = pendingChallenge.copyWith(
      status: ChallengeStatus.accepted,
    );

    final completedChallenge = pendingChallenge.copyWith(
      status: ChallengeStatus.completed,
    );

    final declinedChallenge = pendingChallenge.copyWith(
      status: ChallengeStatus.declined,
    );

    testWidgets('pending incoming shows Accept/Decline', (tester) async {
      await tester.pumpWidget(_wrap(
        ChallengeCard(
          challenge: pendingChallenge,
          senderName: 'Alice',
          questTitle: 'Climb Everest',
          onAccept: () {},
          onDecline: () {},
        ),
      ),);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Climb Everest'), findsOneWidget);
      expect(find.text('"I dare you!"'), findsOneWidget);
      expect(find.text('Accept'), findsOneWidget);
      expect(find.text('Decline'), findsOneWidget);
    });

    testWidgets('pending outgoing shows waiting text', (tester) async {
      await tester.pumpWidget(_wrap(
        ChallengeCard(
          challenge: pendingChallenge,
          senderName: 'Alice',
          questTitle: 'Climb Everest',
          isIncoming: false,
        ),
      ),);
      expect(find.text('Waiting for response...'), findsOneWidget);
    });

    testWidgets('accepted shows in-progress message', (tester) async {
      await tester.pumpWidget(_wrap(
        ChallengeCard(
          challenge: acceptedChallenge,
          senderName: 'Alice',
          questTitle: 'Climb Everest',
        ),
      ),);
      expect(
        find.text('Accepted — quest in progress!'),
        findsOneWidget,
      );
    });

    testWidgets('completed shows XP earned', (tester) async {
      await tester.pumpWidget(_wrap(
        ChallengeCard(
          challenge: completedChallenge,
          senderName: 'Alice',
          questTitle: 'Climb Everest',
        ),
      ),);
      expect(find.text('Completed! +25 XP earned'), findsOneWidget);
    });

    testWidgets('declined shows declined text', (tester) async {
      await tester.pumpWidget(_wrap(
        ChallengeCard(
          challenge: declinedChallenge,
          senderName: 'Alice',
          questTitle: 'Climb Everest',
        ),
      ),);
      expect(find.text('Declined'), findsOneWidget);
    });

    testWidgets('Accept button calls onAccept', (tester) async {
      var accepted = false;
      await tester.pumpWidget(_wrap(
        ChallengeCard(
          challenge: pendingChallenge,
          senderName: 'Alice',
          questTitle: 'Climb Everest',
          onAccept: () => accepted = true,
          onDecline: () {},
        ),
      ),);
      await tester.tap(find.text('Accept'));
      expect(accepted, isTrue);
    });
  });

  group('ChallengeService', () {
    late FakeFirebaseFirestore firestore;
    late ChallengeService service;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      service = ChallengeService(
        challengeRepository: ChallengeRepository(firestore),
        userQuestRepository: UserQuestRepository(firestore),
      );
    });

    test('sendChallenge creates a challenge document', () async {
      final id = await service.sendChallenge(
        senderId: 'u1',
        receiverId: 'u2',
        questId: 'q1',
        message: 'Try this!',
      );
      expect(id, isNotEmpty);

      final doc =
          await firestore.collection('challenges').doc(id).get();
      expect(doc.exists, isTrue);
      expect(doc.data()!['senderId'], 'u1');
      expect(doc.data()!['receiverId'], 'u2');
      expect(doc.data()!['status'], 'pending');
    });

    test('acceptChallenge updates status and adds quest', () async {
      final id = await service.sendChallenge(
        senderId: 'u1',
        receiverId: 'u2',
        questId: 'q1',
      );

      await service.acceptChallenge(
        challengeId: id,
        receiverId: 'u2',
        questId: 'q1',
      );

      final doc =
          await firestore.collection('challenges').doc(id).get();
      expect(doc.data()!['status'], 'accepted');

      // UserQuest should exist
      final uqSnap = await firestore
          .collection('users')
          .doc('u2')
          .collection('quests')
          .get();
      expect(uqSnap.docs, hasLength(1));
      expect(uqSnap.docs.first.data()['questId'], 'q1');
    });

    test('declineChallenge updates status', () async {
      final id = await service.sendChallenge(
        senderId: 'u1',
        receiverId: 'u2',
        questId: 'q1',
      );

      await service.declineChallenge(challengeId: id);

      final doc =
          await firestore.collection('challenges').doc(id).get();
      expect(doc.data()!['status'], 'declined');
    });

    test('completeChallenge updates status', () async {
      final id = await service.sendChallenge(
        senderId: 'u1',
        receiverId: 'u2',
        questId: 'q1',
      );
      await service.acceptChallenge(
        challengeId: id,
        receiverId: 'u2',
        questId: 'q1',
      );

      await service.completeChallenge(challengeId: id);

      final doc =
          await firestore.collection('challenges').doc(id).get();
      expect(doc.data()!['status'], 'completed');
    });
  });
}
