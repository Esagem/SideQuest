import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/models/quest_model.dart';

void main() {
  final now = DateTime(2026);
  final json = {
    'id': 'q1',
    'creatorId': 'u1',
    'type': 'public',
    'title': 'Test Quest',
    'description': 'A test.',
    'category': 'travel',
    'tags': <String>[],
    'difficulty': 'medium',
    'visibility': 'public',
    'intent': <String>['growth'],
    'repeatable': false,
    'blocks': {
      'proof': {'type': 'photo'},
    },
    'addedCount': 10,
    'completedCount': 5,
    'worthItCount': 3,
    'needsWorkCount': 1,
    'reportCount': 0,
    'isHidden': false,
    'createdAt': now.toIso8601String(),
    'updatedAt': now.toIso8601String(),
  };

  test('fromJson → toJson round-trip', () {
    final model = QuestModel.fromJson(json);
    // Encode to JSON string and decode back to ensure clean Map types
    final encoded = jsonEncode(model.toJson());
    final decoded = jsonDecode(encoded) as Map<String, dynamic>;
    final roundTrip = QuestModel.fromJson(decoded);
    expect(roundTrip.id, 'q1');
    expect(roundTrip.title, 'Test Quest');
    expect(roundTrip.difficulty, Difficulty.medium);
    expect(roundTrip.blocks.proof.type.name, 'photo');
    expect(roundTrip, model);
  });
}
