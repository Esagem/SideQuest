import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

/**
 * Runs every Monday at 00:00 UTC.
 * Checks all users for streak breaks and consumes freezes.
 */
export const weeklyStreakCheck = functions.pubsub
  .schedule('0 0 * * 1')
  .timeZone('UTC')
  .onRun(async () => {
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    const usersSnap = await db.collection('users')
      .where('currentStreak', '>', 0)
      .get();

    const batch = db.batch();
    const activityWrites: Promise<any>[] = [];

    for (const doc of usersSnap.docs) {
      const user = doc.data();
      const lastCompletion = user.lastCompletionDate?.toDate?.() || null;

      if (lastCompletion && lastCompletion >= sevenDaysAgo) continue;

      if ((user.streakFreezeAvailable || 0) > 0) {
        batch.update(doc.ref, {
          streakFreezeAvailable: admin.firestore.FieldValue.increment(-1),
        });
      } else {
        batch.update(doc.ref, {
          currentStreak: 0,
          updatedAt: admin.firestore.Timestamp.now(),
        });
        activityWrites.push(db.collection('activity').add({
          userId: doc.id,
          type: 'streakMilestone',
          metadata: { event: 'streak_broken', previousStreak: user.currentStreak },
          createdAt: admin.firestore.Timestamp.now(),
        }));
      }
    }

    await batch.commit();
    await Promise.all(activityWrites);
  });
