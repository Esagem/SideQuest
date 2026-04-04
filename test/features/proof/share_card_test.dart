import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_theme.dart';
import 'package:sidequest/features/proof/widgets/platform_share_row.dart';
import 'package:sidequest/features/proof/widgets/share_card_canvas.dart';
import 'package:sidequest/services/deep_link_service.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      );

  group('ShareCardCanvas', () {
    testWidgets('renders quest title', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(wrap(
        ShareCardCanvas(
          repaintKey: key,
          data: const ShareCardData(
            questTitle: 'Summit Reached!',
            category: 'travel',
          ),
        ),
      ),);
      expect(find.text('Summit Reached!'), findsOneWidget);
    });

    testWidgets('renders difficulty pill', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(wrap(
        ShareCardCanvas(
          repaintKey: key,
          data: const ShareCardData(
            questTitle: 'Test',
            category: 'travel',
            difficulty: 'Hard',
          ),
        ),
      ),);
      expect(find.text('Hard'), findsOneWidget);
    });

    testWidgets('renders XP earned pill', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(wrap(
        ShareCardCanvas(
          repaintKey: key,
          data: const ShareCardData(
            questTitle: 'Test',
            category: 'travel',
            xpEarned: 200,
          ),
        ),
      ),);
      expect(find.text('+200 XP'), findsOneWidget);
    });

    testWidgets('renders SideQuest branding', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(wrap(
        ShareCardCanvas(
          repaintKey: key,
          data: const ShareCardData(
            questTitle: 'Test',
            category: 'travel',
          ),
        ),
      ),);
      expect(find.text('SideQuest'), findsOneWidget);
    });

    testWidgets('renders intent emojis', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(wrap(
        ShareCardCanvas(
          repaintKey: key,
          data: const ShareCardData(
            questTitle: 'Test',
            category: 'travel',
            intentEmojis: ['🌱', '💪'],
          ),
        ),
      ),);
      expect(find.text('🌱'), findsOneWidget);
      expect(find.text('💪'), findsOneWidget);
    });

    testWidgets('renders streak count', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(wrap(
        ShareCardCanvas(
          repaintKey: key,
          data: const ShareCardData(
            questTitle: 'Test',
            category: 'travel',
            streakCount: 7,
          ),
        ),
      ),);
      expect(find.text('🔥 7'), findsOneWidget);
    });

    testWidgets('square format renders', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(wrap(
        ShareCardCanvas(
          repaintKey: key,
          format: ShareCardFormat.square,
          data: const ShareCardData(
            questTitle: 'Square Test',
            category: 'food',
          ),
        ),
      ),);
      expect(find.text('Square Test'), findsOneWidget);
    });

    testWidgets('landscape format renders', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(wrap(
        ShareCardCanvas(
          repaintKey: key,
          format: ShareCardFormat.landscape,
          data: const ShareCardData(
            questTitle: 'Landscape Test',
            category: 'fitness',
          ),
        ),
      ),);
      expect(find.text('Landscape Test'), findsOneWidget);
    });
  });

  group('PlatformShareRow', () {
    testWidgets('renders all 6 platform buttons', (tester) async {
      await tester.pumpWidget(wrap(
        PlatformShareRow(
          onInstagram: () {},
          onSnapchat: () {},
          onTikTok: () {},
          onTwitter: () {},
          onCopyLink: () {},
          onMore: () {},
        ),
      ),);
      expect(find.text('Instagram'), findsOneWidget);
      expect(find.text('Snapchat'), findsOneWidget);
      expect(find.text('TikTok'), findsOneWidget);
      expect(find.text('X'), findsOneWidget);
      expect(find.text('Copy Link'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);
    });

    testWidgets('tapping Copy Link calls callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(
        PlatformShareRow(
          onInstagram: () {},
          onSnapchat: () {},
          onTikTok: () {},
          onTwitter: () {},
          onCopyLink: () => tapped = true,
          onMore: () {},
        ),
      ),);
      await tester.tap(find.text('Copy Link'));
      expect(tapped, isTrue);
    });
  });

  group('DeepLinkService', () {
    test('generates quest link', () {
      expect(
        DeepLinkService.questLink('q123'),
        'https://sidequestapp.com/quest/q123',
      );
    });

    test('generates profile link', () {
      expect(
        DeepLinkService.profileLink('u456'),
        'https://sidequestapp.com/profile/u456',
      );
    });

    test('parses quest link', () {
      final uri = Uri.parse('https://sidequestapp.com/quest/q123');
      expect(DeepLinkService.parseLink(uri), '/quest/q123');
    });

    test('parses profile link', () {
      final uri = Uri.parse('https://sidequestapp.com/profile/u456');
      expect(DeepLinkService.parseLink(uri), '/profile/u456');
    });

    test('returns null for invalid link', () {
      final uri = Uri.parse('https://sidequestapp.com/invalid');
      expect(DeepLinkService.parseLink(uri), isNull);
    });
  });
}
