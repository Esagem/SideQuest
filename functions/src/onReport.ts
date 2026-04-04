import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

/**
 * Increments reportCount on the target and auto-hides if >= 3 reports.
 */
export const onReport = functions.firestore
  .document('reports/{reportId}')
  .onCreate(async (snap) => {
    const report = snap.data();
    const { targetType, targetId } = report;

    if (targetType === 'quest') {
      const questRef = db.collection('quests').doc(targetId);
      await questRef.update({
        reportCount: admin.firestore.FieldValue.increment(1),
      });
      const questSnap = await questRef.get();
      if ((questSnap.data()?.reportCount || 0) >= 3) {
        await questRef.update({ isHidden: true });
      }
    }
  });
