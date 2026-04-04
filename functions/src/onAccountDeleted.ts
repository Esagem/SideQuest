import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

/**
 * Handles user account deletion.
 * Sets creatorId to "deleted" on quests, holds username for 30 days.
 */
export const onAccountDeleted = functions.firestore
  .document('users/{userId}')
  .onDelete(async (snap, context) => {
    const { userId } = context.params;
    const userData = snap.data();

    // Set creatorId to "deleted" on all quests
    const questsSnap = await db.collection('quests')
      .where('creatorId', '==', userId)
      .get();
    const batch = db.batch();
    for (const doc of questsSnap.docs) {
      batch.update(doc.ref, { creatorId: 'deleted' });
    }

    // Hold username for 30 days
    if (userData.username) {
      batch.set(db.collection('deletedUsernames').doc(userData.username), {
        deletedAt: admin.firestore.Timestamp.now(),
        expiresAt: admin.firestore.Timestamp.fromDate(
          new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
        ),
      });
    }

    await batch.commit();
  });
