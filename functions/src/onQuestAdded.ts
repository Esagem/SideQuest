import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

const CREATOR_MILESTONES: Record<number, number> = {
  10: 10, 50: 25, 100: 50, 500: 100,
};

/**
 * Triggered when a quest's addedCount changes.
 * Awards creator XP at milestone thresholds.
 */
export const onQuestAdded = functions.firestore
  .document('quests/{questId}')
  .onUpdate(async (change) => {
    const before = change.before.data();
    const after = change.after.data();

    const oldCount = before.addedCount || 0;
    const newCount = after.addedCount || 0;

    if (newCount <= oldCount) return;

    const creatorId = after.creatorId;
    if (!creatorId || creatorId === 'deleted') return;

    for (const [threshold, bonus] of Object.entries(CREATOR_MILESTONES)) {
      const t = Number(threshold);
      if (oldCount < t && newCount >= t) {
        await db.collection('users').doc(creatorId).update({
          xp: admin.firestore.FieldValue.increment(bonus),
        });
        await db.collection('activity').add({
          userId: creatorId,
          type: 'creatorMilestone',
          questId: change.after.id,
          metadata: { milestone: t, xpBonus: bonus },
          createdAt: admin.firestore.Timestamp.now(),
        });
      }
    }
  });
