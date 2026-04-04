import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

/**
 * Runs on the 1st of each month at 00:00 UTC.
 * Resets streak freeze count: 1 for free users, 3 for Pro.
 */
export const monthlyStreakFreezeReset = functions.pubsub
  .schedule('0 0 1 * *')
  .timeZone('UTC')
  .onRun(async () => {
    // Reset free users
    const freeSnap = await db.collection('users')
      .where('isPro', '==', false)
      .get();
    const batch1 = db.batch();
    for (const doc of freeSnap.docs) {
      batch1.update(doc.ref, { streakFreezeAvailable: 1 });
    }
    await batch1.commit();

    // Reset Pro users
    const proSnap = await db.collection('users')
      .where('isPro', '==', true)
      .get();
    const batch2 = db.batch();
    for (const doc of proSnap.docs) {
      batch2.update(doc.ref, { streakFreezeAvailable: 3 });
    }
    await batch2.commit();
  });
