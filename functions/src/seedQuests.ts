import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as fs from 'fs';
import * as path from 'path';

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

/**
 * Callable function to seed the quest library.
 * Only runs if the quests collection is empty or has < 10 seed quests.
 * Batch-writes all seed quests attributed to @SideQuest official account.
 */
export const seedQuests = functions.https.onCall(async () => {
  // Check if already seeded
  const existing = await db.collection('quests')
    .where('type', '==', 'seed')
    .limit(10)
    .get();

  if (existing.docs.length >= 10) {
    return { status: 'already_seeded', count: existing.docs.length };
  }

  // Load seed data from JSON file
  const seedPath = path.join(__dirname, '..', 'seed_quests.json');
  let seedData: any[];

  try {
    const raw = fs.readFileSync(seedPath, 'utf8');
    seedData = JSON.parse(raw);
  } catch {
    return { status: 'error', message: 'seed_quests.json not found' };
  }

  // Batch write (Firestore limit: 500 per batch)
  let count = 0;
  let batch = db.batch();

  for (const quest of seedData) {
    const ref = db.collection('quests').doc();
    batch.set(ref, {
      ...quest,
      creatorId: 'sidequest_official',
      type: 'seed',
      visibility: 'public',
      addedCount: 0,
      completedCount: 0,
      worthItCount: 0,
      needsWorkCount: 0,
      reportCount: 0,
      isHidden: false,
      createdAt: admin.firestore.Timestamp.now(),
      updatedAt: admin.firestore.Timestamp.now(),
    });

    count++;
    if (count % 500 === 0) {
      await batch.commit();
      batch = db.batch();
    }
  }

  if (count % 500 !== 0) {
    await batch.commit();
  }

  return { status: 'seeded', count };
});
