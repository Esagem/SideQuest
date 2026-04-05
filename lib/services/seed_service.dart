import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:sidequest/core/constants/seed_quests.dart';

/// Seeds Firestore with initial quest data for development and first launch.
///
/// Only runs if the quests collection has fewer than 10 documents.
/// Safe to call multiple times — it is idempotent.
class SeedService {
  /// Creates a [SeedService].
  SeedService(this._firestore);

  final FirebaseFirestore _firestore;

  /// Seeds the quests collection if it is empty.
  Future<void> seedIfNeeded() async {
    final snapshot =
        await _firestore.collection('quests').limit(10).get();
    if (snapshot.docs.length >= 10) {
      debugPrint('SeedService: already seeded (${snapshot.docs.length} quests found)');
      return;
    }

    debugPrint('SeedService: seeding ${SeedQuests.all.length} quests...');

    final now = Timestamp.now();
    const batchSize = 500;
    const quests = SeedQuests.all;

    for (var i = 0; i < quests.length; i += batchSize) {
      final batch = _firestore.batch();
      final chunk = quests.sublist(
        i,
        (i + batchSize).clamp(0, quests.length),
      );

      for (final raw in chunk) {
        final doc = _firestore.collection('quests').doc();
        batch.set(doc, {
          ...raw,
          'type': 'seed',
          'visibility': 'public',
          'tags': <String>[],
          'addedCount': 0,
          'completedCount': 0,
          'worthItCount': 0,
          'needsWorkCount': 0,
          'reportCount': 0,
          'isHidden': false,
          'repeatable': false,
          'createdAt': now,
          'updatedAt': now,
        });
      }

      await batch.commit();
      debugPrint('SeedService: committed ${i + chunk.length}/${quests.length}');
    }

    debugPrint('SeedService: seeding complete');
  }
}
