import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/constants/seed_quests.dart';

void main() {
  group('SeedQuests', () {
    test('has at least 100 quests', () {
      expect(SeedQuests.all.length, greaterThanOrEqualTo(100));
    });

    test('every quest has required fields', () {
      for (final quest in SeedQuests.all) {
        expect(quest['title'], isNotNull, reason: 'missing title');
        expect(quest['category'], isNotNull, reason: 'missing category');
        expect(quest['difficulty'], isNotNull, reason: 'missing difficulty');
        expect(quest['intent'], isNotNull, reason: 'missing intent');
        expect(quest['blocks'], isNotNull, reason: 'missing blocks');
        expect(
          (quest['blocks'] as Map)['proof'],
          isNotNull,
          reason: 'missing proof block in ${quest['title']}',
        );
      }
    });

    test('covers all 8 categories', () {
      final categories = SeedQuests.all
          .map((q) => q['category'] as String)
          .toSet();
      expect(categories, containsAll([
        'travel',
        'food',
        'fitness',
        'creative',
        'social',
        'career',
        'thrill',
        'random',
      ]),);
    });

    test('covers all 4 difficulties', () {
      final difficulties = SeedQuests.all
          .map((q) => q['difficulty'] as String)
          .toSet();
      expect(difficulties, containsAll([
        'easy',
        'medium',
        'hard',
        'legendary',
      ]),);
    });

    test('covers all 6 intents', () {
      final allIntents = <String>{};
      for (final quest in SeedQuests.all) {
        final intents = quest['intent'] as List;
        for (final i in intents) {
          allIntents.add(i as String);
        }
      }
      expect(allIntents, containsAll([
        'growth',
        'connection',
        'fun',
        'challenge',
        'explore',
        'create',
      ]),);
    });

    test('all quests attributed to sidequest_official', () {
      for (final quest in SeedQuests.all) {
        expect(
          quest['creatorId'],
          'sidequest_official',
          reason: '${quest['title']} not attributed correctly',
        );
      }
    });

    test('includes Auburn-specific quests', () {
      const keywords = ['auburn', 'toomer', 'tiger', 'samford', 'chewacla', 'lake martin'];
      final auburnCount = SeedQuests.all.where((q) {
        final title = (q['title'] as String).toLowerCase();
        return keywords.any(title.contains);
      }).length;
      expect(auburnCount, greaterThanOrEqualTo(5));
    });
  });
}
