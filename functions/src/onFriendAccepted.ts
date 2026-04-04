import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

/**
 * Increments friendCount on both users when a friendship is accepted.
 */
export const onFriendAccepted = functions.firestore
  .document('friendships/{friendshipId}')
  .onUpdate(async (change) => {
    const before = change.before.data();
    const after = change.after.data();

    if (before.status === 'accepted' || after.status !== 'accepted') return;

    const userIds: string[] = after.userIds || [];
    const batch = db.batch();
    for (const uid of userIds) {
      batch.update(db.collection('users').doc(uid), {
        friendCount: admin.firestore.FieldValue.increment(1),
      });
    }
    await batch.commit();
  });
